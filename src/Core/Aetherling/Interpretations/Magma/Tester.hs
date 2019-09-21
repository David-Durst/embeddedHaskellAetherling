module Aetherling.Interpretations.Magma.Tester where
import qualified Aetherling.Interpretations.Magma.Printer as P
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Control.Applicative
import Aetherling.Monad_Helpers
import Data.List
import qualified Data.Map.Strict as M
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import System.Exit
import Debug.Trace

data ST_Val_Index = ST_Val_Index {
  flat_idx :: Int,
  mv_valid :: Bool,
  flat_s :: Int,
  flat_t :: Int
  } deriving (Show, Eq)

data Type_For_Magma =
  Int_For_Magma
  | Bit_For_Magma
  | ATuple_For_Magma AST_Type AST_Type
  deriving (Show, Eq)

type Flat_Idx_To_Magma_Val = Int -> Type_For_Magma -> String

class Convertible_To_Atom_Strings a where
  convert_to_flat_atom_list :: a -> [String]

instance Convertible_To_Atom_Strings Int where
  convert_to_flat_atom_list x = [show x]
  
instance Convertible_To_Atom_Strings Integer where
  convert_to_flat_atom_list x = [show x]

instance Convertible_To_Atom_Strings Bool where
  convert_to_flat_atom_list x = [show x]
  
instance (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) => Convertible_To_Atom_Strings (a, b) where
  convert_to_flat_atom_list (x, y) = [show_no_quotes $ (head $ convert_to_flat_atom_list x,
                                          head $ convert_to_flat_atom_list y)]

instance (Convertible_To_Atom_Strings a) => Convertible_To_Atom_Strings [a] where
  convert_to_flat_atom_list xs = concat $ map convert_to_flat_atom_list xs

data Fault_Result = Fault_Success
                  | Fault_Failure {
                      fault_stdout :: String,
                      fault_stderr :: String,
                      fault_exit_code :: Int
                      } deriving (Show, Eq)

test_circuit_with_fault p inputs output = do
  result <- test_circuit_with_fault_no_io p inputs output
  case result of
    Fault_Success -> return ()
    Fault_Failure stdout stderr exit_code -> do
      putStrLn "Failure"
      putStrLn stdout
      putStrLn stderr
      putStrLn $ "Exit Code: " ++ show exit_code
  return result

test_circuit_with_fault_no_io :: (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr -> [a] -> b -> IO Fault_Result 
test_circuit_with_fault_no_io p inputs output = do
  p_str <- test_circuit_with_fault_string p inputs output
  circuit_file <- emptySystemTempFile "ae_circuit.py"
  writeFile circuit_file p_str
  stdout_name <- emptySystemTempFile "ae_circuit_result_stdout.txt"
  stdout_file <- openFile stdout_name WriteMode
  stderr_name <- emptySystemTempFile "ae_circuit_result_stderr.txt"
  stderr_file <- openFile stderr_name WriteMode
  let process =
        proc "python" [circuit_file]
  (_ , _, _, phandle) <- createProcess process { std_out = UseHandle stdout_file,
                                                std_err = UseHandle stderr_file}
  exit_code <- waitForProcess phandle
  case exit_code of
    ExitSuccess -> return Fault_Success
    ExitFailure c -> do
      stdout_fault <- readFile stdout_name
      stderr_fault <- readFile stderr_name
      return $ Fault_Failure stdout_fault stderr_fault c

test_circuit_with_fault_print p inputs outputs = do 
  str <- test_circuit_with_fault_string p inputs outputs
  putStrLn str

test_circuit_with_fault_string :: (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr -> [a] -> b -> IO String
test_circuit_with_fault_string p inputs output = do
  module_str_data <- P.module_to_magma_string p
  let num_ports = length $ P.in_ports $ P.module_outer_results $ module_str_data
  let fault_io = generate_fault_input_output_for_st_program p inputs output
  let f_inputs = foldl (++) "" $
        map (\i -> "fault_inputs" ++ show i ++ " = " ++
             show_no_quotes (fault_inputs fault_io !! i) ++ "\n")
        [0..num_ports - 1]
  let f_output = "fault_output = " ++ fault_output fault_io ++ "\n"
  let test_start =
        "if __name__ == '__main__':\n" ++
        P.tab_str ++ "mod = Main\n" ++
        P.tab_str ++ "tester = fault.Tester(mod, mod.CLK)\n" ++
        P.tab_str ++ "for f_clk in range(" ++ show (fault_clocks fault_io) ++ "):\n"
  let test_inputs = foldl (++) "" $
        map (\i -> (P.tab_str ++ P.tab_str ++ "tester.circuit." ++
                     (P.port_name $ (P.in_ports $
                                      P.module_outer_results module_str_data) !! i) ++
                     " = fault_inputs" ++ show i ++ "[f_clk]\n"))
                    [0..num_ports - 1]
  let test_eval = P.tab_str ++ P.tab_str ++ "tester.eval()\n"
  let test_output = P.tab_str ++ P.tab_str ++ "tester.circuit." ++
                    (P.port_name $ P.out_port $
                     P.module_outer_results module_str_data) ++
                    ".expect(fault_output[f_clk])\n"
  let test_step = P.tab_str ++ P.tab_str ++ "tester.step(2)\n"
  let test_run = P.tab_str ++ "fault_helpers.compile_and_run(tester)\n"
  return $ (P.module_str module_str_data) ++ f_inputs ++ f_output ++
    test_start ++ test_inputs ++ test_eval ++ test_output ++
    test_step ++ test_run
  
data Fault_IO = Fault_IO {
  fault_inputs :: [String],
  fault_output :: String,
  fault_valid_out :: [Bool],
  fault_clocks :: Int
  } deriving (Show, Eq)

generate_fault_input_output_for_st_program ::
  (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) => Expr -> [a] -> b -> Fault_IO
generate_fault_input_output_for_st_program p inputs output = do
  -- get the mapping from flat_idx to value
  let flat_input_strs_xs = map convert_to_flat_atom_list inputs
  let flat_input_idx_to_str_xs :: [M.Map Int String] =
        map (M.fromList . zip [0..]) flat_input_strs_xs
  let flat_output_strs = convert_to_flat_atom_list output
  let flat_output_idx_to_str :: M.Map Int String =
        M.fromList $ zip [0..] flat_output_strs

  -- get the mapping from flat st to flat_idx
  let p_types = expr_to_outer_types p
  let p_in_st_idxs_xs = map generate_st_val_idxs_for_st_type (e_in_types p_types)
  let p_out_st_idxs = generate_st_val_idxs_for_st_type (e_out_type p_types)
  let valid_out = map mv_valid $ map head p_out_st_idxs

  -- convert the st_idx double nested arrays to st double arrays with values
  let p_in_st_vals_xs = [convert_st_val_idxs_to_vals
                         (flat_input_idx_to_str_xs !! i) (p_in_st_idxs_xs !! i)
                         | i <- [0..length inputs - 1]]
  let p_out_st_vals = convert_st_val_idxs_to_vals flat_output_idx_to_str p_out_st_idxs
  Fault_IO (map show_no_quotes p_in_st_vals_xs) (show_no_quotes p_out_st_vals)
    valid_out (length p_out_st_idxs)

show_no_quotes :: Show a => a -> String
show_no_quotes = filter (\x -> x /= '\"') . show

convert_st_val_idxs_to_vals :: M.Map Int String -> [[ST_Val_Index]] -> [[String]]
convert_st_val_idxs_to_vals idx_to_str st_val_idxs =
  map (map (\st_val_idx -> idx_to_str M.! flat_idx st_val_idx)) st_val_idxs

generate_st_val_idxs_for_st_type :: AST_Type -> [[ST_Val_Index]]
generate_st_val_idxs_for_st_type t = do
  let total_width = num_atoms_t t
  let total_time = clocks_t t
  let valid_time = valid_clocks_t t
  let flat_results =
        generate_st_val_idxs_for_st_type' t total_width total_time
        valid_time 0 0 True 0
  let sorted_results = sortBy (\x y -> compare (flat_t x) (flat_t y)) flat_results
  let grouped_by_t = groupBy (\x y -> flat_t x == flat_t y) sorted_results
  let grouped_and_sorted_by_s =
        map (sortBy (\x y -> compare (flat_s x) (flat_s y))) grouped_by_t
  let invs_filtered = filter (mv_valid . head) grouped_and_sorted_by_s
  grouped_and_sorted_by_s
  --let grouped_and_sorted_just_vals = map (map magma_value) grouped_and_sorted_by_s
  -- need to filter out quotes from string printing
  --filter (\x -> x /= '\"') $ show grouped_and_sorted_just_vals

generate_st_val_idxs_for_st_type' :: AST_Type -> Int -> Int -> Int ->
                                      Int -> Int -> Bool ->
                                      Int -> [ST_Val_Index]
generate_st_val_idxs_for_st_type' UnitT _ _ _ cur_space cur_time
  valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' BitT _ _ _ cur_space cur_time
  valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' IntT _ _ _ cur_space cur_time
  valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' (ATupleT t0 t1) _ _ _ cur_space
  cur_time valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' (STupleT n t) total_width
  total_time valid_time cur_space cur_time valid cur_idx = do
  let element_width = total_width `div` n
  let element_time = total_time
  let element_valid_time = valid_time
  let element_strs = [generate_st_val_idxs_for_st_type' t
                      element_width element_time element_valid_time
                      (cur_space + j*element_width) cur_time
                      valid
                      (cur_idx + j*element_width*element_valid_time)
                     | j <- [0..n-1]]
  concat element_strs
generate_st_val_idxs_for_st_type' (SSeqT n t) total_width
  total_time valid_time cur_space cur_time valid cur_idx = do
  let element_width = total_width `div` n
  let element_time = total_time
  let element_valid_time = valid_time
  let element_strs = [generate_st_val_idxs_for_st_type' t
                      element_width element_time element_valid_time
                      (cur_space + j*element_width) cur_time
                      valid
                      (cur_idx + j*element_width*element_valid_time)
                     | j <- [0..n-1]]
  concat element_strs
generate_st_val_idxs_for_st_type' (TSeqT n i t) total_width
  total_time valid_time cur_space cur_time valid cur_idx = do
  let element_width = total_width
  let element_time = total_time `div` (n+i)
  let element_valid_time = valid_time `div` n
  let element_strs = [generate_st_val_idxs_for_st_type' t
                      element_width element_time element_valid_time
                      cur_space (cur_time + j * element_time)
                      (valid && j < n)
                      (cur_idx + j*element_width*element_valid_time)
                     | j <- [0..(n+i)-1]]
  concat element_strs

module Aetherling.Interpretations.Magma.Tester where
import Aetherling.Interpretations.Magma.Expr_To_String
import Aetherling.Interpretations.Magma.Value_To_String
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

data Fault_Result = Fault_Success
                  | Fault_Failure {
                      fault_stdout :: String,
                      fault_stderr :: String,
                      fault_exit_code :: Int,
                      python_file :: FilePath
                      } deriving (Show, Eq)

test_circuit_with_fault p inputs output = do
  result <- test_circuit_with_fault_no_io p inputs output
  case result of
    Fault_Success -> return ()
    Fault_Failure stdout stderr exit_code py_file -> do
      putStrLn $ "Failure with file " ++ py_file
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
  stdout_name <- emptySystemTempFile "ae_circuit_fault_stdout.txt"
  stdout_file <- openFile stdout_name WriteMode
  stderr_name <- emptySystemTempFile "ae_circuit_fault_stderr.txt"
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
      return $ Fault_Failure stdout_fault stderr_fault c circuit_file

test_circuit_with_fault_print p inputs outputs = do 
  str <- test_circuit_with_fault_string p inputs outputs
  putStrLn str

test_circuit_with_fault_string :: (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr -> [a] -> b -> IO String
test_circuit_with_fault_string p inputs output = do
  let p_types = expr_to_outer_types p
  module_str_data <- module_to_magma_string p
  let num_ports = length $ in_ports $ module_outer_results $ module_str_data
  let fault_io = generate_fault_input_output_for_st_program p inputs output
  -- these are nested for both space and time
  -- issue: if 1 input per clock, then need to remove the space dimension
  let f_inputs = foldl (++) "" $
        map (\i -> "fault_inputs" ++ show i ++ " = " ++
              show_no_quotes (fault_inputs fault_io !! i) ++ "\n" ++
              "fault_inputs" ++ show i ++ "_valid = " ++
              show_no_quotes (fault_valid_in fault_io !! i) ++ "\n"
            )
        [0..num_ports - 1]
  let f_output = "fault_output = " ++ fault_output fault_io ++ "\n"
  let f_output_valid = "fault_output_valid = " ++
                       show_no_quotes (fault_valid_out fault_io) ++ "\n"
  let test_start =
        "if __name__ == '__main__':\n" ++
        tab_str ++ "mod = Main()\n" ++
        tab_str ++ "tester = fault.Tester(mod, mod.CLK)\n" ++
        tab_str ++ "tester.circuit.valid_up = 1\n" ++
        tab_str ++ "for f_clk in range(" ++ show (fault_clocks fault_io) ++ "):\n" ++
        tab_str ++ tab_str ++ "tester.print('clk: {}\\n'.format(f_clk))\n"
  let test_inputs = foldl (++) "" $
        map (\i ->
               tab_str ++ tab_str ++ "if fault_inputs" ++ show i ++ "_valid[f_clk]:\n" ++
               tab_str ++ tab_str ++ tab_str ++
               "fault_helpers.wire_nested_port(tester, tester.circuit." ++
               (port_name $ (in_ports $ module_outer_results module_str_data) !! i) ++
               ", fault_inputs" ++ show i ++ "[f_clk], " ++
               "num_nested_space_layers(" ++ (type_to_python $ e_in_types p_types !! i) ++ "), 0)\n")
        [0..num_ports - 1]
  let test_eval = tab_str ++ tab_str ++ "tester.eval()\n"
  let test_output_if_valid = tab_str ++ tab_str ++ "if fault_output_valid[f_clk]:\n"
  let test_output = tab_str ++ tab_str ++ tab_str ++
                    "fault_helpers.expect_nested_port(tester, tester.circuit." ++
                    (port_name $ out_port $
                     module_outer_results module_str_data) ++
                    ", fault_output[f_clk], num_nested_space_layers(" ++
                    (type_to_python $ e_out_type p_types)  ++ "), 0)\n"
  let test_step = tab_str ++ tab_str ++ "tester.step(2)\n"
  let test_run = tab_str ++ "fault_helpers.compile_and_run(tester)\n"
  return $ (module_str module_str_data) ++ f_inputs ++ f_output ++
    f_output_valid ++ test_start ++ test_inputs ++ test_eval ++
    test_output_if_valid ++ test_output ++ test_step ++ test_run
  
data Fault_IO = Fault_IO {
  fault_inputs :: [String],
  fault_valid_in :: [[Bool]],
  fault_output :: String,
  fault_valid_out :: [Bool],
  fault_clocks :: Int
  } deriving (Show, Eq)

generate_fault_input_output_for_st_program ::
  (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) => Expr -> [a] -> b -> Fault_IO
generate_fault_input_output_for_st_program p inputs output = do
  -- get the mapping from flat st to flat_idx
  let p_types = expr_to_outer_types p
  let in_types_and_values = zip (e_in_types p_types) inputs
  
  let fault_inputs = map (\(t, v) ->
                           convert_seq_val_to_st_val_string v t)
                     in_types_and_values
  let ST_Val_String fault_output valid_out =
        convert_seq_val_to_st_val_string output (e_out_type p_types)
  Fault_IO (map st_values fault_inputs) (map st_valids fault_inputs)
    fault_output valid_out (length valid_out)


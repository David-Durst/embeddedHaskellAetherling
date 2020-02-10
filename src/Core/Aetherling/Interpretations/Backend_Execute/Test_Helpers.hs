module Aetherling.Interpretations.Backend_Execute.Test_Helpers where
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import System.IO.Temp
import System.IO
import Data.Ratio
import Data.List.Split
import Text.Printf
import Debug.Trace

data Test_Result = Test_Success
                  | Test_Failure {
                      python_file :: FilePath,
                      test_exit_code :: Int
                      }
                  | Compiler_Failure
                 deriving (Show, Eq)

data Tester_IO = Tester_IO {
  tester_inputs :: [String],
  tester_valid_in :: [[Bool]],
  tester_output :: String,
  tester_valid_out :: [Bool],
  tester_clocks :: Int
  } deriving (Show, Eq)

data Test_File_Data = Test_File_Data {
  test_path :: FilePath,
  nested_array :: Bool
  } deriving (Show, Eq)

data Tester_Files = Tester_Files {
  tester_inputs_fp :: [Test_File_Data],
  tester_valid_in_fp :: [FilePath],
  tester_output_fp :: Test_File_Data,
  tester_valid_out_fp :: FilePath,
  tester_clocks_files :: Int
  } deriving (Show, Eq)

generate_and_save_tester_io_for_st_program ::
  (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr -> [a] -> b -> IO Tester_Files
generate_and_save_tester_io_for_st_program p inputs output = do
  traceShowM $ "ports: " ++ (show $ expr_to_outer_types p)
  let p_types = expr_to_outer_types p
  let num_in_ports = length $ e_in_types p_types
  -- generate files
  test_input_file_names <-
    mapM (\idx -> emptySystemTempFile ("ae_input_" ++ show idx ++ ".json"))
    [0..num_in_ports-1]
  test_in_valid_file_names <-
    mapM (\idx -> emptySystemTempFile ("ae_in_valid_" ++ show idx ++ ".json"))
    [0..num_in_ports-1]
  test_output_file_name <- emptySystemTempFile "ae_output.json"
  test_out_valid_file_name <- emptySystemTempFile "ae_out_valid.json"

  -- write the IO strings to files
  traceShowM "writing inputs and outputs for test"
  let tester_strings = generate_tester_input_output_for_st_program json_conf p_types
                       inputs output
  let input_strs = tester_inputs tester_strings
  traceShowM "writing inputs and outputs for test1"
  mapM (\(file_name, idx) ->
          writeFile file_name (input_strs !! idx)
      ) (zip test_input_file_names [0..])
  traceShowM "writing inputs and outputs for test2"
  mapM (\(file_name, idx) ->
          writeFile file_name (show_no_quotes $
                               map (make_bool_string_for_backend json_conf) $
                               tester_valid_in tester_strings !! idx)
      ) (zip test_in_valid_file_names [0..])
  traceShowM "writing inputs and outputs for test3"
  let output_str = tester_output tester_strings
  traceShowM $ "len of output_str " ++ show (length output_str)
  traceShowM "writing inputs and outputs for test4"
  writeFile test_output_file_name output_str
  traceShowM "writing inputs and outputs for test5"
  writeFile test_out_valid_file_name (show_no_quotes $
                                      map (make_bool_string_for_backend json_conf) $
                                      tester_valid_out tester_strings)
  traceShowM "finished writing inputs and outputs for test"

  -- compute whether input and outputs are nested
  let inputs_nested = map (\input_str -> (head $ tail input_str) == '[')
                      input_strs
  let output_nested = (head $ tail output_str) == '['
  let inputs_file_data =
        map (\(input_path, is_nested) -> Test_File_Data input_path is_nested)
        (zip test_input_file_names inputs_nested)
  let output_file_data = Test_File_Data test_output_file_name output_nested

  return $ Tester_Files inputs_file_data test_in_valid_file_names
    output_file_data test_out_valid_file_name (tester_clocks tester_strings)


test_gen_io_for_st ::
  (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr_Types -> [a] -> b -> IO ()
test_gen_io_for_st p_types inputs output = do
  let num_in_ports = length $ e_in_types p_types
  -- generate files
  test_input_file_names <-
    mapM (\idx -> emptySystemTempFile ("ae_input_" ++ show idx ++ ".json"))
    [0..num_in_ports-1]
  test_in_valid_file_names <-
    mapM (\idx -> emptySystemTempFile ("ae_in_valid_" ++ show idx ++ ".json"))
    [0..num_in_ports-1]
  test_output_file_name <- emptySystemTempFile "ae_output.json"
  test_out_valid_file_name <- emptySystemTempFile "ae_out_valid.json"

  -- write the IO strings to files
  traceShowM "writing inputs and outputs for test"
  let tester_strings = generate_tester_input_output_for_st_program json_conf p_types
                       inputs output
                       {-
  let input_strs = tester_inputs tester_strings
  traceShowM "writing inputs and outputs for test1"
  mapM (\(file_name, idx) ->
          writeFile file_name (input_strs !! idx)
      ) (zip test_input_file_names [0..])
  traceShowM "writing inputs and outputs for test2"
  mapM (\(file_name, idx) ->
          writeFile file_name (show_no_quotes $
                               map (make_bool_string_for_backend json_conf) $
                               tester_valid_in tester_strings !! idx)
      ) (zip test_in_valid_file_names [0..])
-}
  traceShowM "writing inputs and outputs for test3"
  let output_str = tester_output tester_strings
  traceShowM $ "len of output_str " ++ show (length output_str)
  traceShowM "writing inputs and outputs for test4"
  writeFile test_output_file_name output_str
  traceShowM "writing inputs and outputs for test5"
  writeFile test_out_valid_file_name (show_no_quotes $
                                      map (make_bool_string_for_backend json_conf) $
                                      tester_valid_out tester_strings)
  traceShowM "finished writing inputs and outputs for test"
{-
  -- compute whether input and outputs are nested
  let inputs_nested = map (\input_str -> (head $ tail input_str) == '[')
                      input_strs
  let output_nested = (head $ tail output_str) == '['
  let inputs_file_data =
        map (\(input_path, is_nested) -> Test_File_Data input_path is_nested)
        (zip test_input_file_names inputs_nested)
  let output_file_data = Test_File_Data test_output_file_name output_nested

  return $ Tester_Files inputs_file_data test_in_valid_file_names
    output_file_data test_out_valid_file_name (tester_clocks tester_strings)
-}


    

generate_tester_input_output_for_st_program ::
  (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  ST_Val_To_String_Config -> Expr_Types -> [a] -> b -> Tester_IO
generate_tester_input_output_for_st_program conf p_types inputs output = do
  -- get the mapping from flat st to flat_idx
  let in_types_and_values = zip (e_in_types p_types) inputs

  let tester_inputs = map (\(t, v) ->
                           convert_seq_val_to_st_val_string v t conf)
                     in_types_and_values
  let ST_Val_String tester_output valid_out =
        convert_seq_val_to_st_val_string output (e_out_type p_types) conf
  Tester_IO (map st_values tester_inputs) (map st_valids tester_inputs)
    tester_output valid_out (length valid_out)

speed_to_slow :: [Ratio Integer] -> Integer -> [Int]
speed_to_slow speed_ups image_size = map (\speed_up -> fromInteger $ numerator $ (fromIntegral image_size) / speed_up) speed_ups

stencil_generator :: Integer -> [Integer] -> [[[Integer]]]
stencil_generator row_size inputs = do
  let inputs_2d = chunksOf (fromInteger row_size) inputs
  let col_size = toInteger $ length inputs `div` fromInteger row_size
  let num_rows = toInteger $ col_size
  let num_cols = row_size
  let get_input r c = if (r < 0) || (c < 0) || (r >= row_size) || (c >= col_size)
        then int_to_ignore
        else (inputs_2d !! fromInteger r) !! (fromInteger c)
  [
    [
      [
        get_input (r - stencil_r) (c - stencil_c)
      | stencil_c <- [2,1..0]] | stencil_r <- [2,1..0]]
    | r <- [0..num_rows-1], c <- [0..num_cols-1]]
    
stencil_2x2_generator :: Integer -> [Integer] -> [[[Integer]]]
stencil_2x2_generator row_size inputs = do
  let inputs_2d = chunksOf (fromInteger row_size) inputs
  let col_size = toInteger $ length inputs `div` fromInteger row_size
  let num_rows = toInteger $ col_size
  let num_cols = row_size
  let get_input r c = if (r < 0) || (c < 0) || (r >= row_size) || (c >= col_size)
        then int_to_ignore
        else (inputs_2d !! fromInteger r) !! (fromInteger c)
  [
    [
      [
        get_input (r - stencil_r) (c - stencil_c)
      | stencil_c <- [1,0]] | stencil_r <- [1,0]]
    | r <- [0..num_rows-1], c <- [0..num_cols-1]]

-- need thse for Integer and Int versions
hask_kernel :: [[Int]] = [[0,1,0],[1,2,1],[0,1,0]]
hask_kernel' :: [Integer] = [1,2,1,2,4,2,1,2,1]
conv_generator :: [[[Integer]]] -> [Integer]
conv_generator stencil_2d_output = [
  if window_valid
  then (sum $ zipWith (*) window_flat hask_kernel') `mod` 256 `div` 16
  else int_to_ignore
  | window <- stencil_2d_output,
    let window_flat = concat window,
    let window_valid = not $ any (\x -> x == int_to_ignore) window_flat]

int_to_3char :: PrintfArg a => a -> String
int_to_3char x = printf "%03d" x

print_linear_matrix row_length matrix =
  sequence $ map print $ map (map int_to_3char) $ chunksOf row_length matrix
  
-- a helper int for values that should be ignored by tester as they
-- indicate invalid in shift (and thus stencil)
int_to_ignore = 253

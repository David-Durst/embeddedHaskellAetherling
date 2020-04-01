module Aetherling.Interpretations.Backend_Execute.Test_Helpers where
import Aetherling.Interpretations.Backend_Execute.Constants
import qualified Aetherling.Languages.Sequence.Deep.Serialize as SeqSer
import qualified Aetherling.Languages.Space_Time.Deep.Serialize as STSer
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
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
import Data.List
import Data.Word
import qualified Data.Vector as Vec
import Data.Aeson
import System.Directory
import System.FilePath

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

data Rust_Gen_Params = Rust_Gen_Params {
  values_proto :: FilePath,
  type_proto :: FilePath,
  values_json :: FilePath,
  valids_json :: FilePath
  } deriving (Show, Eq)

data Tester_Files = Tester_Files {
  tester_inputs_fp :: [Test_File_Data],
  tester_valid_in_fp :: [FilePath],
  tester_output_fp :: Test_File_Data,
  tester_valid_out_fp :: FilePath,
  rust_params :: [Rust_Gen_Params],
  tester_clocks_files :: Int
  } deriving (Show, Eq)


generate_tester_io_with_rust ::
  (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr -> [a] -> b -> IO Tester_Files
generate_tester_io_with_rust p inputs output = do
  --traceShowM $ "ports: " ++ (show $ expr_to_outer_types p)
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

  let test_values_file_names = test_input_file_names ++ [test_output_file_name]
  let test_valids_file_names = test_in_valid_file_names ++ [test_out_valid_file_name]
  
  test_values_proto_file_names <-
    mapM (\idx -> emptySystemTempFile ("ae_proto_values_" ++ show idx ++ ".bin"))
    [0..num_in_ports]
  test_types_proto_file_names <-
    mapM (\idx -> emptySystemTempFile ("ae_proto_types_" ++ show idx ++ ".bin"))
    [0..num_in_ports]

  let params = map (\(a, b, c, d) -> Rust_Gen_Params a b c d)
               (zip4 test_values_proto_file_names test_types_proto_file_names
                test_values_file_names test_valids_file_names)
      

  -- write the IO strings to files
  mapM (\(file_name, input) ->
          SeqSer.save_value file_name input
      ) (zip test_values_proto_file_names inputs)
  SeqSer.save_value (last test_values_proto_file_names) output
    
  mapM (\(file_name, t) ->
          STSer.save_type file_name t
      ) (zip test_types_proto_file_names (e_in_types p_types ++ [e_out_type p_types]))

  -- techincally stuple is an atom but the backend treats it as an array (like sseq)
  -- so nested if stuples of length > 1
  let inputs_nested = map (\t -> num_atoms_or_stuple_per_valid_t t > 1) (e_in_types p_types)
  let output_nested = num_atoms_or_stuple_per_valid_t (e_out_type p_types) > 1
  let clks = clocks_t $ e_out_type p_types

  let inputs_fp = map (\(path, nested) -> Test_File_Data path nested)
                  (zip test_input_file_names inputs_nested)
  let output_fp = Test_File_Data test_output_file_name output_nested

  return $ Tester_Files inputs_fp test_in_valid_file_names
    output_fp test_out_valid_file_name params clks

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
    output_file_data test_out_valid_file_name [] (tester_clocks tester_strings)


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

save_seq_test_io_as_json :: Integral a => FilePath -> [[a]] -> [a] -> IO ()
save_seq_test_io_as_json test_name inputs output = do
  let test_file_prelude = test_json_dir ++ test_name
  createDirectoryIfMissing True $ takeDirectory test_file_prelude
  if length inputs == 1
    then
    encodeFile (test_file_prelude ++ "_input.json") $ map toInteger $ head inputs
    else do
    let inputs_with_idxs = zip [0..] $ map (map toInteger) inputs
    mapM (\(idx, els) -> encodeFile (test_file_prelude ++ "_input_" ++
                                    show idx ++ ".json") els) inputs_with_idxs
    return ()
  encodeFile (test_file_prelude ++ "_output.json") $ map toInteger output

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

speed_and_expr_to_slow :: [Ratio Integer] -> SeqE.Expr -> [Int]
speed_and_expr_to_slow speedups e = do
  let out_seq_t = Seq_Conv.e_out_type $
                  Seq_Conv.expr_to_types e
  
  let out_len = SeqT.num_atoms_total_t_seq out_seq_t
  speed_to_slow speedups (toInteger out_len)

stencil_generator :: (Num a, Integral a) => Integer -> [a] -> [[[a]]]
stencil_generator row_size inputs = do
  let inputs_2d = Vec.fromList inputs
  let col_size = toInteger $ length inputs `div` fromInteger row_size
  let num_rows = toInteger $ col_size
  let num_cols = row_size
  let get_input r c = if (r < 0) || (c < 0) 
        then fromInteger int_to_ignore
        else (inputs_2d Vec.! (fromInteger (r * row_size + c)))
  [
    [
      [
        get_input (r - stencil_r) (c - stencil_c)
      | stencil_c <- [2,1,0]] | stencil_r <- [2,1,0]]
    | r <- [0..num_rows-1], c <- [0..num_cols-1]]
    
stencil_2x2_generator :: (Num a, Integral a) => Integer -> [a] -> [[[a]]]
stencil_2x2_generator row_size inputs = do
  let inputs_2d = Vec.fromList inputs
  let col_size = toInteger $ length inputs `div` fromInteger row_size
  let num_rows = toInteger $ col_size
  let num_cols = row_size
  let get_input r c = if (r < 0) || (c < 0) 
        then fromInteger int_to_ignore
        else (inputs_2d Vec.! (fromInteger (r * row_size + c)))
  [
    [
      [
        get_input (r - stencil_r) (c - stencil_c)
      | stencil_c <- [1,0]] | stencil_r <- [1,0]]
    | r <- [0..num_rows-1], c <- [0..num_cols-1]]

demosaic_generator :: forall a . (Num a, Integral a) => Integer -> [a] -> [(a, (a, a))]
demosaic_generator row_size inputs =
  map (\(r, g, b) ->
         if (r == fromInteger int_to_ignore) || (g == fromInteger int_to_ignore) || (b == fromInteger int_to_ignore)
         then (fromInteger int_to_ignore, (fromInteger int_to_ignore, fromInteger int_to_ignore))
         else (r,(g,b)) ) $
  demosaic_generator' row_size inputs

-- this generates demosiacs with partial pixel data (i.e. red channel but not
-- green or blue)
demosaic_generator' :: forall a . (Num a, Integral a) => Integer -> [a] -> [(a,a,a)]
demosaic_generator' row_size inputs = do
  [(get_red r c, get_green r c, get_blue r c)
    | r <- [0..num_rows-1], c <- [0..num_cols-1]]
    where
      col_size = toInteger $ length inputs `div` fromInteger row_size
      num_rows = toInteger $ col_size
      num_cols = row_size
      inputs_2d = Vec.fromList inputs
      get_input r c = if (r < 0) || (c < 0) || (r >= num_rows) || (c >= num_cols)
                      then fromInteger int_to_ignore
                      else (inputs_2d Vec.! (fromInteger (r * row_size + c)))
      div2 :: a -> a -> a
      div2 x y | x == fromInteger int_to_ignore || y == fromInteger int_to_ignore = fromInteger int_to_ignore
      div2 x y = (x + y) `div` 2
      div4 :: a -> a -> a -> a -> a
      div4 x y z q |
        x == fromInteger int_to_ignore || y == fromInteger int_to_ignore ||
        z == fromInteger int_to_ignore || q == fromInteger int_to_ignore = fromInteger int_to_ignore
      div4 x y z q = (x + y + z + q) `div` 4
      get_red :: Integer -> Integer -> a
      get_red r c | (r < 0) || (c < 0) = fromInteger int_to_ignore
      get_red r c | (r `mod` 2 == 0) && (c `mod` 2 == 1) =
                    get_input r c
      get_red r c | r `mod` 2 == 0 = div2
                    (get_input r (c - 1)) (get_input r (c + 1)) 
      get_red r c | (r `mod` 2 == 1) && (c `mod` 2 == 0) = div4
                    (get_input (r - 1) (c - 1)) (get_input (r - 1) (c + 1))
                    (get_input (r + 1) (c - 1)) (get_input (r + 1) (c + 1))
      get_red r c | r `mod` 2 == 1 = div2
                    (get_input (r - 1) c) (get_input (r + 1) c)
      get_red r c = error $ "r: " ++ show r ++ ", c: " ++ show c ++ " no match for red"
      get_green :: Integer -> Integer -> a
      get_green r c | (r < 0) || (c < 0) = fromInteger int_to_ignore
      get_green r c | (r `mod` 2 == 0) && (c `mod` 2 == 0) =
                    get_input r c
      get_green r c | (r `mod` 2 == 1) && (c `mod` 2 == 1) = 
                    get_input r c
      get_green r c = div4
                      (get_input (r - 1) c) (get_input (r + 1) c)
                      (get_input r (c-1)) (get_input r (c+1))
      get_blue :: Integer -> Integer -> a
      get_blue r c | (r < 0) || (c < 0) = fromInteger int_to_ignore
      get_blue r c | (r `mod` 2 == 1) && (c `mod` 2 == 0) =
                    get_input r c
      get_blue r c | r `mod` 2 == 1 = div2
                    (get_input r (c - 1)) (get_input r (c + 1))
      get_blue r c | (r `mod` 2 == 0) && (c `mod` 2 == 1) = div4
                    (get_input (r - 1) (c - 1)) (get_input (r - 1) (c + 1))
                    (get_input (r + 1) (c - 1)) (get_input (r + 1) (c + 1))
      get_blue r c | r `mod` 2 == 0 = div2
                    (get_input (r - 1) c) (get_input (r + 1) c)
      get_blue r c = error $ "r: " ++ show r ++ ", c: " ++ show c ++ " no match for blue"

hask_kernel :: [[Word8]] = [[0,1,0],[1,2,1],[0,1,0]]
hask_kernel_real :: [[Word8]] = [[1,2,1],[2,4,2],[1,2,1]]
hask_kernel_real16 :: [[Word16]] = [[1,2,1],[2,4,2],[1,2,1]]
hask_kernel_real32 :: [[Word32]] = [[1,2,1],[2,4,2],[1,2,1]]
hask_kernel' :: [Word8] = [1,2,1,2,4,2,1,2,1]
conv_generator :: (Num a, Integral a) => [[[a]]] -> [a]
conv_generator stencil_2d_output = [
  if window_valid
  then (sum $ zipWith (*) window_flat (map fromIntegral hask_kernel')) `div` 16
  else fromIntegral int_to_ignore
  | window <- stencil_2d_output,
    let window_flat = concat window,
    let window_valid = not $ any (\x -> (fromIntegral x) == int_to_ignore) window_flat]

hask_kernel_2x2 :: [[Word8]] = [[0,2],[1,0]]
hask_kernel_2x2_real :: [[Word8]] = [[1,4],[2,1]]
hask_kernel_2x2_real16 :: [[Word16]] = [[1,4],[2,1]]
hask_kernel_2x2_real32 :: [[Word32]] = [[1,4],[2,1]]
hask_kernel'_2x2 :: [Word8] = [1,4,2,1]

conv_2x2_generator :: (Num a, Integral a) => [[[a]]] -> [a]
conv_2x2_generator stencil_2d_output = [
  if window_valid
  then (sum $ zipWith (*) window_flat (map fromIntegral hask_kernel'_2x2)) `div` 8
  else fromIntegral int_to_ignore
  | window <- stencil_2d_output,
    let window_flat = concat window,
    let window_valid = not $ any (\x -> (fromIntegral x) == int_to_ignore) window_flat]

t_const :: Integer
t_const = 15
sharpen_one_pixel' :: (Num a, Integral a) => a -> a -> a 
sharpen_one_pixel' a b = do
  let h = if (b - a) > (fromIntegral t_const) || (a - b) > (fromIntegral t_const) then b - a else 0
  fromIntegral $ if (fromIntegral a) == int_to_ignore then a else b + (h `div` 4)
  
sharpen_one_pixel'_integer :: Integer -> Integer -> Integer
sharpen_one_pixel'_integer a b = do
  let h = if (abs $ b - a) > t_const then b - a else 0
  if a == int_to_ignore then a else b + (h `div` 4)
  
int_to_3char :: PrintfArg a => a -> String
int_to_3char x = printf "%03d" x

print_linear_matrix row_length matrix =
  sequence $ map print $ map (map int_to_3char) $ chunksOf row_length matrix

pixel_to_3char :: PrintfArg a => (a,(a,a)) -> String
pixel_to_3char (x0,(x1,x2)) = "(" ++ printf "%03d" x0 ++ ", "
                              ++ printf "%03d" x1 ++ ", "
                              ++ printf "%03d" x2 ++ ")"

print_linear_image row_length matrix =
  sequence $ map print $ map (map pixel_to_3char) $ chunksOf row_length matrix

red_on_row = [0,10,0,20,0,30,0,40]
red_off_row = [0,0,0,0,0,0,0,0]
blue_on_row = [15,0,25,0,35,0,45,0]
blue_off_row = red_off_row
green_first_row = [7,0,17,0,27,0,37,0]
green_second_row = [0,3,0,13,0,23,0,33]
-- a helper int for values that should be ignored by tester as they
-- indicate invalid in shift (and thus stencil)
int_to_ignore = 253

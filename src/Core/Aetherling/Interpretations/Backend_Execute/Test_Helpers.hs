module Aetherling.Interpretations.Backend_Execute.Test_Helpers where
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import Data.Ratio
import Data.List.Split
import Text.Printf

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

generate_tester_input_output_for_st_program ::
  (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  ST_Val_To_String_Config -> Expr -> [a] -> b -> Tester_IO
generate_tester_input_output_for_st_program conf p inputs output = do
  -- get the mapping from flat st to flat_idx
  let p_types = expr_to_outer_types p
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

better_stencil_generator :: Integer -> [Integer] -> [[[Integer]]]
better_stencil_generator row_size inputs = do
  let inputs_2d = chunksOf (fromInteger row_size) inputs
  let col_size = length inputs `div` fromInteger row_size
  let get_input r c = if (r < 0) || (c < 0) || (r >= row_size) || (c >= col_size)
        then int_to_ignore
        else (inputs_2d !! fromInteger r) !! c
  [
    [
      [
        get_input (r - stencil_r) (c - stencil_c)
      | stencil_c <- [2,1..0]] | stencil_r <- [2,1..0]]
    | r <- [0..row_size-1], c <- [0..col_size-1]]

int_to_3char :: PrintfArg a => a -> String
int_to_3char x = printf "%03d" x

print_linear_matrix row_length matrix =
  sequence $ map print $ map (map int_to_3char) $ chunksOf row_length matrix
  
-- a helper int for values that should be ignored by tester as they
-- indicate invalid in shift (and thus stencil)
int_to_ignore = 253

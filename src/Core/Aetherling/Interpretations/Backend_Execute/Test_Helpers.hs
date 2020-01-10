module Aetherling.Interpretations.Backend_Execute.Test_Helpers where
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Interpretations.Backend_Execute.Value_To_String

data Test_Result = Test_Success
                  | Test_Failure {
                      python_file :: FilePath,
                      test_stdout :: String,
                      test_stderr :: String,
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

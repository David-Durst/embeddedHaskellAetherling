import Test.Tasty
import Test.Tasty.HUnit
import Test_Seq_Simulator
import Test_Seq_Embedding
import Test_ST_Embedding
import Test_Slowdown
import Test_Apps
import Test_Big
import Test_Spatial
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import Aetherling.Interpretations.Space_Time_Printer
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import Data.List

main :: IO ()
main = defaultMain tests
--main = do
--  error "hi"
--  putStrLn "hi"
-- putStrLn $ show $ length $ rewrite_all_AST_types 25600 $ Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions.e_out_type  $ Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions.expr_to_outer_types big_conv_2d_seq_idx
--  putStrLn $ show $ length $ tester_inputs $ generate_tester_input_output_for_st_program  json_conf (big_conv_2d_ppar !! 1)  big_conv_2d_inputs  big_conv_2d_output
  --putStrLn $ show $ e_out_type $ expr_to_outer_types_st $ big_conv_2d_ppar !! 0
--  print_st $ big_conv_2d_ppar !! 6
--  let p_types = Expr_Types {e_in_types = [TSeqT 2073600 0 (TSeqT 1 2 IntT)], e_out_type = TSeqT 2073600 0 (TSeqT 1 2 IntT)}
--  test_gen_io_for_st p_types big_conv_2d_inputs big_conv_2d_output
--  return ()

tests :: TestTree
tests = testGroup "Top Level Aetherling Tests" [slowdown_tests, apps_tests]
--tests = testGroup "Top Level Aetherling Tests" [slowdown_tests, apps_tests, big_tests]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests]
--tests = testGroup "Top Level Aetherling Tests" [slowdown_tests]
--tests = testGroup "Top Level Aetherling Tests" [big_tests]


import Test.Tasty
import Test.Tasty.HUnit
import Test_Seq_Simulator
import Test_Seq_Embedding
import Test_ST_Embedding
import Test_Slowdown
import Test_Apps
import Test_Apps_Real_Math
import Test_Big
import Test_Big16
import Test_Big32
import Test_Spatial
import Test_Big_Real_Math
import Test_Big_Real_Math16
import Test_Big_Real_Math32
import Test_Demosaic
import Test_Camera
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import Aetherling.Interpretations.Space_Time_Printer
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import Data.List

main :: IO ()
main = defaultMain tests
--main = gen_io
--main = print_st_text
--main = do
--  putStrLn $ show $ sum big_conv_2d_output
--  return ()
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
--tests = testGroup "Top Level Aetherling Tests" [slowdown_tests, apps_tests, big_tests]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests_chisel, big_tests']
--tests = testGroup "Top Level Aetherling Tests" [apps_tests_chisel]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests_chisel']
--tests = testGroup "Top Level Aetherling Tests" [slowdown_tests]
--tests = testGroup "Top Level Aetherling Tests" [slowdown_tests_chisel]
--tests = testGroup "Top Level Aetherling Tests" [big_tests]
--tests = testGroup "Top Level Aetherling Tests" [big_tests']
--tests = testGroup "Top Level Aetherling Tests" [big_tests, big_16_tests, big_32_tests]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests_real_math_chisel]
--tests = testGroup "Top Level Aetherling Tests" [big_real_tests, big_real_16_tests, big_real_32_tests, big_tests, big_16_tests, big_32_tests]
--tests = testGroup "Top Level Aetherling Tests" [big_real_16_tests, big_real_32_tests]
--tests = testGroup "Top Level Aetherling Tests" [big_real_32_tests_part]
--tests = testGroup "Top Level Aetherling Tests" [big_16_tests]
--tests = testGroup "Top Level Aetherling Tests" [big_32_tests']
--tests = testGroup "Top Level Aetherling Tests" [big_real_32_tests']
--tests = testGroup "Top Level Aetherling Tests" [big_real_16_tests']
--tests = testGroup "Top Level Aetherling Tests" [big_16_tests']
--tests = testGroup "Top Level Aetherling Tests" [big_real_32_tests_part, big_tests, big_16_tests, big_32_tests]
--tests = testGroup "Top Level Aetherling Tests" [big_real_32_tests_sharpen']
--tests = testGroup "Top Level Aetherling Tests" [big_32_tests, big_real_32_tests]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests_chisel_map]
--tests = testGroup "Top Level Aetherling Tests" [demosaic_tests, big_32_tests, big_real_32_tests, apps_tests_chisel_map]
tests = testGroup "Top Level Aetherling Tests" [camera_tests']


gen_io :: IO ()
gen_io = do
  -- need:
  -- paper apps: as in paper and real math - done
  -- 1920x1080: 8, 32 and shifts, real
  apps_paper_shifts_io
  apps_paper_real_io
  apps_big_shifts_io
  apps_big_32_shifts_io
  apps_big_8_real_io
  apps_big_32_real_io
  return ()

print_st_text :: IO ()
print_st_text = do
  --big_real_32_conv_2d_st_prints
  --big_real_32_conv_2d_b2b_st_prints
  --big_real_32_sharpen_st_prints
  --big_32_conv_2d_st_prints
  --big_32_conv_2d_b2b_st_prints
  --big_32_sharpen_st_prints
  --demosaic_st_prints
  print_st $ demosaic_ppar_tr !! 0
  return ()

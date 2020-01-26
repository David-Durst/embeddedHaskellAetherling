import Test.Tasty
import Test.Tasty.HUnit
import Test_Seq_Simulator
import Test_Seq_Embedding
import Test_ST_Embedding
import Test_Slowdown
import Test_Apps
import Test_Spatial
import Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Data.List

main :: IO ()
main = defaultMain tests
--main = do
--  putStrLn "hi"
--  putStrLn $ show $ length $ rewrite_all_AST_types 25600 $ Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions.e_out_type  $ Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions.expr_to_outer_types big_conv_2d_seq_idx

tests :: TestTree
--tests = testGroup "Top Level Aetherling Tests" [slowdown_tests, apps_tests]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests]
--tests = testGroup "Top Level Aetherling Tests" [slowdown_tests]
tests = testGroup "Top Level Aetherling Tests" [big_tests]


import Test.Tasty
import Test.Tasty.HUnit
import Test_Seq_Simulator
import Test_Seq_Embedding
import Test_ST_Embedding
import Test_Slowdown
import Test_Apps
import Test_Spatial

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Top Level Aetherling Tests" [slowdown_tests, apps_tests]
--tests = testGroup "Top Level Aetherling Tests" [apps_tests]


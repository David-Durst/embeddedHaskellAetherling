import Test.Tasty
import Test.Tasty.HUnit
import Test_Seq_Simulator
import Test_Seq_Embedding
import Test_ST_Embedding
import Test_Slowdown

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Top Level Aetherling Tests" [slowdown_tests]

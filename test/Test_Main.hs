import Test.Tasty
import Test.Tasty.HUnit
import Test_Seq_Simulator

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Top Level Aetherling Tests" [sequence_simulator_tests]

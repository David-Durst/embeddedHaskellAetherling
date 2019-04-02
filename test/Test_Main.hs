import Test.Tasty
import Test.Tasty.HUnit
import Test_Composition

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Top Level Aetherling Tests" [sequence_composition_tests]

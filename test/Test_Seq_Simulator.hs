module Test_Seq_Simulator where
import Test.Tasty
import Test.Tasty.HUnit
import Aetherling.ASTs.Sequence
import Aetherling.Interpretations.Simulator
import Aetherling.Types.Declarations

two_abs = absC >>> absC $ Atom_Int (-3)

add_of_two_abs x y = do
  x_abs <- absC x
  y_abs <- absC y
  x_y_abs_zipped <- atom_tupleC x_abs y_abs 
  addC x_y_abs_zipped

sequence_simulator_tests = testGroup "Verifying Sequence Simulator"
  [
    testCase "compose two unary functions" $ simulate two_abs @?= (Atom_Int 3),
    testCase "zip two unary functions into binary function" (
      simulate (add_of_two_abs (Atom_Int (-3)) (Atom_Int (-9))) @?= (Atom_Int 12))
  ]

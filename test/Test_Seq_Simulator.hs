module Test_Seq_Simulator where
import Test.Tasty
import Test.Tasty.HUnit
import Aetherling.ASTs.Sequence
import Aetherling.Interpretations.Simulator
import Aetherling.Types.Declarations
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Aetherling.Types.Isomorphisms

two_abs = absC >>> absC $ Atom_Int (-3)

add_of_two_abs x y = do
  x_val <- x
  y_val <- y
  x_abs <- absC x_val
  y_abs <- absC y_val
  x_y_abs_zipped <- atom_tupleC x_abs y_abs 
  addC x_y_abs_zipped

first_input_two_abs = sim_input_int (-3)
second_input_two_abs = sim_input_int (-9)

mapped_add x = do
  x_val <- x
  mapC (Proxy @2) addC x_val

mapped_add_input :: Simulation_Env (Seq 2 0 (Atom_Tuple Atom_Int Atom_Int))
mapped_add_input = sim_input_seq [
  Atom_Tuple (Atom_Int 1) (Atom_Int 3),
  Atom_Tuple (Atom_Int 3) (Atom_Int 4)]

mapped_add_output :: Seq 2 0 Atom_Int
mapped_add_output = Seq $ listToVector (Proxy @2) [Atom_Int 4, Atom_Int 7]

reduce_add x = do
  x_val <- x
  reduceC (Proxy @5) addC x_val
  
reduce_add_input :: Simulation_Env (Seq 5 0 Atom_Int)
reduce_add_input = sim_input_seq [Atom_Int 1, Atom_Int 3, Atom_Int 3,
                                  Atom_Int (-3), Atom_Int 4]

reduce_add_output :: Seq 1 4 Atom_Int
reduce_add_output = Seq $ listToVector (Proxy @1) [Atom_Int 8]

sequence_simulator_tests = testGroup "Verifying Sequence Simulator"
  [
    testCase "compose two unary functions" $ simulate two_abs @?= (Atom_Int 3),
    testCase "zip two unary functions into binary function" (
      simulate (add_of_two_abs first_input_two_abs second_input_two_abs) @?= (Atom_Int 12)),
    testCase "adding two sequences of length two" (
      simulate (mapped_add mapped_add_input) @?= mapped_add_output
      ),
    testCase "reducing a sequence with add" (
      simulate (reduce_add reduce_add_input) @?= reduce_add_output)
  ]

module Test_Slowdown where
import Test.Tasty
import Test.Tasty.HUnit
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Isomorphisms
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Aetherling.Rewrites.Sequence_Shallow_To_Deep
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
import Aetherling.Rewrites.Sequence_Assign_Indexes
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import Aetherling.Interpretations.Magma.Compile
import Aetherling.Interpretations.Magma.Tester
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.SBV
import Control.Monad.State

slowdown_tests = testGroup "Compiler Sequence To Verilog, Running Verilator"
  [
    testCase "slowing a single map" $
    (all_success =<< single_map_results) @? "single map slowdowns failed",
    testCase "slowing a single map applied to 200 elements" $
    (all_success =<< single_map_200_results) @? "single map 200 slowdowns failed",
    testCase "slowing two maps" $
    (all_success =<< two_maps_results) @? "two maps slowdowns failed",
    testCase "slowing a diamond" $
    (all_success =<< diamond_map_results) @? "diamond slowdowns failed",
    testCase "slowing a map with underutilization" $
    (all_success =<< single_map_underutil_results) @? "map with underutilization slowdowns failed",
    testCase "slowing a constant generator" $
    (all_success =<< const_test_results) @? "constant generator slowdowns failed",
    testCase "slowing a map to an upsample" $
    (all_success =<< map_to_up_results) @? "map to up slowdowns failed",
    testCase "slowing up to down" $
    (all_success =<< up_to_down_results) @? "up to down slowdowns failed",
    testCase "slowing nested map to top level up" $
    (all_success =<< nested_map_to_top_level_up_results) @? "nested map to top level up slowdowns failed",
    testCase "slowing nested map to nested up" $
    (all_success =<< nested_map_to_nested_up_results) @? "nested map to nested up slowdowns failed",
    testCase "slowing partition to flat map" $
    (all_success =<< partition_to_flat_map_results) @? "partition to flat map slowdowns failed",
    testCase "slowing map to unpartition" $
    (all_success =<< map_to_unpartition_results) @? "map to unpartition slowdowns failed",
    testCase "slowing double up" $
    (all_success =<< double_up_results) @? "double_up slowdowns failed",
    testCase "slowing down over nested to down over flattened" $
    (all_success =<< down_over_nested_to_down_over_flattened_results) @? "down over nested to down over flattened slowdowns failed",
    testCase "slowing tuple sum" $
    (all_success =<< tuple_sum_results) @? "tuple_sum slowdowns failed",
    testCase "slowing tuple reduce" $
    (all_success =<< tuple_reduce_results) @? "tuple_reduce slowdowns failed",
    testCase "slowing fst snd sum" $
    (all_success =<< fst_snd_sum_results) @? "fst snd sum slowdowns failed",
    testCase "slowing stuple to seq" $
    (all_success =<< stuple_to_seq_results) @? "stuple to seq slowdowns failed",
    testCase "slowing seq to stuple" $
    (all_success =<< seq_to_stuple_results) @? "seq to stuple slowdowns failed",
    testCase "slowing seq and stuple" $
    (all_success =<< seq_and_stuple_results) @? "seq and stuple slowdowns failed",
    testCase "slowing striple" $
    (all_success =<< striple_results) @? "striple slowdowns failed",
    testCase "slowing striple to seq" $
    (all_success =<< striple_to_seq_results) @? "striple to seq slowdowns failed"
  ]

all_success :: [Fault_Result] -> IO Bool
all_success results = do
  let checked_results = all (\x -> x == Fault_Success) results
  return checked_results
  
-- input to scheduling algorithm: expr tree
-- output to scheduling algorithm: amount to slow down each node
-- must slow down by same amount, potentially to different layers depending on partition/unpartition


-- comments are max slow down while not underutil for each layer
-- (layer is in ops, not seqs)

-- two most basic examples
single_map = 
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 Atom_Int))
single_map_seq_idx = add_indexes $ seq_shallow_to_deep single_map
single_map_ppar = fmap (\s -> rewrite_to_partially_parallel s single_map_seq_idx) [1,2,4]
single_map_ppar_typechecked = fmap check_type single_map_ppar
single_map_inputs :: [[Integer]] = [[0,-1,2,3]]
single_map_output :: [Integer] = [0,1,2,3]
-- sequence used to flip [] and IO so can print from command line
single_map_results = sequence $ fmap (\s -> compile_and_test_with_slowdown single_map s
                                            single_map_inputs single_map_output) [1,2,4]
single_map_results' = sequence $ fmap (\s -> compile_and_test_with_slowdown single_map s
                                            single_map_inputs single_map_output) [4]
single_map_ae_verilog = sequence $ fmap (\s -> compile_and_test_verilog single_map s
                                            single_map_inputs single_map_output
                                            "test/verilog_examples/aetherling_copies/map_s_4.v") [4]

add_5 atom_in = do
  let const = const_genC (Atom_Int 5) atom_in
  let tupled = atom_tupleC atom_in const
  addC tupled
single_map_200 = 
  mapC' (Proxy @200) add_5 $
  com_input_seq "hi" (Proxy :: Proxy (Seq 200 0 Atom_Int))
single_map_200_seq_idx = add_indexes $ seq_shallow_to_deep single_map_200
single_map_200_ppar = fmap (\s -> rewrite_to_partially_parallel s single_map_200_seq_idx) [1,5,10,20,25,40,50,100,200]
single_map_200_ppar_typechecked = fmap check_type single_map_200_ppar
single_map_200_inputs :: [[Integer]] = [[1..200]]
single_map_200_output :: [Integer] = [6..205]
-- sequence used to flip [] and IO so can print from command line
single_map_200_results = sequence $ fmap (\s -> compile_and_test_with_slowdown single_map_200 s
                                            single_map_200_inputs single_map_200_output) [1,5,10,20,25,40,50,100,200]

two_maps = 
  mapC' (Proxy @4) absC >>>
  mapC absC $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 Atom_Int))
two_maps_seq_idx = add_indexes $ seq_shallow_to_deep two_maps
two_maps_ppar = fmap (\s -> rewrite_to_partially_parallel s two_maps_seq_idx) [1,2,4]
two_maps_ppar_typechecked = fmap check_type two_maps_ppar
two_maps_inputs :: [[Integer]] = [[0,-1,2,3]]
two_maps_output :: [Integer] = [0,1,2,3]
-- sequence used to flip [] and IO so can print from command line
two_maps_results = sequence $ fmap (\s -> compile_and_test_with_slowdown two_maps s
                                            two_maps_inputs two_maps_output) [1,2,4]
{-
input_rewrite = rewrite_to_partially_parallel 2 (InputN (SeqT 4 0 IntT) "hi")
input_rewrite' :: Partially_Parallel_StateM STE.Expr
input_rewrite' = do
  tr <- lift $ rewrite_AST_type 2 (SeqT 4 0 IntT)
  sequence_to_partially_parallel tr (InputN (SeqT 4 0 IntT) "hi")
seq_rewrite' :: Partially_Parallel_StateM STT.AST_Type
seq_rewrite' = do
  tr <- lift $ rewrite_AST_type 2 (SeqT 4 0 IntT)
  part_par_AST_type tr (SeqT 4 0 IntT)
-}
tuple_simple_no_input input0 input1 =
  atom_tupleC input0 input1
tuple_simple = tuple_simple_no_input
               (com_input_int "l_int") 
               (com_input_bit "r_bit") 
tuple_simple_seq_idx = add_indexes $ seq_shallow_to_deep tuple_simple
-- this should fail. Can't slow down an operator on just atoms
tuple_simple_ppar = rewrite_to_partially_parallel 2 tuple_simple_seq_idx

tuple_map_no_input input0 input1 =
  map2C atom_tupleC input0 input1
tuple_map = tuple_map_no_input
               (com_input "l_int_seq" (Proxy :: Proxy (Seq 4 0 Atom_Int))) 
               (com_input "l_bit_seq" (Proxy :: Proxy (Seq 4 0 Atom_Bit))) 
tuple_map_seq_idx = add_indexes $ seq_shallow_to_deep tuple_map
tuple_map_ppar = fmap (\s -> rewrite_to_partially_parallel s tuple_map_seq_idx) [1,2,4]
tuple_map_ppar_typechecked = fmap check_type tuple_map_ppar

diamond_map_no_input input = do
  let branch = mapC absC input
  let tuple = map2C atom_tupleC branch input
  mapC addC tuple
diamond_map = diamond_map_no_input $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 Atom_Int))
diamond_map_seq_idx = add_indexes $ seq_shallow_to_deep diamond_map
diamond_map_ppar = fmap
  (\s -> rewrite_to_partially_parallel s diamond_map_seq_idx) [1,2,4]
diamond_map_ppar_typechecked = fmap check_type diamond_map_ppar
diamond_map_inputs :: [[Integer]] = [[0,-1,2,3]]
diamond_map_output :: [Integer] = [0,0,4,6]
diamond_map_results = sequence $ fmap (\s -> compile_and_test_with_slowdown diamond_map s
                                            diamond_map_inputs diamond_map_output) [1,2,4]

single_map_underutil = 
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 4 Atom_Int))
single_map_underutil_seq_idx = add_indexes $ seq_shallow_to_deep single_map_underutil
single_map_underutil_ppar = fmap
  (\s -> rewrite_to_partially_parallel s single_map_underutil_seq_idx) [1,2,4,8]
single_map_underutil_ppar_typechecked = fmap check_type single_map_underutil_ppar
single_map_underutil_inputs :: [[Integer]] = [[0,-1,2,3]]
single_map_underutil_output :: [Integer] = [0,1,2,3]
single_map_underutil_results = sequence $ fmap (\s -> compile_and_test_with_slowdown single_map_underutil s
                                            single_map_underutil_inputs single_map_underutil_output) [1,2,4,8]

const_test =
  const_genC (list_to_seq (Proxy @9) $ fmap Atom_Int [0..8] :: Seq 9 0 Atom_Int) $
  com_input "not_used" (Proxy :: Proxy Atom_Int)
const_test_seq_idx = add_indexes $ seq_shallow_to_deep const_test
const_test_ppar = fmap
  (\s -> rewrite_to_partially_parallel s const_test_seq_idx) [1,3,9]
const_test_ppar_typechecked = fmap check_type const_test_ppar
const_test_inputs :: [[Integer]] = []
const_test_outputs :: [Integer] = [0..8]
const_test_results = sequence $ fmap (\s -> compile_and_test_with_slowdown const_test s
                                     const_test_inputs const_test_outputs) [1,3,9]

-- tests basic multi-rate
map_to_up = 
  mapC' (Proxy @1) absC >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 3 Atom_Int))
map_to_up_seq_idx = add_indexes $ seq_shallow_to_deep map_to_up
map_to_up_ppar = fmap (\s -> rewrite_to_partially_parallel s map_to_up_seq_idx) [1,2,4]
map_to_up_ppar_typechecked = fmap check_type map_to_up_ppar
map_to_up_inputs :: [[Integer]] = [[2]]
map_to_up_output :: [Integer] = [2,2,2,2]
map_to_up_results = sequence $ fmap (\s -> compile_and_test_with_slowdown map_to_up s
                                            map_to_up_inputs map_to_up_output) [1,2,4]

-- test two multi-rates of different rates
up_to_down = 
  down_1dC' (Proxy @5) 0 >>>
  up_1dC (Proxy @4) $
  com_input_seq "I" (Proxy :: Proxy (Seq 5 0 Atom_Int))
up_to_down_seq_idx = add_indexes $ seq_shallow_to_deep up_to_down
up_to_down_ppar = fmap (\s -> rewrite_to_partially_parallel s up_to_down_seq_idx) [1,5]
up_to_down_ppar_typechecked = fmap check_type up_to_down_ppar
up_to_down_inputs :: [[Integer]] = [[1,2,3,4,5]]
up_to_down_output :: [Integer] = [1,1,1,1]
up_to_down_results = sequence $ fmap (\s -> compile_and_test_with_slowdown up_to_down s
                                            up_to_down_inputs up_to_down_output) [1,5]
up_to_down_results' = sequence $ fmap (\s -> compile_and_test_with_slowdown up_to_down s
                                            up_to_down_inputs up_to_down_output) [1]

-- next two test how to distribute slowdown correctly when multi-rate is nested
nested_map_to_top_level_up = 
  mapC' (Proxy @1) (mapC' (Proxy @4) absC) >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 5 (Seq 4 0 Atom_Int)))
-- note: the reason the output is a seminly unecessary split on the outer seq
-- for the slowest schedule is that there are still 2 invalid clocks not used
-- and I say partially parallel for those, becuase not fully slowed down
nested_map_to_top_level_up_seq_idx = add_indexes $ seq_shallow_to_deep nested_map_to_top_level_up
nested_map_to_top_level_up_ppar = fmap (\s -> rewrite_to_partially_parallel s nested_map_to_top_level_up_seq_idx) [1,2,4,8,16]
nested_map_to_top_level_up_ppar_typechecked = fmap check_type nested_map_to_top_level_up_ppar
nested_map_to_top_level_up_inputs :: [[[Integer]]] = [[[2,3,4,5]]]
nested_map_to_top_level_up_output :: [[Integer]] = [[2,3,4,5], [2,3,4,5],
                                                    [2,3,4,5], [2,3,4,5]]
nested_map_to_top_level_up_results = sequence $
  fmap (\s -> compile_and_test_with_slowdown nested_map_to_top_level_up s
              nested_map_to_top_level_up_inputs nested_map_to_top_level_up_output) [1,2,4,8,16]


nested_map_to_nested_up =
  mapC' (Proxy @4) (mapC' (Proxy @1) absC) >>> -- [1]
  mapC' (Proxy @4) (up_1dC (Proxy @4)) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 1 5 Atom_Int)))
nested_map_to_nested_up_seq_idx = add_indexes $ seq_shallow_to_deep nested_map_to_nested_up
nested_map_to_nested_up_ppar = fmap (\s -> rewrite_to_partially_parallel s nested_map_to_nested_up_seq_idx) [1,2,3,4,8,16]
nested_map_to_nested_up_ppar_typechecked = fmap check_type nested_map_to_nested_up_ppar
nested_map_to_nested_up_inputs :: [[[Integer]]] = [[[2],[3],[4],[5]]]
nested_map_to_nested_up_output :: [[Integer]] = [[2,2,2,2], [3,3,3,3],
                                                  [4,4,4,4], [5,5,5,5]]
nested_map_to_nested_up_results = sequence $
  fmap (\s -> compile_and_test_with_slowdown nested_map_to_nested_up s
              nested_map_to_nested_up_inputs nested_map_to_nested_up_output) [1,2,4,8,16]

-- testing basic partitioning
partition_to_flat_map = 
  partitionC (Proxy @2) (Proxy @2) (Proxy @2) (Proxy @2) >>>
  mapC (mapC absC) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 12 Atom_Int))
partition_to_flat_map_seq_idx = add_indexes $ seq_shallow_to_deep partition_to_flat_map
partition_to_flat_map_ppar = fmap (\s -> rewrite_to_partially_parallel s partition_to_flat_map_seq_idx) [1,2,4,8,16]
partition_to_flat_map_ppar_typechecked = fmap check_type partition_to_flat_map_ppar
partition_to_flat_inputs :: [[Integer]] = [[1,-2,3,4]]
partition_to_flat_output :: [[Integer]] = [[1,2],[3,4]]
partition_to_flat_map_results = sequence $ fmap (\s -> compile_and_test_with_slowdown partition_to_flat_map s
                                            partition_to_flat_inputs partition_to_flat_output) [1,2,4,8,16]

map_to_unpartition =
  mapC (mapC absC) >>>
  unpartitionC' (Proxy @2) (Proxy @2) >>>
  mapC absC $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 6 (Seq 2 0 Atom_Int)))
map_to_unpartition_seq_idx = add_indexes $ seq_shallow_to_deep map_to_unpartition
map_to_unpartition_ppar = fmap (\s -> rewrite_to_partially_parallel s map_to_unpartition_seq_idx) [1,2,4,8,16]
map_to_unpartition_ppar_typechecked = fmap check_type map_to_unpartition_ppar
map_to_unpartition_inputs :: [[[Integer]]] = [[[1,-2],[3,4]]]
map_to_unpartition_output :: [Integer] = [1,2,3,4]
map_to_unpartition_results = sequence $ fmap (\s -> compile_and_test_with_slowdown map_to_unpartition s
                                            map_to_unpartition_inputs map_to_unpartition_output) [1,2,4,8,16]

-- combining multi-rate with partitioning
double_up =
  partitionC (Proxy @2) (Proxy @1) (Proxy @0) (Proxy @15) >>>
  (mapC' (Proxy @2) (up_1dC (Proxy @4)) >>> -- [2, 3]
   unpartitionC >>> -- in : [2, 3], out : [6]
   partitionC (Proxy @1) (Proxy @8) Proxy (Proxy @0) >>> -- in : [6], out : [1, 6] or in : [[2, 3]] out : [1, [2, 3]] (this doesn't work as can't slow input down by 5, so must not be able to slow output down by 5) or in : [[2, 3]] out : []
   up_1dC (Proxy @4)) >>>
   unpartitionC $ -- [5, 6]
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 30 Atom_Int))
double_up_seq_idx = add_indexes $ seq_shallow_to_deep double_up
double_up_ppar = fmap (\s -> rewrite_to_partially_parallel s double_up_seq_idx) [1,2,4,8,16,32]
double_up_ppar_typechecked = fmap check_type double_up_ppar
double_up_inputs :: [[Integer]] = [[1,2]]
double_up_output :: [[Integer]] = [[1,1,1,1,2,2,2,2] | _ <- [1..4]]
double_up_results = sequence $ fmap (\s -> compile_and_test_with_slowdown double_up s
                                      double_up_inputs double_up_output) [1,2,4,8,16,32]


down_over_nested_to_down_over_flattened = 
  partitionC (Proxy @4) (Proxy @4) (Proxy @0) (Proxy @0) >>>
  (down_1dC' (Proxy @4) 0 >>>
   unpartitionC' (Proxy @1) (Proxy @4) >>>
   down_1dC' (Proxy @4) 0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 16 0 Atom_Int))
down_over_nested_to_down_over_flattened_seq_idx = add_indexes $
  seq_shallow_to_deep down_over_nested_to_down_over_flattened
down_over_nested_to_down_over_flattened_ppar =
  fmap (\s -> rewrite_to_partially_parallel s down_over_nested_to_down_over_flattened_seq_idx)
  [1,2,4,8,16]
down_over_nested_to_down_over_flattened_ppar_typechecked =
  fmap check_type down_over_nested_to_down_over_flattened_ppar
down_over_nested_to_down_over_flattened_ppar_typechecked' =
  fmap check_type' down_over_nested_to_down_over_flattened_ppar
down_over_nested_to_down_over_flattened_inputs :: [[Integer]] =
  [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]
down_over_nested_to_down_over_flattened_output :: [Integer] = [1]
down_over_nested_to_down_over_flattened_results =
  sequence $ fmap (\s -> compile_and_test_with_slowdown
                         down_over_nested_to_down_over_flattened s
                         down_over_nested_to_down_over_flattened_inputs
                         down_over_nested_to_down_over_flattened_output) [1,2,4,8,16]


tuple_sum_shallow_no_input in_seq = do
  let kernel_list = fmap Atom_Int [1,2,3,4]
  let kernel = const_genC (Seq $ listToVector (Proxy @4) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  mapC addC kernel_and_values
tuple_sum = tuple_sum_shallow_no_input $ 
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 Atom_Int))
tuple_sum_seq_idx = add_indexes $ seq_shallow_to_deep tuple_sum
tuple_sum_ppar =
  fmap (\s -> rewrite_to_partially_parallel s tuple_sum_seq_idx) [1,2,4]
tuple_sum_ppar_typechecked =
  fmap check_type tuple_sum_ppar
tuple_sum_ppar_typechecked' =
  fmap check_type' tuple_sum_ppar
tuple_sum_inputs :: [[Integer]] = [[4,2,8,10]]
tuple_sum_output :: [Integer] = [5,4,11,14]
tuple_sum_results = sequence $ fmap (\s -> compile_and_test_with_slowdown tuple_sum s
                                      tuple_sum_inputs tuple_sum_output) [1,2,4]

tuple_reduce_no_input in_seq = do
  let kernel_list = fmap Atom_Int [1,2,3,4,2,1,2,3]
  let kernel = const_genC (Seq $ listToVector (Proxy @8) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  let muled_pairs = mapC mulC kernel_and_values
  reduceC addC muled_pairs
tuple_reduce = tuple_reduce_no_input $
  com_input_seq "hi" (Proxy :: Proxy (Seq 8 0 Atom_Int))
tuple_reduce_seq_idx = add_indexes $ seq_shallow_to_deep tuple_reduce
tuple_reduce_ppar =
  fmap (\s -> rewrite_to_partially_parallel s tuple_reduce_seq_idx) [1,2,4,8]
tuple_reduce_ppar_typechecked =
  fmap check_type tuple_reduce_ppar
tuple_reduce_ppar_typechecked' =
  fmap check_type' tuple_reduce_ppar
tuple_reduce_inputs :: [[Integer]] = [[10,8,9,3,4,2,2,2]]
tuple_reduce_output :: [Integer] = [85]
-- need to come back and check why slowest version uses a reduce_s
tuple_reduce_results = sequence $ fmap (\s -> compile_and_test_with_slowdown tuple_reduce s
                                      tuple_reduce_inputs tuple_reduce_output) [1,2,4,8]


fst_snd_sum_no_input in_seq = do
  let kernel_list = fmap Atom_Int [1,2,3,4,5,6,7,8]
  let kernel = const_genC (Seq $ listToVector (Proxy @8) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  let kernel_again = mapC fstC kernel_and_values
  let in_seq_again = mapC sndC kernel_and_values
  let kernel_and_values_again = map2C atom_tupleC kernel_again in_seq_again
  mapC addC kernel_and_values_again
fst_snd_sum = fst_snd_sum_no_input $
  com_input_seq "hi" (Proxy :: Proxy (Seq 8 0 Atom_Int))
fst_snd_sum_seq_idx = add_indexes $ seq_shallow_to_deep fst_snd_sum
fst_snd_sum_ppar =
  fmap (\s -> rewrite_to_partially_parallel s fst_snd_sum_seq_idx) [1,2,4,8]
fst_snd_sum_ppar_typechecked =
  fmap check_type fst_snd_sum_ppar
fst_snd_sum_ppar_typechecked' =
  fmap check_type' fst_snd_sum_ppar
fst_snd_sum_inputs :: [[Integer]] = [[6,7,8,9,10,11,12,13]]
fst_snd_sum_output :: [Integer] = [7,9,11,13,15,17,19,21]
-- need to come back and check why slowest version uses a reduce_s
fst_snd_sum_results = sequence $ fmap (\s -> compile_and_test_with_slowdown fst_snd_sum s
                                      fst_snd_sum_inputs fst_snd_sum_output) [1,2,4,8]

seq_to_stuple = 
  seq_to_seq_tupleC $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 4 0 Atom_Int)))
seq_to_stuple_seq_idx = add_indexes $ seq_shallow_to_deep seq_to_stuple
seq_to_stuple_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s seq_to_stuple_seq_idx) [1,2,4,8,16]
seq_to_stuple_ppar_typechecked =
  fmap check_type seq_to_stuple_ppar
seq_to_stuple_inputs :: [[Integer]] = [[1..16]]
--seq_to_stuple_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
seq_to_stuple_output :: [Integer] = [1..16]
-- need to come back and check why slowest version uses a reduce_s
seq_to_stuple_results = sequence $ fmap (\s -> compile_and_test_with_slowdown seq_to_stuple s
                                      seq_to_stuple_inputs seq_to_stuple_output) [1,2,4,8,16]

stuple_to_seq = 
  seq_tuple_to_seqC Proxy (Proxy @0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 12 (Seq_Tuple 4 Atom_Int)))
stuple_to_seq_seq_idx = add_indexes $ seq_shallow_to_deep stuple_to_seq
stuple_to_seq_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s stuple_to_seq_seq_idx) [1,2,4,8,16]
stuple_to_seq_ppar_typechecked =
  fmap check_type stuple_to_seq_ppar
stuple_to_seq_inputs :: [[Integer]] = [[1..16]]
--stuple_to_seq_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
stuple_to_seq_output :: [Integer] = [1..16]
-- need to come back and check why slowest version uses a reduce_s
stuple_to_seq_results = sequence $ fmap (\s -> compile_and_test_with_slowdown stuple_to_seq s
                                      stuple_to_seq_inputs stuple_to_seq_output) [1,2,4,8,16]
  
seq_and_stuple_no_input = 
  seq_to_seq_tupleC >>>
  seq_tuple_to_seqC Proxy (Proxy @0)
seq_and_stuple = seq_and_stuple_no_input $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 4 0 Atom_Int)))
seq_and_stuple_seq_idx = add_indexes $ seq_shallow_to_deep $ seq_and_stuple
seq_and_stuple_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s seq_and_stuple_seq_idx) [1,2,4,8,16]
seq_and_stuple_ppar_typechecked =
  fmap check_type seq_and_stuple_ppar
seq_and_stuple_inputs :: [[Integer]] = [[1..16]]
--seq_and_stuple_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
seq_and_stuple_output :: [Integer] = [1..16]
-- need to come back and check why slowest version uses a reduce_s
seq_and_stuple_results = sequence $ fmap (\s -> compile_and_test_with_slowdown seq_and_stuple s
                                      seq_and_stuple_inputs seq_and_stuple_output) [1,2,4,8,16]

striple_no_input in_seq = do
  let pair = map2C seq_tupleC in_seq in_seq
  let triple = map2C seq_tuple_appendC pair in_seq
  seq_tuple_to_seqC Proxy (Proxy @0) triple
striple = striple_no_input $
          com_input_seq "hi" (Proxy :: Proxy (Seq 8 16 Atom_Int))
striple_seq_idx = add_indexes $ seq_shallow_to_deep striple
striple_ppar =
  fmap (\s -> rewrite_to_partially_parallel s striple_seq_idx) [1,2,4,8,24]
striple_ppar_typechecked =
  fmap check_type striple_ppar
striple_ppar_typechecked' =
  fmap check_type' striple_ppar
striple_inputs :: [[Integer]] = [[1..8]]
--striple_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
striple_output :: [[Integer]] = [[i, i, i] | i <- [1 .. 8]]
-- need to come back and check why slowest version uses a reduce_s
striple_results = sequence $ fmap (\s -> compile_and_test_with_slowdown striple s
                                      striple_inputs striple_output) [1,2,4,8,24]

striple_to_seq_shallow in_seq = do
  let pair = map2C seq_tupleC in_seq in_seq
  let triple = map2C seq_tuple_appendC pair in_seq
  seq_tuple_to_seqC Proxy (Proxy @0) triple
striple_to_seq = striple_to_seq_shallow $
  com_input_seq "hi" (Proxy :: Proxy (Seq 8 16 Atom_Int))
striple_to_seq_seq_idx = add_indexes $ seq_shallow_to_deep striple_to_seq
striple_to_seq_ppar =
  fmap (\s -> rewrite_to_partially_parallel s striple_to_seq_seq_idx) [1,2,4,8,24]
striple_to_seq_ppar_typechecked =
  fmap check_type striple_to_seq_ppar
striple_to_seq_ppar_typechecked' =
  fmap check_type' striple_to_seq_ppar
striple_to_seq_inputs :: [[Integer]] = [[1..8]]
--striple_to_seq_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
striple_to_seq_output :: [[Integer]] = [[i, i, i] | i <- [1 .. 8]]
-- need to come back and check why slowest version uses a reduce_s
striple_to_seq_results = sequence $ fmap (\s -> compile_and_test_with_slowdown striple_to_seq s
                                      striple_to_seq_inputs striple_to_seq_output) [1,2,4,8,24]


stencil_1dC_test window_size in_seq | (natVal window_size) >= 2 = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC (Proxy @1) last_shifted_seq) : l)
                     [in_seq] [0 .. natVal window_size - 2]
  let tuple = zipC window_size shifted_seqs
  seq_tuple_to_seqC Proxy (Proxy @0) tuple
stencil_1dC_test _ _ = undefined
stencil_1d_test = stencil_1dC_test (Proxy @3) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 100 200 Atom_Int))
stencil_1d_test_seq_idx = add_indexes $ seq_shallow_to_deep stencil_1d_test
stencil_1d_test_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s stencil_1d_test_seq_idx) [1,2,5,10,30,100,300]
stencil_1d_test_ppar_typechecked =
  fmap check_type stencil_1d_test_ppar
stencil_1d_test_ppar_typechecked' =
  fmap check_type' stencil_1d_test_ppar
stencil_1d_inputs :: [[Integer]] = [[1..100]]
--stencil_1d_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
stencil_1d_output :: [[Integer]] = [
  [
    if i > 2 then i-2 else int_to_ignore,
    if i > 1 then i-1 else int_to_ignore,
    i
  ] | i <- [1 .. 100]]
-- need to come back and check why slowest version uses a reduce_s
stencil_1d_results = sequence $ fmap (\s -> compile_and_test_with_slowdown stencil_1d_test s
                                      stencil_1d_inputs stencil_1d_output) [1,2,5,10,30,100,300]
                    -- 30 really bad case
stencil_1d_results' = sequence $ fmap (\s -> compile_and_test_with_slowdown stencil_1d_test s
                                      stencil_1d_inputs stencil_1d_output) [30]

tuple_mul_shallow_no_input in_seq = do
  let kernel_list = fmap Atom_Int [1,1,1]
  let kernel = const_genC (Seq $ listToVector (Proxy @3) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  let mul_result = mapC mulC kernel_and_values
  let sum = reduceC addC mul_result
  let norm_list = fmap Atom_Int [3]
  let norm = const_genC (Seq $ listToVector (Proxy @1) norm_list) in_seq
  let sum_and_norm = map2C atom_tupleC sum norm
  mapC divC sum_and_norm
conv_1d_shallow_no_input in_seq = do
  let stencil = stencil_1dC_test (Proxy @3) in_seq
  let conv_nested = mapC tuple_mul_shallow_no_input stencil
  unpartitionC conv_nested
conv_1d = conv_1d_shallow_no_input $ 
  com_input_seq "hi" (Proxy :: Proxy (Seq 5 10 Atom_Int))
conv_1d_seq_idx = add_indexes $ seq_shallow_to_deep conv_1d
conv_1d_ppar =
  fmap (\s -> rewrite_to_partially_parallel s conv_1d_seq_idx) [1,3,5,15]
conv_1d_ppar_typechecked =
  fmap check_type conv_1d_ppar
conv_1d_ppar_typechecked' =
  fmap check_type' conv_1d_ppar
conv_1d_inputs :: [[Integer]] = [[1,2,3,4,5]]
conv_1d_output :: [Integer] = [int_to_ignore,int_to_ignore,2,3,4]
conv_1d_results = sequence $ fmap (\s -> compile_and_test_with_slowdown conv_1d s
                                      conv_1d_inputs conv_1d_output) [1,3,5,15]
pyramid_1d_shallow_no_input in_seq = do
  let layer1_blurred = conv_1d_shallow_no_input in_seq
  let layer2_input = unpartitionC $ down_1dC 2 $
        partitionC (Proxy @3) (Proxy @3) Proxy (Proxy @0) layer1_blurred
  let layer2_blurred = conv_1d_shallow_no_input layer2_input
  down_1dC 2 layer2_blurred
pyramid_1d = pyramid_1d_shallow_no_input $ 
  com_input_seq "hi" (Proxy :: Proxy (Seq 9 18 Atom_Int))
pyramid_1d_seq_idx = add_indexes $ seq_shallow_to_deep pyramid_1d
pyramid_1d_ppar =
  fmap (\s -> rewrite_to_partially_parallel s pyramid_1d_seq_idx) [1,3,9,27]
pyramid_1d_ppar_typechecked =
  fmap check_type pyramid_1d_ppar
pyramid_1d_ppar_typechecked' =
  fmap check_type' pyramid_1d_ppar
pyramid_1d_inputs :: [[Integer]] = [[1..9]]
pyramid_1d_output :: [Integer] = [5]
pyramid_1d_results = sequence $ fmap (\s -> compile_and_test_with_slowdown pyramid_1d s
                                      pyramid_1d_inputs pyramid_1d_output) [1,3,9,27]

stencil_2dC_test window_size_row window_size_col in_col in_img = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC in_col last_shifted_seq) : l)
                     [in_img] [0 .. natVal window_size_row - 2]
  let stenciled_seqs = fmap (stencil_1dC_test window_size_col) shifted_seqs
  let tupled_seqs = zipC window_size_row stenciled_seqs
  let unflattened_windows = seq_tuple_to_seqC Proxy (Proxy @0) tupled_seqs
  mapC unpartitionC unflattened_windows
stencil_2d_test = seq_shallow_to_deep $
  stencil_2dC_test (Proxy @3) (Proxy @3) (Proxy @10) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 100 800 Atom_Int))
stencil_2d_test_seq_idx = add_indexes stencil_2d_test
stencil_2d_test_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s stencil_2d_test_seq_idx) [1,2,5,10,30]
stencil_2d_test_ppar_typechecked =
  fmap check_type stencil_2d_test_ppar
stencil_2d_test_ppar_typechecked' =
  fmap check_type' stencil_2d_test_ppar

map_reduce_nested = seq_shallow_to_deep $
  mapC (mapC absC) >>>
  mapC (reduceC addC) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 9 0 (Seq 9 0 Atom_Int)))
map_reduce_seq_idx = add_indexes map_reduce_nested
map_reduce_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s map_reduce_seq_idx) [1,3,9]
map_reduce_ppar_typechecked =
  fmap check_type map_reduce_ppar
-- END OF ACTUALLY TESTED THINGS
-- multiple unpartitions into a multi-rate
multi_unpartition_with_multi_rate = seq_shallow_to_deep $
  (mapC' (Proxy @3) (unpartitionC' (Proxy @2) (Proxy @5)) >>>
   unpartitionC' (Proxy @3) (Proxy @10) >>>
   down_1dC' (Proxy @30) 0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 3 0 (Seq 2 0 (Seq 5 0 Atom_Int))))

multi_partition_with_multi_rate = seq_shallow_to_deep $
  (up_1dC (Proxy @30) >>>
   partitionC (Proxy @3) (Proxy @10) (Proxy @0) (Proxy @0)  >>>
   mapC' (Proxy @3) (partitionC (Proxy @2) (Proxy @5) (Proxy @0) (Proxy @0) )) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 29 Atom_Int))
  
-- multiple unpartitions into a multi-rate, using fewer factors to show
-- can't split map between fully sequential 0 invalid clocks and
-- fully sequential with all invalid clocks
multi_unpartition_with_multi_rate_cant_split = seq_shallow_to_deep $
  (mapC' (Proxy @2) (mapC' (Proxy @2) absC) >>>
   unpartitionC' (Proxy @2) (Proxy @2) >>>
   partitionC (Proxy @1) (Proxy @4) Proxy (Proxy @0) >>>
   up_1dC (Proxy @4)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 2 6 Atom_Int)))

  -- down 6 >>> up 6
matching_down_up = seq_shallow_to_deep $
  (down_1dC' (Proxy @6) 0 >>>
   up_1dC (Proxy @6)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 6 0 Atom_Int))
  
  -- down 7 >>> up 5
mismatched_down_up = seq_shallow_to_deep $
  (down_1dC' (Proxy @7) 0 >>>
   up_1dC (Proxy @5)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 7 0 Atom_Int))


  -- map 4 of map 6 abs into map 4 of down_1d 6 - test which policy to use when downsample by 6 and 8
matched_nested_abs_down = seq_shallow_to_deep $
  (mapC' (Proxy @4) (mapC' (Proxy @6) absC) >>>
   mapC' (Proxy @4) (down_1dC' (Proxy @6) 0)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 6 0 Atom_Int)))

  -- multi-rate to map
  -- why won't the max approach without global solving for i work here?
  -- slow down by 8. Max n is 8, so think I can slow outer down by 8.
  -- this fails for slwoding down down 2 as end up partially parallelizing it
  -- I end up slowing down the down by 2 and then splitting the seq 8 that I'm downsampling
  -- into a tseq 4 and sseq 2.  This doesn't match how the map 8 abs is serialized without splitting
multi_rate_to_map = seq_shallow_to_deep $
  (down_1dC' (Proxy @2) 0 >>>
   unpartitionC' (Proxy @1) (Proxy @8) >>>
   mapC' (Proxy @8) absC) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 8 0 Atom_Int)))

nested_down_to_down = seq_shallow_to_deep $
  (mapC' (Proxy @2) (down_1dC' (Proxy @3) 0) >>>
   unpartitionC' (Proxy @2) (Proxy @1) >>>
   down_1dC' (Proxy @2) 0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 3 0 Atom_Int)))

down_unpartition_down = seq_shallow_to_deep $
  (down_1dC' (Proxy @4) 0 >>>
   unpartitionC' (Proxy @1) (Proxy @4) >>>
   down_1dC' (Proxy @4) 0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 4 0 Atom_Int)))

f_sbv :: IO SatResult
f_sbv = sat $ do
      x <- sInteger "x"
      constrain $ x .< 200

f_add_sbv :: Int -> IO SatResult
f_add_sbv x = sat $ do
  in_no <- sInteger "in_no"
  constrain $ in_no .== (fromIntegral x) + 1
  
f_comp_sbv :: Int -> IO SatResult
f_comp_sbv x = sat $ do
  in_no <- sInteger "in_no"
  in_ni <- sInteger "in_ni"
  in_io <- sInteger "in_io"
  in_ii <- sInteger "in_ii"
  constrain $ in_no .== (fromIntegral x)
  constrain $ in_ni .== 300
  constrain $ 300 .== (in_no * in_ii) + (in_io * (in_ni + in_ii))
  constrain $ in_io .<= 600
  constrain $ in_ii .<= 600
  constrain $ in_io .>= 0
  constrain $ in_ii .>= 0

  -- map 4 abs >>> partition 4 1 >>> up_1d 4  - nullset in second nesting

  -- map 8 abs >>> partition 4 2 >>> map 4 (map 2 abs)

  -- note: only way for a factor in the below structure to not be equal is if: multi-rate, which goes from n to 1 or 1 to n, or partition, which requires that factors across two layers for one index in lists equal to factor in 1 layer for before parittion/after unpartition
  -- algorithm - create a datastructure where - list for each layer of program. FOr each layer's list, create a list of elements with 1 per operator
  -- enter a nullset if an operator doesn't exist at a layer
  -- slowdown by s - if s >= max(layer lengths) and s `mod` length == 0 for all lengths in a layer, then slow down all op's for this layer by s and then try slowdown by remaining amount at lower layers
  --            else if s <= min(layer lengths) and length `mod` s == 0 for all lenghts in a layer, then split all ops for this layer and slow down by s. Done
  --            else if s > min(layer lengths) and s < max(layer lengths) and length `mod` s == 0 or s `mod` length == 0 for all, then split current layer, then split max layer, slow it by s, and propagate s to lower layers only for those with s > min(layer lengths). Since only way this can occur is partition, will have factors at lower layers for those ops where rest of s can be applied
  --            else if last layer, then go up
  -- on way up, if remaining s is greater than all remaining parallaleism for that layer, then underudtil for that layer and stop
  -- if reach top and s is not 1, fail
  -- if underutil at layer below one that a node has lengths for, propagate unduertilization up using the underutil formulas for partition and unpartition

  -- this algorithm doesn't work. The layers don't have consistent amount of nesting
  -- so figuring out the max for one layer doesn't account for how that max
  -- will be distributed over other layers with partition/unpartition.
  -- the global solve for i does this as it makes it clear how to solve for all levels.



  -- new algorithm:
  -- try to rewrite each node from top to bottom, keeping track of either sseq, tseq, or split output
  -- each node accepts its 

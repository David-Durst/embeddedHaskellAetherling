module Test_Slowdown where
import Test.Tasty
import Test.Tasty.HUnit
import Aetherling.Monad_Helpers
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Isomorphisms
import Aetherling.Interpretations.Compute_Latency
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Aetherling.Rewrites.Sequence_Shallow_To_Deep
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Aetherling.Rewrites.Sequence_Assign_Indexes
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import Aetherling.Interpretations.Backend_Execute.Compile
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import Control.Monad.Except
import Data.Proxy
import Data.Traversable
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.SBV
import Control.Monad.State
import Data.Either

slowdown_tests = testGroup "Compiler Sequence To Verilog, Running Verilator"
  [
    testCase "slowing a single map" $
    (all_success single_map_results) @? "single map slowdowns failed",
    testCase "slowing two maps" $
    (all_success two_maps_results) @? "two maps slowdowns failed",
    testCase "slowing a diamond" $
    (all_success diamond_map_results) @? "diamond slowdowns failed",
    testCase "slowing a map with underutilization" $
    (all_success single_map_underutil_results) @? "map with underutilization slowdowns failed",
    testCase "slowing a constant generator" $
    (all_success const_test_results) @? "constant generator slowdowns failed",
    testCase "slowing a less than" $
    (all_success lt_test_results) @? "less than slowdowns failed",
    testCase "slowing an if and less than" $
    (all_success if_lt_test_results) @? "if and less than slowdowns failed",
    testCase "slowing a map to an upsample" $
    (all_success map_to_up_results) @? "map to up slowdowns failed",
    testCase "slowing up to down" $
    (all_success up_to_down_results) @? "up to down slowdowns failed",
    testCase "slowing nested map to top level up" $
    (all_success nested_map_to_top_level_up_results) @? "nested map to top level up slowdowns failed",
    testCase "slowing nested map to nested up" $
    (all_success nested_map_to_nested_up_results) @? "nested map to nested up slowdowns failed",
    testCase "slowing partition to flat map" $
    (all_success partition_to_flat_map_results) @? "partition to flat map slowdowns failed",
    testCase "slowing map to unpartition" $
    (all_success map_to_unpartition_results) @? "map to unpartition slowdowns failed",
    testCase "slowing double up" $
    (all_success double_up_results) @? "double_up slowdowns failed",
    testCase "slowing down over nested to down over flattened" $
    (all_success down_over_nested_to_down_over_flattened_results) @? "down over nested to down over flattened slowdowns failed",
    testCase "slowing tuple sum" $
    (all_success tuple_sum_results) @? "tuple_sum slowdowns failed",
    testCase "slowing tuple reduce" $
    (all_success tuple_reduce_results) @? "tuple_reduce slowdowns failed",
    testCase "slowing fst snd sum" $
    (all_success fst_snd_sum_results) @? "fst snd sum slowdowns failed",
    testCase "slowing stuple to seq" $
    (all_success stuple_to_seq_results) @? "stuple to seq slowdowns failed",
    testCase "slowing seq to stuple" $
    (all_success seq_to_stuple_results) @? "seq to stuple slowdowns failed",
    testCase "slowing seq and stuple" $
    (all_success seq_and_stuple_results) @? "seq and stuple slowdowns failed",
    testCase "slowing striple to seq" $
    (all_success striple_to_seq_results) @? "striple to seq slowdowns failed"
  ]

all_success :: IO [[Test_Result]] -> IO Bool
all_success results_io = do
  results <- results_io
  let checked_results = all (\x -> x == Test_Success) $ concat results
  return checked_results
  
-- input to scheduling algorithm: expr tree
-- output to scheduling algorithm: amount to slow down each node
-- must slow down by same amount, potentially to different layers depending on partition/unpartition


-- comments are max slow down while not underutil for each layer
-- (layer is in ops, not seqs)

-- two most basic examples
single_map = 
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
single_map_seq_idx = add_indexes $ seq_shallow_to_deep single_map
single_map_ppar = fmap (\s -> compile_with_slowdown_to_expr single_map s) [1,2,4]
single_map_ppar_typechecked = fmap check_type single_map_ppar
single_map_inputs :: [[Integer]] = [[0,-1,2,3]]
single_map_output :: [Integer] = [0,1,2,3]
-- sequence used to flip [] and IO so can print from command line
single_map_results = sequence $
  fmap (\s -> test_with_backend
              single_map (wrap_single_s s)
              Magma (Save_Gen_Verilog "single_map")
              single_map_inputs single_map_output) [1,2,4]
single_map_results_chisel = sequence $
  fmap (\s -> test_with_backend
              single_map (wrap_single_s s)
              Chisel (Save_Gen_Verilog "single_map")
              single_map_inputs single_map_output) [1,2,4]
single_map_verilog_path = "test/verilog_examples/aetherling_copies/single_map/single_map_4_0.v"
single_map_ae_verilog = sequence $
  fmap (\s -> test_with_backend
              single_map (wrap_single_s s)
              Magma (verilog_sim_source single_map_verilog_path)
              single_map_inputs single_map_output
       ) [4]
single_map_save_chisel = sequence $
  fmap (\s -> compile_to_file
              single_map (wrap_single_s s)
              Chisel "single_map_chisel") [1,2,4]


two_maps = 
  mapC' (Proxy @4) absC >>>
  mapC absC $ -- [4]
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
two_maps_seq_idx = add_indexes $ seq_shallow_to_deep two_maps
two_maps_ppar = fmap (\s -> compile_with_slowdown_to_expr two_maps s) [1,2,4]
two_maps_ppar_typechecked = fmap check_type two_maps_ppar
two_maps_inputs :: [[Integer]] = [[0,-1,2,3]]
two_maps_output :: [Integer] = [0,1,2,3]
-- sequence used to flip [] and IO so can print from command line
two_maps_results = sequence $
  fmap (\s -> test_with_backend
              two_maps (wrap_single_s s)
              Magma No_Verilog
              two_maps_inputs two_maps_output) [1,2,4]
two_maps_results_chisel = sequence $
  fmap (\s -> test_with_backend
              two_maps (wrap_single_s s)
              Chisel No_Verilog
              two_maps_inputs two_maps_output) [1,2,4]
two_maps_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              two_maps (wrap_single_s s)
              Chisel No_Verilog
              two_maps_inputs two_maps_output) [1]
                   
tuple_simple_no_input input0 input1 =
  atom_tupleC input0 input1
tuple_simple = tuple_simple_no_input
               (com_input_int "l_int") 
               (com_input_bit "r_bit") 
tuple_simple_seq_idx = add_indexes $ seq_shallow_to_deep tuple_simple
-- this should fail. Can't slow down an operator on just atoms
tuple_simple_ppar = compile_with_slowdown_to_expr tuple_simple 2

tuple_map_no_input input0 input1 =
  map2C atom_tupleC input0 input1
tuple_map = tuple_map_no_input
               (com_input "l_int_seq" (Proxy :: Proxy (Seq 4 Atom_Int))) 
               (com_input "l_bit_seq" (Proxy :: Proxy (Seq 4 Atom_Bit))) 
tuple_map_seq_idx = add_indexes $ seq_shallow_to_deep tuple_map
tuple_map_ppar = fmap (\s -> compile_with_slowdown_to_expr tuple_map s) [1,2,4]
tuple_map_ppar_typechecked = fmap check_type tuple_map_ppar

diamond_map_no_input input = do
  let branch = mapC absC input
  let tuple = map2C atom_tupleC branch input
  mapC addC tuple
diamond_map = diamond_map_no_input $
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
diamond_map_seq_idx = add_indexes $ seq_shallow_to_deep diamond_map
diamond_map_ppar = fmap
  (\s -> compile_with_slowdown_to_expr diamond_map s) [1,2,4]
diamond_map_ppar_typechecked = fmap check_type diamond_map_ppar
diamond_map_inputs :: [[Integer]] = [[0,-1,2,3]]
diamond_map_output :: [Integer] = [0,0,4,6]
diamond_map_results = sequence $
  fmap (\s -> test_with_backend
              diamond_map (wrap_single_s s)
              Magma No_Verilog
              diamond_map_inputs diamond_map_output) [1,2,4]
diamond_map_results_chisel = sequence $
  fmap (\s -> test_with_backend
              diamond_map (wrap_single_s s)
              Chisel No_Verilog
              diamond_map_inputs diamond_map_output) [1,2,4]

single_map_underutil = 
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
single_map_underutil_seq_idx = add_indexes $ seq_shallow_to_deep single_map_underutil
single_map_underutil_ppar = fmap
  (\s -> compile_with_slowdown_to_expr single_map_underutil s) [1,2,4,8]
single_map_underutil_ppar_typechecked = fmap check_type single_map_underutil_ppar
single_map_underutil_inputs :: [[Integer]] = [[0,-1,2,3]]
single_map_underutil_output :: [Integer] = [0,1,2,3]
single_map_underutil_results = sequence $
  fmap (\s -> test_with_backend
              single_map_underutil (wrap_single_s s)
              Magma No_Verilog
              single_map_underutil_inputs single_map_underutil_output) [1,2,4,8]
single_map_underutil_results_chisel = sequence $
  fmap (\s -> test_with_backend
              single_map_underutil (wrap_single_s s)
              Chisel No_Verilog
              single_map_underutil_inputs single_map_underutil_output) [1,2,4,8]

const_test =
  const_genC (list_to_seq (Proxy @9) $ fmap Atom_Int [0..8] :: Seq 9 Atom_Int) $
  com_input "not_used" (Proxy :: Proxy Atom_Int)
const_test_seq_idx = add_indexes $ seq_shallow_to_deep const_test
-- why does this test have latency 3 for 1 input reg and 3 out?
-- because the input never gets added since no input to reg
-- the output only has 2 regs since 1 of 3 gets folded into const
const_test_ppar = fmap
  (\s -> compile_with_slowdown_to_expr const_test s) [1,3,9]
const_test_ppar_typechecked = fmap check_type const_test_ppar
const_test_inputs :: [[Integer]] = []
const_test_outputs :: [Integer] = [0..8]
const_test_results = sequence $
  fmap (\s -> test_with_backend 
              const_test (wrap_single_s s)
              Magma No_Verilog
              const_test_inputs const_test_outputs) [1,3,9]
const_test_results_chisel = sequence $
  fmap (\s -> test_with_backend 
              const_test (wrap_single_s s)
              Chisel No_Verilog
              const_test_inputs const_test_outputs) [1,3,9]

lt_atom_test x = do
  let one = const_genC (Atom_Int 1) x
  ltC $ atom_tupleC x one
lt_test =
  mapC' (Proxy @4) lt_atom_test $
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
lt_test_seq_idx = add_indexes $ seq_shallow_to_deep lt_test
lt_test_ppar = fmap
  (\s -> compile_with_slowdown_to_expr lt_test s) [1,2,4]
lt_test_ppar_typechecked = fmap check_type lt_test_ppar
lt_test_ppar_typechecked' = fmap check_type_get_error lt_test_ppar
lt_test_inputs :: [[Integer]] = [[0..3]]
lt_test_outputs :: [Integer] = [1,0,0,0]
lt_test_results = sequence $
  fmap (\s -> test_with_backend
              lt_test (wrap_single_s s)
              Magma No_Verilog
              lt_test_inputs lt_test_outputs) [1,2,4]
lt_test_results_chisel = sequence $
  fmap (\s -> test_with_backend
              lt_test (wrap_single_s s)
              Chisel No_Verilog
              lt_test_inputs lt_test_outputs) [1,2,4]
  
if_lt_atom_test x = do
  let one = const_genC (Atom_Int 1) x
  let two = const_genC (Atom_Int 2) x
  let three = const_genC (Atom_Int 3) x
  let bool = ltC $ atom_tupleC x one
  ifC (atom_tupleC bool (atom_tupleC three two))
if_lt_test =
  mapC' (Proxy @4) if_lt_atom_test $
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
if_lt_test_seq_idx = add_indexes $ seq_shallow_to_deep if_lt_test
if_lt_test_ppar = fmap
  (\s -> compile_with_slowdown_to_expr if_lt_test s) [1,2,4]
if_lt_test_ppar_typechecked = fmap check_type if_lt_test_ppar
if_lt_test_ppar_typechecked' = fmap check_type_get_error if_lt_test_ppar
if_lt_test_inputs :: [[Integer]] = [[0..3]]
if_lt_test_outputs :: [Integer] = [3,2,2,2]
if_lt_test_results = sequence $
  fmap (\s -> test_with_backend 
              if_lt_test (wrap_single_s s)
              Magma No_Verilog
              if_lt_test_inputs if_lt_test_outputs) [1,2,4]
if_lt_test_results_chisel = sequence $
  fmap (\s -> test_with_backend 
              if_lt_test (wrap_single_s s)
              Chisel No_Verilog
              if_lt_test_inputs if_lt_test_outputs) [1,2,4]
  
-- tests basic multi-rate
map_to_up = 
  mapC' (Proxy @1) absC >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "I" (Proxy :: Proxy (Seq 1 Atom_Int))
map_to_up_seq_idx = add_indexes $ seq_shallow_to_deep map_to_up
map_to_up_ppar = fmap (\s -> compile_with_slowdown_to_expr map_to_up s) [1,2,4]
map_to_up_ppar_typechecked = fmap check_type map_to_up_ppar
map_to_up_inputs :: [[Integer]] = [[2]]
map_to_up_output :: [Integer] = [2,2,2,2]
map_to_up_results = sequence $
  fmap (\s -> test_with_backend
              map_to_up (wrap_single_s s)
              Magma No_Verilog
              map_to_up_inputs map_to_up_output) [1,2,4]
map_to_up_results_chisel = sequence $
  fmap (\s -> test_with_backend
              map_to_up (wrap_single_s s)
              Chisel No_Verilog
              map_to_up_inputs map_to_up_output) [1,2,4]

-- test two multi-rates of different rates
up_to_down = 
  down_1dC' (Proxy @5) 0 >>>
  up_1dC (Proxy @4) $
  com_input_seq "I" (Proxy :: Proxy (Seq 5 Atom_Int))
up_to_down_seq_idx = add_indexes $ seq_shallow_to_deep up_to_down
up_to_down_ppar = fmap (\s -> compile_with_slowdown_to_expr up_to_down s) [1,5]
up_to_down_ppar_typechecked = fmap check_type up_to_down_ppar
up_to_down_inputs :: [[Integer]] = [[1,2,3,4,5]]
up_to_down_output :: [Integer] = [1,1,1,1]
up_to_down_results = sequence $
  fmap (\s -> test_with_backend
              up_to_down (wrap_single_s s)
              Magma No_Verilog
              up_to_down_inputs up_to_down_output) [1,5]
up_to_down_results_chisel = sequence $
  fmap (\s -> test_with_backend
              up_to_down (wrap_single_s s)
              Chisel No_Verilog
              up_to_down_inputs up_to_down_output) [1,5]
  
up_to_down_results' = sequence $
  fmap (\s -> test_with_backend 
              up_to_down (wrap_single_s s)
              Magma No_Verilog
              up_to_down_inputs up_to_down_output) [1]

-- next two test how to distribute slowdown correctly when multi-rate is nested
nested_map_to_top_level_up = 
  mapC' (Proxy @1) (mapC' (Proxy @4) absC) >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "I" (Proxy :: Proxy (Seq 1 (Seq 4 Atom_Int)))
-- note: the reason the output is a seminly unecessary split on the outer seq
-- for the slowest schedule is that there are still 2 invalid clocks not used
-- and I say partially parallel for those, becuase not fully slowed down
nested_map_to_top_level_up_seq_idx = add_indexes $ seq_shallow_to_deep nested_map_to_top_level_up
nested_map_to_top_level_up_ppar =
  fmap (\s -> compile_with_slowdown_to_expr
              nested_map_to_top_level_up s) [1,2,4,8,16]
nested_map_to_top_level_up_ppar_typechecked =
  fmap check_type nested_map_to_top_level_up_ppar
nested_map_to_top_level_up_inputs :: [[[Integer]]] = [[[2,3,4,5]]]
nested_map_to_top_level_up_output :: [[Integer]] = [[2,3,4,5], [2,3,4,5],
                                                    [2,3,4,5], [2,3,4,5]]
nested_map_to_top_level_up_results = sequence $
  fmap (\s -> test_with_backend
              nested_map_to_top_level_up (wrap_single_s s)
              Magma No_Verilog
              nested_map_to_top_level_up_inputs nested_map_to_top_level_up_output)
  [1,2,4,8,16]
nested_map_to_top_level_up_results_chisel = sequence $
  fmap (\s -> test_with_backend
              nested_map_to_top_level_up (wrap_single_s s)
              Chisel No_Verilog
              nested_map_to_top_level_up_inputs nested_map_to_top_level_up_output)
  [1,2,4,8,16]


nested_map_to_nested_up =
  mapC' (Proxy @4) (mapC' (Proxy @1) absC) >>> -- [1]
  mapC' (Proxy @4) (up_1dC (Proxy @4)) $ -- [4]
  com_input_seq "I" (Proxy :: Proxy (Seq 4 (Seq 1 Atom_Int)))
nested_map_to_nested_up_seq_idx = add_indexes $ seq_shallow_to_deep nested_map_to_nested_up
nested_map_to_nested_up_ppar =
  fmap (\s -> compile_with_slowdown_to_expr
              nested_map_to_nested_up s) [1,2,3,4,8,16]
nested_map_to_nested_up_ppar_typechecked = fmap check_type nested_map_to_nested_up_ppar
nested_map_to_nested_up_inputs :: [[[Integer]]] = [[[2],[3],[4],[5]]]
nested_map_to_nested_up_output :: [[Integer]] = [[2,2,2,2], [3,3,3,3],
                                                  [4,4,4,4], [5,5,5,5]]
nested_map_to_nested_up_results = sequence $
  fmap (\s -> test_with_backend
              nested_map_to_nested_up (wrap_single_s s)
              Magma No_Verilog
              nested_map_to_nested_up_inputs nested_map_to_nested_up_output) [1,2,4,8,16]
nested_map_to_nested_up_results_chisel = sequence $
  fmap (\s -> test_with_backend
              nested_map_to_nested_up (wrap_single_s s)
              Chisel No_Verilog
              nested_map_to_nested_up_inputs nested_map_to_nested_up_output) [1,2,4,8,16]

-- testing basic partitioning
partition_to_flat_map = 
  partitionC (Proxy @2) (Proxy @2) >>>
  mapC (mapC absC) $
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
partition_to_flat_map_seq_idx = add_indexes $ seq_shallow_to_deep partition_to_flat_map
partition_to_flat_map_ppar =
  fmap (\s -> compile_with_slowdown_to_expr
              partition_to_flat_map s) [1,2,4,8,16]
partition_to_flat_map_ppar_typechecked = fmap check_type partition_to_flat_map_ppar
partition_to_flat_inputs :: [[Integer]] = [[1,-2,3,4]]
partition_to_flat_output :: [[Integer]] = [[1,2],[3,4]]
partition_to_flat_map_results = sequence $
  fmap (\s -> test_with_backend
              partition_to_flat_map (wrap_single_s s)
              Magma No_Verilog
              partition_to_flat_inputs partition_to_flat_output) [1,2,4,8,16]
partition_to_flat_map_results_chisel = sequence $
  fmap (\s -> test_with_backend
              partition_to_flat_map (wrap_single_s s)
              Chisel No_Verilog
              partition_to_flat_inputs partition_to_flat_output) [1,2,4,8,16]

map_to_unpartition =
  mapC (mapC absC) >>>
  unpartitionC' (Proxy @2) (Proxy @2) >>>
  mapC absC $
  com_input_seq "I" (Proxy :: Proxy (Seq 2 (Seq 2 Atom_Int)))
map_to_unpartition_seq_idx = add_indexes $ seq_shallow_to_deep map_to_unpartition
map_to_unpartition_ppar =
  fmap (\s -> compile_with_slowdown_to_expr
              map_to_unpartition s) [1,2,4,8,16]
map_to_unpartition_ppar_typechecked = fmap check_type map_to_unpartition_ppar
map_to_unpartition_inputs :: [[[Integer]]] = [[[1,-2],[3,4]]]
map_to_unpartition_output :: [Integer] = [1,2,3,4]
map_to_unpartition_results = sequence $
  fmap (\s -> test_with_backend
              map_to_unpartition (wrap_single_s s)
              Magma No_Verilog
              map_to_unpartition_inputs map_to_unpartition_output) [1,2,4,8,16]
map_to_unpartition_results_chisel = sequence $
  fmap (\s -> test_with_backend
              map_to_unpartition (wrap_single_s s)
              Chisel No_Verilog
              map_to_unpartition_inputs map_to_unpartition_output) [1,2,4,8,16]

-- combining multi-rate with partitioning
double_up =
  partitionC (Proxy @2) (Proxy @1) >>>
  (mapC' (Proxy @2) (up_1dC (Proxy @4)) >>> -- [2, 3]
   unpartitionC >>> -- in : [2, 3], out : [6]
   partitionC (Proxy @1) (Proxy @8) >>> -- in : [6], out : [1, 6] or in : [[2, 3]] out : [1, [2, 3]] (this doesn't work as can't slow input down by 5, so must not be able to slow output down by 5) or in : [[2, 3]] out : []
   up_1dC (Proxy @4)) >>>
   unpartitionC $ -- [5, 6]
  com_input_seq "I" (Proxy :: Proxy (Seq 2 Atom_Int))
double_up_seq_idx = add_indexes $ seq_shallow_to_deep double_up
double_up_ppar =
  fmap (\s -> compile_with_slowdown_to_expr
              double_up s) [1,2,4,8,16,32]
double_up_ppar_typechecked = fmap check_type double_up_ppar
double_up_inputs :: [[Integer]] = [[1,2]]
double_up_output :: [[Integer]] = [[1,1,1,1,2,2,2,2] | _ <- [1..4]]
double_up_results = sequence $
  fmap (\s -> test_with_backend
              double_up (wrap_single_s s)
              Magma No_Verilog
              double_up_inputs double_up_output) [1,2,4,8,16,32]
double_up_results_chisel = sequence $
  fmap (\s -> test_with_backend
              double_up (wrap_single_s s)
              Chisel No_Verilog
              -- not using other throuhgputs as they require reshape
              -- that isn't a passthrough
              -- and I haven't implemented that for chisel yet
              double_up_inputs double_up_output) [1,8,32]


down_over_nested_to_down_over_flattened = 
  partitionC (Proxy @4) (Proxy @4) >>>
  (down_1dC' (Proxy @4) 0 >>>
   unpartitionC' (Proxy @1) (Proxy @4) >>>
   down_1dC' (Proxy @4) 0) $
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_Int))
down_over_nested_to_down_over_flattened_seq_idx = add_indexes $
  seq_shallow_to_deep down_over_nested_to_down_over_flattened
down_over_nested_to_down_over_flattened_ppar =
  fmap (\s -> compile_with_slowdown_to_expr
         down_over_nested_to_down_over_flattened s) [1,2,4,8,16]
--down_over_nested_to_down_over_flattened_ppar_old =
--  fmap (\s -> rewrite_to_partially_parallel_old s down_over_nested_to_down_over_flattened_seq_idx)
--  [1,2,4,8,16]
down_over_nested_to_down_over_flattened_ppar_typechecked =
  fmap check_type down_over_nested_to_down_over_flattened_ppar
down_over_nested_to_down_over_flattened_ppar_typechecked' =
  fmap check_type_get_error down_over_nested_to_down_over_flattened_ppar
down_over_nested_to_down_over_flattened_inputs :: [[Integer]] =
  [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]
down_over_nested_to_down_over_flattened_output :: [Integer] = [1]
down_over_nested_to_down_over_flattened_results = sequence $
  fmap (\s -> test_with_backend
              down_over_nested_to_down_over_flattened
              (wrap_single_s s) Magma No_Verilog
              down_over_nested_to_down_over_flattened_inputs
              down_over_nested_to_down_over_flattened_output) [1,2,4,8,16]
down_over_nested_to_down_over_flattened_results_chisel = sequence $
  fmap (\s -> test_with_backend
              down_over_nested_to_down_over_flattened
              (wrap_single_s s) Chisel No_Verilog
              down_over_nested_to_down_over_flattened_inputs
              -- not using other throuhgputs as they require reshape
              -- that isn't a passthrough
              -- and I haven't implemented that for chisel yet
              down_over_nested_to_down_over_flattened_output) [1,16]
down_over_nested_to_down_over_flattened_results' = sequence $
  fmap (\s -> test_with_backend
              down_over_nested_to_down_over_flattened
              (wrap_single_s s) Magma No_Verilog
              down_over_nested_to_down_over_flattened_inputs
              down_over_nested_to_down_over_flattened_output) [16]


tuple_reverse_shallow_no_input in_seq0 in_seq1 = do
  map2C (\x y -> sndC $ atom_tupleC y x) in_seq0 in_seq1
tuple_reverse = tuple_reverse_shallow_no_input
  (com_input_seq "I0" (Proxy :: Proxy (Seq 4 Atom_Int)))
  (com_input_seq "I1" (Proxy :: Proxy (Seq 4 Atom_Int)))
tuple_reverse_seq_idx = add_indexes $ seq_shallow_to_deep tuple_reverse
tuple_reverse_ppar =
  fmap (\s -> compile_with_slowdown_to_expr tuple_reverse s) [1,2,4]
tuple_reverse_ppar_typechecked =
  fmap check_type tuple_reverse_ppar
tuple_reverse_ppar_typechecked' =
  fmap check_type_get_error tuple_reverse_ppar
tuple_reverse_inputs :: [[Integer]] = [[1,2,3,4], [5,6,7,8]]
tuple_reverse_output :: [Integer] = [1,2,3,4]
tuple_reverse_results = sequence $
  fmap (\s -> test_with_backend
              tuple_reverse (wrap_single_s s)
              Magma No_Verilog
              tuple_reverse_inputs tuple_reverse_output) [1,2,4]
tuple_reverse_results_chisel = sequence $
  fmap (\s -> test_with_backend
              tuple_reverse (wrap_single_s s)
              Chisel No_Verilog
              tuple_reverse_inputs tuple_reverse_output) [1,2,4]
                    
tuple_sum_shallow_no_input in_seq = do
  let kernel_list = fmap Atom_Int [1,2,3,4]
  let kernel = const_genC (Seq $ listToVector (Proxy @4) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  mapC addC kernel_and_values
tuple_sum = tuple_sum_shallow_no_input $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 4 Atom_Int))
tuple_sum_seq_idx = add_indexes $ seq_shallow_to_deep tuple_sum
tuple_sum_ppar =
  fmap (\s -> compile_with_slowdown_to_expr tuple_sum s) [1,2,4]
tuple_sum_ppar_typechecked =
  fmap check_type tuple_sum_ppar
tuple_sum_ppar_typechecked' =
  fmap check_type_get_error tuple_sum_ppar
tuple_sum_inputs :: [[Integer]] = [[4,2,8,10]]
tuple_sum_output :: [Integer] = [5,4,11,14]
tuple_sum_results = sequence $
  fmap (\s -> test_with_backend
              tuple_sum (wrap_single_s s)
              Magma No_Verilog
              tuple_sum_inputs tuple_sum_output) [1,2,4]
tuple_sum_results_chisel = sequence $
  fmap (\s -> test_with_backend
              tuple_sum (wrap_single_s s)
              Chisel No_Verilog
              tuple_sum_inputs tuple_sum_output) [1,2,4]

tuple_reduce_no_input in_seq = do
  let kernel_list = fmap Atom_Int [1,2,3,4,2,1,2,3]
  let kernel = const_genC (Seq $ listToVector (Proxy @8) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  let muled_pairs = mapC mulC kernel_and_values
  reduceC addC muled_pairs
tuple_reduce = tuple_reduce_no_input $
  com_input_seq "I" (Proxy :: Proxy (Seq 8 Atom_Int))
tuple_reduce_seq_idx = add_indexes $ seq_shallow_to_deep tuple_reduce
tuple_reduce_ppar =
  fmap (\s -> compile_with_slowdown_to_expr tuple_reduce s) [1,2,4,8]
tuple_reduce_ppar_typechecked =
  fmap check_type tuple_reduce_ppar
tuple_reduce_ppar_typechecked' =
  fmap check_type_get_error tuple_reduce_ppar
tuple_reduce_inputs :: [[Integer]] = [[10,8,9,3,4,2,2,2]]
tuple_reduce_output :: [Integer] = [85]
-- need to come back and check why slowest version uses a reduce_s
tuple_reduce_results = sequence $
  fmap (\s -> test_with_backend
              tuple_reduce (wrap_single_s s)
              Magma No_Verilog
              tuple_reduce_inputs tuple_reduce_output) [1,2,4,8]
tuple_reduce_results_chisel = sequence $
  fmap (\s -> test_with_backend
              tuple_reduce (wrap_single_s s)
              Chisel No_Verilog
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
  com_input_seq "I" (Proxy :: Proxy (Seq 8 Atom_Int))
fst_snd_sum_seq_idx = add_indexes $ seq_shallow_to_deep fst_snd_sum
fst_snd_sum_ppar =
  fmap (\s -> compile_with_slowdown_to_expr fst_snd_sum s) [1,2,4,8]
fst_snd_sum_ppar_typechecked =
  fmap check_type fst_snd_sum_ppar
fst_snd_sum_ppar_typechecked' =
  fmap check_type_get_error fst_snd_sum_ppar
fst_snd_sum_inputs :: [[Integer]] = [[6,7,8,9,10,11,12,13]]
fst_snd_sum_output :: [Integer] = [7,9,11,13,15,17,19,21]
-- need to come back and check why slowest version uses a reduce_s
fst_snd_sum_results = sequence $
  fmap (\s -> test_with_backend
              fst_snd_sum (wrap_single_s s)
              Magma No_Verilog
              fst_snd_sum_inputs fst_snd_sum_output) [1,2,4,8]
fst_snd_sum_results_chisel = sequence $
  fmap (\s -> test_with_backend
              fst_snd_sum (wrap_single_s s)
              Chisel No_Verilog
              fst_snd_sum_inputs fst_snd_sum_output) [1,2,4,8]

seq_to_stuple = 
  mapC seq_to_seq_tupleC $
  com_input_seq "I" (Proxy :: Proxy (Seq 4 (Seq 4 Atom_Int)))
seq_to_stuple_seq_idx = add_indexes $ seq_shallow_to_deep seq_to_stuple
seq_to_stuple_ppar = 
  fmap (\s -> compile_with_slowdown_to_expr seq_to_stuple s) [1,2,4,8,16]
seq_to_stuple_ppar_typechecked =
  fmap check_type seq_to_stuple_ppar
seq_to_stuple_inputs :: [[Integer]] = [[1..16]]
--seq_to_stuple_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
seq_to_stuple_output :: [Integer] = [1..16]
-- need to come back and check why slowest version uses a reduce_s
seq_to_stuple_results = sequence $
  fmap (\s -> test_with_backend
              seq_to_stuple (wrap_single_s s)
              Magma No_Verilog
              seq_to_stuple_inputs seq_to_stuple_output) [1,2,4,8,16]
seq_to_stuple_results_chisel = sequence $
  fmap (\s -> test_with_backend
              seq_to_stuple (wrap_single_s s)
              Chisel No_Verilog
              seq_to_stuple_inputs seq_to_stuple_output) [1,2,4,8,16]

stuple_to_seq = 
  mapC seq_tuple_to_seqC $
  com_input_seq "I" (Proxy :: Proxy (Seq 4 (Seq 1 (Seq_Tuple 4 Atom_Int))))
stuple_to_seq_seq_idx = add_indexes $ seq_shallow_to_deep stuple_to_seq
stuple_to_seq_ppar = 
  fmap (\s -> compile_with_slowdown_to_expr stuple_to_seq s) [1,2,4,8,16]
stuple_to_seq_ppar_typechecked =
  fmap check_type stuple_to_seq_ppar
stuple_to_seq_ppar_typechecked' =
  fmap check_type_get_error stuple_to_seq_ppar
stuple_to_seq_inputs :: [[Integer]] = [[1..16]]
--stuple_to_seq_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
stuple_to_seq_output :: [Integer] = [1..16]
-- need to come back and check why slowest version uses a reduce_s
stuple_to_seq_results = sequence $
  fmap (\s -> test_with_backend
              stuple_to_seq (wrap_single_s s)
              Magma No_Verilog
              stuple_to_seq_inputs stuple_to_seq_output) [1,2,4,8,16]
stuple_to_seq_results_chisel = sequence $
  fmap (\s -> test_with_backend
              stuple_to_seq (wrap_single_s s)
              Chisel No_Verilog
              stuple_to_seq_inputs stuple_to_seq_output) [1,2,4,8,16]
stuple_to_seq_results' = sequence $
  fmap (\s -> test_with_backend
              stuple_to_seq (wrap_single_s s)
              Magma No_Verilog
              stuple_to_seq_inputs stuple_to_seq_output) [16]
                        
seq_and_stuple_no_input = 
  mapC (seq_to_seq_tupleC >>> seq_tuple_to_seqC)
seq_and_stuple = seq_and_stuple_no_input $
  com_input_seq "I" (Proxy :: Proxy (Seq 4 (Seq 4 Atom_Int)))
seq_and_stuple_seq_idx = add_indexes $ seq_shallow_to_deep $ seq_and_stuple
seq_and_stuple_ppar = 
  fmap (\s -> compile_with_slowdown_to_expr seq_and_stuple s) [1,2,4,8,16]
seq_and_stuple_ppar_typechecked =
  fmap check_type seq_and_stuple_ppar
seq_and_stuple_ppar_typechecked' =
  fmap check_type_get_error seq_and_stuple_ppar
seq_and_stuple_inputs :: [[Integer]] = [[1..16]]
--seq_and_stuple_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
seq_and_stuple_output :: [Integer] = [1..16]
-- need to come back and check why slowest version uses a reduce_s
seq_and_stuple_results = sequence $
  fmap (\s -> test_with_backend
              seq_and_stuple (wrap_single_s s)
              Magma No_Verilog
              seq_and_stuple_inputs seq_and_stuple_output) [1,2,4,8,16]
seq_and_stuple_results_chisel = sequence $
  fmap (\s -> test_with_backend
              seq_and_stuple (wrap_single_s s)
              Chisel No_Verilog
              seq_and_stuple_inputs seq_and_stuple_output) [1,2,4,8,16]

striple_to_seq_shallow in_seq = do
  let pair = map2C (map2C seq_tupleC) in_seq in_seq
  let triple = map2C (map2C seq_tuple_appendC) pair in_seq
  mapC seq_tuple_to_seqC triple
striple_to_seq = striple_to_seq_shallow $
  com_input_seq "I" (Proxy :: Proxy (Seq 8 (Seq 1 Atom_Int)))
striple_to_seq_seq_idx = add_indexes $ seq_shallow_to_deep striple_to_seq
striple_to_seq_ppar =
  fmap (\s -> compile_with_slowdown_to_expr striple_to_seq s) [1,2,4,8,24]
striple_to_seq_ppar_typechecked =
  fmap check_type striple_to_seq_ppar
striple_to_seq_ppar_typechecked' =
  fmap check_type_get_error striple_to_seq_ppar
striple_to_seq_inputs :: [[Integer]] = [[1..8]]
--striple_to_seq_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
striple_to_seq_output :: [[Integer]] = [[i, i, i] | i <- [1 .. 8]]
-- need to come back and check why slowest version uses a reduce_s
striple_to_seq_results = sequence $
  fmap (\s -> test_with_backend
              striple_to_seq (wrap_single_s s)
              Magma No_Verilog
              striple_to_seq_inputs striple_to_seq_output) [1,2,4,8,24]
striple_to_seq_results_chisel = sequence $
  fmap (\s -> test_with_backend
              striple_to_seq (wrap_single_s s)
              Chisel No_Verilog
              striple_to_seq_inputs striple_to_seq_output) [1,2,4,8,24]

shift_length = 4096
shift_one_shallow in_seq = do
  let y = shiftC (Proxy @4) in_seq
  let x = shiftC (Proxy @1) y
  shiftC (Proxy @1) x
shift_one = shift_one_shallow $
  com_input_seq "I" (Proxy :: Proxy (Seq 4096 Atom_Int))
shift_one_seq_idx = add_indexes $ seq_shallow_to_deep shift_one
shift_slowdowns = speed_to_slow [16, 8, 4, 2, 1] shift_length
shift_one_ppar =
  fmap (\s -> compile_with_slowdown_to_expr shift_one s) shift_slowdowns
shift_one_ppar_typechecked =
  fmap check_type shift_one_ppar
shift_one_ppar_typechecked' =
  fmap check_type_get_error shift_one_ppar
shift_one_inputs :: [[Integer]] = [[1..shift_length]]
--shift_one_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
shift_one_output :: [[Integer]] = [replicate 6 int_to_ignore ++ [1..shift_length-6]]--[[int_to_ignore, int_to_ignore, int_to_ignore, int_to_ignore] ++ [1..4]]
-- need to come back and check why slowest version uses a reduce_s
shift_one_results = sequence $
  fmap (\s -> test_with_backend
              shift_one (wrap_single_s s)
              Magma No_Verilog
              shift_one_inputs shift_one_output) shift_slowdowns
-- NOTE: NEED TO FAKE COST OF SHIFT_S IN ORDER FOR THIS TEST TO
-- USE ANY OTHER SHIFT AS OTHERWISE COST MODEL WILL JUST ADD MORE
-- DELAYS TO INNER SEQ RATHER THAN CHANGING SHIFT
shift_one_results_chisel = sequence $
  fmap (\s -> test_with_backend
              shift_one (wrap_single_s s)
              Chisel No_Verilog
              shift_one_inputs shift_one_output) shift_slowdowns

stencil_1dC_internal_test in_seq = do
  let shifted_once = shiftC (Proxy @1) in_seq
  let shifted_twice = shiftC (Proxy @1) shifted_once
  let window_tuple = map2C seq_tuple_appendC
                     (map2C seq_tupleC in_seq shifted_once)
                     shifted_twice
  let partitioned_tuple = partitionC Proxy (Proxy :: Proxy 1) window_tuple
  mapC seq_tuple_to_seqC partitioned_tuple
stencil_1d_internal_test = stencil_1dC_internal_test $
  com_input_seq "I" (Proxy :: Proxy (Seq 100 Atom_Int))
stencil_1d_internal_seq_idx = add_indexes $ seq_shallow_to_deep stencil_1d_internal_test
stencil_1d_internal_ppar =
  fmap (\s -> compile_with_slowdown_to_expr stencil_1d_internal_test s)
  [1,2,5,10,30,100,300]
stencil_1d_internal_ppar_typechecked =
  fmap check_type stencil_1d_internal_ppar
stencil_1d_internal_ppar_typechecked' =
  fmap check_type_get_error stencil_1d_internal_ppar
tuple_mul_internal_shallow_no_input in_seq = do
  let kernel_list = fmap Atom_Int [1,1,1]
  let kernel = const_genC (Seq $ listToVector (Proxy @3) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  let mul_result = mapC mulC kernel_and_values
  let sum = reduceC addC mul_result
  let norm_list = fmap Atom_Int [3]
  let norm = const_genC (Seq $ listToVector (Proxy @1) norm_list) in_seq
  let sum_and_norm = map2C atom_tupleC sum norm
  mapC divC sum_and_norm
conv_1d_internal_shallow_no_input in_seq = do
  let stencil = stencil_1dC_internal_test in_seq
  let conv_result = mapC tuple_mul_internal_shallow_no_input stencil
  unpartitionC conv_result
conv_1d_internal = conv_1d_internal_shallow_no_input $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 10 Atom_Int))
conv_1d_internal_seq_idx = add_indexes $ seq_shallow_to_deep conv_1d_internal
conv_1d_internal_ppar =
  fmap (\s -> compile_with_slowdown_to_expr conv_1d_internal s) [1,3,5,6,10,30]
  
stencil_1dC_test window_size in_seq | (natVal window_size) >= 2 = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC (Proxy @1) last_shifted_seq) : l)
                     [in_seq] [0 .. natVal window_size - 2]
  let tuple = zipC window_size shifted_seqs
  mapC seq_tuple_to_seqC tuple
stencil_1dC_test _ _ = undefined
stencil_1d_test = stencil_1dC_test (Proxy @3) $
  com_input_seq "I" (Proxy :: Proxy (Seq 100 (Seq 1 Atom_Int)))
stencil_1d_test_seq_idx = add_indexes $ seq_shallow_to_deep stencil_1d_test
stencil_1d_test_ppar = 
  fmap (\s -> compile_with_slowdown_to_expr stencil_1d_test s) [1,2,5,10,30,100,300]
stencil_1d_test_ppar_typechecked =
  fmap check_type stencil_1d_test_ppar
stencil_1d_test_ppar_typechecked' =
  fmap check_type_get_error stencil_1d_test_ppar
stencil_1d_inputs :: [[Integer]] = [[1..100]]
--stencil_1d_output :: [((Integer, Integer), Integer)] = [((i, i), i) | i <- [1 .. 8]]
stencil_1d_output :: [[Integer]] = [
  [
    if i > 2 then i-2 else int_to_ignore,
    if i > 1 then i-1 else int_to_ignore,
    i
  ] | i <- [1 .. 100]]
-- need to come back and check why slowest version uses a reduce_s
stencil_1d_results = sequence $
  fmap (\s -> test_with_backend
              stencil_1d_test (wrap_single_s s)
              Magma No_Verilog
              stencil_1d_inputs stencil_1d_output) [1,2,5,10,30,100,300]

-- 30 really bad case
stencil_1d_results' = sequence $
  fmap (\s -> test_with_backend
              stencil_1d_test (wrap_single_s s)
              Magma No_Verilog
              stencil_1d_inputs stencil_1d_output) [1]
 
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
  mapC tuple_mul_shallow_no_input stencil
conv_1d = conv_1d_shallow_no_input $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 5 (Seq 1 Atom_Int)))
conv_1d_seq_idx = add_indexes $ seq_shallow_to_deep conv_1d
conv_1d_ppar =
  fmap (\s -> compile_with_slowdown_to_expr conv_1d s) [1,3,5,15]
conv_1d_ppar_typechecked =
  fmap check_type conv_1d_ppar
conv_1d_ppar_typechecked' =
  fmap check_type_get_error conv_1d_ppar
conv_1d_inputs :: [[Integer]] = [[1,2,3,4,5]]
conv_1d_output :: [Integer] = [int_to_ignore,int_to_ignore,2,3,4]
conv_1d_results = sequence $
  fmap (\s -> test_with_backend
              conv_1d (wrap_single_s s)
              Magma No_Verilog
              conv_1d_inputs conv_1d_output) [1,3,5,15]
conv_1d_results' = sequence $
  fmap (\s -> test_with_backend
              conv_1d (wrap_single_s s)
              Magma No_Verilog
              conv_1d_inputs conv_1d_output) [3]

tuple_mul_shallow_no_input_for_pyr in_seq = do
  let kernel_list = fmap Atom_Int [0,1,0]
  let kernel = const_genC (Seq $ listToVector (Proxy @3) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC in_seq kernel
  let mul_result = mapC lslC kernel_and_values
  let sum = reduceC addC mul_result
  let norm_list = fmap Atom_Int [2]
  let norm = const_genC (Seq $ listToVector (Proxy @1) norm_list) in_seq
  let sum_and_norm = map2C atom_tupleC sum norm
  mapC lsrC sum_and_norm
conv_1d_shallow_no_input_for_pyr in_seq = do
  let stencil = stencil_1dC_test (Proxy @3) in_seq
  mapC tuple_mul_shallow_no_input_for_pyr stencil
pyramid_1d_shallow_no_input in_seq = do
  let layer1_blurred = conv_1d_shallow_no_input_for_pyr in_seq
  let layer2_input = unpartitionC $ mapC (down_1dC 2) $
        partitionC (Proxy @9) (Proxy @3) layer1_blurred
  let layer2_blurred = conv_1d_shallow_no_input_for_pyr layer2_input
  unpartitionC $ mapC (down_1dC 2) $ partitionC (Proxy @3) (Proxy @3) layer2_blurred
pyramid_1d = pyramid_1d_shallow_no_input $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 27 (Seq 1 Atom_Int)))
pyramid_1d_seq_idx = add_indexes $ seq_shallow_to_deep pyramid_1d
pyramid_1d_ppar =
  fmap (\s -> compile_with_slowdown_to_expr pyramid_1d s) [1,3,9,27,81]
pyramid_1d_ppar_type =
  fmap (\tr -> compile_with_type_rewrite_to_expr pyramid_1d tr)
  [[SpaceR 1, SpaceR 1, NonSeqR],
   [SplitR 1 2 1, SpaceR 1, NonSeqR],
   [SplitNestedR (TimeR 1 2) (SplitNestedR (TimeR 1 2) NonSeqR), SpaceR 1, NonSeqR],
   [SplitNestedR (TimeR 1 2) (SplitNestedR (TimeR 1 2) NonSeqR), TimeR 1 2, NonSeqR]]
pyramid_1d_ppar_typechecked =
  fmap check_type pyramid_1d_ppar
pyramid_1d_ppar_typechecked' =
  fmap check_type_get_error pyramid_1d_ppar
pyramid_1d_ppar_type_typechecked =
  fmap check_type pyramid_1d_ppar_type
pyramid_1d_ppar_type_typechecked' =
  fmap check_type_get_error pyramid_1d_ppar_type
pyramid_1d_inputs :: [[Integer]] = [[1..27]]
pyramid_1d_output :: [Integer] = [5,14,23]
pyramid_1d_results = sequence $
  fmap (\s -> test_with_backend 
              pyramid_1d (wrap_single_s s)
              Magma (Save_Gen_Verilog "pyramid")
              pyramid_1d_inputs pyramid_1d_output) [1,3,9,27,81]
pyramid_1d_results_all_types = sequence $
  fmap (\s -> test_with_backend
              pyramid_1d (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "pyramid")
              pyramid_1d_inputs pyramid_1d_output) [1,3,9,27]
pyramid_1d_results_types = sequence $
  fmap (\trs -> test_with_backend
              pyramid_1d (Type_Rewrites trs)
              Magma No_Verilog
              pyramid_1d_inputs pyramid_1d_output)
  [[SpaceR 1, SpaceR 1, NonSeqR],
    [SplitR 1 2 1, SpaceR 1, NonSeqR],
    [SplitNestedR (TimeR 1 2) (SplitNestedR (TimeR 1 2) NonSeqR), SpaceR 1, NonSeqR],
    [SplitNestedR (TimeR 1 2) (SplitNestedR (TimeR 1 2) NonSeqR), TimeR 1 2, NonSeqR]]
pyramid_1d_prints = sequence $
  fmap (\s -> compile_to_file
              pyramid_1d (wrap_single_s s)
              text_backend "pyramid1d")
  [1,3,9,27]

{-
  let tuple = zipC window_size shifted_seqs
  mapC seq_tuple_to_seqC tuple
map_reduce_nested = seq_shallow_to_deep $
  mapC (mapC absC) >>>
  mapC (reduceC addC) $
  com_input_seq "I" (Proxy :: Proxy (Seq 9 0 (Seq 9 0 Atom_Int)))
map_reduce_seq_idx = add_indexes map_reduce_nested
map_reduce_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s map_reduce_seq_idx) [1,3,9]
map_reduce_ppar_typechecked =
  fmap check_type map_reduce_ppar
-}

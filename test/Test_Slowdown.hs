module Test_Slowdown where
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
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import Data.Proxy
import Data.SBV
import Control.Monad.State

-- input to scheduling algorithm: expr tree
-- output to scheduling algorithm: amount to slow down each node
-- must slow down by same amount, potentially to different layers depending on partition/unpartition


-- comments are max slow down while not underutil for each layer
-- (layer is in ops, not seqs)

-- two most basic examples
single_map = compile $
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 Atom_Int))
single_map_ppar = fmap (\s -> rewrite_to_partially_parallel s single_map) [1,2,4]
single_map_ppar_results = fmap check_type single_map_ppar
input_rewrite = rewrite_to_partially_parallel 2 (InputN (SeqT 4 0 IntT) "hi")
input_rewrite' :: Partially_Parallel_StateM STE.Expr
input_rewrite' = do
  tr <- lift $ rewrite_AST_type 2 (SeqT 4 0 IntT)
  sequence_to_partially_parallel tr (InputN (SeqT 4 0 IntT) "hi")
seq_rewrite' :: Partially_Parallel_StateM STT.AST_Type
seq_rewrite' = do
  tr <- lift $ rewrite_AST_type 2 (SeqT 4 0 IntT)
  part_par_AST_type tr (SeqT 4 0 IntT)
  
single_map_underutil = compile $
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 4 Atom_Int))
single_map_underutil_ppar = fmap
  (\s -> rewrite_to_partially_parallel s single_map_underutil) [1,2,4,8]
single_map_underutil_ppar_results = fmap check_type single_map_underutil_ppar

-- tests basic multi-rate
map_to_up = compile $
  mapC' (Proxy @1) absC >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 3 Atom_Int))
map_to_up_ppar = fmap (\s -> rewrite_to_partially_parallel s map_to_up) [1,2,4]
map_to_up_ppar_result = fmap check_type map_to_up_ppar

-- test two multi-rates of different rates
up_to_down = compile $
  down_1dC' (Proxy @5) 0 >>>
  up_1dC (Proxy @4) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 5 0 Atom_Int))
up_to_down_ppar = fmap (\s -> rewrite_to_partially_parallel s up_to_down) [1,5]
up_to_down_ppar_result = fmap check_type up_to_down_ppar

-- next two test how to distribute slowdown correctly when multi-rate is nested
nested_map_to_top_level_up = compile $
  mapC' (Proxy @1) (mapC' (Proxy @4) absC) >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 5 (Seq 4 0 Atom_Int)))
-- note: the reason the output is a seminly unecessary split on the outer seq
-- for the slowest schedule is that there are still 2 invalid clocks not used
-- and I say partially parallel for those, becuase not fully slowed down
nested_map_to_top_level_up_ppar = fmap (\s -> rewrite_to_partially_parallel s nested_map_to_top_level_up) [1,2,4,8,16]
nested_map_to_top_level_up_ppar_result = fmap check_type nested_map_to_top_level_up_ppar

nested_map_to_nested_up = compile $
  --mapC' (Proxy @4) (mapC' (Proxy @1) absC) >>> -- [1]
  mapC' (Proxy @4) (up_1dC (Proxy @4)) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 1 5 Atom_Int)))
nested_map_to_nested_up_ppar = fmap (\s -> rewrite_to_partially_parallel s nested_map_to_nested_up) [1,2,3,4,8,16]
nested_map_to_nested_up_ppar_result = fmap check_type nested_map_to_nested_up_ppar

-- testing basic partitioning
partition_to_flat_map = compile $
  partitionC (Proxy @2) (Proxy @2) (Proxy @2) (Proxy @2) >>>
  mapC (mapC absC) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 12 Atom_Int))
partition_to_flat_map_ppar = fmap (\s -> rewrite_to_partially_parallel s partition_to_flat_map) [1,2,4,8,16]
partition_to_flat_map_ppar_result = fmap check_type partition_to_flat_map_ppar

map_to_unpartition = compile $
  mapC (mapC absC) >>>
  unpartitionC' (Proxy @2) (Proxy @2) >>>
  mapC absC $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 6 (Seq 2 0 Atom_Int)))
map_to_unpartition_ppar = fmap (\s -> rewrite_to_partially_parallel s map_to_unpartition) [1,2,4,8,16]
map_to_unpartition_ppar_result = fmap check_type map_to_unpartition_ppar

-- combining multi-rate with partitioning
double_up = compile $
  (mapC' (Proxy @2) (up_1dC (Proxy @3)) >>> -- [2, 3]
   unpartitionC >>> -- in : [2, 3], out : [6] (or [[2, 3]] if not splitting here)
   partitionC (Proxy @1) (Proxy @6) Proxy (Proxy @0) >>> -- in : [6], out : [1, 6] or in : [[2, 3]] out : [1, [2, 3]] (this doesn't work as can't slow input down by 5, so must not be able to slow output down by 5) or in : [[2, 3]] out : []
   up_1dC (Proxy @5)) $ -- [5, [2, 3]]
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 1 14 Atom_Int)) )
double_up_ppar = fmap (\s -> rewrite_to_partially_parallel s double_up) [1,2,3,5,6,10,15,30]
double_up_ppar_no_errors = filter (not . STE.is_error_node) double_up_ppar
double_up_ppar_result = fmap check_type double_up_ppar
double_up_ppar_result' = fmap check_type' double_up_ppar
double_up_slow_6 = rewrite_to_partially_parallel 6 double_up
-- the problem with this case is that, for the output Seq 5 (Seq 6 Int)
-- with s = 6, the 5 is fully utilized and the 6 is fully underutilized.
-- so the up and add don't put an extra sseq below the TSeq 6 0 Int.
-- The add is the only thing necessary for the partition to work
-- However, when unpartitioning, the unpartition 2 3 have lots of
-- potentially empty clocks from all of 5 that got rolled into them.
-- So unpartition creates an extra 1.
double_up_slow_6_result = check_type double_up_slow_6
double_up_slow_6_result' = check_type' double_up_slow_6

down_over_nested_to_down_over_flattened = compile $
  (down_1dC' (Proxy @4) 0 >>>
   unpartitionC' (Proxy @1) (Proxy @4) >>>
   down_1dC' (Proxy @4) 0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 4 0 Atom_Int)))
down_over_nested_to_down_over_flattened_ppar =
  fmap (\s -> rewrite_to_partially_parallel s down_over_nested_to_down_over_flattened)
  [1,2,4,8,16]
down_over_nested_to_down_over_flattened_ppar_result =
  fmap check_type down_over_nested_to_down_over_flattened_ppar
down_over_nested_to_down_over_flattened_ppar_result' =
  fmap check_type' down_over_nested_to_down_over_flattened_ppar

tuple_sum_shallow in_seq = do
  let kernel_list = fmap Atom_Int [1,2,3,4]
  let kernel = const_genC (Seq $ listToVector (Proxy @4) kernel_list) in_seq
  let kernel_and_values = map2C atom_tupleC kernel in_seq
  mapC addC kernel_and_values
tuple_sum = compile $
  tuple_sum_shallow $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 Atom_Int))
tuple_sum_ppar =
  fmap (\s -> rewrite_to_partially_parallel s tuple_sum) [1,2,4]
tuple_sum_ppar_result =
  fmap check_type tuple_sum_ppar
tuple_sum_ppar_result' =
  fmap check_type' tuple_sum_ppar
tuple_sum_ppar_result_s_2 = check_type' $ rewrite_to_partially_parallel 2 tuple_sum

-- END OF ACTUALLY TESTED THINGS
-- multiple unpartitions into a multi-rate
multi_unpartition_with_multi_rate = compile $
  (mapC' (Proxy @3) (unpartitionC' (Proxy @2) (Proxy @5)) >>>
   unpartitionC' (Proxy @3) (Proxy @10) >>>
   down_1dC' (Proxy @30) 0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 3 0 (Seq 2 0 (Seq 5 0 Atom_Int))))

multi_partition_with_multi_rate = compile $
  (up_1dC (Proxy @30) >>>
   partitionC (Proxy @3) (Proxy @10) (Proxy @0) (Proxy @0)  >>>
   mapC' (Proxy @3) (partitionC (Proxy @2) (Proxy @5) (Proxy @0) (Proxy @0) )) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 29 Atom_Int))
  
-- multiple unpartitions into a multi-rate, using fewer factors to show
-- can't split map between fully sequential 0 invalid clocks and
-- fully sequential with all invalid clocks
multi_unpartition_with_multi_rate_cant_split = compile $
  (mapC' (Proxy @2) (mapC' (Proxy @2) absC) >>>
   unpartitionC' (Proxy @2) (Proxy @2) >>>
   partitionC (Proxy @1) (Proxy @4) Proxy (Proxy @0) >>>
   up_1dC (Proxy @4)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 2 6 Atom_Int)))

  -- down 6 >>> up 6
matching_down_up = compile $
  (down_1dC' (Proxy @6) 0 >>>
   up_1dC (Proxy @6)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 6 0 Atom_Int))
  
  -- down 7 >>> up 5
mismatched_down_up = compile $
  (down_1dC' (Proxy @7) 0 >>>
   up_1dC (Proxy @5)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 7 0 Atom_Int))


  -- map 4 of map 6 abs into map 4 of down_1d 6 - test which policy to use when downsample by 6 and 8
matched_nested_abs_down = compile $
  (mapC' (Proxy @4) (mapC' (Proxy @6) absC) >>>
   mapC' (Proxy @4) (down_1dC' (Proxy @6) 0)) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 6 0 Atom_Int)))

  -- multi-rate to map
  -- why won't the max approach without global solving for i work here?
  -- slow down by 8. Max n is 8, so think I can slow outer down by 8.
  -- this fails for slwoding down down 2 as end up partially parallelizing it
  -- I end up slowing down the down by 2 and then splitting the seq 8 that I'm downsampling
  -- into a tseq 4 and sseq 2.  This doesn't match how the map 8 abs is serialized without splitting
multi_rate_to_map = compile $
  (down_1dC' (Proxy @2) 0 >>>
   unpartitionC' (Proxy @1) (Proxy @8) >>>
   mapC' (Proxy @8) absC) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 8 0 Atom_Int)))

nested_down_to_down = compile $
  (mapC' (Proxy @2) (down_1dC' (Proxy @3) 0) >>>
   unpartitionC' (Proxy @2) (Proxy @1) >>>
   down_1dC' (Proxy @2) 0) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 3 0 Atom_Int)))

down_unpartition_down = compile $
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

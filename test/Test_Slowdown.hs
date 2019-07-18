module Test_Slowdown where
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Rewrites.Sequence_Shallow_To_Deep
import Data.Proxy
import Data.SBV

-- input to scheduling algorithm: expr tree
-- output to scheduling algorithm: amount to slow down each node
-- must slow down by same amount, potentially to different layers depending on partition/unpartition


-- comments are max slow down while not underutil for each layer
-- (layer is in ops, not seqs)

-- two most basic examples
single_map = compile $
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 Atom_Int))
  
single_map_underutil = compile $
  mapC' (Proxy @4) absC $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 4 Atom_Int))

-- tests basic multi-rate
map_to_up = compile $
  mapC' (Proxy @1) absC >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 3 Atom_Int))
  
-- next two test how to distribute slowdown correctly when multi-rate is nested
nested_map_to_top_level_up = compile $
  mapC' (Proxy @1) (mapC' (Proxy @4) absC) >>> -- [1]
  up_1dC (Proxy @4) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 1 5 (Seq 4 0 Atom_Int)))

nested_map_to_nested_up = compile $
  mapC' (Proxy @4) (mapC' (Proxy @1) absC) >>> -- [1]
  mapC' (Proxy @4) (up_1dC (Proxy @4)) $ -- [4]
  com_input_seq "hi" (Proxy :: Proxy (Seq 4 0 (Seq 1 5 Atom_Int)))
  
-- combining multi-rate with partitioning
double_up = compile $
  (mapC' (Proxy @2) (up_1dC (Proxy @3)) >>> -- [2, 3]
   unpartitionC >>> -- in : [2, 3], out : [6] (or [[2, 3]] if not splitting here)
   partitionC (Proxy @1) (Proxy @6) Proxy (Proxy @0) >>> -- in : [6], out : [1, 6] or in : [[2, 3]] out : [1, [2, 3]] (this doesn't work as can't slow input down by 5, so must not be able to slow output down by 5) or in : [[2, 3]] out : []
   up_1dC (Proxy @5)) $ -- [5, [2, 3]]
  com_input_seq "hi" (Proxy :: Proxy (Seq 2 0 (Seq 1 14 Atom_Int)) )

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
 {- 
script :: Z3 (Result, Maybe [Integer])
script = do
  in_no <- mkFreshIntVar "in_no"
  in_ni <- mkFreshIntVar "in_ni"
  in_io <- mkFreshIntVar "in_io"
  in_ii <- mkFreshIntVar "in_ii"
  no <- mkInteger 1
  ni <- mkInteger 3
  tr_no <- mkInteger 3
  tr_io <- mkInteger 3
  ni_add_ii <- mkAdd [in_ni,in_ii]
  io_mul_ni_add_ii <- mkMul [in_io, ni_add_ii]
  no_mul_ii <- mkMul [in_no, in_ii]
  flattened_invalids <- mkAdd [no_mul_ii, io_mul_ni_add_ii]
  assert =<< mkAnd =<< T.sequence
    [
      in_no `mkEq` no,
      in_ni `mkEq` ni,
      tr_io `mkEq` flattened_invalids
    ]
  withModel $ \m ->
    catMaybes <$> mapM (evalInt m) [in_no, in_ni, in_io, in_ii]
 
script2 :: Z3 (Result, Maybe Model)
script2 = do
  in_no <- mkFreshIntVar "in_no"
  no <- mkInteger 1
  assert =<< mkAnd =<< T.sequence
    [
      in_no `mkEq` no
    ]
  getModel

script3 :: Z3 (Maybe [Integer])
script3 = do
  q1 <- mkFreshIntVar "q1"
  q2 <- mkFreshIntVar "q2"
  q3 <- mkFreshIntVar "q3"
  q4 <- mkFreshIntVar "q4"
  _1 <- mkInteger 1
  _4 <- mkInteger 4
  -- the ith-queen is in the ith-row.
  -- qi is the column of the ith-queen
  assert =<< mkAnd =<< T.sequence
    [ mkLe _1 q1, mkLe q1 _4  -- 1 <= q1 <= 4
    , mkLe _1 q2, mkLe q2 _4
    , mkLe _1 q3, mkLe q3 _4
    , mkLe _1 q4, mkLe q4 _4
    ]
  -- different columns
  assert =<< mkDistinct [q1,q2,q3,q4]
  -- avoid diagonal attacks
  assert =<< mkNot =<< mkOr =<< T.sequence
    [ diagonal 1 q1 q2  -- diagonal line of attack between q1 and q2
    , diagonal 2 q1 q3
    , diagonal 3 q1 q4
    , diagonal 1 q2 q3
    , diagonal 2 q2 q4
    , diagonal 1 q3 q4
    ]
  -- check and get solution
  fmap snd $ withModel $ \m ->
    catMaybes <$> mapM (evalInt m) [q1,q2,q3,q4]
  where mkAbs x = do
          _0 <- mkInteger 0
          join $ mkIte <$> mkLe _0 x <*> pure x <*> mkUnaryMinus x
        diagonal d c c' =
          join $ mkEq <$> (mkAbs =<< mkSub [c',c]) <*> (mkInteger d)
-}
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

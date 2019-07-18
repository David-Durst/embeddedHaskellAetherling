module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr where
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import qualified Aetherling.Languages.Space_Time.Deep.Expr_Builders as STB
import Aetherling.Languages.Sequence.Shallow.Expr_Type_Conversions
import Control.Monad.Except
import Control.Monad.Identity
import Data.Maybe
import Data.Either
import Data.List.Split (chunksOf)

rewrite_to_partially_parallel :: Int -> SeqE.Expr -> IO STE.Expr
rewrite_to_partially_parallel s seq_expr = do
  expr_par <- runExceptT $ rewrite_to_partially_parallel' s seq_expr
  if isLeft expr_par
    then return $ STE.ErrorN (rw_msg $ fromLeft undefined expr_par)
    else return $ fromRight undefined expr_par

rewrite_to_partially_parallel' :: Int -> SeqE.Expr -> Rewrite_IO_StateM STE.Expr
rewrite_to_partially_parallel' s seq_expr = do
  let seq_expr_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types seq_expr
  output_type_slowdowns <- rewrite_AST_type s seq_expr_out_type
  sequence_to_partially_parallel output_type_slowdowns seq_expr
  

sequence_to_partially_parallel :: [Type_Rewrite] -> SeqE.Expr -> Rewrite_IO_StateM STE.Expr
sequence_to_partially_parallel type_rewrites (SeqE.IdN producer) =
  part_par_atom_operator type_rewrites STE.IdN producer
sequence_to_partially_parallel type_rewrites (SeqE.AbsN producer) =
  part_par_atom_operator type_rewrites STE.AbsN producer
sequence_to_partially_parallel type_rewrites (SeqE.NotN producer) =
  part_par_atom_operator type_rewrites STE.NotN producer
sequence_to_partially_parallel type_rewrites (SeqE.AddN producer) =
  part_par_atom_operator type_rewrites STE.AddN producer
sequence_to_partially_parallel type_rewrites (SeqE.SubN producer) =
  part_par_atom_operator type_rewrites STE.SubN producer
sequence_to_partially_parallel type_rewrites (SeqE.MulN producer) =
  part_par_atom_operator type_rewrites STE.MulN producer
sequence_to_partially_parallel type_rewrites (SeqE.DivN producer) =
  part_par_atom_operator type_rewrites STE.DivN producer
sequence_to_partially_parallel type_rewrites (SeqE.EqN t producer) = do
  -- can reuse all of type_rewrites in these calls as atom tuples
  -- and other atoms all have same Type_Rewrite object - NonSeqR
  producer_par <- sequence_to_partially_parallel type_rewrites producer
  t_par <- part_par_AST_type type_rewrites t
  return $ STE.EqN t_par producer_par

-- generators
sequence_to_partially_parallel _ node@(SeqE.Lut_GenN _ _ producer) =
  throwError $ Expr_Failure $ "Can't parallelize LUTs: " ++ show node
sequence_to_partially_parallel type_rewrites (SeqE.Const_GenN constant_val constant_type) = do
  t_par <- part_par_AST_type type_rewrites constant_type
  v_par <- part_par_AST_value type_rewrites constant_val
  return $ STE.Const_GenN v_par t_par

-- sequence operators
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  (SeqE.ShiftN n i shift_amount elem_t producer) |
  parameters_match tr n i = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  return $ STE.Shift_sN tr_n shift_amount elem_t_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  (SeqE.ShiftN n i shift_amount elem_t producer) |
  parameters_match tr n i = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  return $ STE.Shift_tN tr_n tr_i shift_amount elem_t_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  (SeqE.ShiftN n i shift_amount elem_t producer) |
  parameters_match tr n i = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  let repeated_inputs_with_index = zip [0..] $ replicate ni producer_ppar
  let inner_sseqs_shifted = fmap (
        \(i, in_seq) ->
          STE.Shift_tN no io ((ni - i + shift_amount - 1) `div` ni) elem_t_ppar $
          STE.Map_tN no io (STE.Down_1d_sN ni ((i - shift_amount) `mod` ni) elem_t_ppar $
                            STE.InputN (STT.SSeqT ni elem_t_ppar) "f_in") $
          in_seq
        ) repeated_inputs_with_index
  let nested_stuple_of_shifted_rows =
        STB.repeated_stuple (STE.Map2_tN no io) inner_sseqs_shifted elem_t_ppar
  let nested_stuple_to_sseq = STE.Map_tN no io (
        STE.STupleToSSeqN ni elem_t_ppar (
            STE.InputN (STT.SSeqT ni elem_t_ppar) "f_in")) nested_stuple_of_shifted_rows
  return nested_stuple_to_sseq



sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  (SeqE.Up_1dN n i elem_t producer) |
  parameters_match tr n i = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR 1 : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Up_1d_sN tr_n elem_t_ppar producer_ppar

sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  (SeqE.Up_1dN n i elem_t producer) |
  parameters_match tr n i = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = TimeR 1 (tr_n + tr_i - 1) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  return $ STE.Up_1d_tN tr_n tr_i elem_t_ppar producer_ppar

sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  (SeqE.Up_1dN n i elem_t producer) |
  -- i for Up_1d indicates extra invalids not caused by this upsample
  -- so can use i here
  parameters_match tr n i = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitR 1 (no + io - 1) ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  let up_outer = STE.Up_1d_tN no i (STT.SSeqT 1 elem_t_ppar) producer_ppar
  let up_inner = STE.Map_tN no i ( STB.add_input_to_expr_for_map $
                                   STE.Up_1d_sN ni elem_t_ppar
                                 ) up_outer
  return up_inner

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  (SeqE.Down_1dN n i sel_idx elem_t producer) |
  parameters_match tr 1 (n+i-1) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- using n here rather than tr_n as tr_n is 1, indicating sequence length,
  -- an n is for amount of downsampling. Input is of length n
  let upstream_type_rewrites = SpaceR n : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Down_1d_sN n sel_idx elem_t_ppar producer_ppar

sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  (SeqE.Down_1dN n i sel_idx elem_t producer) |
  parameters_match tr 1 (n+i-1) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- using n here rather than tr_n as tr_n is 1, indicating sequence length,
  -- an n is for amount of downsampling. Input is of length n
  -- subtract 1 from n in invalid clocks compute as n-1 is minimum number
  -- of invalid clocks on output so 0 should be min invalid clocks on input
  let upstream_type_rewrites = TimeR n (tr_i - (n-1)) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  return $ STE.Down_1d_tN n i sel_idx elem_t_ppar producer_ppar

-- no*ni must be 1
-- have io + 1 total clocks to do downsample
-- throughput must be n / (io + 1)
sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  (SeqE.Down_1dN n i sel_idx elem_t producer) |
  parameters_match tr 1 (n+i-1) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- using n here rather than no as tr_n is 1, indicating sequence length,
  -- an n is for amount of downsampling. Input is of length n
  -- subtract 1 from n in invalid clocks compute as n-1 is minimum number
  -- of invalid clocks on output so 0 should be min invalid clocks on input
  let upstream_type_rewrites = SplitR n (io - (n-1)) ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- if io+no >= n, then fully sequential downsample with
  -- space downsample just for type helping
  if no + io >= n
    then do
    let down_outer = STE.Down_1d_tN n i sel_idx (STT.SSeqT ni elem_t_ppar) producer_ppar
    let down_inner = STE.Map_tN n i ( STB.add_input_to_expr_for_map $
                                      STE.Down_1d_sN 1 0 elem_t_ppar
                                    ) down_outer
    return down_inner
    else do
    let outer_down_amount = no + io
    let down_outer = STE.Down_1d_tN outer_down_amount 0 (sel_idx `div` outer_down_amount) (STT.SSeqT ni elem_t_ppar) producer_ppar
    let down_inner = STE.Map_tN (no+io) 0 ( STB.add_input_to_expr_for_map $
                                            STE.Down_1d_sN (n `div` outer_down_amount) (sel_idx `mod` outer_down_amount) elem_t_ppar
                                          ) down_outer
    return down_inner
                                      
  {-
)ddSTE.Down_1d_tN no io (sel_idx `div` no) (STT.SSeqT ni elem_t_ppar) producer_ppar
  let up_inner = STE.Map_tN no i ( STB.add_input_to_expr_for_map $
                                   STE.Up_1d_sN ni elem_t_ppar
                                 ) up_outer
  return up_inner
-}


-- Partition must accept either an SSeq, TSeq, or TSeq (SSeq) and then emit one of the 9
-- combinations below.
-- Each method composes flips with partition_t_tt and partition_s_ss to create the match
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr_no) : tr1@(SpaceR tr_ni) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR (no*ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Partition_s_ssN tr_no tr_ni elem_t_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr_no) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- need to split them as always keep space outside time
  -- note ni no naming scheme is based on order of output and the below
  -- usages of variables are ordered for inputs that are reversed
  let upstream_type_rewrites = SplitR tr_ni tr_ii tr_no : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Flip_ts_to_st tr_ni tr_ii tr_no elem_t_ppar producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr0_no) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- output is SSeq (TSeq (SSeq)), so do a partition_s_ss and the flip the top SSeq with the above TSeq
  -- so flip's elem_t contains the lowest SSeq
  let flip_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  let upstream_type_rewrites = SplitR tr1_no tr1_io (tr0_no*tr1_ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Flip_ts_to_st tr1_no tr1_io tr0_no flip_elem_t_ppar $
    STE.Map_tN tr1_no tr1_ni (STB.add_input_to_expr_for_map $
                              STE.Partition_s_ssN tr0_no tr1_ni elem_t_ppar) producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_no tr_io) : tr1@(SpaceR tr_ni) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  -- doing nothing. Since this emits a nested TSeq(SSeq), nothing to do for partition.
  -- this partition becomes a Noop.
  -- Just need to propagate the split as a single SplitR up pipeline
  let upstream_type_rewrites = SplitR tr_no tr_io tr_ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_no tr_io) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = TimeR (tr_no*tr_ni) ((tr_no * tr_ii) + (tr_io * (tr_ni + tr_ii))) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Partition_t_ttN tr_no tr_ni tr_io tr_ii elem_t_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_no tr0_io) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- output is TSeq (TSeq (SSeq)), so do a partition_t_tt on the outer part of the split
  -- partition_t_tt's element type is the inner most SSeq 
  let partition_t_tt_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) tr1_ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Partition_t_ttN tr0_no tr1_no tr0_io tr1_io partition_t_tt_elem_t_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SpaceR tr1_ni) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- split the SplitR's inner SSeq and the SpaceR's SSeq, leave outer TSeq alone
  let upstream_type_rewrites = SplitR tr0_no tr0_io (tr0_ni*tr1_ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                                     STE.Partition_s_ssN tr0_ni tr1_ni elem_t_ppar)
    producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(TimeR tr1_n tr1_i) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  -- partition_t_tt's element type is actually an SSeq of the PartitionN's element type
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let partition_elem_t_ppar = STT.SSeqT tr0_ni elem_t_ppar
  let upstream_type_rewrites = SplitR (tr0_no*tr1_n) ((tr0_no * tr1_i) + (tr0_io * (tr1_n + tr1_i))) tr0_ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                                     STE.Flip_ts_to_st tr1_n tr1_i tr0_ni elem_t_ppar) $
    STE.Partition_t_ttN no ni io ii partition_elem_t_ppar producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  (SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- partition_t_tt's element type is actually an SSeq that will be split by the partition_s_ss's element type
  let partition_t_tt_elem_t_ppar = STT.SSeqT (tr0_ni * tr1_ni) elem_t_ppar
  -- flip's element type is the inner SSeq after the partition_s_ss
  let flip_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) (tr0_ni*tr1_ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                                     STE.Flip_ts_to_st tr1_no tr1_io tr0_ni flip_elem_t_ppar) $
    STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                              STE.Map_tN tr1_no tr1_io (STB.add_input_to_expr_for_map $
                                                        STE.Partition_s_ssN tr0_ni tr1_ni elem_t_ppar)) $
    STE.Partition_t_ttN tr0_no tr0_ni tr1_no tr1_io partition_t_tt_elem_t_ppar producer_ppar


{-
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_no) : type_rewrites_tl)
  (SeqE.UnpartitionN no ni io ii elem_t producer) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- this works as parameters_match makes sure no*ni equals tr_no
  -- and unpartition must accept same no and ni regardless of invalid clocks
  let upstream_type_rewrites = SpaceR no : SpaceR ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Unpartition_s_ssN no ni elem_t_ppar producer_ppar

-- use these computations if I'm wrong about TimeR always being fully sequential
-- for Unpartition no ni io ii into a TimeR tr_no tr_io
-- TSeq in_no in_io (TSeq in_ni in_io) is input
-- in_no*in_ni = tr_no
-- in_no = no
-- in_ni = ni
-- tr_io = (in_no * in_ii) + (in_io * (in_ni + in_ii))
-- in_io <= io
-- in_ii <= ii
-- since 3 equations and 4 unknowns, need solver
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  (SeqE.UnpartitionN no ni io ii elem_t producer) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- only get a time if fully sequential, using all invalid clocks
  -- therefore can use io and ii
  let upstream_type_rewrites = TimeR no io : TimeR ni ii : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Unpartition_t_ttN no ni io ii elem_t_ppar producer_ppar
 -}
sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  (SeqE.UnpartitionN no ni io ii elem_t producer) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  -- to compute how to speed up input, get the amount the output is sped up
  -- then distribute that speedup over the input
  let total_spedup_clocks = get_type_rewrite_periods tr
  let fully_sequential_clocks = Seq_Conv.total_clocks_from_nested no ni io ii
  let speedup = fully_sequential_clocks `div` total_spedup_clocks

  (outer_input_rewrite : inner_input_rewrite : _) <- rewrite_AST_type speedup (SeqT.SeqT no io (SeqT.SeqT ni ii SeqT.IntT))

  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = outer_input_rewrite : inner_input_rewrite : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer

  get_scheduled_partition outer_input_rewrite inner_input_rewrite elem_t_ppar producer_ppar
  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_partition :: Type_Rewrite -> Type_Rewrite -> STT.AST_Type -> STE.Expr -> Rewrite_IO_StateM STE.Expr
    get_scheduled_partition (SpaceR in0_n) (SpaceR in1_n) elem_t_ppar producer_ppar =
      return $ STE.Unpartition_s_ssN in0_n in1_n elem_t_ppar producer_ppar
    get_scheduled_partition (SpaceR in0_n) (TimeR in1_n in1_i) elem_t_ppar producer_ppar =
      return $ STE.Flip_st_to_ts in1_n in1_i in0_n elem_t_ppar producer_ppar
    get_scheduled_partition (SpaceR in0_n) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let flip_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Map_tN in1_no in1_io (STB.add_input_to_expr_for_map $ 
                                         STE.Unpartition_s_ssN in0_n in1_ni elem_t_ppar) $
        STE.Flip_st_to_ts in1_no in1_io in0_n flip_elem_t_ppar producer_ppar
    get_scheduled_partition (TimeR in0_n in0_i) (SpaceR in1_n) elem_t_ppar producer_ppar = do
      return producer_ppar
    get_scheduled_partition (TimeR in0_n in0_i) (TimeR in1_n in1_i) elem_t_ppar producer_ppar = 
      return $ STE.Unpartition_t_ttN in0_n in1_n in0_i in1_i elem_t_ppar producer_ppar
    get_scheduled_partition (TimeR in0_n in0_i) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let unpartition_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Unpartition_t_ttN in0_n in1_no in0_i in1_ni unpartition_elem_t_ppar producer_ppar
    get_scheduled_partition (SplitR in0_no in0_io in0_ni) (SpaceR in1_n) elem_t_ppar producer_ppar = do
      return $ STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                         STE.Unpartition_s_ssN in0_ni in1_n elem_t_ppar)
        producer_ppar
    get_scheduled_partition (SplitR in0_no in0_io in0_ni) (TimeR in1_n in1_i) elem_t_ppar producer_ppar = do
      let unpartition_elem_t_ppar = STT.SSeqT in0_ni elem_t_ppar
      return $ STE.Unpartition_t_ttN in0_ni in1_n in0_io in1_i unpartition_elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                   STE.Flip_st_to_ts in1_n in1_i in0_ni elem_t_ppar) $
        producer_ppar
    get_scheduled_partition (SplitR in0_no in0_io in0_ni) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let unpartition_t_tt_elem_t_ppar = STT.SSeqT in0_ni (STT.SSeqT in1_ni elem_t_ppar)
      let flip_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ STE.Map_tN in1_no in1_io $
                                         STB.add_input_to_expr_for_map $ STE.Unpartition_s_ssN in0_ni in1_ni elem_t_ppar
                                        ) $
        STE.Unpartition_t_ttN in0_no in1_no in0_io in1_io unpartition_t_tt_elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                   STE.Flip_st_to_ts in1_no in1_io in0_ni flip_elem_t_ppar) $
        producer_ppar
    get_scheduled_partition NonSeqR _ _ _ = throwError $
      Slowdown_Failure "can't get nonseq for unpartition input"
    get_scheduled_partition _ NonSeqR _ _ = throwError $
      Slowdown_Failure "can't get nonseq for unpartition input"



-- higher order operators
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  (SeqE.MapN n i f producer) |
  parameters_match tr n i = do
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  f_ppar <- sequence_to_partially_parallel type_rewrites_tl f
  return $ STE.Map_sN tr_n f_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  (SeqE.MapN n i f producer) |
  parameters_match tr n i = do
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  f_ppar <- sequence_to_partially_parallel type_rewrites_tl f
  return $ STE.Map_tN tr_n tr_i f_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr@(SplitR tr_no tr_io tr_ni) : type_rewrites_tl)
  (SeqE.MapN n i f producer) |
  parameters_match tr n i = do
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  f_ppar <- sequence_to_partially_parallel type_rewrites_tl f
  return $ STE.Map_tN tr_no tr_io (STB.add_input_to_expr_for_map $
                                   STE.Map_sN tr_ni f_ppar)
    producer_ppar



sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  (SeqE.Map2N n i f producer_left producer_right) |
  parameters_match tr n i = do
  producer_left_ppar <- sequence_to_partially_parallel type_rewrites producer_left
  producer_right_ppar <- sequence_to_partially_parallel type_rewrites producer_right
  f_ppar <- sequence_to_partially_parallel type_rewrites_tl f
  return $ STE.Map2_sN tr_n f_ppar producer_left_ppar producer_right_ppar

sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  (SeqE.Map2N n i f producer_left producer_right) |
  parameters_match tr n i = do
  producer_left_ppar <- sequence_to_partially_parallel type_rewrites producer_left
  producer_right_ppar <- sequence_to_partially_parallel type_rewrites producer_right
  f_ppar <- sequence_to_partially_parallel type_rewrites_tl f
  return $ STE.Map2_tN tr_n tr_i f_ppar producer_left_ppar producer_right_ppar

sequence_to_partially_parallel type_rewrites@(tr@(SplitR tr_no tr_io tr_ni) : type_rewrites_tl)
  (SeqE.Map2N n i f producer_left producer_right) |
  parameters_match tr n i = do
  producer_left_ppar <- sequence_to_partially_parallel type_rewrites producer_left
  producer_right_ppar <- sequence_to_partially_parallel type_rewrites producer_right
  f_ppar <- sequence_to_partially_parallel type_rewrites_tl f
  return $ STE.Map2_tN tr_no tr_io (STB.add_input_to_expr_for_map2 $
                                    STE.Map2_sN tr_ni f_ppar)
    producer_left_ppar producer_right_ppar



sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  (SeqE.ReduceN n i f producer) |
  parameters_match tr n i = do
  -- to compute how to speed up input, get the amount the output is sped up
  -- then distribute that speedup over the input
  let total_spedup_clocks = get_type_rewrite_periods tr
  let fully_sequential_clocks = n + i
  let speedup = fully_sequential_clocks `div` total_spedup_clocks

  input_rewrite : _ <- rewrite_AST_type speedup (SeqT.SeqT n i SeqT.IntT)

  let upstream_type_rewrites = input_rewrite : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  f_ppar <- sequence_to_partially_parallel type_rewrites_tl f

  get_scheduled_partition input_rewrite f_ppar producer_ppar
  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_partition :: Type_Rewrite -> STE.Expr -> STE.Expr -> Rewrite_IO_StateM STE.Expr
    get_scheduled_partition (SpaceR in_n) f_ppar producer_ppar =
      return $ STE.Reduce_sN in_n f_ppar producer_ppar
    get_scheduled_partition (TimeR in_n in_i) f_ppar producer_ppar =
      return $ STE.Reduce_tN in_n in_i f_ppar producer_ppar
    get_scheduled_partition (SplitR in_no in_io in_ni) f_ppar producer_ppar =
      return $ STE.Reduce_tN in_no in_io (STB.add_input_to_expr_for_map $
                                          STE.Map_sN 1 f_ppar) $
      STE.Map_tN in_no in_io (STB.add_input_to_expr_for_map $
                              STE.Reduce_sN in_ni f_ppar)
      producer_ppar
    get_scheduled_partition NonSeqR _ _ = throwError $
      Slowdown_Failure "can't get nonseq for reduce input"

-- tuple operations
sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  (SeqE.FstN t0 t1 producer) = do
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  t0_ppar <- part_par_AST_type type_rewrites_tl t0
  t1_ppar <- part_par_AST_type type_rewrites_tl t1
  return $ STE.FstN t0_ppar t1_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  (SeqE.SndN t0 t1 producer) = do
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  t0_ppar <- part_par_AST_type type_rewrites_tl t0
  t1_ppar <- part_par_AST_type type_rewrites_tl t1
  return $ STE.SndN t0_ppar t1_ppar producer_ppar

sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  (SeqE.ATupleN t0 t1 producer_left producer_right) = do
  producer_left_ppar <- sequence_to_partially_parallel type_rewrites producer_left
  producer_right_ppar <- sequence_to_partially_parallel type_rewrites producer_right
  t0_ppar <- part_par_AST_type type_rewrites_tl t0
  t1_ppar <- part_par_AST_type type_rewrites_tl t1
  return $ STE.ATupleN t0_ppar t1_ppar producer_left_ppar producer_right_ppar

sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  (SeqE.STupleN elem_t producer_left producer_right) = do
  producer_left_ppar <- sequence_to_partially_parallel type_rewrites producer_left
  producer_right_ppar <- sequence_to_partially_parallel type_rewrites producer_right
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  return $ STE.STupleN elem_t_ppar producer_left_ppar producer_right_ppar

sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  (SeqE.STupleAppendN out_len elem_t producer_left producer_right) = do
  producer_left_ppar <- sequence_to_partially_parallel type_rewrites producer_left
  producer_right_ppar <- sequence_to_partially_parallel type_rewrites producer_right
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  return $ STE.STupleAppendN out_len elem_t_ppar producer_left_ppar producer_right_ppar
  
{-
sequence_to_partially_parallel type_rewrites@(tr0 : tr1 : type_rewrites_tl) (SeqE.STupleToSeqN no ni io ii elem_t producer) = do
  -- to compute how to speed up input, get the amount the output is sped up
  -- then distribute that speedup over the input
  let total_spedup_clocks = get_type_rewrite_periods tr
  let fully_sequential_clocks = Seq_Conv.total_clocks_from_nested no ni io ii
  let speedup = fully_sequential_clocks `div` total_spedup_clocks
  t_par <- parallelize_AST_type elem_t
  producer_par <- sequence_to_partially_parallel producer
  return $ STE.Map_sN no (STE.STupleToSSeqN ni t_par
                          -- need to wrap t_par for input as STuple takes
                          -- in an stuple of elements
                          (STE.InputN (STT.STupleT ni t_par) "seq_in")) producer_par
  
sequence_to_partially_parallel (SeqE.SeqToSTupleN no ni io ii elem_t producer) = do
  t_par <- parallelize_AST_type elem_t
  producer_par <- sequence_to_partially_parallel producer
  return $ STE.Map_sN no (STE.SSeqToSTupleN ni t_par
                          -- need to wrap t_par for input as STuple takes
                          -- in an stuple of elements
                          (STE.InputN (STT.SSeqT ni t_par) "seq_in")) producer_par

-}
sequence_to_partially_parallel type_rewrites (SeqE.InputN t input_name) = do
  t_ppar <- part_par_AST_type type_rewrites t
  return $ STE.InputN t_ppar input_name

sequence_to_partially_parallel _ (SeqE.ErrorN s) = return $ STE.ErrorN s

-- | Verifies that Type_Rewrite matches the output Seq that is being rewritten
parameters_match :: Type_Rewrite -> Int -> Int -> Bool
parameters_match (SpaceR tr_n) n _ = tr_n == n
parameters_match (TimeR tr_n tr_i) n i = tr_n == n && tr_i <= i
parameters_match (SplitR tr_n_outer tr_i_outer tr_n_inner) n i =
  tr_n_outer * tr_n_inner == n && tr_i_outer <= i
parameters_match _ _ _ = False

part_par_AST_type :: [Type_Rewrite] -> SeqT.AST_Type -> Rewrite_IO_StateM STT.AST_Type
part_par_AST_type [NonSeqR] SeqT.UnitT = return STT.UnitT
part_par_AST_type [NonSeqR] SeqT.BitT = return STT.BitT
part_par_AST_type [NonSeqR] SeqT.IntT = return STT.IntT
part_par_AST_type [NonSeqR] (SeqT.ATupleT x y) = do
  x_stt <- part_par_AST_type [NonSeqR] x
  y_stt <- part_par_AST_type [NonSeqR] y
  return $ (STT.ATupleT x_stt y_stt) 
part_par_AST_type (tr@(SpaceR tr_n) : type_rewrites_tl) (SeqT.SeqT n i t) |
  parameters_match tr n i = do
  inner_type <- part_par_AST_type type_rewrites_tl t
  return $ STT.SSeqT n inner_type
part_par_AST_type (tr@(TimeR tr_n tr_i) : type_rewrites_tl) (SeqT.SeqT n i t) |
  parameters_match tr n i = do
  inner_type <- part_par_AST_type type_rewrites_tl t
  return $ STT.TSeqT n tr_i inner_type
part_par_AST_type (tr@(SplitR tr_n_outer tr_i_outer tr_n_inner) : type_rewrites_tl)
  (SeqT.SeqT n i t) |
  parameters_match tr n i = do
  inner_type <- part_par_AST_type type_rewrites_tl t
  return $ STT.TSeqT n tr_i_outer inner_type
part_par_AST_type (NonSeqR : type_rewrites_tl) (SeqT.STupleT n t) = do
  inner_type <- part_par_AST_type type_rewrites_tl t
  return $ STT.STupleT n inner_type
part_par_AST_type type_rewrites t = throwError $ Slowdown_Failure $
  "type_rewrite " ++ show type_rewrites ++ " not valid for partially " ++
  "parallelizing AST type " ++ show t

part_par_AST_value :: [Type_Rewrite] -> SeqT.AST_Value -> Rewrite_IO_StateM STT.AST_Value
part_par_AST_value [NonSeqR] SeqT.UnitV = return STT.UnitV
part_par_AST_value [NonSeqR] (SeqT.BitV b) = return (STT.BitV b)
part_par_AST_value [NonSeqR] (SeqT.IntV i) = return (STT.IntV i)
part_par_AST_value [NonSeqR] (SeqT.ATupleV x y) = do
  x_stv <- part_par_AST_value [NonSeqR] x
  y_stv <- part_par_AST_value [NonSeqR] y
  return $ (STT.ATupleV x_stv y_stv)
part_par_AST_value (tr@(SpaceR tr_n) : type_rewrites_tl) (SeqT.SeqV xs i) |
  -- just sticking IntT here as need some type that won't be looked at
  parameters_match tr (length xs) i = do
  xs_par <- mapM (part_par_AST_value type_rewrites_tl) xs
  return $ STT.SSeqV xs_par
part_par_AST_value (tr@(TimeR tr_n tr_i) : type_rewrites_tl) (SeqT.SeqV xs i) |
  parameters_match tr (length xs) i = do
  xs_par <- mapM (part_par_AST_value type_rewrites_tl) xs
  return $ STT.TSeqV xs_par tr_i 
part_par_AST_value (tr@(SplitR tr_n_outer tr_i_outer tr_n_inner) : type_rewrites_tl)
  (SeqT.SeqV xs i) |
  parameters_match tr (length xs) i = do
  xs_par <- mapM (part_par_AST_value type_rewrites_tl) xs
  -- split the xs into chunks where each chunk is an sseq of length
  -- tr_n_inner
  -- and then group all the sseq into one tseq
  let xs_par_chunked = chunksOf tr_n_inner xs_par
  let xs_chunks_as_sseqs = fmap STT.SSeqV xs_par_chunked
  return $ STT.TSeqV xs_chunks_as_sseqs tr_i_outer
part_par_AST_value (NonSeqR : type_rewrites_tl) (SeqT.STupleV xs) = do
  xs_par <- mapM (part_par_AST_value type_rewrites_tl) xs
  return $ STT.STupleV xs_par
part_par_AST_value type_rewrites v = throwError $ Slowdown_Failure $
  "type_rewrite " ++ show type_rewrites ++ " not valid for partially " ++
  "parallelizing AST value " ++ show v
  
part_par_atom_operator :: [Type_Rewrite] -> (STE.Expr -> STE.Expr) -> SeqE.Expr -> Rewrite_IO_StateM STE.Expr
part_par_atom_operator [] atom_op_gen _ = throwError $ Slowdown_Failure $
  "type_rewrite list empty while processing " ++
  show (atom_op_gen $ STE.ErrorN "place_holder")
part_par_atom_operator [NonSeqR] atom_op_gen producer = do
  producer_par <- sequence_to_partially_parallel [NonSeqR] producer
  return $ atom_op_gen producer_par
part_par_atom_operator type_rewrites atom_op_gen _ = throwError $ Slowdown_Failure $
  "type_rewrite list " ++ show type_rewrites ++ " not just a NonSeqR for atom op " ++
  show (atom_op_gen $ STE.ErrorN "place_holder")
 {- 
parallelize_unary_seq_operator :: (STT.AST_Type -> STE.Expr -> STE.Expr) -> SeqT.AST_Type ->
                                  SeqE.Expr -> Rewrite_StateM STE.Expr
parallelize_unary_seq_operator unary_seq_op_gen t producer = do
  producer_par <- sequence_to_partially_parallel producer
  t_par <- parallelize_AST_type t
  return $ unary_seq_op_gen t_par producer_par
-}

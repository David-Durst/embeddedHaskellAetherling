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

rewrite_to_partially_parallel :: Int -> SeqE.Expr -> STE.Expr
rewrite_to_partially_parallel s seq_expr = do
  let expr_par = runExcept $ rewrite_to_partially_parallel' s seq_expr
  if isLeft expr_par
    then STE.ErrorN (rw_msg $ fromLeft undefined expr_par)
    else fromRight undefined expr_par

rewrite_to_partially_parallel' :: Int -> SeqE.Expr -> Rewrite_StateM STE.Expr
rewrite_to_partially_parallel' s seq_expr = do
  let seq_expr_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types seq_expr
  output_type_slowdowns <- rewrite_AST_type s seq_expr_out_type
  sequence_to_partially_parallel output_type_slowdowns seq_expr
  

sequence_to_partially_parallel :: [Type_Rewrite] -> SeqE.Expr -> Rewrite_StateM STE.Expr
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
  return $ STE.Down_1d_tN tr_n tr_i sel_idx elem_t_ppar producer_ppar
  
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
  let down_outer = STE.Down_1d_tN no io (sel_idx `div` no) (STT.SSeqT ni elem_t_ppar) producer_ppar
  {-
  let up_inner = STE.Map_tN no i ( STB.add_input_to_expr_for_map $
                                   STE.Up_1d_sN ni elem_t_ppar
                                 ) up_outer
  return up_inner
-}
  return undefined
{-
sequence_to_partially_parallel (SeqE.PartitionN no ni _ _ elem_t producer) =
  parallelize_unary_seq_operator (STE.Partition_s_ssN no ni) elem_t producer
sequence_to_partially_parallel (SeqE.UnpartitionN no ni _ _ elem_t producer) =
  parallelize_unary_seq_operator (STE.Unpartition_s_ssN no ni) elem_t producer

-- higher order operators
sequence_to_partially_parallel (SeqE.MapN n _ f producer) = do
  f_par <- sequence_to_partially_parallel f
  producer_par <- sequence_to_partially_parallel producer
  return $ STE.Map_sN n f_par producer_par
sequence_to_partially_parallel (SeqE.Map2N n _ f producer_left producer_right) = do
  f_par <- sequence_to_partially_parallel f
  producer_left_par <- sequence_to_partially_parallel producer_left
  producer_right_par <- sequence_to_partially_parallel producer_right
  return $ STE.Map2_sN n f_par producer_left_par producer_right_par
sequence_to_partially_parallel (SeqE.ReduceN n _ f producer) = do
  f_par <- sequence_to_partially_parallel f
  producer_par <- sequence_to_partially_parallel producer
  return $ STE.Reduce_sN n f_par producer_par

-- tuple operations
sequence_to_partially_parallel (SeqE.FstN t0 t1 producer) = do
  producer_par <- sequence_to_partially_parallel producer
  t0_par <- parallelize_AST_type t0
  t1_par <- parallelize_AST_type t1
  return $ STE.FstN t0_par t1_par producer_par

sequence_to_partially_parallel (SeqE.SndN t0 t1 producer) = do
  producer_par <- sequence_to_partially_parallel producer
  t0_par <- parallelize_AST_type t0
  t1_par <- parallelize_AST_type t1
  return $ STE.SndN t0_par t1_par producer_par

sequence_to_partially_parallel (SeqE.ATupleN t0 t1 producer_left producer_right) = do
  producer_left_par <- sequence_to_partially_parallel producer_left
  producer_right_par <- sequence_to_partially_parallel producer_right
  t0_par <- parallelize_AST_type t0
  t1_par <- parallelize_AST_type t1
  return $ STE.ATupleN t0_par t1_par producer_left_par producer_right_par

sequence_to_partially_parallel (SeqE.STupleN elem_t producer_left producer_right) = do
  t_par <- parallelize_AST_type elem_t
  producer_left_par <- sequence_to_partially_parallel producer_left
  producer_right_par <- sequence_to_partially_parallel producer_right
  return $ STE.STupleN t_par producer_left_par producer_right_par

sequence_to_partially_parallel (SeqE.STupleAppendN out_len elem_t producer_left producer_right) = do
  t_par <- parallelize_AST_type elem_t
  producer_left_par <- sequence_to_partially_parallel producer_left
  producer_right_par <- sequence_to_partially_parallel producer_right
  return $ STE.STupleAppendN out_len t_par producer_left_par producer_right_par
  
sequence_to_partially_parallel (SeqE.STupleToSeqN no ni io ii elem_t producer) = do
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

sequence_to_partially_parallel (SeqE.InputN t input_name) = do
  t_par <- parallelize_AST_type t
  return $ STE.InputN t_par input_name

sequence_to_partially_parallel (SeqE.ErrorN s) = return $ STE.ErrorN s
-}

-- | Verifies that Type_Rewrite matches the Seq that is being rewritten
parameters_match :: Type_Rewrite -> Int -> Int -> Bool
parameters_match (SpaceR tr_n) n _ = tr_n == n
parameters_match (TimeR tr_n tr_i) n i = tr_n == n && tr_i <= i
parameters_match (SplitR tr_n_outer tr_i_outer tr_n_inner) n i =
  tr_n_outer * tr_n_inner == n && tr_i_outer <= i
parameters_match _ _ _ = False

part_par_AST_type :: [Type_Rewrite] -> SeqT.AST_Type -> Rewrite_StateM STT.AST_Type
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

part_par_AST_value :: [Type_Rewrite] -> SeqT.AST_Value -> Rewrite_StateM STT.AST_Value
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
  
part_par_atom_operator :: [Type_Rewrite] -> (STE.Expr -> STE.Expr) -> SeqE.Expr -> Rewrite_StateM STE.Expr
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

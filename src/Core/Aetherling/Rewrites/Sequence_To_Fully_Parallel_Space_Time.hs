module Aetherling.Rewrites.Sequence_To_Fully_Parallel_Space_Time where
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Rewrites.Rewrite_Helpers
import Control.Monad.Except
import Control.Monad.Identity
import Data.Maybe
import Data.Either

type Rewrite_StateM = Except Rewrite_Failure

rewrite_to_fully_parallel :: (Aetherling_Value a) => a -> Expr
rewrite_to_fully_parallel seq_program = do
  let expr_maybe = edge_to_maybe_expr seq_program
  if isJust expr_maybe
    then do
    let expr_par = runExcept $ sequence_to_fully_parallel $ fromJust expr_maybe
    if isLeft expr_par
      then ErrorN (rw_msg $ fromLeft undefined expr_par)
      else fromRight undefined expr_par
    else ErrorN "Not an edge, please pass in the result of calling compile"

sequence_to_fully_parallel :: Expr -> Rewrite_StateM Expr
sequence_to_fully_parallel (IdN producer) = parallelize_atom_operator IdN producer
sequence_to_fully_parallel (AbsN producer) = parallelize_atom_operator AbsN producer
sequence_to_fully_parallel (NotN producer) = parallelize_atom_operator NotN producer
sequence_to_fully_parallel (AddN producer) = parallelize_atom_operator AddN producer
sequence_to_fully_parallel (SubN producer) = parallelize_atom_operator SubN producer
sequence_to_fully_parallel (MulN producer) = parallelize_atom_operator MulN producer
sequence_to_fully_parallel (DivN producer) = parallelize_atom_operator DivN producer
sequence_to_fully_parallel (EqN t producer) = do
  producer_par <- sequence_to_fully_parallel producer
  t_par <- parallelize_AST_type t
  return $ EqN t_par producer_par

-- generators
sequence_to_fully_parallel (Lut_GenN _ _ producer) =
  throwError $ Expr_Failure "Can't parallelize LUTs" producer
sequence_to_fully_parallel (Const_GenN constant_val constant_type) = do
  t_par <- parallelize_AST_type constant_type
  v_par <- parallelize_AST_value constant_val
  return $ Const_GenN v_par t_par

-- sequence operators
sequence_to_fully_parallel (ShiftN n _ shift_amount elem_t producer) =
  parallelize_unary_seq_operator (Shift_sN n shift_amount) elem_t producer
sequence_to_fully_parallel (Up_1dN n _ elem_t producer) =
  parallelize_unary_seq_operator (Up_1d_sN n) elem_t producer
sequence_to_fully_parallel (Down_1dN n _ sel_idx elem_t producer) =
  parallelize_unary_seq_operator (Down_1d_sN n sel_idx) elem_t producer
sequence_to_fully_parallel (PartitionN no ni _ _ elem_t producer) =
  parallelize_unary_seq_operator (Partition_s_ssN no ni) elem_t producer
sequence_to_fully_parallel (UnpartitionN no ni _ _ elem_t producer) =
  parallelize_unary_seq_operator (Unpartition_s_ssN no ni) elem_t producer

-- higher order operators
sequence_to_fully_parallel (MapN n _ f producer) = do
  f_par <- sequence_to_fully_parallel f
  producer_par <- sequence_to_fully_parallel producer
  return $ Map_sN n f_par producer_par
sequence_to_fully_parallel (Map2N n _ f producer_left producer_right) = do
  f_par <- sequence_to_fully_parallel f
  producer_left_par <- sequence_to_fully_parallel producer_left
  producer_right_par <- sequence_to_fully_parallel producer_right
  return $ Map2_sN n f_par producer_left_par producer_right_par
sequence_to_fully_parallel (ReduceN n _ f producer) = do
  f_par <- sequence_to_fully_parallel f
  producer_par <- sequence_to_fully_parallel producer
  return $ Reduce_sN n f_par producer_par

-- tuple operations
sequence_to_fully_parallel (FstN t0 t1 producer) = do
  producer_par <- sequence_to_fully_parallel producer
  t0_par <- parallelize_AST_type t0
  t1_par <- parallelize_AST_type t1
  return $ FstN t0_par t1_par producer_par

sequence_to_fully_parallel (SndN t0 t1 producer) = do
  producer_par <- sequence_to_fully_parallel producer
  t0_par <- parallelize_AST_type t0
  t1_par <- parallelize_AST_type t1
  return $ SndN t0_par t1_par producer_par

sequence_to_fully_parallel (ATupleN t0 t1 producer_left producer_right) = do
  producer_left_par <- sequence_to_fully_parallel producer_left
  producer_right_par <- sequence_to_fully_parallel producer_right
  t0_par <- parallelize_AST_type t0
  t1_par <- parallelize_AST_type t1
  return $ ATupleN t0_par t1_par producer_left_par producer_right_par

sequence_to_fully_parallel (STupleN elem_t producer_left producer_right) = do
  t_par <- parallelize_AST_type elem_t
  producer_left_par <- sequence_to_fully_parallel producer_left
  producer_right_par <- sequence_to_fully_parallel producer_right
  return $ STupleN t_par producer_left_par producer_right_par

sequence_to_fully_parallel (STupleAppendN out_len elem_t producer_left producer_right) = do
  t_par <- parallelize_AST_type elem_t
  producer_left_par <- sequence_to_fully_parallel producer_left
  producer_right_par <- sequence_to_fully_parallel producer_right
  return $ STupleAppendN out_len t_par producer_left_par producer_right_par
  
sequence_to_fully_parallel (STupleToSeqN no ni io ii elem_t producer) = do
  t_par <- parallelize_AST_type elem_t
  producer_par <- sequence_to_fully_parallel producer
  return $ Map_sN no (STupleToSSeqN ni t_par (InputN t_par "seq_in")) producer_par
  
sequence_to_fully_parallel (SeqToSTupleN no ni io ii elem_t producer) = do
  t_par <- parallelize_AST_type elem_t
  producer_par <- sequence_to_fully_parallel producer
  return $ Map_sN no (SSeqToSTupleN ni t_par (InputN t_par "seq_in")) producer_par

sequence_to_fully_parallel (InputN t input_name) = do
  t_par <- parallelize_AST_type t
  return $ InputN t_par input_name

sequence_to_fully_parallel x =
  throwError $ Expr_Failure "Space-Time operators can't be parallelized" x

parallelize_AST_type :: AST_Type -> Rewrite_StateM AST_Type
parallelize_AST_type (SeqT n _ t) = do
  inner_type <- parallelize_AST_type t
  return $ SSeqT n inner_type
parallelize_AST_type (STupleT n t) = do
  inner_type <- parallelize_AST_type t
  return $ STupleT n inner_type
parallelize_AST_type (SSeqT n t) =
  throwError $ Type_Failure "Can't parallelize SSeq" (SSeqT n t)
parallelize_AST_type (TSeqT n i t) =
  throwError $ Type_Failure "Can't parallelize TSeq" (TSeqT n i t)
parallelize_AST_type x = return x

parallelize_AST_value :: AST_Value -> Rewrite_StateM AST_Value
parallelize_AST_value (SeqV xs _) = do
  xs_par <- mapM parallelize_AST_value xs
  return $ SSeqV xs_par
parallelize_AST_value (STupleV xs) = do
  xs_par <- mapM parallelize_AST_value xs
  return $ STupleV xs_par
parallelize_AST_value v@(SSeqV _) =
  throwError $ Value_Failure "Can't parallelize SSeq" v
parallelize_AST_value v@(TSeqV _ _) =
  throwError $ Value_Failure "Can't parallelize TSeq" v
parallelize_AST_value x = return x

parallelize_atom_operator :: (Expr -> Expr) -> Expr -> Rewrite_StateM Expr
parallelize_atom_operator atom_op_gen producer = do
  producer_par <- sequence_to_fully_parallel producer
  return $ atom_op_gen producer_par
  
parallelize_unary_seq_operator :: (AST_Type -> Expr -> Expr) -> AST_Type ->
                                  Expr -> Rewrite_StateM Expr
parallelize_unary_seq_operator unary_seq_op_gen t producer = do
  producer_par <- sequence_to_fully_parallel producer
  t_par <- parallelize_AST_type t
  return $ unary_seq_op_gen t_par producer_par

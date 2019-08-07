module Aetherling.Rewrites.Sequence_To_Fully_Parallel_Space_Time where
import Aetherling.Monad_Helpers
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Aetherling.Languages.Sequence.Shallow.Expr_Type_Conversions
import Control.Monad.Except
import Control.Monad.Identity
import Control.Monad.State
import Data.Maybe
import Data.Either

rewrite_to_fully_parallel :: SeqE.Expr -> STE.Expr
rewrite_to_fully_parallel seq_expr = do
  let expr_par = evalState
                 (runExceptT $ startEvalMemoT $ sequence_to_fully_parallel seq_expr)
                 empty_rewrite_data
  if isLeft expr_par
    then STE.ErrorN (rw_msg $ fromLeft undefined expr_par) No_Index
    else fromRight undefined expr_par

sequence_to_fully_parallel :: SeqE.Expr -> Memo_Rewrite_StateM STE.Expr STE.Expr
sequence_to_fully_parallel (SeqE.IdN producer _) = parallelize_atom_operator STE.IdN producer
sequence_to_fully_parallel (SeqE.AbsN producer _) = parallelize_atom_operator STE.AbsN producer
sequence_to_fully_parallel (SeqE.NotN producer _) = parallelize_atom_operator STE.NotN producer
sequence_to_fully_parallel (SeqE.AddN producer _) = parallelize_atom_operator STE.AddN producer
sequence_to_fully_parallel (SeqE.SubN producer _) = parallelize_atom_operator STE.SubN producer
sequence_to_fully_parallel (SeqE.MulN producer _) = parallelize_atom_operator STE.MulN producer
sequence_to_fully_parallel (SeqE.DivN producer _) = parallelize_atom_operator STE.DivN producer
sequence_to_fully_parallel (SeqE.EqN t producer _) = do
  producer_par <- memo producer $ sequence_to_fully_parallel producer
  t_par <- lift $ parallelize_AST_type t
  cur_idx <- get_cur_index
  return $ STE.EqN t_par producer_par cur_idx

-- generators
sequence_to_fully_parallel node@(SeqE.Lut_GenN _ _ producer _) =
  throwError $ Expr_Failure $ "Can't parallelize LUTs: " ++ show node
sequence_to_fully_parallel (SeqE.Const_GenN constant_val constant_type _) = do
  t_par <- lift $ parallelize_AST_type constant_type
  v_par <- lift $ parallelize_AST_value constant_val
  cur_idx <- get_cur_index
  return $ STE.Const_GenN v_par t_par cur_idx

-- sequence operators
sequence_to_fully_parallel (SeqE.ShiftN n _ shift_amount elem_t producer _) =
  parallelize_unary_seq_operator (STE.Shift_sN n shift_amount) elem_t producer
sequence_to_fully_parallel (SeqE.Up_1dN n _ elem_t producer _) =
  parallelize_unary_seq_operator (STE.Up_1d_sN n) elem_t producer
sequence_to_fully_parallel (SeqE.Down_1dN n _ sel_idx elem_t producer _) =
  parallelize_unary_seq_operator (STE.Down_1d_sN n sel_idx) elem_t producer
sequence_to_fully_parallel (SeqE.PartitionN no ni _ _ elem_t producer _) =
  parallelize_unary_seq_operator (STE.Partition_s_ssN no ni) elem_t producer
sequence_to_fully_parallel (SeqE.UnpartitionN no ni _ _ elem_t producer _) =
  parallelize_unary_seq_operator (STE.Unpartition_s_ssN no ni) elem_t producer

-- higher order operators
sequence_to_fully_parallel (SeqE.MapN n _ f producer _) = do
  f_par <- memo f $ sequence_to_fully_parallel f
  producer_par <- memo producer $ sequence_to_fully_parallel producer
  cur_idx <- get_cur_index
  return $ STE.Map_sN n f_par producer_par cur_idx
sequence_to_fully_parallel (SeqE.Map2N n _ f producer_left producer_right _) = do
  f_par <- memo f $ sequence_to_fully_parallel f
  producer_left_par <- memo producer_left $ sequence_to_fully_parallel producer_left
  producer_right_par <- memo producer_right $ sequence_to_fully_parallel producer_right
  cur_idx <- get_cur_index
  return $ STE.Map2_sN n f_par producer_left_par producer_right_par cur_idx
sequence_to_fully_parallel (SeqE.ReduceN n _ f producer _) = do
  f_par <- memo f $ sequence_to_fully_parallel f
  producer_par <- memo producer $ sequence_to_fully_parallel producer
  cur_idx <- get_cur_index
  return $ STE.Reduce_sN n f_par producer_par cur_idx

-- tuple operations
sequence_to_fully_parallel (SeqE.FstN t0 t1 producer _) = do
  producer_par <- sequence_to_fully_parallel producer
  t0_par <- lift $ parallelize_AST_type t0
  t1_par <- lift $ parallelize_AST_type t1
  cur_idx <- get_cur_index
  return $ STE.FstN t0_par t1_par producer_par cur_idx

sequence_to_fully_parallel (SeqE.SndN t0 t1 producer _) = do
  producer_par <- sequence_to_fully_parallel producer
  t0_par <- lift $ parallelize_AST_type t0
  t1_par <- lift $ parallelize_AST_type t1
  cur_idx <- get_cur_index
  return $ STE.SndN t0_par t1_par producer_par cur_idx

sequence_to_fully_parallel (SeqE.ATupleN t0 t1 producer_left producer_right _) = do
  producer_left_par <- sequence_to_fully_parallel producer_left
  producer_right_par <- sequence_to_fully_parallel producer_right
  t0_par <- lift $ parallelize_AST_type t0
  t1_par <- lift $ parallelize_AST_type t1
  cur_idx <- get_cur_index
  return $ STE.ATupleN t0_par t1_par producer_left_par producer_right_par cur_idx

sequence_to_fully_parallel (SeqE.STupleN elem_t producer_left producer_right _) = do
  t_par <- lift $ parallelize_AST_type elem_t
  producer_left_par <- memo producer_left $ sequence_to_fully_parallel producer_left
  producer_right_par <- memo producer_left $ sequence_to_fully_parallel producer_right
  cur_idx <- get_cur_index
  return $ STE.STupleN t_par producer_left_par producer_right_par cur_idx

sequence_to_fully_parallel (SeqE.STupleAppendN out_len elem_t producer_left producer_right _) = do
  t_par <- lift $ parallelize_AST_type elem_t
  producer_left_par <- memo producer_left $ sequence_to_fully_parallel producer_left
  producer_right_par <- memo producer_left $ sequence_to_fully_parallel producer_right
  cur_idx <- get_cur_index
  return $ STE.STupleAppendN out_len t_par producer_left_par producer_right_par cur_idx
  
sequence_to_fully_parallel (SeqE.STupleToSeqN no ni io ii elem_t producer _) = do
  t_par <- lift $ parallelize_AST_type elem_t
  producer_par <- memo producer $ sequence_to_fully_parallel producer
  input_idx <- get_cur_index
  stuple_idx <- get_cur_index
  map_idx <- get_cur_index
  return $ STE.Map_sN no (STE.STupleToSSeqN ni t_par
                          -- need to wrap t_par for input as STuple takes
                          -- in an stuple of elements
                          (STE.InputN (STT.STupleT ni t_par) "seq_in" input_idx)
                          stuple_idx) producer_par map_idx
  
sequence_to_fully_parallel (SeqE.SeqToSTupleN no ni io ii elem_t producer _) = do
  t_par <- lift $ parallelize_AST_type elem_t
  producer_par <- memo producer $ sequence_to_fully_parallel producer
  input_idx <- get_cur_index
  stuple_idx <- get_cur_index
  map_idx <- get_cur_index
  return $ STE.Map_sN no (STE.SSeqToSTupleN ni t_par
                          -- need to wrap t_par for input as STuple takes
                          -- in an stuple of elements
                          (STE.InputN (STT.SSeqT ni t_par) "seq_in" input_idx)
                         stuple_idx) producer_par map_idx

sequence_to_fully_parallel (SeqE.InputN t input_name _) = do
  t_par <- lift $ parallelize_AST_type t
  cur_idx <- get_cur_index
  return $ STE.InputN t_par input_name cur_idx

sequence_to_fully_parallel (SeqE.ErrorN s _) = do
  cur_idx <- get_cur_index
  return $ STE.ErrorN s cur_idx

parallelize_AST_type :: SeqT.AST_Type -> Rewrite_StateM STT.AST_Type
parallelize_AST_type SeqT.UnitT = return STT.UnitT
parallelize_AST_type SeqT.BitT = return STT.BitT
parallelize_AST_type SeqT.IntT = return STT.IntT
parallelize_AST_type (SeqT.ATupleT x y) = do
  x_stt <- parallelize_AST_type x
  y_stt <- parallelize_AST_type y
  return $ (STT.ATupleT x_stt y_stt) 
parallelize_AST_type (SeqT.SeqT n _ t) = do
  inner_type <- parallelize_AST_type t
  return $ STT.SSeqT n inner_type
parallelize_AST_type (SeqT.STupleT n t) = do
  inner_type <- parallelize_AST_type t
  return $ STT.STupleT n inner_type

parallelize_AST_value :: SeqT.AST_Value -> Rewrite_StateM STT.AST_Value
parallelize_AST_value SeqT.UnitV = return STT.UnitV
parallelize_AST_value (SeqT.BitV b) = return (STT.BitV b)
parallelize_AST_value (SeqT.IntV i) = return (STT.IntV i)
parallelize_AST_value (SeqT.ATupleV x y) = do
  x_stv <- parallelize_AST_value x
  y_stv <- parallelize_AST_value y
  return $ (STT.ATupleV x_stv y_stv) 
parallelize_AST_value (SeqT.SeqV xs _) = do
  xs_par <- mapM parallelize_AST_value xs
  return $ STT.SSeqV xs_par
parallelize_AST_value (SeqT.STupleV xs) = do
  xs_par <- mapM parallelize_AST_value xs
  return $ STT.STupleV xs_par

parallelize_atom_operator :: (STE.Expr -> DAG_Index -> STE.Expr) -> SeqE.Expr ->
                             Memo_Rewrite_StateM STE.Expr STE.Expr
parallelize_atom_operator atom_op_gen producer = do
  producer_par <- memo producer $ sequence_to_fully_parallel producer
  cur_idx <- get_cur_index
  return $ atom_op_gen producer_par cur_idx
  
parallelize_unary_seq_operator :: (STT.AST_Type -> STE.Expr -> DAG_Index -> STE.Expr) ->
                                  SeqT.AST_Type -> SeqE.Expr ->
                                  Memo_Rewrite_StateM STE.Expr STE.Expr
parallelize_unary_seq_operator unary_seq_op_gen t producer = do
  producer_par <- memo producer $ sequence_to_fully_parallel producer
  t_par <- lift $ parallelize_AST_type t
  cur_idx <- get_cur_index
  return $ unary_seq_op_gen t_par producer_par cur_idx

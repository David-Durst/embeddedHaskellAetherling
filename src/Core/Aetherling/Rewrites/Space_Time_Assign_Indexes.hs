module Aetherling.Rewrites.Space_Time_Assign_Indexes where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Memo

add_indexes :: Expr -> Expr
add_indexes e = do
  evalState (startEvalMemoT $ add_indexes' e) RH.empty_rewrite_data
  
type Expr_Memo = MemoT Expr Expr (State RH.Rewrite_Data) Expr

add_indexes' :: Expr -> Expr_Memo
add_indexes' (IdN producer_e _) = add_indexes' producer_e
add_indexes' consumer_e@(AbsN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(NotN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(AddN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(SubN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(MulN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(DivN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(EqN _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e

-- generators
add_indexes' consumer_e@(Lut_GenN _ _ producer_e _) = 
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Const_GenN _ _ _) = do
  cur_idx <- get_cur_index
  return $ consumer_e {index = cur_idx}

-- sequence operators
add_indexes' consumer_e@(Shift_sN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Shift_tN _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Up_1d_sN _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Up_1d_tN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Down_1d_sN _ _ _ producer_e _) = 
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Down_1d_tN _ _ _ _ producer_e _) = 
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Partition_s_ssN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Partition_t_ttN _ _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Unpartition_s_ssN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Unpartition_t_ttN _ _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(SerializeN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(DeserializeN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Add_1_sN _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Add_1_0_tN _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Remove_1_sN _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Remove_1_0_tN _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e

-- higher order operators
add_indexes' consumer_e@(Map_sN _ f producer_e _) = do
  add_indexes' f
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Map_tN _ _ f producer_e _) = do
  add_indexes' f
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Map2_sN _ f producer0_e producer1_e _) = do
  add_indexes' f
  add_index_to_binary_operator consumer_e producer0_e producer1_e
add_indexes' consumer_e@(Map2_tN _ _ f producer0_e producer1_e _) = do
  add_indexes' f
  add_index_to_binary_operator consumer_e producer0_e producer1_e
add_indexes' consumer_e@(Reduce_sN _ f producer_e _) = do
  add_indexes' f
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Reduce_tN _ _ f producer_e _) = do
  add_indexes' f
  add_index_to_unary_operator consumer_e producer_e

-- tuple operators
add_indexes' consumer_e@(FstN _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(SndN _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(ATupleN _ _ producer0_e producer1_e _) = do
  add_index_to_binary_operator consumer_e producer0_e producer1_e
add_indexes' consumer_e@(STupleN _ producer0_e producer1_e _) = do
  add_index_to_binary_operator consumer_e producer0_e producer1_e

add_indexes' consumer_e@(STupleAppendN _ _ producer0_e producer1_e _) = do
  add_index_to_binary_operator consumer_e producer0_e producer1_e

add_indexes' consumer_e@(STupleToSSeqN _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(SSeqToSTupleN _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e

add_indexes' (InputN t n _) = do
  cur_idx <- get_cur_index
  return $ InputN t n cur_idx
add_indexes' e@(ErrorN _ _) = do
  cur_idx <- get_cur_index
  return $ e { index = cur_idx }
add_indexes' consumer_e@(FIFON _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e

add_index_to_unary_operator :: Expr -> Expr -> Expr_Memo
add_index_to_unary_operator pre_idx_consumer_op pre_idx_producer_op = do
  producer_op <- memo add_indexes' pre_idx_producer_op
  cur_idx <- get_cur_index
  return $ pre_idx_consumer_op { seq_in = producer_op, index = cur_idx }

add_index_to_binary_operator :: Expr -> Expr -> Expr -> Expr_Memo
add_index_to_binary_operator pre_idx_consumer_op pre_idx_producer0_op
  pre_idx_producer1_op = do
  producer0_op <- memo add_indexes' pre_idx_producer0_op
  producer1_op <- memo add_indexes' pre_idx_producer1_op
  cur_idx <- get_cur_index
  return $ pre_idx_consumer_op { seq_in_left = producer0_op,
                                 seq_in_right = producer1_op,
                                 index = cur_idx }

get_cur_index :: MemoT Expr Expr (State RH.Rewrite_Data) MH.DAG_Index
get_cur_index = do
  cur_data <- lift get
  case RH.cur_index cur_data of
    MH.Index cur_idx -> do
      lift $ put $ RH.Rewrite_Data $ MH.Index (cur_idx + 1)
      return $ MH.Index cur_idx
    _ -> return MH.No_Index

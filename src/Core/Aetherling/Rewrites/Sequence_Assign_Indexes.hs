module Aetherling.Rewrites.Sequence_Assign_Indexes where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Isomorphisms
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Identity
import Control.Monad.Memo
import Data.Proxy
import Data.Maybe
import Control.Applicative
import Data.Either

add_indexes :: Expr -> Expr
add_indexes e = do
  evalState (startEvalMemoT $ add_indexes' e) RH.empty_rewrite_data

type Expr_Memo = MemoT Expr Expr (State RH.Rewrite_Data) Expr

add_indexes' :: Expr -> Expr_Memo
add_indexes' consumer_e@(IdN producer_e _) = 
  add_index_to_unary_operator consumer_e producer_e
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
add_indexes' consumer_e@(ShiftN _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Up_1dN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Down_1dN _ _ _ _ producer_e _) = 
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(PartitionN _ _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(UnpartitionN _ _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e

-- higher order operators
add_indexes' consumer_e@(MapN _ _ f producer_e _) = do
  f_with_indexes <- add_indexes' f
  add_index_to_unary_operator (consumer_e {f = f_with_indexes}) producer_e
add_indexes' consumer_e@(Map2N _ _ f producer0_e producer1_e _) = do
  f_with_indexes <- add_indexes' f
  add_index_to_binary_operator (consumer_e {f = f_with_indexes}) producer0_e producer1_e
add_indexes' consumer_e@(ReduceN _ _ f producer_e _) = do
  f_with_indexes <- add_indexes' f
  add_index_to_unary_operator (consumer_e {f = f_with_indexes}) producer_e

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
  
add_indexes' consumer_e@(STupleToSeqN _ _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(SeqToSTupleN _ _ _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
  
add_indexes' (InputN t n _) = do
  cur_idx <- get_cur_index
  return $ InputN t n cur_idx
add_indexes' e@(ErrorN _ _) = do
  cur_idx <- get_cur_index
  return $ e { index = cur_idx }

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

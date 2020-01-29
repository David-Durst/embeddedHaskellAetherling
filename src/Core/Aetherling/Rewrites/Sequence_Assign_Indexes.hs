module Aetherling.Rewrites.Sequence_Assign_Indexes where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Sequence.Deep.Expr
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Memo

add_indexes :: Expr -> Expr
add_indexes e = do
  evalState (startEvalMemoT $ add_indexes' e) RH.empty_rewrite_data

-- issue: the subgraphs of different maps are being memoized as they
-- have the same content. This means different subgraphs are getting the
-- same indices. This function is called for each subgraph
add_indexes_with_starting_index :: Expr -> MH.DAG_Index -> (Expr, RH.Rewrite_Data)
add_indexes_with_starting_index e first_index = do
  runState (startEvalMemoT $ add_indexes' e) (RH.Rewrite_Data first_index)


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
add_indexes' consumer_e@(LtN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(LSRN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(LSLN producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(EqN _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(IfN _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e

-- generators
add_indexes' consumer_e@(Lut_GenN _ _ producer_e _) = 
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Const_GenN _ _ _) = do
  cur_idx <- get_cur_index
  return $ consumer_e {index = cur_idx}

-- sequence operators
add_indexes' consumer_e@(ShiftN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Up_1dN _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(Down_1dN _ _ _ producer_e _) = 
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(PartitionN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(UnpartitionN _ _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e

-- higher order operators
add_indexes' consumer_e@(MapN _ f producer_e _) = do
  f_with_indexes <- add_index_to_subgraph f
  add_index_to_unary_operator (consumer_e {f = f_with_indexes}) producer_e
add_indexes' consumer_e@(Map2N _ f producer0_e producer1_e _) = do
  f_with_indexes <- add_index_to_subgraph f
  add_index_to_binary_operator (consumer_e {f = f_with_indexes}) producer0_e producer1_e
add_indexes' consumer_e@(ReduceN _ f producer_e _) = do
  f_with_indexes <- add_index_to_subgraph f
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
  
add_indexes' consumer_e@(STupleToSeqN _ _ producer_e _) =
  add_index_to_unary_operator consumer_e producer_e
add_indexes' consumer_e@(SeqToSTupleN _ _ producer_e _) =
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

add_index_to_subgraph :: Expr -> Expr_Memo
add_index_to_subgraph f = do
  cur_idx <- get_cur_index
  let (subgraph, next_idx) = add_indexes_with_starting_index f cur_idx
  set_next_index (RH.cur_index next_idx)
  return subgraph

-- these are repeats of the RH set and get index functions.
-- they are duplicated because I'm using a different memoization library in this function
-- I need a custom memoization function for most of the rest of Aetherling because
-- I'm doing index lookups using indexes rather than equality
-- I can't do that when generating the indexes in the first place, so I use
-- the standard memoizaiton library here whcih should be more optimized for the general case
-- these functions are for the general memoization monad
set_next_index :: MH.DAG_Index -> MemoT Expr Expr (State RH.Rewrite_Data) ()
set_next_index next_index = do
  lift $ put $ RH.Rewrite_Data next_index
  
get_cur_index :: MemoT Expr Expr (State RH.Rewrite_Data) MH.DAG_Index
get_cur_index = do
  cur_data <- lift get
  case RH.cur_index cur_data of
    MH.Index cur_idx -> do
      lift $ put $ RH.Rewrite_Data $ MH.Index (cur_idx + 1)
      return $ MH.Index cur_idx
    _ -> return MH.No_Index

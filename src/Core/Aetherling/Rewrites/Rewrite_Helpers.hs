module Aetherling.Rewrites.Rewrite_Helpers where
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Aetherling.Monad_Helpers
import System.IO

data Rewrite_Data = Rewrite_Data {
  cur_index :: DAG_Index
  } deriving (Show, Eq)

empty_rewrite_data = Rewrite_Data $ Index 0

get_cur_index :: (Monad m) => DAG_MemoT v (Rewrite_StateTM m) DAG_Index
get_cur_index = do
  cur_data <- lift get
  case cur_index cur_data of
    Index cur_idx -> do
      lift $ put $ Rewrite_Data $ Index (cur_idx + 1)
      return $ Index cur_idx
    _ -> return No_Index

set_next_index :: (Monad m) => DAG_Index -> DAG_MemoT v (Rewrite_StateTM m) ()
set_next_index next_index = do
  lift $ put $ Rewrite_Data next_index

update_index :: (Monad m, Indexible e) => e -> DAG_MemoT v (Rewrite_StateTM m) e
update_index e = do
  cur_idx <- get_cur_index
  return $ set_index e cur_idx

add_index :: Monad m => (a -> DAG_Index -> a) -> a -> Memo_Rewrite_StateTM a m a
add_index node_gen producer = do
  cur_idx <- get_cur_index
  return $ node_gen producer cur_idx

type Rewrite_StateTM m = ExceptT Rewrite_Failure (StateT Rewrite_Data m)
type Rewrite_StateM = ExceptT Rewrite_Failure (State Rewrite_Data)

type Memo_Rewrite_StateTM v m = DAG_MemoT v (ExceptT Rewrite_Failure (StateT Rewrite_Data m))
type Memo_Rewrite_StateM v = DAG_MemoT v (ExceptT Rewrite_Failure (State Rewrite_Data))

lift_memo_rewrite_state :: forall v m t . Monad m => m t -> Memo_Rewrite_StateTM v m t
lift_memo_rewrite_state x = lift $ lift $ lift x

type Rewrite_IO_StateM = ExceptT Rewrite_Failure IO

data Rewrite_Failure = Expr_Failure {rw_msg :: String}
                     | Type_Failure {rw_msg :: String}
                     | Value_Failure {rw_msg :: String}
                     | Input_Failure {rw_msg :: String}
                     | Module_Failure {rw_msg :: String}
                     | Latency_Failure {rw_msg :: String}
                     | Slowdown_Failure {rw_msg :: String}
                     | Magma_Failure {rw_msg :: String}
  deriving (Eq, Show)

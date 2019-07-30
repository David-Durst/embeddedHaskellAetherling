module Aetherling.Monad_Helpers where
import Control.Monad.State
import Control.Monad.Identity
import Debug.Trace
import qualified Data.Map as M

fail_message :: String -> String -> String
fail_message fName tName = fName ++ " must receive " ++ tName ++
  "not " ++ tName ++ "_Edge."

-- fail message where the function actually wants edges
fail_message_edge :: String -> String -> String
fail_message_edge fName tName = fName ++ " must receive " ++ tName ++
  "_Edge not " ++ tName ++ "."

data DAG_Index = No_Index
  | Index {rewrite :: Int, elem_index :: Int}
  deriving (Show, Eq, Ord)

class Indexible a where
  get_index :: a -> DAG_Index

type DAG_MemoT m v a = StateT (M.Map DAG_Index v) m a

memo :: (Indexible k, Show k, Monad m, Show v) => k -> DAG_MemoT m v v -> DAG_MemoT m v v
memo indexible_obj computed_result = do
  memo_map <- get
  let result_index = get_index indexible_obj
  if M.member result_index memo_map
    then return $ memo_map M.! result_index
    else do
    unwrapped_computed_result <- computed_result
    post_eval_memo_map <- get
    let new_memo_map = M.insert result_index unwrapped_computed_result post_eval_memo_map
    put new_memo_map
    return unwrapped_computed_result

startEvalMemoT :: Monad m => DAG_MemoT m v a -> m a
startEvalMemoT f = evalStateT f M.empty

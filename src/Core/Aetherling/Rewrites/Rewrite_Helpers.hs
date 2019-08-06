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

get_cur_index :: Rewrite_StateM DAG_Index
get_cur_index = do
  cur_data <- get
  case cur_index cur_data of
    Index cur_idx -> do
      put $ Rewrite_Data $ Index (cur_idx + 1)
      return $ Index cur_idx
    _ -> return No_Index
    
type Rewrite_StateM = ExceptT Rewrite_Failure (State Rewrite_Data)

type Rewrite_IO_StateM = ExceptT Rewrite_Failure IO

data Rewrite_Failure = Expr_Failure {rw_msg :: String}
                     | Type_Failure {rw_msg :: String}
                     | Value_Failure {rw_msg :: String}
                     | Input_Failure {rw_msg :: String}
                     | Module_Failure {rw_msg :: String}
                     | Slowdown_Failure {rw_msg :: String}
  deriving (Eq, Show)

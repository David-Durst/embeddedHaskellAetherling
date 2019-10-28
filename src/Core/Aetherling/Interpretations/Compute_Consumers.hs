module Aetherling.Interpretations.Compute_Consumers where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Builders
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions as ST_Conv
import Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import Aetherling.Interpretations.Space_Time_Printer
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Monad_Helpers
import Control.Monad.State as S
import Control.Monad.Identity
import Control.Monad.Except
import Data.Either
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import Debug.Trace
import Data.Map as M
import Data.List

compute_consumers :: Expr -> M.Map DAG_Index [DAG_Index]
compute_consumers st_expr_in = do
  let producers_map_maybe = evalState
                            (runExceptT $ startExecMemoT $ compute_producers' st_expr_in)
                            empty_rewrite_data
  if isLeft producers_map_maybe
    then M.empty
    else do
    let producers_map = fromRight undefined producers_map_maybe
    let consumer_producer_pairs = concatMap (\(x,ys) -> fmap (\y -> (y,x)) ys) $
                                  M.toList producers_map
    let cosumer_map =
          --fmap (\l ->   ) - need to convert list of tuples to tuple of one and list of others
          groupBy (\x y -> fst x == fst y) $
          sortBy (\x y -> compare (fst x) (fst y)) consumer_producer_pairs
    undefined
    
compute_producers' :: Expr -> Memo_Rewrite_StateM [DAG_Index] [DAG_Index]
compute_producers' consumer_e = do
  let f_e_maybe = get_f consumer_e
  mapM (\f_e -> memo f_e $ compute_producers' f_e) f_e_maybe
  let producers_e = get_producers consumer_e
  mapM (\producer_e -> memo producer_e $ compute_producers' producer_e)
    producers_e
  undefined
  {-
  --return $ consumer_e { seq_in = merged_producer }
  let consumer_e_producers_replaced =
        if length producers_e == 0
        then consumer_e
        else if length producers_e == 1
        then consumer_e { seq_in = merged_producers !! 0}
        else consumer_e {
          seq_in_left = merged_producers !! 0,
          seq_in_right = merged_producers !! 1
          }
  if isJust merged_f
    then return $ consumer_e_producers_replaced { f = fromJust merged_f }
    else return consumer_e_producers_replaced
-}

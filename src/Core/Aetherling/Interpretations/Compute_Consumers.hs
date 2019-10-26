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

compute_consumers :: Expr -> M.Map DAG_Index [DAG_Index]
compute_consumers st_expr_in = do
  let expr_par = evalState
                 (runExceptT $ startExecMemoT $ compute_consumers' st_expr_in)
                 empty_rewrite_data
  if isLeft expr_par
    then M.empty
    else fromRight undefined expr_par
    
compute_consumers' :: Expr -> Memo_Rewrite_StateM [DAG_Index] Expr
compute_consumers' = undefined
{-
compute_consumers' fifo_e@(FIFON _ fifo_delay
                                const_e@(Const_GenN _ _ const_delay _)
                                _) = do
  return $ const_e { delay = fifo_delay + const_delay }
compute_consumers' consumer_e = do
  let f_e_maybe = get_f consumer_e
  merged_f <- mapM (\f_e -> memo f_e $ compute_consumers' f_e) f_e_maybe
  let producers_e = get_producers consumer_e
  merged_producers <- mapM (\producer_e ->
                             memo producer_e $ compute_consumers' producer_e)
                     producers_e
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

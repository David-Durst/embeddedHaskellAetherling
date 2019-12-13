module Aetherling.Rewrites.Merge_Const_FIFOs where
import Aetherling.Interpretations.Compute_Latency
import Aetherling.Interpretations.Compute_Max_Idx
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
import Data.Maybe
import qualified Data.Map as M

merge_consts_and_fifos :: Expr -> Expr
merge_consts_and_fifos st_expr_in = do
  let pre_merge_max_idx = compute_max_idx st_expr_in
  let expr_par = evalState (
        evalStateT
          (runExceptT $ startEvalMemoT $ merge_consts_and_fifos' st_expr_in)
          (Rewrite_Data $ incr_DAG_index pre_merge_max_idx))
        (Merge_FIFO_State M.empty)
  if isLeft expr_par
    then ErrorN (rw_msg $ fromLeft undefined expr_par) No_Index
    else fromRight undefined expr_par

data Merge_FIFO_State = Merge_FIFO_State {
  rewritten_fifos :: M.Map (DAG_Index, Int) DAG_Index
  } deriving (Show, Eq)

merge_consts_and_fifos' :: Expr ->
                           Memo_Rewrite_StateTM Expr
                           (S.State Merge_FIFO_State) Expr
merge_consts_and_fifos' fifo_e@(FIFON _ fifo_delay
                                const_e@(Const_GenN _ _ const_delay _)
                                orig_idx) = do
  cur_state <-  lift $ lift $ lift $ get
  let rewritten_fifos_map = rewritten_fifos cur_state
  if M.member (orig_idx, fifo_delay + const_delay) rewritten_fifos_map
    then return const_e {
    delay = fifo_delay + const_delay,
    index = rewritten_fifos_map M.! (orig_idx, const_delay)
    }
    else do
    copy_idx <- get_cur_index
    let updated_fifos_map = M.insert (orig_idx, fifo_delay + const_delay)
                            copy_idx rewritten_fifos_map
    lift $ lift $ lift $ put $ Merge_FIFO_State $ updated_fifos_map
    return const_e {
          delay = fifo_delay + const_delay,
          index = copy_idx
          }
merge_consts_and_fifos' consumer_e = do
  let f_e_maybe = get_f consumer_e
  merged_f <- mapM (\f_e -> memo f_e $ merge_consts_and_fifos' f_e) f_e_maybe
  let producers_e = get_producers consumer_e
  merged_producers <- mapM (\producer_e ->
                             memo producer_e $ merge_consts_and_fifos' producer_e)
                     producers_e
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

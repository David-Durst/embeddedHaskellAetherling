module Aetherling.Rewrites.Merge_Const_FIFOs where
import Aetherling.Interpretations.Latency
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

merge_consts_and_fifos :: Expr -> Expr
merge_consts_and_fifos st_expr_in = do
  let expr_par = evalState
                 (runExceptT $ startEvalMemoT $ merge_consts_and_fifos' st_expr_in)
                 empty_rewrite_data
  if isLeft expr_par
    then ErrorN (rw_msg $ fromLeft undefined expr_par) No_Index
    else fromRight undefined expr_par
    
merge_consts_and_fifos' :: Expr -> Memo_Rewrite_StateM Expr Expr
merge_consts_and_fifos' fifo_e@(FIFON _ fifo_delay
                                const_e@(Const_GenN _ _ const_delay _)
                                _) = do
  return $ const_e { delay = fifo_delay + const_delay }
merge_consts_and_fifos' consumer_e = do
  let f_e_maybe = get_f consumer_e
  merged_f <- mapM (\f_e -> memo f_e $ merge_consts_and_fifos' f_e) f_e_maybe
  let producers_e = get_producers consumer_e
  merged_producers <- mapM (\producer_e ->
                             memo producer_e $ merge_consts_and_fifos' producer_e)
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
{-
merge_consts_and_fifos' e@(IdN _ _) = merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(AbsN producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(NotN producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(AddN producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(SubN producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(MulN producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(DivN producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(EqN t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
  
-- generators
merge_consts_and_fifos' e@(Lut_GenN lut_table lut_type producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Const_GenN constant constant_type _ cur_idx) =
  merge_consts_and_fifos_unary e

-- sequence operators
merge_consts_and_fifos' e@(Shift_sN n shift_amount elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Shift_tN n i shift_amount elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Shift_tsN no io ni shift_amount elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Up_1d_sN n elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Up_1d_tN n i elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Down_1d_sN n sel_idx elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Down_1d_tN n i sel_idx elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Partition_s_ssN no ni elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Partition_t_ttN no ni io ii elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Unpartition_s_ssN no ni elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Unpartition_t_ttN no ni io ii elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(SerializeN n i elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(DeserializeN n i elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Add_1_sN elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Add_1_0_tN elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Remove_1_sN elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e
merge_consts_and_fifos' e@(Remove_1_0_tN elem_t producer_e cur_idx) =
  merge_consts_and_fifos_unary e

-- higher order operators
merge_consts_and_fifos' e@(Map_sN n f producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  max_idx_f <- memo f $ merge_consts_and_fifos' f
  return $ max cur_idx $ max max_idx_f max_idx_producer
merge_consts_and_fifos' e@(Map_tN n i f producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  max_idx_f <- memo f $ merge_consts_and_fifos' f
  return $ max cur_idx $ max max_idx_f max_idx_producer
merge_consts_and_fifos' e@(Map2_sN n f producer0_e producer1_e cur_idx) =
  max_idx_producer0 <- memo producer0_e $ merge_consts_and_fifos' producer0_e
  max_idx_producer1 <- memo producer1_e $ merge_consts_and_fifos' producer1_e
  max_idx_f <- memo f $ merge_consts_and_fifos' f
  return $ max cur_idx $ max max_idx_f $ max max_idx_producer0 max_idx_producer1
merge_consts_and_fifos' e@(Map2_tN n i f producer0_e producer1_e cur_idx) =
  max_idx_producer0 <- memo producer0_e $ merge_consts_and_fifos' producer0_e
  max_idx_producer1 <- memo producer1_e $ merge_consts_and_fifos' producer1_e
  max_idx_f <- memo f $ merge_consts_and_fifos' f
  return $ max cur_idx $ max max_idx_f $ max max_idx_producer0 max_idx_producer1
merge_consts_and_fifos' e@(Reduce_sN n f producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  max_idx_f <- memo f $ merge_consts_and_fifos' f
  return $ max cur_idx $ max max_idx_f max_idx_producer
merge_consts_and_fifos' e@(Reduce_tN n i f producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  max_idx_f <- memo f $ merge_consts_and_fifos' f
  return $ max cur_idx $ max max_idx_f max_idx_producer

-- tuple operators
merge_consts_and_fifos' e@(FstN t0 t1 producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  return $ max cur_idx max_idx_producer
merge_consts_and_fifos' e@(SndN t0 t1 producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  return $ max cur_idx max_idx_producer
merge_consts_and_fifos' e@(ATupleN t0 t1 producer0_e producer1_e cur_idx) =
  max_idx_producer0 <- memo producer0_e $ merge_consts_and_fifos' producer0_e
  max_idx_producer1 <- memo producer1_e $ merge_consts_and_fifos' producer1_e
  return $ max cur_idx $ max max_idx_producer0 max_idx_producer1
merge_consts_and_fifos' e@(STupleN elem_t producer0_e producer1_e cur_idx) =
  max_idx_producer0 <- memo producer0_e $ merge_consts_and_fifos' producer0_e
  max_idx_producer1 <- memo producer1_e $ merge_consts_and_fifos' producer1_e
  return $ max cur_idx $ max max_idx_producer0 max_idx_producer1
merge_consts_and_fifos' e@(STupleAppendN out_len elem_t producer0_e producer1_e cur_idx) =
  max_idx_producer0 <- memo producer0_e $ merge_consts_and_fifos' producer0_e
  max_idx_producer1 <- memo producer1_e $ merge_consts_and_fifos' producer1_e
  return $ max cur_idx $ max max_idx_producer0 max_idx_producer1
  
merge_consts_and_fifos' e@(STupleToSSeqN tuple_len elem_t producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  return $ max cur_idx max_idx_producer
merge_consts_and_fifos' e@(SSeqToSTupleN tuple_len elem_t producer_e cur_idx) =
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  return $ max cur_idx max_idx_producer

merge_consts_and_fifos' (InputN t name cur_idx) = do
  return cur_idx
merge_consts_and_fifos' e@(ErrorN msg cur_idx) = do
  return cur_idx
merge_consts_and_fifos' e@(FIFON t delay_clks producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  return $ max cur_idx max_idx_producer
merge_consts_and_fifos' e@(ReshapeN in_t out_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ merge_consts_and_fifos' producer_e
  return $ max cur_idx max_idx_producer

merge_consts_and_fifos_unary consumer_e = do
  merged_producer <- memo producer_e $ merge_consts_and_fifos' (seq_in consumer_e)
  return $ consumer_e { seq_in = merged_producer }
-}

module Aetherling.Interpretations.Compute_Max_Idx where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Data.Either
import Aetherling.Monad_Helpers
import Debug.Trace

compute_max_idx :: Expr -> DAG_Index
compute_max_idx e = do
  let max_int_or_fail =
        evalState (runExceptT $ startEvalMemoT $ compute_max_idx' e)
        RH.empty_rewrite_data
  if isLeft max_int_or_fail
    then No_Index
    else fromRight No_Index max_int_or_fail
    
  
-- this handles the strings inside a module
-- the strings here are the variables in the SSA that the producer's
-- outputs were assigned to
compute_max_idx' :: Expr -> RH.Memo_Rewrite_StateM DAG_Index DAG_Index
compute_max_idx' (IdN producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(AbsN producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(NotN producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(AddN producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(SubN producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(MulN producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(DivN producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(EqN t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
  
-- generators
compute_max_idx' consumer_e@(Lut_GenN lut_table lut_type producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Const_GenN constant constant_type cur_idx) = do
  return cur_idx

-- sequence operators
compute_max_idx' consumer_e@(Shift_sN n shift_amount elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Shift_tN n i shift_amount elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Shift_tsN no io ni shift_amount elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Up_1d_sN n elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Up_1d_tN n i elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Down_1d_sN n sel_idx elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Down_1d_tN n i sel_idx elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Partition_s_ssN no ni elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Partition_t_ttN no ni io ii elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Unpartition_s_ssN no ni elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Unpartition_t_ttN no ni io ii elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(SerializeN n i elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(DeserializeN n i elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Add_1_sN elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Add_1_0_tN elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Remove_1_sN elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(Remove_1_0_tN elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer

-- higher order operators
compute_max_idx' consumer_e@(Map_sN n f producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  max_idx_f <- memo f $ compute_max_idx' f
  return $ max cur_idx $ max max_idx_f max_idx_producer
compute_max_idx' consumer_e@(Map_tN n i f producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  max_idx_f <- memo f $ compute_max_idx' f
  return $ max cur_idx $ max max_idx_f max_idx_producer
compute_max_idx' consumer_e@(Map2_sN n f producer0_e producer1_e cur_idx) = do
  max_idx_producer0 <- memo producer0_e $ compute_max_idx' producer0_e
  max_idx_producer1 <- memo producer1_e $ compute_max_idx' producer1_e
  max_idx_f <- memo f $ compute_max_idx' f
  return $ max cur_idx $ max max_idx_f $ max max_idx_producer0 max_idx_producer1
compute_max_idx' consumer_e@(Map2_tN n i f producer0_e producer1_e cur_idx) = do
  max_idx_producer0 <- memo producer0_e $ compute_max_idx' producer0_e
  max_idx_producer1 <- memo producer1_e $ compute_max_idx' producer1_e
  max_idx_f <- memo f $ compute_max_idx' f
  return $ max cur_idx $ max max_idx_f $ max max_idx_producer0 max_idx_producer1
compute_max_idx' consumer_e@(Reduce_sN n f producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  max_idx_f <- memo f $ compute_max_idx' f
  return $ max cur_idx $ max max_idx_f max_idx_producer
compute_max_idx' consumer_e@(Reduce_tN n i f producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  max_idx_f <- memo f $ compute_max_idx' f
  return $ max cur_idx $ max max_idx_f max_idx_producer

-- tuple operators
compute_max_idx' consumer_e@(FstN t0 t1 producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(SndN t0 t1 producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(ATupleN t0 t1 producer0_e producer1_e cur_idx) = do
  max_idx_producer0 <- memo producer0_e $ compute_max_idx' producer0_e
  max_idx_producer1 <- memo producer1_e $ compute_max_idx' producer1_e
  return $ max cur_idx $ max max_idx_producer0 max_idx_producer1
compute_max_idx' consumer_e@(STupleN elem_t producer0_e producer1_e cur_idx) = do
  max_idx_producer0 <- memo producer0_e $ compute_max_idx' producer0_e
  max_idx_producer1 <- memo producer1_e $ compute_max_idx' producer1_e
  return $ max cur_idx $ max max_idx_producer0 max_idx_producer1
compute_max_idx' consumer_e@(STupleAppendN out_len elem_t producer0_e producer1_e cur_idx) = do
  max_idx_producer0 <- memo producer0_e $ compute_max_idx' producer0_e
  max_idx_producer1 <- memo producer1_e $ compute_max_idx' producer1_e
  return $ max cur_idx $ max max_idx_producer0 max_idx_producer1
  
compute_max_idx' consumer_e@(STupleToSSeqN tuple_len elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(SSeqToSTupleN tuple_len elem_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer

compute_max_idx' (InputN t name cur_idx) = do
  return cur_idx
compute_max_idx' e@(ErrorN msg cur_idx) = do
  return cur_idx
compute_max_idx' consumer_e@(FIFON t delay_clks producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer
compute_max_idx' consumer_e@(ReshapeN in_t out_t producer_e cur_idx) = do
  max_idx_producer <- memo producer_e $ compute_max_idx' producer_e
  return $ max cur_idx max_idx_producer

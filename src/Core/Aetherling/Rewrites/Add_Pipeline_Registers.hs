module Aetherling.Rewrites.Add_Pipeline_Registers where
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
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import Debug.Trace

add_pipeline_registers :: Expr -> Int -> Expr
-- | Add 1 register to each input port, num_end_registers to output port
add_pipeline_registers e num_end_registers = do
  let pre_pipelined_max_idx = compute_max_idx e
  let pipelined_e = evalState
                 (runExceptT $ startEvalMemoT $
                  add_pipeline_registers' e $ Just num_end_registers)
                 (Rewrite_Data $ incr_DAG_index pre_pipelined_max_idx)
  if isLeft pipelined_e
    then (ErrorN (rw_msg $ fromLeft undefined pipelined_e) No_Index)
    else fromRight undefined pipelined_e

-- maybe int is number of end registers if expr is output or nothing otherwise
add_pipeline_registers' :: Expr -> Maybe Int -> Memo_Rewrite_StateM Expr Expr
-- ok to assume this input is a top level input as map/reduce never calls inner
-- function for this rewrite
add_pipeline_registers' e@(InputN t _ _) maybe_num_end_registers = do
  reg_idx <- get_cur_index
  add_pipeline_registers_if_last maybe_num_end_registers $
    FIFON t 1 e reg_idx
add_pipeline_registers' e@(Map2_sN _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_right_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(Map2_tN _ _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_right_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(ATupleN _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_right_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(STupleN _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_right_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(STupleAppendN _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_right_pipelined, seq_in_right = producer_right_pipelined }
-- all other expressions are unary
add_pipeline_registers' e maybe_num_end_registers = do
  let producer = seq_in e
  producer_pipelined <- memo producer $
                             add_pipeline_registers' producer Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in = producer_pipelined }

add_pipeline_registers_if_last :: Maybe Int -> Expr -> Memo_Rewrite_StateM Expr Expr
  -- | if e is the last expression and 1 or more pipeline reigsters to add,
  -- add 1 and recur
  -- otherwise return immediately as no registers to add
add_pipeline_registers_if_last Nothing e = return e
add_pipeline_registers_if_last (Just 0) e = return e
add_pipeline_registers_if_last (Just n) e = do
  reg_idx <- get_cur_index
  pipelined_n_minus_1_e <- add_pipeline_registers_if_last (Just $ n-1) e
  let t = ST_Conv.e_out_type $ ST_Conv.expr_to_types e
  return $ FIFON t 1 e reg_idx
{-
match_latencies' e@(IdN producer _) = match_combinational_op e producer
match_latencies' e@(AbsN producer _) = match_combinational_op e producer
match_latencies' e@(NotN producer _) = match_combinational_op e producer
match_latencies' e@(AddN producer _) = match_combinational_op e producer
match_latencies' e@(SubN producer _) = match_combinational_op e producer
match_latencies' e@(MulN producer _) = match_combinational_op e producer
match_latencies' e@(DivN producer _) = match_combinational_op e producer
match_latencies' e@(EqN t producer _) = match_combinational_op e producer

-- generators
match_latencies' e@(Lut_GenN _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Const_GenN _ _ _) = do
  e_new_idx <- update_index e
  return $ Matched_Latency_Result e_new_idx 0

-- sequence operators
match_latencies' e@(Shift_sN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Shift_tN _ _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Shift_tsN _ _ _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Up_1d_sN _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Up_1d_tN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Down_1d_sN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Down_1d_tN _ _ _ _ producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  return $ result_without_e_latency {
    latency = latency result_without_e_latency + cur_latency
    }
match_latencies' e@(Partition_s_ssN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Partition_t_ttN _ _ _ _ _ producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  let input_output_types = ST_Conv.expr_to_types e
  let reshape =
        ReshapeN
        (head $ ST_Conv.e_in_types input_output_types)
        (ST_Conv.e_out_type input_output_types)
        producer No_Index
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' reshape
  return $ result_without_e_latency {
    latency = latency result_without_e_latency + cur_latency
    }
match_latencies' e@(Unpartition_s_ssN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Unpartition_t_ttN _ _ _ _ _ producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  let input_output_types = ST_Conv.expr_to_types e
  let reshape =
        ReshapeN
        (head $ ST_Conv.e_in_types input_output_types)
        (ST_Conv.e_out_type input_output_types)
        producer No_Index
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' reshape
  return $ result_without_e_latency {
    latency = latency result_without_e_latency + cur_latency
    }
  
-- these helpers shouldn't exist now that i've written reshape
match_latencies' e@(SerializeN _ _ _ _ _) = undefined
match_latencies' e@(DeserializeN _ _ _ _ _) = undefined
match_latencies' e@(Add_1_sN _ _ _) = undefined
match_latencies' e@(Add_1_0_tN _ _ _) = undefined
match_latencies' e@(Remove_1_sN _ _ _) = undefined
match_latencies' e@(Remove_1_0_tN _ _ _) = undefined

-- higher order operators
match_latencies' e@(Map_sN _ f producer _) = do
  Matched_Latency_Result new_producer latency_producer <-
    memo producer $ match_latencies' producer
  update_latency_state latency_producer
  Matched_Latency_Result new_f latency_f <- memo f $ match_latencies' f
  cur_idx <- get_cur_index
  return $ Matched_Latency_Result
    (e {f = new_f, seq_in = new_producer, index = cur_idx} )
    latency_f
match_latencies' e@(Map_tN _ _ f producer _) = do
  Matched_Latency_Result new_producer latency_producer <-
    memo producer $ match_latencies' producer
  update_latency_state latency_producer
  Matched_Latency_Result new_f latency_f <- memo f $ match_latencies' f
  cur_idx <- get_cur_index
  return $ Matched_Latency_Result
    (e {f = new_f, seq_in = new_producer, index = cur_idx} )
    latency_f
match_latencies' e@(Map2_sN _ f producer_left producer_right _) = do
  match_map2 e f producer_left producer_right
match_latencies' e@(Map2_tN _ _ f producer_left producer_right _) = do
  match_map2 e f producer_left producer_right
match_latencies' e@(Reduce_sN _ f producer _) = do
  Matched_Latency_Result new_producer latency_producer <-
    memo producer $ match_latencies' producer
  cur_lat <- get_cur_latency
  update_latency_state 0
  Matched_Latency_Result new_f latency_f <- memo f $ match_latencies' f
  update_latency_state cur_lat
  reduce_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  if latency_f == 0
    then do
    cur_idx <- get_cur_index
    return $ Matched_Latency_Result
      (e {f = new_f, seq_in = new_producer, index = cur_idx} )
      (latency_producer + latency_f)
    else do
    lift_memo_rewrite_state $ lift $ print_st e
    throwError $ Latency_Failure $
         "latency for f " ++ show latency_f ++
         "inside reduce must be 0 for now "
match_latencies' e@(Reduce_tN _ _ f producer _) = do
  Matched_Latency_Result new_producer latency_producer <-
    memo producer $ match_latencies' producer
  cur_lat <- get_cur_latency
  update_latency_state 0
  Matched_Latency_Result new_f latency_f <- memo f $ match_latencies' f
  update_latency_state cur_lat
  reduce_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  if latency_f == 0
    then do
    cur_idx <- get_cur_index
    reduce_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
    return $ Matched_Latency_Result
      (e {f = new_f, seq_in = new_producer, index = cur_idx} )
      (latency_producer + reduce_latency)
    else do
    lift_memo_rewrite_state $ lift $ print_st e
    throwError $ Latency_Failure $
         "latency for f " ++ show latency_f ++
         "inside reduce must be 0 for now "

-- tuple operators
match_latencies' e@(FstN _ _ producer _) =
  match_combinational_op e producer
match_latencies' e@(SndN _ _ producer _) =
  match_combinational_op e producer
  
match_latencies' e@(ATupleN _ _ producer_left producer_right _) = do
  match_binary_op e producer_left producer_right
match_latencies' e@(STupleN _ producer_left producer_right _) = do
  match_binary_op e producer_left producer_right
match_latencies' e@(STupleAppendN _ _ producer_left producer_right _) = do
  match_binary_op e producer_left producer_right

match_latencies' e@(STupleToSSeqN _ _ producer _) = match_combinational_op e producer
match_latencies' e@(SSeqToSTupleN _ _ producer _) = match_combinational_op e producer

-- other operators
match_latencies' e@(InputN _ _ _) = do
  new_e <- update_index e
  cur_lat <- get_cur_latency
  return $ Matched_Latency_Result new_e cur_lat
match_latencies' e@(ErrorN error_msg _) = throwError $ Latency_Failure $
  "Found error node with message: " ++ error_msg
match_latencies' e@(FIFON _ _ producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  return $ result_without_e_latency {
    latency = latency result_without_e_latency + cur_latency
    }
match_latencies' e@(ReshapeN _ _ producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  return $ result_without_e_latency {
    latency = latency result_without_e_latency + cur_latency
    }

match_combinational_op :: Expr -> Expr ->
                                  Memo_Rewrite_StateTM Matched_Latency_Result Latency_StateTM Matched_Latency_Result
match_combinational_op op producer = do
  Matched_Latency_Result new_producer producer_latency <-
    memo producer $ match_latencies' producer
  op_new_idx <- update_index op
  let new_op = op_new_idx { seq_in = new_producer }
  return (Matched_Latency_Result new_op producer_latency)

match_map2 e f producer_left producer_right = do
  Matched_Latency_Result e_updated latency_producers <- match_binary_op e producer_left producer_right
  update_latency_state latency_producers
  Matched_Latency_Result new_f latency_f <- memo f $ match_latencies' f
  let e_replaced_f = e_updated {f = new_f}
  return $ Matched_Latency_Result e_replaced_f latency_f

match_binary_op e producer_left producer_right = do
  Matched_Latency_Result new_producer_left latency_producer_left <-
    memo producer_left $ match_latencies' producer_left
  Matched_Latency_Result new_producer_right latency_producer_right <-
    memo producer_right $ match_latencies' producer_right
  if latency_producer_left == latency_producer_right
    then do
    cur_idx <- get_cur_index
    return $ Matched_Latency_Result
      (e {seq_in_left = new_producer_left,
          seq_in_right = new_producer_right, index = cur_idx} )
      latency_producer_left
    else if latency_producer_left < latency_producer_right
    then do
    let producer_left_types = ST_Conv.expr_to_types producer_left
    fifo_idx <- get_cur_index
    let delayed_producer_left = FIFON
                                (ST_Conv.e_out_type producer_left_types)
                                (latency_producer_right - latency_producer_left)
                                new_producer_left
                                fifo_idx
    map2_idx <- get_cur_index
    return $ Matched_Latency_Result
      (e {seq_in_left = delayed_producer_left,
          seq_in_right = new_producer_right, index = map2_idx})
      latency_producer_right
    else do
    let producer_right_types = ST_Conv.expr_to_types producer_right
    fifo_idx <- get_cur_index
    let delayed_producer_right = FIFON
                                (ST_Conv.e_out_type producer_right_types)
                                (latency_producer_left - latency_producer_right)
                                new_producer_right
                                fifo_idx
    map2_idx <- get_cur_index
    return $ Matched_Latency_Result
      (e {seq_in_left = new_producer_left,
          seq_in_right = delayed_producer_right, index = map2_idx})
      latency_producer_left
-}

module Aetherling.Rewrites.Match_Latencies where
import Aetherling.Interpretations.Compute_Latency
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

match_latencies :: Expr -> Matched_Latency_Result 
match_latencies e = do
  let matched_latencies = evalState
                       (
                         evalStateT
                         (runExceptT $ startEvalMemoT $ match_latencies' e)
                         empty_rewrite_data
                       )
                       empty_latency_state
  if isLeft matched_latencies
    then Matched_Latency_Result
         (ErrorN (rw_msg $ fromLeft undefined matched_latencies) No_Index)
         (-1)
    else fromRight undefined matched_latencies

data Matched_Latency_Result = Matched_Latency_Result {
  new_expr :: Expr,
  latency :: Int
  } deriving (Show, Eq)

instance Ord Matched_Latency_Result where
  (Matched_Latency_Result _ l0) <= (Matched_Latency_Result _ l1) = l0 <= l1

match_latencies' :: Expr ->
                    Memo_Rewrite_StateTM Matched_Latency_Result
                    Latency_StateM Matched_Latency_Result
match_latencies' e@(IdN producer _) = match_combinational_op e producer
match_latencies' e@(AbsN _ producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 1
    }
match_latencies' e@(NotN producer _) = match_combinational_op e producer
match_latencies' e@(AndN producer _) = match_combinational_op e producer
match_latencies' e@(OrN producer _) = match_combinational_op e producer
match_latencies' e@(AddN _ producer _) = match_combinational_op e producer
match_latencies' e@(SubN _ producer _) = match_combinational_op e producer
-- mul and div latencies taken from vivado IP for xc7z020
match_latencies' e@(MulN Int32T producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 6
    }
match_latencies' e@(MulN UInt32T producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 6
    }
match_latencies' e@(MulN _ producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 3
    }
match_latencies' e@(DivN Int32T producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 6
    }
match_latencies' e@(DivN UInt32T producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 6
    }
match_latencies' e@(DivN t producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 3
    }
match_latencies' e@(LSRN _ producer _) = match_combinational_op e producer
match_latencies' e@(LSLN _ producer _) = match_combinational_op e producer
match_latencies' e@(LtN _ producer _) = match_combinational_op e producer
match_latencies' e@(EqN t producer _) = match_combinational_op e producer
match_latencies' e@(IfN t producer _) = match_combinational_op e producer

-- generators
match_latencies' e@(Lut_GenN _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Const_GenN _ _ delay _) = do
  e_new_idx <- update_index e
  return $ Matched_Latency_Result e_new_idx delay

-- sequence operators
match_latencies' e@(Shift_sN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Shift_tN _ _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Shift_tsN _ _ _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Shift_ttN _ _ _ _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Shift_tnN _ _ _ _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Up_1d_sN _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Up_1d_tN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Down_1d_sN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Down_1d_tN _ _ sel_idx t producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  let cur_latency = compute_down_latency sel_idx t
  return $ result_without_e_latency {
    latency = latency result_without_e_latency + cur_latency
    }
match_latencies' e@(Partition_s_ssN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Partition_t_ttN _ _ _ _ _ producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  let input_output_types = ST_Conv.expr_to_types e
  let in_t = (head $ ST_Conv.e_in_types input_output_types)
  let out_t = (ST_Conv.e_out_type input_output_types)
  return $ result_without_e_latency {
    latency = latency result_without_e_latency +
              compute_reshape_latency in_t out_t
    }
match_latencies' e@(Unpartition_s_ssN _ _ _ producer _) = match_combinational_op e producer
match_latencies' e@(Unpartition_t_ttN _ _ _ _ _ producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  let input_output_types = ST_Conv.expr_to_types e
  let in_t = (head $ ST_Conv.e_in_types input_output_types)
  let out_t = (ST_Conv.e_out_type input_output_types)
  return $ result_without_e_latency {
    latency = latency result_without_e_latency +
              compute_reshape_latency in_t out_t
    }
  
-- these helpers shouldn't exist now that i've written reshape
match_latencies' e@(SerializeN _ _ _ producer _) = do
  this_comb_latency <- match_combinational_op e producer
  return $ this_comb_latency {
    latency = latency this_comb_latency + 1
    }
match_latencies' e@(DeserializeN _ _ _ _ _) = undefined
match_latencies' e@(Add_1_sN f producer _) = match_map e f producer
match_latencies' e@(Add_1_0_tN f producer _) = match_map e f producer
match_latencies' e@(Remove_1_sN f producer _) = match_map e f producer
match_latencies' e@(Remove_1_0_tN f producer _) = match_map e f producer

-- higher order operators
match_latencies' e@(Map_sN _ f producer _) = match_map e f producer
match_latencies' e@(Map_tN _ _ f producer _) = match_map e f producer
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
  if latency_f == 0
    then do
    cur_idx <- get_cur_index
    return $ Matched_Latency_Result
      (e {f = new_f, seq_in = new_producer, index = cur_idx} )
      (latency_producer + latency_f + 1)
    else do
    print_stM e
    throwError $ Latency_Failure $
         "latency for f " ++ show latency_f ++
         "inside reduce must be 0 for now "
match_latencies' e@(Reduce_tN n _ f producer _) = do
  Matched_Latency_Result new_producer latency_producer <-
    memo producer $ match_latencies' producer
  cur_lat <- get_cur_latency
  update_latency_state 0
  Matched_Latency_Result new_f latency_f <- memo f $ match_latencies' f
  update_latency_state cur_lat
  let reduce_latency = compute_reduce_latency n f
  if latency_f == 0
    then do
    cur_idx <- get_cur_index
    return $ Matched_Latency_Result
      (e {f = new_f, seq_in = new_producer, index = cur_idx} )
      (latency_producer + reduce_latency)
    else do
    print_stM e
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
match_latencies' e@(FIFON _ delay_clks producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  return $ result_without_e_latency {
    latency = latency result_without_e_latency + delay_clks
    }
match_latencies' e@(ReshapeN in_t out_t producer _) = do
  result_without_e_latency <- match_combinational_op e producer
  return $ result_without_e_latency {
    latency = latency result_without_e_latency +
              compute_reshape_latency in_t out_t
    }

match_combinational_op :: Expr -> Expr ->
                                  Memo_Rewrite_StateTM Matched_Latency_Result
                                  Latency_StateM Matched_Latency_Result
match_combinational_op op producer = do
  Matched_Latency_Result new_producer producer_latency <-
    memo producer $ match_latencies' producer
  op_new_idx <- update_index op
  let new_op = op_new_idx { seq_in = new_producer }
  return (Matched_Latency_Result new_op producer_latency)

match_map e f producer = do
  Matched_Latency_Result new_producer latency_producer <-
    memo producer $ match_latencies' producer
  update_latency_state latency_producer
  Matched_Latency_Result new_f latency_f <- memo f $ match_latencies' f
  cur_idx <- get_cur_index
  return $ Matched_Latency_Result
    (e {f = new_f, seq_in = new_producer, index = cur_idx} )
    latency_f

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

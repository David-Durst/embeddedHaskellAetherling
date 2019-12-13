module Aetherling.Interpretations.Latency where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Builders
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions as ST_Conv
import Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import Aetherling.Interpretations.Space_Time_Printer
import Aetherling.Functional_Models.Reshape
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Monad_Helpers
import Control.Monad.State as S
import Control.Monad.Identity
import Control.Monad.Except
import Data.Either
import qualified Safe as Safe
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import Debug.Trace
import Data.Map as M

-- | Return true if all latencies match when merging two paths
check_latency :: Expr -> Bool
check_latency e = do
  let computed_latency = evalState
                      (
                        evalStateT
                        (runExceptT $ startEvalMemoT $ compute_latency e)
                        empty_rewrite_data
                      )
                      empty_latency_state
  isRight computed_latency
  
get_ops_latencies :: Expr -> (M.Map DAG_Index Int)
get_ops_latencies e = do
  let computed_latencies = evalState
                      (
                        evalStateT
                        (runExceptT $ startExecMemoT $ compute_latency e)
                        empty_rewrite_data
                      )
                      empty_latency_state
  fromRight M.empty computed_latencies
  
print_latency :: Expr -> Int
print_latency e = do
  let computed_latency = evalState
                      (
                        evalStateT
                        (runExceptT $ startEvalMemoT $ compute_latency e)
                        empty_rewrite_data
                      )
                      empty_latency_state
  fromRight undefined computed_latency

-- need to track cur_latency so that map inputs can check they latency of input
-- to outer map
type Latency_StateM = State Latency_State

data Latency_State = Latency_State {
  cur_latency :: Int
  } deriving (Show, Eq, Ord)

empty_latency_state = Latency_State 0

update_latency_state :: Int -> Memo_Rewrite_StateTM v Latency_StateM ()
update_latency_state new_latency = do
  lift_memo_rewrite_state $ put $ Latency_State new_latency

get_cur_latency :: Memo_Rewrite_StateTM v Latency_StateM Int
get_cur_latency = do
  latency_state <- lift_memo_rewrite_state $ get
  return $ cur_latency latency_state

compute_latency :: Expr -> Memo_Rewrite_StateTM Int Latency_StateM Int
compute_latency e@(IdN producer _) = memo producer $ compute_latency producer
compute_latency e@(AbsN producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  return $ producer_latency + 1
compute_latency e@(NotN producer _) = memo producer $ compute_latency producer
compute_latency e@(AddN producer _) = memo producer $ compute_latency producer
compute_latency e@(SubN producer _) = memo producer $ compute_latency producer
compute_latency e@(MulN producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  return $ producer_latency + 2
compute_latency e@(DivN producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  return $ producer_latency + 1
compute_latency e@(LSRN producer _) = memo producer $ compute_latency producer
compute_latency e@(LSLN producer _) = memo producer $ compute_latency producer
compute_latency e@(LtN producer _) = memo producer $ compute_latency producer
compute_latency e@(EqN t producer _) = memo producer $ compute_latency producer
compute_latency e@(IfN t producer _) = memo producer $ compute_latency producer

-- generators
compute_latency e@(Lut_GenN _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Const_GenN _ _ delay _) = return delay

-- sequence operators
compute_latency e@(Shift_sN _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Shift_tN _ _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Shift_tsN _ _ _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Shift_ttN _ _ _ _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Shift_tnN _ _ _ _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Up_1d_sN _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Up_1d_tN _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Down_1d_sN _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Down_1d_tN _ _ _ _ producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  cur_latency <- lift_memo_rewrite_state $ lift $ return $ compute_latency' e
  return $ producer_latency + cur_latency
compute_latency e@(Partition_s_ssN _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Partition_t_ttN _ _ _ _ _ producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  let input_output_types = ST_Conv.expr_to_types e
  let reshape =
        ReshapeN
        (head $ ST_Conv.e_in_types input_output_types)
        (ST_Conv.e_out_type input_output_types)
        producer No_Index
  cur_latency <- lift_memo_rewrite_state $ lift $ return $ compute_latency' reshape
  return $ producer_latency + cur_latency
compute_latency e@(Unpartition_s_ssN _ _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(Unpartition_t_ttN _ _ _ _ _ producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  let input_output_types = ST_Conv.expr_to_types e
  let reshape =
        ReshapeN
        (head $ ST_Conv.e_in_types input_output_types)
        (ST_Conv.e_out_type input_output_types)
        producer No_Index
  cur_latency <- lift_memo_rewrite_state $ lift $ return $ compute_latency' reshape
  return $ producer_latency + cur_latency
  
-- these helpers shouldn't exist now that i've written reshape
compute_latency e@(SerializeN _ _ _ producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  return $ producer_latency + 1
compute_latency e@(DeserializeN _ _ _ _ _) = undefined
compute_latency e@(Add_1_sN f producer _) = compute_latency_map e f producer
compute_latency e@(Add_1_0_tN f producer _) = compute_latency_map e f producer
compute_latency e@(Remove_1_sN f producer _) = compute_latency_map e f producer
compute_latency e@(Remove_1_0_tN f producer _) = compute_latency_map e f producer

-- higher order operators
compute_latency e@(Map_sN _ f producer _) = compute_latency_map e f producer
compute_latency e@(Map_tN _ _ f producer _) = compute_latency_map e f producer 
compute_latency e@(Map2_sN _ f producer_left producer_right _) = do
  producer_left_latency <- memo producer_left $ compute_latency producer_left
  producer_right_latency <- memo producer_right $ compute_latency producer_right
  update_latency_state producer_left_latency
  inner_latency <- memo f $ compute_latency f
  if producer_left_latency == producer_right_latency
    then return $ inner_latency
    else do
    lift_memo_rewrite_state $ lift $ return $ print_st e
    throwError $ Latency_Failure $ "For Map2_sN" ++
         "latency for producer_left " ++ show producer_left_latency ++
         "doesn't equal latency for producer_left " ++ show producer_right_latency
compute_latency e@(Map2_tN _ _ f producer_left producer_right _) = do
  producer_left_latency <- memo producer_left $ compute_latency producer_left
  producer_right_latency <- memo producer_right $ compute_latency producer_right
  update_latency_state producer_left_latency
  inner_latency <- memo f $ compute_latency f
  if producer_left_latency == producer_right_latency
    then return $ inner_latency
    else do
    lift_memo_rewrite_state $ lift $ return $ print_st e
    throwError $ Latency_Failure $ "For Map2_tN" ++
         "latency for producer_left " ++ show producer_left_latency ++
         "doesn't equal latency for producer_left " ++ show producer_right_latency
compute_latency e@(Reduce_sN _ f producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  cur_lat <- get_cur_latency
  update_latency_state 0
  inner_latency <- compute_latency f
  update_latency_state cur_lat
  if inner_latency == 0
    then return $ producer_latency + 1
    else do
    lift_memo_rewrite_state $ lift $ return $ print_st e
    throwError $ Latency_Failure $
         "latency for f " ++ show inner_latency ++
         "inside reduce must be 0 for now "
compute_latency e@(Reduce_tN _ _ f producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  reduce_latency <- lift_memo_rewrite_state $ lift $ return $ compute_latency' e
  cur_lat <- get_cur_latency
  update_latency_state 0
  inner_latency <- compute_latency f
  update_latency_state cur_lat
  if inner_latency == 0
    then return $ producer_latency + reduce_latency
    else do
    lift_memo_rewrite_state $ lift $ return $ print_st e
    throwError $ Latency_Failure $
         "latency for f " ++ show inner_latency ++
         "inside reduce must be 0 for now "

-- tuple operators
compute_latency e@(FstN _ _ producer _) =
  memo producer $ compute_latency producer
compute_latency e@(SndN _ _ producer _) =
  memo producer $ compute_latency producer
compute_latency e@(ATupleN _ _ producer_left producer_right _) = do
  producer_left_latency <- memo producer_left $ compute_latency producer_left
  producer_right_latency <- memo producer_right $ compute_latency producer_right
  if producer_left_latency == producer_right_latency
    then return $ producer_left_latency 
    else do
    lift_memo_rewrite_state $ lift $ return $ print_st e
    throwError $ Latency_Failure $ "For ATupleN " ++
         "latency for producer_left " ++ show producer_left_latency ++
         "doesn't equal latency for producer_left " ++ show producer_right_latency
compute_latency e@(STupleN _ producer_left producer_right _) = do
  producer_left_latency <- memo producer_left $ compute_latency producer_left
  producer_right_latency <- memo producer_right $ compute_latency producer_right
  if producer_left_latency == producer_right_latency
    then return $ producer_left_latency
    else do
    lift_memo_rewrite_state $ lift $ return $ print_st e
    throwError $ Latency_Failure $ "For STupleN " ++
         "latency for producer_left " ++ show producer_left_latency ++
         "doesn't equal latency for producer_left " ++ show producer_right_latency
compute_latency e@(STupleAppendN _ _ producer_left producer_right _) = do
  producer_left_latency <- memo producer_left $ compute_latency producer_left
  producer_right_latency <- memo producer_right $ compute_latency producer_right
  if producer_left_latency == producer_right_latency
    then return $ producer_left_latency
    else do
    lift_memo_rewrite_state $ lift $ return $ print_st e
    throwError $ Latency_Failure $ "For STupleN " ++
         "latency for producer_left " ++ show producer_left_latency ++
         "doesn't equal latency for producer_left " ++ show producer_right_latency
compute_latency e@(STupleToSSeqN _ _ producer _) = memo producer $ compute_latency producer
compute_latency e@(SSeqToSTupleN _ _ producer _) = memo producer $ compute_latency producer

-- other operators
compute_latency e@(InputN _ _ _) = do
  get_cur_latency
compute_latency e@(ErrorN error_msg _) = throwError $ Latency_Failure $
  "Found error node with message: " ++ error_msg
compute_latency e@(FIFON _ _ producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  cur_latency <- lift_memo_rewrite_state $ lift $ return $ compute_latency' e
  return $ producer_latency + cur_latency
compute_latency e@(ReshapeN _ _ producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  cur_latency <- lift_memo_rewrite_state $ lift $ return $ compute_latency' e
  return $ producer_latency + cur_latency

compute_latency_map e f producer = do
  producer_latency <- memo producer $ compute_latency producer
  update_latency_state producer_latency
  inner_latency <- compute_latency f
  return $ inner_latency

compute_latency' :: Expr -> Int
compute_latency' (Down_1d_tN _ _ sel_idx t _ _) =
  sel_idx * clocks_t t
compute_latency' (Reduce_tN n _ f _ _) = do
  let f_out_type = ST_Conv.e_out_type $ ST_Conv.expr_to_types f
  (n - 1) * (clocks_t f_out_type) + 1
compute_latency' (FIFON _ delay_clks _ _) = delay_clks
compute_latency' (ReshapeN in_t out_t _ _) = do
  let in_t_norm = normalize_type in_t
  let out_t_norm = normalize_type out_t
  let in_out_diff = diff_types in_t_norm out_t_norm
  case in_out_diff of
    Just _ -> do
      let flat_idx_to_in_locations = M.toAscList $ compute_element_locations in_t
      let flat_idx_to_out_locations = M.toAscList $ compute_element_locations out_t
      let get_times = Prelude.map (\(_, location) -> time $ port_and_time location)
      let out_in_times = zip (get_times flat_idx_to_out_locations)
                         (get_times flat_idx_to_in_locations)
      -- add 1 as 1 clock delay from reading/writing to memories
      1 + (maximum $ Prelude.map (\(x,y) -> x-y) out_in_times) 
    _ -> 0
  where
    get_last_out_for_in :: AST_Type -> AST_Type -> Int
    get_last_out_for_in _ _ = undefined
compute_latency' _ = 0

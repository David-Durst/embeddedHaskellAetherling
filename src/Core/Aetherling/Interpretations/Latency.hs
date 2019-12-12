module Aetherling.Interpretations.Latency where
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
import qualified Safe as Safe
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import Debug.Trace
import Data.Map as M

-- | Return true if all latencies match when merging two paths
check_latency :: Expr -> IO Bool
check_latency e = do
  computed_latency <- evalStateT
                      (
                        evalStateT
                        (runExceptT $ startEvalMemoT $ compute_latency e)
                        empty_rewrite_data
                      )
                      empty_latency_state
  if isLeft computed_latency
    then putStrLn $ show $ fromLeft undefined computed_latency
    else return ()
  return $ isRight computed_latency
  
get_ops_latencies :: Expr -> IO (M.Map DAG_Index Int)
get_ops_latencies e = do
  computed_latencies <- evalStateT
                      (
                        evalStateT
                        (runExceptT $ startExecMemoT $ compute_latency e)
                        empty_rewrite_data
                      )
                      empty_latency_state
  if isLeft computed_latencies
    then putStrLn $ show $ fromLeft undefined computed_latencies
    else return ()
  return $ fromRight M.empty computed_latencies
  
print_latency :: Expr -> IO Int
print_latency e = do
  computed_latency <- evalStateT
                      (
                        evalStateT
                        (runExceptT $ startEvalMemoT $ compute_latency e)
                        empty_rewrite_data
                      )
                      empty_latency_state
  return $ fromRight undefined computed_latency

-- need to track cur_latency so that map inputs can check they latency of input
-- to outer map
type Latency_StateTM = StateT Latency_State IO

data Latency_State = Latency_State {
  cur_latency :: Int
  } deriving (Show, Eq, Ord)

empty_latency_state = Latency_State 0

update_latency_state :: Int -> Memo_Rewrite_StateTM v Latency_StateTM ()
update_latency_state new_latency = do
  lift_memo_rewrite_state $ put $ Latency_State new_latency

get_cur_latency :: Memo_Rewrite_StateTM v Latency_StateTM Int
get_cur_latency = do
  latency_state <- lift_memo_rewrite_state $ get
  return $ cur_latency latency_state

compute_latency :: Expr -> Memo_Rewrite_StateTM Int Latency_StateTM Int
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
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
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
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' reshape
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
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' reshape
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
    lift_memo_rewrite_state $ lift $ print_st e
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
    lift_memo_rewrite_state $ lift $ print_st e
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
    lift_memo_rewrite_state $ lift $ print_st e
    throwError $ Latency_Failure $
         "latency for f " ++ show inner_latency ++
         "inside reduce must be 0 for now "
compute_latency e@(Reduce_tN _ _ f producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  reduce_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  cur_lat <- get_cur_latency
  update_latency_state 0
  inner_latency <- compute_latency f
  update_latency_state cur_lat
  if inner_latency == 0
    then return $ producer_latency + reduce_latency
    else do
    lift_memo_rewrite_state $ lift $ print_st e
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
    lift_memo_rewrite_state $ lift $ print_st e
    throwError $ Latency_Failure $ "For ATupleN " ++
         "latency for producer_left " ++ show producer_left_latency ++
         "doesn't equal latency for producer_left " ++ show producer_right_latency
compute_latency e@(STupleN _ producer_left producer_right _) = do
  producer_left_latency <- memo producer_left $ compute_latency producer_left
  producer_right_latency <- memo producer_right $ compute_latency producer_right
  if producer_left_latency == producer_right_latency
    then return $ producer_left_latency
    else do
    lift_memo_rewrite_state $ lift $ print_st e
    throwError $ Latency_Failure $ "For STupleN " ++
         "latency for producer_left " ++ show producer_left_latency ++
         "doesn't equal latency for producer_left " ++ show producer_right_latency
compute_latency e@(STupleAppendN _ _ producer_left producer_right _) = do
  producer_left_latency <- memo producer_left $ compute_latency producer_left
  producer_right_latency <- memo producer_right $ compute_latency producer_right
  if producer_left_latency == producer_right_latency
    then return $ producer_left_latency
    else do
    lift_memo_rewrite_state $ lift $ print_st e
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
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  return $ producer_latency + cur_latency
compute_latency e@(ReshapeN _ _ producer _) = do
  producer_latency <- memo producer $ compute_latency producer
  cur_latency <- lift_memo_rewrite_state $ lift $ compute_latency' e
  return $ producer_latency + cur_latency

compute_latency_map e f producer = do
  producer_latency <- memo producer $ compute_latency producer
  update_latency_state producer_latency
  inner_latency <- compute_latency f
  return $ inner_latency

compute_latency' :: Expr -> IO Int
compute_latency' (Down_1d_tN _ _ sel_idx t _ _) =
  return $ sel_idx * clocks_t t
compute_latency' (Reduce_tN n _ f _ _) = do
  let f_out_type = ST_Conv.e_out_type $ ST_Conv.expr_to_types f
  return $ (n - 1) * (clocks_t f_out_type) + 1
compute_latency' (FIFON _ delay_clks _ _) = return $ delay_clks
compute_latency' (ReshapeN in_t out_t _ _) = do
  let in_t_norm = normalize_type in_t
  let out_t_norm = normalize_type out_t
  let in_out_diff = diff_types in_t_norm out_t_norm
  return $ case in_out_diff of
    Just _ -> get_last_out_for_in in_t out_t
    _ -> 0
  where
    get_last_out_for_in :: AST_Type -> AST_Type -> Int
    get_last_out_for_in _ _ = undefined
compute_latency' _ = return 0

data Port_And_Time = PT {port :: Int, time :: Int} deriving (Show, Eq)
data ST_Element_Locations = ST_Element_Locations {
  st_coordinates :: [Int],
  port_and_time :: Port_And_Time
  } deriving (Show, Eq)

type Flat_Idxs_To_Locations = M.Map Int ST_Element_Locations

data Flat_Idx_State = Flat_Idx_State {
  next_flat_idx :: Int,
  idx_to_loc :: Flat_Idxs_To_Locations
  } deriving (Show, Eq)

empty_flat_idx_state = Flat_Idx_State 0 M.empty

type Flat_Idx_StateM = S.State Flat_Idx_State

update_flat_idx_state :: ST_Element_Locations -> Flat_Idx_StateM ()
update_flat_idx_state el_locs = do
  cur_state <- get
  let cur_idx = next_flat_idx cur_state
  put $ cur_state {
    next_flat_idx = cur_idx + 1,
    idx_to_loc = M.insert cur_idx el_locs (idx_to_loc cur_state)
    }

compute_element_locations :: AST_Type -> Flat_Idxs_To_Locations
compute_element_locations t = evalState (compute_element_locations' t)
                              empty_flat_idx_state

compute_element_locations' :: AST_Type -> Flat_Idx_StateM Flat_Idxs_To_Locations
compute_element_locations' UnitT = do
  undefined

data TS_Elem = T_Elem Int Int | S_Elem Int deriving (Show, Eq)

compute_el_locations :: [TS_Elem] -> Flat_Idxs_To_Locations
compute_el_locations ts_elem_xs = do
  let num_el = get_num_els ts_elem_xs
  -- drop the top t or s type as multiplying each index by inner types
  let ts_elem_tl = Prelude.drop 1 ts_elem_xs
  let divisors = get_divisors_for_els ts_elem_tl
  let nested_indices =
        Prelude.map (compute_nested_indices divisors) [0..num_el - 1]
  let multipliers = get_multipliers_for_els ts_elem_xs
  M.fromAscList $
    Prelude.map (compute_port_and_time multipliers ts_elem_xs) nested_indices

get_num_els :: [TS_Elem] -> Int
get_num_els [] = 1
get_num_els (T_Elem n _ : tl) = n * get_num_els tl
get_num_els (S_Elem n : tl) = n * get_num_els tl

-- divisors indicate how to compute index for each dimension from flat_idx
get_divisors_for_els :: [TS_Elem] -> [Int]
get_divisors_for_els [] = []
get_divisors_for_els (T_Elem n _ : tl) = n * Safe.headDef 1 inner : inner
  where
    inner = get_divisors_for_els tl
get_divisors_for_els (S_Elem n : tl) = n * Safe.headDef 1 inner : inner
  where
    inner = get_divisors_for_els tl

compute_nested_indices :: [Int] -> Int -> [Int]
compute_nested_indices [] flat_idx = [flat_idx]
compute_nested_indices (hd_divisor : tl_divisors) flat_idx =
  flat_idx `div` hd_divisor :
  compute_nested_indices tl_divisors (flat_idx `mod` hd_divisor)

-- multipliers indicate how to compute space and time coordinates from nested
-- indices
data ST_Multiplier = ST_Multiplier {s_multiplier :: Int, t_multiplier :: Int}
  deriving (Show, Eq)

get_multipliers_for_els :: [TS_Elem] -> [ST_Multiplier]
get_multipliers_for_els [] = []
get_multipliers_for_els (T_Elem n i : tl) = do
  let inner = get_multipliers_for_els tl
  let prior_mul = Safe.headDef (ST_Multiplier 1 1) inner
  let t_mul = (n+i) * t_multiplier prior_mul
  prior_mul { t_multiplier = t_mul } : inner
get_multipliers_for_els (S_Elem n : tl) = do
  let inner = get_multipliers_for_els tl
  let prior_mul = Safe.headDef (ST_Multiplier 1 1) inner
  let t_mul = n * t_multiplier prior_mul
  prior_mul { t_multiplier = t_mul } : inner

compute_port_and_time :: [ST_Multiplier] -> [TS_Elem] -> [Int] -> Port_And_Time
compute_port_and_time [] [] [] = PT 0 0
compute_port_and_time (ST_Multiplier _ t_mul : mul_tl) (T_Elem _ _ : ts_tl)
  (nested_idx_hd : nested_idx_tl) = do
  let inner_pt = compute_port_and_time mul_tl ts_tl nested_idx_tl
  inner_pt {
    time = t_mul * nested_idx_hd + time inner_pt
    }
compute_port_and_time (ST_Multiplier s_mul _ : mul_tl) (S_Elem _ : ts_tl)
  (nested_idx_hd : nested_idx_tl) = do
  let inner_pt = compute_port_and_time mul_tl ts_tl nested_idx_tl
  inner_pt {
    port = s_mul * nested_idx_hd + port inner_pt
    }
compute_port_and_time _ _ _ =
  error "can't compute port and time, different input arg lengths"
  

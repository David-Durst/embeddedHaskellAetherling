module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr where
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Factors
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Monad_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import qualified Aetherling.Interpretations.Sequence_Printer as Seq_Print
import qualified Aetherling.Interpretations.Space_Time_Printer as ST_Print
import qualified Aetherling.Interpretations.Compute_Area as Comp_Area
import qualified Aetherling.Interpretations.Has_Error as Has_Error
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import qualified Aetherling.Languages.Space_Time.Deep.Expr_Builders as STB
import qualified Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions as ST_Conv
import Aetherling.Languages.Sequence.Shallow.Expr_Type_Conversions
import Control.Monad.Except
import Control.Monad.Identity
import Control.Monad.State
import Data.Maybe
import Data.Either
import qualified Data.List as L
import Data.List.Split (chunksOf)
import qualified Data.Set as S
import qualified Data.Map as M
import Debug.Trace
import Data.Time
import System.IO.Unsafe
import Control.DeepSeq
import GHC.Generics (Generic)
{-
rewrite_to_partially_parallel_old :: Int -> SeqE.Expr -> STE.Expr
rewrite_to_partially_parallel_old s seq_expr = do
  let (expr_par, state) = runState (evalStateT
                             (runExceptT $ rewrite_to_partially_parallel' s seq_expr)
                             empty_rewrite_data)
                 empty_ppar_state
  --trace ("num_calls : " ++ (show $ num_calls state)) $
  if isLeft expr_par
    then STE.ErrorN (rw_msg $ fromLeft undefined expr_par) No_Index
    else do
    let result = fromRight undefined expr_par
    let output_time = STT.clocks_t $ ST_Conv.e_out_type $ ST_Conv.expr_to_types result
    if output_time == s
      then result
      else STE.ErrorN ("slowdown doesn't match result" ++ ST_Print.print_st_str result) No_Index

rewrite_to_partially_parallel' :: Int -> SeqE.Expr -> Partially_ParallelM STE.Expr
rewrite_to_partially_parallel' s seq_expr = do
  let seq_expr_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types seq_expr
  --traceShowM $ rewrite_AST_type_debug s seq_expr_out_type
  output_type_slowdowns <- rewrite_AST_type s seq_expr_out_type
  --traceM ("output type slowdown" ++ show output_type_slowdowns ++ "\n s" ++ show s ++ "\n seq_expr_out_type" ++ show seq_expr_out_type ++ "\n")
  startEvalMemoT $ sequence_to_partially_parallel output_type_slowdowns seq_expr
-} 
rewrite_to_partially_parallel_type_rewrite :: [Type_Rewrite] -> SeqE.Expr -> STE.Expr
rewrite_to_partially_parallel_type_rewrite tr seq_expr = do
  let (expr_par, state) = runState (evalStateT
                             (runExceptT $ rewrite_to_partially_parallel_type_rewrite' tr seq_expr)
                             empty_rewrite_data)
                 empty_ppar_state
  --trace ("num_calls : " ++ (show $ num_calls state)) $
  if isLeft expr_par
    then STE.ErrorN (rw_msg $ fromLeft undefined expr_par) No_Index
    else do
    let result = fromRight undefined expr_par
    let output_time = STT.clocks_t $ ST_Conv.e_out_type $ ST_Conv.expr_to_types result
    if output_time == product_tr_periods tr
      then result
      else STE.ErrorN ("\noutput_time: " ++ show output_time ++
                       "\ntype_rewrites: " ++ show tr ++
                       "\nslowdown doesn't match result" ++ ST_Print.print_st_str result) No_Index

rewrite_to_partially_parallel_type_rewrite' :: [Type_Rewrite] -> SeqE.Expr -> Partially_ParallelM STE.Expr
rewrite_to_partially_parallel_type_rewrite' tr seq_expr = do
  --traceShowM $ rewrite_AST_type_debug s seq_expr_out_type
  --traceM ("output type slowdown" ++ show output_type_slowdowns ++ "\n s" ++ show s ++ "\n seq_expr_out_type" ++ show seq_expr_out_type ++ "\n")
  startEvalMemoT $ sequence_to_partially_parallel tr seq_expr

data Program_And_Area = PA { program :: !STE.Expr, area :: !Int }
  deriving (Show, Eq, Generic, NFData)
rewrite_to_partially_parallel_slowdown :: Int -> SeqE.Expr -> [Program_And_Area]
rewrite_to_partially_parallel_slowdown s seq_expr = do
  let seq_expr_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types seq_expr
  let possible_output_types = rewrite_all_AST_types s seq_expr_out_type
  let possible_st_programs =
        map (\trs -> rewrite_to_partially_parallel_type_rewrite trs seq_expr)
        possible_output_types
  let valid_possible_st_programs =
        filter (not . Has_Error.has_error) possible_st_programs
  map (\p -> PA p (Comp_Area.get_area p)) valid_possible_st_programs

-- | Helper function to get the ST expr with the min area of those generated
-- by rewrite_to_partially_parallel_slowdown
get_expr_with_min_area :: Int -> SeqE.Expr -> [Program_And_Area] -> STE.Expr
get_expr_with_min_area s seq_expr possible_st_programs_and_areas = 
  if length possible_st_programs_and_areas == 0
    then STE.ErrorN ("No possible rewrites for slowdown " ++ show s ++
                     " of program \n" ++
                     Seq_Print.print_seq_str seq_expr) No_Index
    else program $
         L.minimumBy (\pa pb -> compare (area pa) (area pb))
         possible_st_programs_and_areas
         
rewrite_to_partially_parallel_slowdown_min_area_program :: Int -> SeqE.Expr -> STE.Expr
rewrite_to_partially_parallel_slowdown_min_area_program s seq_expr = do
  let seq_expr_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types seq_expr
  let possible_output_types = rewrite_all_AST_types s seq_expr_out_type
  if null possible_output_types
    then STE.ErrorN ("No possible rewrites for slowdown " ++ show s ++
                     " of program \n" ++
                     Seq_Print.print_seq_str seq_expr) No_Index
    else do
    --let first_out_tr = traceShow possible_output_types $ head possible_output_types
    let first_out_tr = head possible_output_types
    let first_st_expr = rewrite_to_partially_parallel_type_rewrite first_out_tr
                        seq_expr
    let other_trs = tail possible_output_types
    let x = L.foldl' (\(PA min_st_expr min_st_area, !min_tr) next_tr -> do
                   let next_st_expr = rewrite_to_partially_parallel_type_rewrite
                                      next_tr seq_expr
                   let next_st_area = Comp_Area.get_area next_st_expr
                   let min_st_out_type = ST_Conv.e_out_type $
                                         ST_Conv.expr_to_types min_st_expr
                   let next_st_out_type = ST_Conv.e_out_type $
                                          ST_Conv.expr_to_types next_st_expr
                   force $ if Has_Error.has_error min_st_expr ||
                              (next_st_area < min_st_area &&
                               (not $ Has_Error.has_error next_st_expr)) ||
                              -- if they produce same program but one has
                              -- simpler type, take that one
                              (next_st_area == min_st_area &&
                               (not $ Has_Error.has_error next_st_expr) && 
                               (not $ Has_Error.has_error min_st_expr) &&
                               (STT.num_layers_t next_st_out_type < STT.num_layers_t min_st_out_type)
                              )
                     then (PA next_st_expr next_st_area, next_tr)
                     else (PA min_st_expr min_st_area, min_tr)
               ) (PA first_st_expr (Comp_Area.get_area first_st_expr), first_out_tr) other_trs
    --traceShow ("resulting area" ++ show (area x)) $ program x
    --traceShow ("possible output types" ++ show possible_output_types) $ program x
    --traceShow ("min type rewrite" ++ show (snd x) ) $ program $ fst x
    program $ fst x
 {-
                   force $ traceShow ("min_st_out_type " ++ show min_st_out_type ++ " min area " ++ show min_st_area ++ " min error " ++ (show $ Has_Error.has_error min_st_expr) ++ (" min layers " ++ (show $ STT.num_layers_t min_st_out_type))) $ traceShow ("next_st_out_type " ++ show next_st_out_type ++ " next_area " ++ show next_st_area ++ " next error " ++ (show $ Has_Error.has_error next_st_expr) ++ (" next layers " ++ (show $ STT.num_layers_t next_st_out_type))) $ if Has_Error.has_error min_st_expr ||

rewrite_to_partially_parallel_search' :: Int -> SeqE.Expr -> Partially_ParallelM STE.Expr
rewrite_to_partially_parallel_search' s seq_expr = do
  --traceShowM $ rewrite_AST_type_debug s seq_expr_out_type
  --traceM ("output type slowdown" ++ show output_type_slowdowns ++ "\n s" ++ show s ++ "\n seq_expr_out_type" ++ show seq_expr_out_type ++ "\n")
  let possible_programs = map
                          (\output_type -> startEvalMemoT $
                                           sequence_to_partially_parallel output_type seq_expr)
                          output_type_slowdowns
-} 
  
data Input_Type_Rewrites = Input_Type_Rewrites {
  input_rewrites :: [Type_Rewrite],
  input_name :: String
  } deriving (Show, Eq)

instance Ord Input_Type_Rewrites where
  tr0 <= tr1 = input_name tr0 <= input_name tr1

data Partially_Parallel_State = Partially_Parallel_State {
  -- these are used to track the input rewrites for subgraphs
  -- because a map must know the input_type rewrites of its subgraph
  -- to compute it's input type
  input_types_rewrites :: S.Set Input_Type_Rewrites,
  -- these are used to track the output type rewrites seen by each sequence node
  -- to detect a DAG where a single node may be rewritten multiple times
  output_rewrites_per_st_index :: M.Map DAG_Index [Type_Rewrite],
  num_calls :: Int
  } deriving (Show, Eq)

empty_ppar_state = Partially_Parallel_State S.empty M.empty 0
  
type Partially_ParallelM = ExceptT Rewrite_Failure (
  StateT Rewrite_Data (
      State Partially_Parallel_State
      )
  )

type Partially_Parallel_MemoM v = DAG_MemoT v Partially_ParallelM

incr_num_calls :: Partially_Parallel_MemoM STE.Expr ()
incr_num_calls = do
  cur_data <- lift $ lift $ lift get
  lift $ lift $ lift $ modify
    (\cur_data -> cur_data { num_calls = (num_calls cur_data + 1) })
    
get_num_calls :: Partially_Parallel_MemoM STE.Expr Int
get_num_calls = do
  cur_data <- lift $ lift $ lift get
  return $ num_calls cur_data
    
get_input_types_rewrites :: Partially_Parallel_MemoM STE.Expr (S.Set Input_Type_Rewrites)
get_input_types_rewrites = do
  cur_data <- lift $ lift $ lift get
  return $ input_types_rewrites cur_data

add_input_type_rewrite :: Input_Type_Rewrites -> Partially_Parallel_MemoM STE.Expr ()
add_input_type_rewrite new_rewrite = do
  cur_rewrites_set <- get_input_types_rewrites
  let new_rewrites_set = S.insert new_rewrite cur_rewrites_set
  lift $ lift $ lift $ modify
    (\cur_data -> cur_data { input_types_rewrites = new_rewrites_set })

set_input_types_rewrites :: S.Set Input_Type_Rewrites -> Partially_Parallel_MemoM STE.Expr ()
set_input_types_rewrites rewrites = do
  lift $ lift $ lift $ modify
    (\cur_data -> cur_data { input_types_rewrites = rewrites })

get_output_rewrites_for_node :: (Indexible a, Show a) => a ->
                               Partially_Parallel_MemoM STE.Expr [Type_Rewrite]
get_output_rewrites_for_node node = do
  cur_data <- lift $ lift $ lift get
  let cur_map = output_rewrites_per_st_index cur_data
  if M.member (get_index node) cur_map
    then return $ cur_map M.! (get_index node)
    else throwError $ Slowdown_Failure $
    "couldn't find index " ++ show (get_index node) ++ " in output type rewrite map " ++
    show cur_data

add_output_rewrite_for_node :: (Indexible a) => a -> [Type_Rewrite] ->
                              Partially_Parallel_MemoM STE.Expr ()
add_output_rewrite_for_node node new_rewrite = do
  cur_data <- lift $ lift $ lift get
  let cur_map = output_rewrites_per_st_index cur_data
  let new_map = M.insert (get_index node) new_rewrite cur_map
  lift $ lift $ lift $ modify
    (\cur_data -> cur_data { output_rewrites_per_st_index = new_map })

sequence_to_partially_parallel :: [Type_Rewrite] -> SeqE.Expr ->
                                  Partially_Parallel_MemoM STE.Expr STE.Expr
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.IdN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.IdN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.AbsN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.AbsN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.NotN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.NotN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.AndN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.AndN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.OrN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.OrN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.AddN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.AddN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.SubN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.SubN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.MulN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.MulN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.DivN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.DivN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.LSRN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.LSRN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.LSLN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.LSLN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.LtN t_seq producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_st <- ppar_AST_type [NonSeqR] t_seq
  ppar_atom_operator type_rewrites (STE.LtN t_st) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.EqN t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- can reuse all of type_rewrites in these calls as atom tuples
  -- and other atoms all have same Type_Rewrite object - NonSeqR
  t_ppar <- ppar_AST_type type_rewrites t
  ppar_atom_operator type_rewrites (STE.EqN t_ppar) producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.IfN t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_ppar <- ppar_AST_type type_rewrites t
  ppar_atom_operator type_rewrites (STE.IfN t_ppar) producer

-- generators
sequence_to_partially_parallel _ node@(SeqE.Lut_GenN _ _ producer _) =
  throwError $ Expr_Failure $ "Can't parallelize LUTs: " ++ show node
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.Const_GenN constant_val constant_type _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_par <- ppar_AST_type type_rewrites constant_type
  v_par <- ppar_AST_value type_rewrites constant_val
  cur_idx <- get_cur_index
  return $ STE.Const_GenN v_par t_par 0 cur_idx
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr0_n) : type_rewrites_tl)
  seq_e@(SeqE.CounterN n incr_amount int_type _) |
  n == tr0_n = do
  int_type_par <- ppar_AST_type type_rewrites_tl int_type
  cur_idx <- get_cur_index
  return $ STE.Counter_sN n incr_amount int_type_par 0 cur_idx
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr0_n tr0_i) : type_rewrites_tl)
  seq_e@(SeqE.CounterN n incr_amount int_type _) |
  n == tr0_n = do
  int_type_par <- ppar_AST_type type_rewrites_tl int_type
  cur_idx <- get_cur_index
  return $ STE.Counter_tN n tr0_i incr_amount int_type_par 0 cur_idx
sequence_to_partially_parallel type_rewrites@(tr@(SplitR tr0_n tr0_i tr1_n) : type_rewrites_tl)
  seq_e@(SeqE.CounterN n incr_amount int_type _) |
  n == tr0_n * tr1_n = do
  out_type_par <- ppar_AST_type type_rewrites_tl int_type
  cur_idx <- get_cur_index
  return $ STE.Counter_tsN tr0_n tr0_i tr1_n incr_amount out_type_par 0 cur_idx
sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                  (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR))
                                                  : type_rewrites_tl)
  seq_e@(SeqE.CounterN n incr_amount int_type _) |
  n == tr0_n * tr1_n = do
  out_type_par <- ppar_AST_type type_rewrites_tl int_type
  cur_idx <- get_cur_index
  return $ STE.Counter_tnN [tr0_n, tr1_n] [tr0_i, tr1_i] incr_amount out_type_par 0 cur_idx
sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                  (SplitNestedR (TimeR tr1_n tr1_i)
                                                  (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)))
                                                  : type_rewrites_tl)
  seq_e@(SeqE.CounterN n incr_amount int_type _) |
  n == tr0_n * tr1_n = do
  out_type_par <- ppar_AST_type type_rewrites_tl int_type
  cur_idx <- get_cur_index
  return $ STE.Counter_tnN [tr0_n, tr1_n, tr2_n] [tr0_i, tr1_i, tr2_i] incr_amount out_type_par 0 cur_idx

-- sequence operators
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n shift_amount elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_sN tr_n shift_amount elem_t_ppar) producer
  
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n shift_amount elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tN tr_n tr_i shift_amount elem_t_ppar) producer

-- if only parallelism 1, then just treat it as a TSeq with an SSeq 1 input wrapping
-- the element type
sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io 1) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n shift_amount elem_t producer _) = do
  out_idx_debug <- get_cur_index_no_increment
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tN no io shift_amount (STT.SSeqT 1 elem_t_ppar)) producer

sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n shift_amount elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tsN no io ni shift_amount elem_t_ppar) producer
    
sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR))
                                               : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n shift_amount elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tnN tr0_n [tr1_n] tr0_i [tr1_i] shift_amount elem_t_ppar) producer

sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i)
                                                 (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)))
                                               : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n shift_amount elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tnN tr0_n [tr1_n, tr2_n] tr0_i [tr1_i, tr2_i] shift_amount elem_t_ppar) producer

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.Up_1dN n elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR 1 : type_rewrites_tl
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.Up_1d_sN tr_n elem_t_ppar) producer

sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.Up_1dN n elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = TimeR 1 (tr_n + tr_i - 1) : type_rewrites_tl
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.Up_1d_tN tr_n tr_i elem_t_ppar) producer

sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  seq_e@(SeqE.Up_1dN n elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitR 1 (no + io - 1) 1 : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_map_t no io (STE.Up_1d_sN ni elem_t_ppar) =<<
    add_index (STE.Up_1d_tN no io (STT.SSeqT 1 elem_t_ppar)) producer_ppar
 
sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.Down_1dN n sel_idx elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr
  --let n_divisors = ae_divisors_from_factors $ ae_factorize n
  --traceShowM $ "n_divisors: " ++ show n_divisors

  let input_rewrite = case tr of
        SpaceR 1 -> SpaceR n -- <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
        TimeR 1 tr_i_down | 1 + tr_i_down >= n -> TimeR n (tr_i_down - n + 1)
        TimeR 1 tr_i_down -> do
          let num_clocks = 1 + tr_i_down
          if num_clocks >= n
            then SplitR n (num_clocks - n) 1
            else do
            let n_divisors = ae_divisors_from_factors $ ae_factorize n
            let no = maximum $ S.filter (\x -> x <= num_clocks) n_divisors
            SplitR no (num_clocks - no) (n `div` no)
        SplitR 1 tr_i_down 1 -> do
          let num_clocks = 1 + tr_i_down
          if num_clocks >= n
            then SplitR n (num_clocks - n) 1
            else do
            let n_divisors = ae_divisors_from_factors $ ae_factorize n
            let no = maximum $ S.filter (\x -> x <= num_clocks) n_divisors
            SplitR no (num_clocks - no) (n `div` no)
        SplitNestedR (TimeR 1 tr_io_down) (SplitNestedR (TimeR 1 tr_ii_down) NonSeqR) -> do
          let num_clocks_outer = 1 + tr_io_down
          let num_clocks_inner = 1 + tr_ii_down
          let n_divisors = ae_divisors_from_factors $ ae_factorize n
          let no = maximumOrDefault (-1) $ S.filter
                (\x -> (x <= num_clocks_outer) && ((n `div` x) <= num_clocks_inner))
                n_divisors
          let ni = n `div` no
          SplitNestedR (TimeR no (tr_io_down - no + 1))
            (SplitNestedR (TimeR ni (tr_ii_down - ni + 1)) NonSeqR)
        _ -> NonSeqR

  let reshape_to_remove_sseq = case tr of
        TimeR 1 tr_i_down | 1 + tr_i_down < n -> True
        _ -> False

  let bad_input = case input_rewrite of
        SplitNestedR (TimeR (-1) _) _ -> True
        NonSeqR -> True
        _ -> False

  --traceShowM $ "down"
  --traceShowM $ "n " ++ show n
  --traceShowM $ "i " ++ show i
  --traceShowM $ "tr " ++ show tr
  --traceShowM $ "in seq t slowed: " ++ show (SeqT.SeqT n i SeqT.IntT)
  --traceShowM $ "input_rewrite " ++ show input_rewrite

  let upstream_type_rewrites = input_rewrite : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t

  if bad_input
    then do
    throwError $ Slowdown_Failure "down invalid output type rewrite"
    else get_scheduled_down input_rewrite elem_t_ppar producer_ppar reshape_to_remove_sseq
  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_down :: Type_Rewrite -> STT.AST_Type -> STE.Expr -> Bool ->
                          Partially_Parallel_MemoM STE.Expr STE.Expr
    get_scheduled_down (SpaceR in_n) elem_t_ppar producer_ppar _ =
      add_index (STE.Down_1d_sN in_n sel_idx elem_t_ppar) producer_ppar
    get_scheduled_down (TimeR in_n in_i) elem_t_ppar producer_ppar _ =
      add_index (STE.Down_1d_tN in_n in_i sel_idx elem_t_ppar) producer_ppar
    get_scheduled_down (SplitR in_no in_io in_ni) elem_t_ppar producer_ppar remove_sseq = do
      let result =
            STB.make_map_t 1 (in_no + in_io - 1) ( 
            STE.Down_1d_sN in_ni (sel_idx `mod` in_ni) elem_t_ppar
            ) =<<
            (add_index
             (STE.Down_1d_tN in_no in_io (sel_idx `div` in_ni) (STT.SSeqT in_ni elem_t_ppar))
             producer_ppar)
      if remove_sseq
        then (add_index $
             STE.ReshapeN
             (STT.TSeqT 1 (in_no + in_io - 1) (STT.SSeqT 1 elem_t_ppar))
             (STT.TSeqT 1 (in_no + in_io - 1) elem_t_ppar))
             =<< result
        else result
    get_scheduled_down (SplitNestedR (TimeR in_no in_io)
                         (SplitNestedR (TimeR in_ni in_ii) NonSeqR))
      elem_t_ppar producer_ppar _ |
      (in_io >= 0) && (in_ii >= 0) = do
        STB.make_map_t 1 (in_no + in_io - 1) ( 
          STE.Down_1d_tN in_ni in_ii (sel_idx `mod` in_ni) elem_t_ppar
          ) =<<
          (add_index
            (STE.Down_1d_tN in_no in_io (sel_idx `div` in_ni) (STT.TSeqT in_ni in_ii elem_t_ppar))
            producer_ppar)
    get_scheduled_down (SplitNestedR _ _) _ _ _ = throwError $
      Slowdown_Failure ("can't handle tr " ++ show tr ++ " with seq_e " ++ show seq_e) 
    get_scheduled_down NonSeqR _ _ _ = throwError $
      Slowdown_Failure "can't get nonseq for down_1d input"

-- first two partitions are special cases where SSeq 1 (TSeq) where can
-- move SSeq cheaply, unlike other 
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR 1) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR tr_ni tr_ii 1 : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr_no tr_io 1) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitNestedR (TimeR tr_no tr_io)
                               (SplitNestedR (TimeR tr_ni tr_ii) NonSeqR) : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr_no) : tr1@(SpaceR tr_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR (no*ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_s_ssN tr_no tr_ni elem_t_ppar) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr_no) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  -- need to split them as always keep space outside time
  -- note ni no naming scheme is based on order of output and the below
  -- usages of variables are ordered for inputs that are reversed
  let upstream_type_rewrites = SplitR tr_ni tr_ii tr_no : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr0_no) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR tr1_no tr1_io (tr0_no*tr1_ni) : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_no tr_io) : tr1@(SpaceR tr_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- doing nothing. Since this emits a nested TSeq(SSeq), nothing to do for partition.
  -- this partition becomes a Noop.
  -- Just need to propagate the split as a single SplitR up pipeline
  let upstream_type_rewrites = SplitR tr_no tr_io tr_ni : type_rewrites_tl
  sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_no tr_io) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitNestedR tr0 (SplitNestedR tr1 NonSeqR) : type_rewrites_tl
  sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_no tr0_io) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- output is TSeq (TSeq (SSeq)), so do a partition_t_tt on the outer part of the split
  -- partition_t_tt's element type is the inner most SSeq 
  let partition_t_tt_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) tr1_ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_t_ttN tr0_no tr1_no tr0_io tr1_io partition_t_tt_elem_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SpaceR tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- split the SplitR's inner SSeq and the SpaceR's SSeq, leave outer TSeq alone
  let upstream_type_rewrites = SplitR tr0_no tr0_io (tr0_ni*tr1_ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_map_t tr0_no tr0_io (STE.Partition_s_ssN tr0_ni tr1_ni elem_t_ppar) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(TimeR tr1_n tr1_i) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR (tr0_no*tr1_n) ((tr0_no * tr1_i) + (tr0_io * (tr1_n + tr1_i))) tr0_ni : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) (tr0_ni*tr1_ni) : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitNestedR (TimeR tr0_n tr0_i)
                                                    (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR))
                                              : tr1@(SpaceR tr2_n) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- split the SplitR's inner SSeq and the SpaceR's SSeq, leave outer TSeq alone
  let upstream_type_rewrites = SplitR (tr0_n*tr1_n)
                               (ST_Conv.invalid_clocks_from_nested tr0_n tr1_n tr0_i tr1_i) tr2_n : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_t_ttN tr0_n tr1_n tr0_i tr1_i (STT.SSeqT tr2_n elem_t_ppar)) producer_ppar
  
sequence_to_partially_parallel type_rewrites@((SplitNestedR tr0@(TimeR tr0_n tr0_i)
                                                    (SplitNestedR tr1@(TimeR tr1_n 0) NonSeqR))
                                              : tr2@(TimeR tr2_n tr2_i) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitNestedR (TimeR (tr0_n * tr1_n) (tr0_i * tr1_n)) (SplitNestedR tr2 NonSeqR) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_t_ttN tr0_n tr1_n tr0_i 0 (STT.TSeqT tr2_n tr2_i elem_t_ppar)) producer_ppar
  
sequence_to_partially_parallel type_rewrites@((SplitNestedR tr0@(TimeR tr0_n tr0_i)
                                                    (SplitNestedR tr1@(TimeR tr1_n tr1_i) NonSeqR))
                                              : tr2@(TimeR tr2_n tr2_i) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitNestedR tr0 (SplitNestedR tr1 (SplitNestedR tr2 NonSeqR)) : type_rewrites_tl
  sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_n tr0_i) :
                                              (SplitNestedR tr1@(TimeR tr1_n 0)
                                                (SplitNestedR tr2@(TimeR tr2_n tr2_i) NonSeqR))
                                               : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitNestedR (TimeR (tr0_n * tr1_n) (tr0_i * tr1_n)) (SplitNestedR tr2 NonSeqR) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_t_ttN tr0_n tr1_n tr0_i 0 (STT.TSeqT tr2_n tr2_i elem_t_ppar)) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_n tr0_i) :
                                              (SplitNestedR tr1@(TimeR tr1_n tr1_i)
                                                (SplitNestedR tr2@(TimeR tr2_n tr2_i) NonSeqR))
                                               : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitNestedR tr0 (SplitNestedR tr1 (SplitNestedR tr2 NonSeqR)) : type_rewrites_tl
  sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  
{-
can come bnack and fix these up for SplitNestedR
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(TimeR tr1_n tr1_i) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni _ _ elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR (tr0_no*tr1_n) ((tr0_no * tr1_i) + (tr0_io * (tr1_n + tr1_i))) tr0_ni : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni _ _ elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) (tr0_ni*tr1_ni) : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
-}

sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_n 0) :
                                              type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer _) |
  tr_n == no && 1 == ni = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = tr0 : TimeR 1 0 : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  let in_t_ppar = ST_Conv.e_out_type $ ST_Conv.expr_to_types producer_ppar
  cur_idx <- get_cur_index
  return $ STE.ReshapeN in_t_ppar out_t_ppar producer_ppar cur_idx

  {-
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_n tr_i) :
                                              type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer _) |
  tr_n == no && 1 == ni = do
  add_output_rewrite_for_node seq_e type_rewrites
  throwError $ Slowdown_Failure "this unpartition will create bad reshape, not exploring for now"
-}

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_no) : type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- this works as parameters_match makes sure no*ni equals tr_no
  -- and unpartition must accept same no and ni regardless of invalid clocks
  let upstream_type_rewrites = SpaceR no : SpaceR ni : type_rewrites_tl
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.Unpartition_s_ssN no ni elem_t_ppar) producer
    
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr_no tr_io tr_ni) :
                                              type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer _) |
  tr_no == no && tr_ni == ni = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = TimeR tr_no tr_io : SpaceR tr_ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  let in_t_ppar = ST_Conv.e_out_type $ ST_Conv.expr_to_types producer_ppar
  cur_idx <- get_cur_index
  return $ STE.ReshapeN in_t_ppar in_t_ppar producer_ppar cur_idx
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr_no tr_io tr_ni) :
                                              type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer _) |
  tr_no*tr_ni == no && 1 == ni = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = tr0 : SpaceR 1 : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  let in_t_ppar = ST_Conv.e_out_type $ ST_Conv.expr_to_types producer_ppar
  cur_idx <- get_cur_index
  return $ STE.ReshapeN in_t_ppar out_t_ppar producer_ppar cur_idx
 
sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR))
                                               : type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer _) |
  tr0_n == no && tr1_n == ni = do
  --traceShowM "howdy"
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- this works as parameters_match makes sure no*ni equals tr_no
  -- and unpartition must accept same no and ni regardless of invalid clocks
  let upstream_type_rewrites = TimeR tr0_n tr0_i : TimeR tr1_n tr1_i : type_rewrites_tl
  -- MAKE THIS PUT A RESHAPE NODE IN IF GOING TO USE IT!!!!!!
  sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer

  
sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i)
                                                 (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)))
                                               : type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer index) |
  -- when both tr1_n and tr2_n are 1, this will match but not sure
  -- whether to group tr1_n with tr0_n or tr2_n, below tries both
  tr0_n == no && tr1_n*tr2_n == ni = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  -- ppar_AST_type applies the type_rewrites to match downstream
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  -- two possible upstream rewrites, either timeR on outside or inside
  let outer_time_upstream_type_rewrites =
        TimeR tr0_n tr0_i :
        (SplitNestedR (TimeR tr1_n tr1_i) (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)) :
        type_rewrites_tl
  let inner_time_upstream_type_rewrites =
        (SplitNestedR (TimeR tr0_n tr0_i) (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR)) :
        TimeR tr2_n tr2_i :
        type_rewrites_tl
  let possible_input_trs = [outer_time_upstream_type_rewrites,
                            inner_time_upstream_type_rewrites]
  let possible_st_programs = map (\trs -> (trs, rewrite_to_partially_parallel_type_rewrite trs producer))
                             possible_input_trs
  let valid_possible_st_programs = filter (not . Has_Error.has_error . snd) possible_st_programs
  --traceShowM $ "valid_possible_st_programs: " ++ show valid_possible_st_programs
  -- when computing area include the reshape as different types will mean different
  -- resahpe area costs
  let possible_st_trs_and_areas = map
        (\(tr, p) -> do
            let p_with_reshape = STE.ReshapeN (ST_Conv.e_out_type $ ST_Conv.expr_to_types p) out_t_ppar p index
            (tr, Comp_Area.get_area p_with_reshape)
        ) valid_possible_st_programs

  if null possible_st_trs_and_areas
    then throwError $ Slowdown_Failure $ "Unpartition has no valid upstreams" ++ show possible_st_programs
    else do
    let min_tr = fst $ L.minimumBy (\pa pb -> compare (snd pa) (snd pb)) possible_st_trs_and_areas
    in_t_ppar <- ppar_AST_type min_tr (head $ Seq_Conv.e_in_types types)
    ppar_unary_seq_operator min_tr
      (STE.ReshapeN in_t_ppar out_t_ppar) producer

-- use these computations if I'm wrong about TimeR always being fully sequential
-- for Unpartition no ni io ii into a TimeR tr_no tr_io
-- TSeq in_no in_io (TSeq in_ni in_io) is input
-- in_no*in_ni = tr_no
-- in_no = no
-- in_ni = ni
-- tr_io = (in_no * in_ii) + (in_io * (in_ni + in_ii))
-- in_io <= io
-- in_ii <= ii
-- since 3 equations and 4 unknowns, need solver
{-
this is is just a reshape, so no need to make this node
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni io ii elem_t producer _) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) &&
  -- this case only matches if fully sequential
  (Seq_Conv.invalid_clocks_from_nested no ni io ii == tr_i) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- only get if fully sequential, using all invalid clocks
  -- therefore can use io and ii
  let upstream_type_rewrites = TimeR no io : TimeR ni ii : type_rewrites_tl
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.Unpartition_t_ttN no ni io ii elem_t_ppar) producer
-}

sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni elem_t producer index) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  let predicted_out_st_type = type_rewrite_to_example_st_type
                              (Seq_Conv.e_out_type types) type_rewrites
  -- ppar_AST_type applies the type_rewrites to match downstream
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)

  let matches_heuristics = case producer of
        SeqE.MapN h_no (SeqE.Down_1dN h_ni _ _ _ _) _ _ ->
          case tr of
            SplitNestedR (TimeR htr0_n htr0_i)
              (SplitNestedR (TimeR htr1_n htr1_i) _) |
              h_no == htr0_n && (h_ni == htr1_n + htr1_i) -> Just False
            SplitNestedR (TimeR htr0_n htr0_i)
              (SplitNestedR (TimeR htr1_n 0) _) |
              h_no == htr0_n * htr1_n -> Just True
            _ -> Nothing
        SeqE.UnpartitionN _ _ _ (SeqE.MapN h_no (SeqE.Down_1dN h_ni _ _ _ _) _ _) _ ->
          case tr of
            SplitNestedR (TimeR htr0_n htr0_i)
              (SplitNestedR (TimeR htr1_n htr1_i) _) |
              h_no == htr0_n && (h_ni == htr1_n + htr1_i) -> Just False
            SplitNestedR (TimeR htr0_n htr0_i)
              (SplitNestedR (TimeR htr1_n 0) _) |
              h_no == htr0_n * htr1_n -> Just True
            _ -> Nothing
        _ -> Nothing 

  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr

  -- just get possible type rewrites for the input two seqs, rest aren't changed by unpartition
  let unparititioned_in_seq = SeqT.SeqT no (SeqT.SeqT ni SeqT.Int8T)
  --traceShowM $ "unpartition " ++ show no ++ " " ++ show ni
  --traceShowM $ "slowdown: " ++ show slowdown
  --traceShowM $ "type_rewrites: " ++ show type_rewrites
  let possible_trs_for_in_seq = rewrite_all_AST_types slowdown unparititioned_in_seq
  --traceShowM $ "possible_trs_for_in_seq: " ++ show possible_trs_for_in_seq
  --traceShowM $ "lengths possible_trs_for_in_seq: " ++ show (fmap length possible_trs_for_in_seq)
  let possible_input_trs = map (\(tr0 : tr1 : _) -> tr0 : tr1 : type_rewrites_tl) possible_trs_for_in_seq
  --traceShowM $ "possible_input_trs: " ++ show possible_input_trs
  reshape_idx <- get_cur_index
  let (min_tr, min_area, _) = if null possible_input_trs
        then (undefined, -1, undefined)
        else do
        let first_out_tr = head possible_input_trs
        let first_st_expr = rewrite_to_partially_parallel_type_rewrite first_out_tr
                            producer
        let first_st_with_reshape =
              STE.ReshapeN (ST_Conv.e_out_type $ ST_Conv.expr_to_types first_st_expr)
              out_t_ppar first_st_expr reshape_idx
        let other_trs = tail possible_input_trs
        L.foldl' (\(!min_tr, !min_st_area, !min_st_expr) next_tr -> do
                     let predicted_in_st_type = type_rewrite_to_example_st_type
                                                (head $ Seq_Conv.e_in_types types)
                                                next_tr
                     let next_st_expr = rewrite_to_partially_parallel_type_rewrite
                                        next_tr producer
                     let next_st_expr_with_reshape = 
                           STE.ReshapeN (ST_Conv.e_out_type $ ST_Conv.expr_to_types next_st_expr)
                           out_t_ppar next_st_expr reshape_idx
                     let next_st_area = Comp_Area.get_area next_st_expr_with_reshape
                     let min_st_out_type = ST_Conv.e_out_type $
                                           ST_Conv.expr_to_types min_st_expr
                     let next_st_out_type = ST_Conv.e_out_type $
                                            ST_Conv.expr_to_types next_st_expr
                     force $ if --isJust (STT.norm_and_diff_types predicted_in_st_type predicted_out_st_type) ||
                                Has_Error.has_error min_st_expr ||
                                (next_st_area < min_st_area &&
                                 (not $ Has_Error.has_error next_st_expr)) ||
                                -- if they produce same program but one has
                                -- simpler type, take that one
                                (next_st_area == min_st_area &&
                                 (not $ Has_Error.has_error next_st_expr) && 
                                 (not $ Has_Error.has_error min_st_expr) &&
                                 (STT.num_layers_t next_st_out_type < STT.num_layers_t min_st_out_type)
                                )
                             then (next_tr, next_st_area, next_st_expr)
                             else (min_tr, min_st_area, min_st_expr)
                 ) (first_out_tr, (Comp_Area.get_area first_st_with_reshape), first_st_expr) other_trs
  if min_area == -1
    then throwError $ Slowdown_Failure 
         ("No possible rewrites for unpartition with " ++ show type_rewrites ++
           " of program \n" ++
           Seq_Print.print_seq_str seq_e)
    else do
    in_t_ppar <- ppar_AST_type min_tr (head $ Seq_Conv.e_in_types types)
    ppar_unary_seq_operator min_tr
      (STE.ReshapeN in_t_ppar out_t_ppar) producer
   {- 
  let possible_st_programs = map (\trs -> (trs, rewrite_to_partially_parallel_type_rewrite trs producer))
                             possible_input_trs
  --traceShowM $ "possible_st_programs: " ++ show possible_st_programs
  let valid_possible_st_programs = filter (not . Has_Error.has_error . snd) possible_st_programs
  --traceShowM $ "valid_possible_st_programs: " ++ show valid_possible_st_programs
  -- when computing area include the reshape as different types will mean different
  -- resahpe area costs
  let possible_st_trs_and_areas = map
        (\(tr, p) -> do
            let p_with_reshape = STE.ReshapeN (ST_Conv.e_out_type $ ST_Conv.expr_to_types p) out_t_ppar p index
            (tr, Comp_Area.get_area p_with_reshape)
        ) valid_possible_st_programs
  --traceShowM $ "valid_possible_st_trs_and_areas: " ++ show possible_st_trs_and_areas
  --base_input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT no io -- (slowdown_without_ni_factors - no)
  --                                                    (SeqT.SeqT ni ii SeqT.IntT))
  --traceShowM $ "base_input_rewrites: " ++ show base_input_rewrites
  --traceShowM $ "matched_huersitics: " ++ show matches_heuristics
  --traceShowM $ "tr:" ++ show type_rewrites
  --traceShowM $ "index: " ++ show index
  -- NOTE: DISABLING HEURISTICS FOR NOW
  if False && isJust matches_heuristics 
    then do
    -- need to handle Tseq TSeq case where adding SSeq 1 to bottom 
    let upstream_type_rewrites =
          case tr of
            SplitNestedR (TimeR tr0_n tr0_i)
              (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR) ->
              TimeR tr0_n tr0_i : TimeR tr1_n tr1_i : type_rewrites_tl
            SplitNestedR (TimeR tr0_n tr0_i)
              (SplitNestedR (TimeR tr1_n tr1_i)
              (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)) ->
              TimeR tr0_n tr0_i :
              (SplitNestedR (TimeR tr1_n tr1_i)
               (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)) :
               type_rewrites_tl
            _ -> error "unpartition heuristics bad"
    sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
    else if False
    then throwError $ Slowdown_Failure "Not doing real unpartition for now"
    else if length possible_st_trs_and_areas /= 0
    then do
    let min_tr = fst $ L.minimumBy (\pa pb -> compare (snd pa) (snd pb)) possible_st_trs_and_areas
    in_t_ppar <- ppar_AST_type min_tr (head $ Seq_Conv.e_in_types types)
    ppar_unary_seq_operator min_tr
      (STE.ReshapeN in_t_ppar out_t_ppar) producer
    else throwError $ Slowdown_Failure "Unpartition has no valid upstreams"
-}

{-
  -- rewrite inputs to get same throuhgput of output,
  -- but this can be in whatever nesting structure rewrite_AST_type chooses
  let slowdown_factors = ae_factorize slowdown
  let no_factors = ae_factorize no
  let ni_factors = ae_factorize ni
  let slowdown_without_ni_factors = ae_factors_product $ ae_factors_diff slowdown_factors ni_factors
  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT no io -- (slowdown_without_ni_factors - no)
                                                      (SeqT.SeqT ni ii SeqT.IntT))
  let input_rewrite_outer : input_rewrite_inner : _ = input_rewrites
  let upstream_type_rewrites = input_rewrite_outer : input_rewrite_inner : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  --traceShowM "unpartition"
  --traceShowM $ "tr: " ++ show tr
  --traceShowM $ "out_t: " ++ show out_t_ppar
  --traceShowM $ "slowdown: " ++ show slowdown
  --traceShowM $ "in seq t slowed: " ++ show (SeqT.SeqT no io (SeqT.SeqT ni ii SeqT.IntT))
  --traceShowM $ "input_rewrites: " ++ show input_rewrites
  --traceShowM $ "in_t_ppar: " ++ show in_t_ppar
  
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.ReshapeN in_t_ppar out_t_ppar) producer
-}
-- higher order operators
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.MapN n f producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl = input_rewrites $ head $ S.toList f_ppar_in_rewrites_tl_set
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  ppar_unary_seq_operator (tr : f_ppar_in_rewrites_tl)
    (STE.Map_sN tr_n f_ppar) producer
  
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.MapN n f producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl = input_rewrites $ head $ S.toList f_ppar_in_rewrites_tl_set
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  ppar_unary_seq_operator (tr : f_ppar_in_rewrites_tl)
    (STE.Map_tN tr_n tr_i f_ppar) producer
  
sequence_to_partially_parallel type_rewrites@(tr@(SplitR tr_no tr_io tr_ni) : type_rewrites_tl)
  seq_e@(SeqE.MapN n f producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl = input_rewrites $ head $ S.toList f_ppar_in_rewrites_tl_set
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  map_s <- STB.add_input_to_expr_for_map (STE.Map_sN tr_ni f_ppar)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   (tr : f_ppar_in_rewrites_tl) producer
  map_t_idx <- get_cur_index
  return $ STE.Map_tN tr_no tr_io map_s producer_ppar map_t_idx--map_st_wrong_producer {STE.seq_in = producer_ppar}

sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR))
                                               : type_rewrites_tl)
  seq_e@(SeqE.MapN n f producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl = input_rewrites $ head $ S.toList f_ppar_in_rewrites_tl_set
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  map_t_inner <- STB.add_input_to_expr_for_map (STE.Map_tN tr1_n tr1_i f_ppar)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   (tr : f_ppar_in_rewrites_tl) producer
  map_t_idx <- get_cur_index
  return $ STE.Map_tN tr0_n tr0_i map_t_inner producer_ppar map_t_idx--map_st_wrong_producer {STE.seq_in = producer_ppar}
  
sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i)
                                                 (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)))
                                               : type_rewrites_tl)
  seq_e@(SeqE.MapN n f producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl = input_rewrites $ head $ S.toList f_ppar_in_rewrites_tl_set
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  map_t_inner2 <- STB.add_input_to_expr_for_map (STE.Map_tN tr2_n tr2_i f_ppar)
  map_t_inner1 <- STB.add_input_to_expr_for_map (STE.Map_tN tr1_n tr1_i map_t_inner2)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   (tr : f_ppar_in_rewrites_tl) producer
  map_t_idx <- get_cur_index
  return $ STE.Map_tN tr0_n tr0_i map_t_inner1 producer_ppar map_t_idx--map_st_wrong_producer {STE.seq_in = producer_ppar}

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.Map2N n f producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl_list = S.toList f_ppar_in_rewrites_tl_set
  let f_ppar_in_rewrites_tl_l = input_rewrites $ head f_ppar_in_rewrites_tl_list
  let f_ppar_in_rewrites_tl_r = input_rewrites $ (f_ppar_in_rewrites_tl_list !! 1)
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_l) producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_r) producer_right
  cur_idx <- get_cur_index
  return $ STE.Map2_sN tr_n f_ppar producer_left_ppar producer_right_ppar cur_idx

sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.Map2N n f producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl_list = S.toList f_ppar_in_rewrites_tl_set
  let f_ppar_in_rewrites_tl_l = input_rewrites $ head f_ppar_in_rewrites_tl_list
  let f_ppar_in_rewrites_tl_r = input_rewrites $ (f_ppar_in_rewrites_tl_list !! 1)
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_l) producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_r) producer_right
  cur_idx <- get_cur_index
  return $ STE.Map2_tN tr_n tr_i f_ppar producer_left_ppar producer_right_ppar cur_idx

sequence_to_partially_parallel type_rewrites@(tr@(SplitR tr_no tr_io tr_ni) : type_rewrites_tl)
  seq_e@(SeqE.Map2N n f producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl_list = S.toList f_ppar_in_rewrites_tl_set
  let f_ppar_in_rewrites_tl_l = input_rewrites $ head f_ppar_in_rewrites_tl_list
  let f_ppar_in_rewrites_tl_r = input_rewrites $ (f_ppar_in_rewrites_tl_list !! 1)
  inner_map_s <- STB.add_input_to_expr_for_map2 $ STE.Map2_sN tr_ni f_ppar
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_l) producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_r) producer_right
  outer_map2_idx <- get_cur_index
  return $ STE.Map2_tN tr_no tr_io inner_map_s
    producer_left_ppar producer_right_ppar outer_map2_idx

sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i) NonSeqR))
                                               : type_rewrites_tl)
  seq_e@(SeqE.Map2N n f producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl_list = S.toList f_ppar_in_rewrites_tl_set
  let f_ppar_in_rewrites_tl_l = input_rewrites $ head f_ppar_in_rewrites_tl_list
  let f_ppar_in_rewrites_tl_r = input_rewrites $ (f_ppar_in_rewrites_tl_list !! 1)
  inner_map_t <- STB.add_input_to_expr_for_map2 $ STE.Map2_tN tr1_n tr1_i f_ppar
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_l) producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_r) producer_right
  outer_map2_idx <- get_cur_index
  return $ STE.Map2_tN tr0_n tr0_i inner_map_t
    producer_left_ppar producer_right_ppar outer_map2_idx
    
sequence_to_partially_parallel type_rewrites@(tr@(SplitNestedR (TimeR tr0_n tr0_i)
                                                 (SplitNestedR (TimeR tr1_n tr1_i)
                                                 (SplitNestedR (TimeR tr2_n tr2_i) NonSeqR)))
                                               : type_rewrites_tl)
  seq_e@(SeqE.Map2N n f producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl_list = S.toList f_ppar_in_rewrites_tl_set
  let f_ppar_in_rewrites_tl_l = input_rewrites $ head f_ppar_in_rewrites_tl_list
  let f_ppar_in_rewrites_tl_r = input_rewrites $ (f_ppar_in_rewrites_tl_list !! 1)
  inner_map_t2 <- STB.add_input_to_expr_for_map2 $ STE.Map2_tN tr2_n tr2_i f_ppar
  inner_map_t1 <- STB.add_input_to_expr_for_map2 $ STE.Map2_tN tr1_n tr1_i inner_map_t2
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_l) producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_r) producer_right
  outer_map2_idx <- get_cur_index
  return $ STE.Map2_tN tr0_n tr0_i inner_map_t1
    producer_left_ppar producer_right_ppar outer_map2_idx

sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.ReduceN n f producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites

  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty

  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  
  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr

  -- this is input rewrite for reduce and not subgraph f
  let input_rewrite = case tr of
        SpaceR 1 -> SpaceR n -- <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
        TimeR 1 tr_i_down | 1 + tr_i_down >= n -> TimeR n (tr_i_down - n + 1)
        TimeR 1 tr_i_down -> do
          let num_clocks = 1 + tr_i_down
          if num_clocks >= n
            then SplitR n (num_clocks - n) 1
            else do
            let n_divisors = ae_divisors_from_factors $ ae_factorize n
            let no = maximum $ S.filter (\x -> x <= num_clocks) n_divisors
            SplitR no (num_clocks - no) (n `div` no)
        SplitR 1 tr_i_down 1 -> do
          let num_clocks = 1 + tr_i_down
          if num_clocks >= n
            then SplitR n (num_clocks - n) 1
            else do
            let n_divisors = ae_divisors_from_factors $ ae_factorize n
            let no = maximum $ S.filter (\x -> x <= num_clocks) n_divisors
            SplitR no (num_clocks - no) (n `div` no)
        SplitNestedR (TimeR 1 tr_io_down) (SplitNestedR (TimeR 1 tr_ii_down) NonSeqR) -> do
          let num_clocks_outer = 1 + tr_io_down
          let num_clocks_inner = 1 + tr_ii_down
          let n_divisors = ae_divisors_from_factors $ ae_factorize n
          let no = maximumOrDefault (-1) $ S.filter
                (\x -> (x <= num_clocks_outer) && ((n `div` x) <= num_clocks_inner))
                n_divisors
          let ni = n `div` no
          SplitNestedR (TimeR no (tr_io_down - no + 1))
            (SplitNestedR (TimeR ni (tr_ii_down - ni + 1)) NonSeqR)
        _ -> NonSeqR

  let reshape_to_remove_sseq = case tr of
        TimeR 1 tr_i_down | 1 + tr_i_down < n -> True
        _ -> False

  let bad_input = case input_rewrite of
        SplitNestedR (TimeR (-1) _) _ -> True
        NonSeqR -> True
        _ -> False


  if bad_input
    then do
    cur_idx <- get_cur_index
    throwError $ Slowdown_Failure "reduce invalid output type rewrite"
    else do
    -- need to know what f_ppar's input type rewrites were
    -- as those are the inner type rewrites that the map must propagate up
    f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
    let f_ppar_in_rewrites_tl = input_rewrites $ head $ S.toList f_ppar_in_rewrites_tl_set

    -- reset the input type rewrites for the current graph
    set_input_types_rewrites outer_input_type_rewrites

    let upstream_type_rewrites = input_rewrite : f_ppar_in_rewrites_tl
    --traceShowM $ "about to do reduce upstream for op " ++ show producer ++ " with rewrites " ++ show upstream_type_rewrites
    producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
    --traceShowM "reduce upstream finished"
    get_scheduled_partition input_rewrite f_ppar producer_ppar reshape_to_remove_sseq

  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_partition :: Type_Rewrite -> STE.Expr -> STE.Expr -> Bool ->
                               Partially_Parallel_MemoM STE.Expr STE.Expr
    get_scheduled_partition (SpaceR in_n) f_ppar producer_ppar _ =
      add_index (STE.Reduce_sN in_n f_ppar) producer_ppar
    get_scheduled_partition (TimeR in_n in_i) f_ppar producer_ppar _ =
      add_index (STE.Reduce_tN in_n in_i f_ppar) producer_ppar
    get_scheduled_partition (SplitR in_no in_io in_ni) f_ppar producer_ppar remove_sseq = do
      let result =
            STB.make_reduce_t in_no in_io (STE.Map_sN 1 f_ppar) =<<
            STB.make_map_t in_no in_io (STE.Reduce_sN in_ni f_ppar)
            producer_ppar
      let elem_t_ppar = ST_Conv.e_out_type $ ST_Conv.expr_to_types f_ppar
      if remove_sseq
        then (add_index $
             STE.ReshapeN
             (STT.TSeqT 1 (in_no + in_io - 1) (STT.SSeqT 1 elem_t_ppar))
             (STT.TSeqT 1 (in_no + in_io - 1) elem_t_ppar))
             =<< result
        else result
    get_scheduled_partition (SplitNestedR (TimeR in_no in_io)
                         (SplitNestedR (TimeR in_ni in_ii) NonSeqR))
      f_ppar producer_ppar _ |
      (in_io >= 0) && (in_ii >= 0) = do
        STB.make_reduce_t in_no in_io (STE.Map_tN 1 (in_ni + in_io - 1) f_ppar) =<<
          STB.make_map_t in_no in_io (STE.Reduce_tN in_ni in_io f_ppar)
          producer_ppar
    get_scheduled_partition (SplitNestedR _ _) _ _ _ = do
      throwError $ Slowdown_Failure ("can't handle tr " ++ show tr ++ " with seq_e " ++ show seq_e)
    get_scheduled_partition NonSeqR _ _ _ = throwError $
      Slowdown_Failure "can't get nonseq for reduce input"

-- tuple operations
sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.FstN t0 t1 producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- use whole type rewrites here as Atom_Tuple (x, y) has type rewrite NonSeqR
  -- just like the atoms x and y
  t0_ppar <- ppar_AST_type type_rewrites t0
  t1_ppar <- ppar_AST_type type_rewrites t1
  ppar_unary_seq_operator type_rewrites (STE.FstN t0_ppar t1_ppar) producer
  
sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.SndN t0 t1 producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- use whole type rewrites here as Atom_Tuple (x, y) has type rewrite NonSeqR
  -- just like the atoms x and y
  t0_ppar <- ppar_AST_type type_rewrites t0
  t1_ppar <- ppar_AST_type type_rewrites t1
  ppar_unary_seq_operator type_rewrites (STE.SndN t0_ppar t1_ppar) producer

sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.ATupleN t0 t1 producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer_right
  -- use whole type rewrites here as Atom_Tuple (x, y) has type rewrite NonSeqR
  -- just like the atoms x and y
  t0_ppar <- ppar_AST_type type_rewrites t0
  t1_ppar <- ppar_AST_type type_rewrites t1
  cur_idx <- get_cur_index
  return $ STE.ATupleN t0_ppar t1_ppar producer_left_ppar producer_right_ppar cur_idx

sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.STupleN elem_t producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- using type_rewrites_tl here
  -- as the NonSeqR rewrite is for the STuple is introduced by the STupleN
  -- upstream doesn't have it
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl producer_right
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  cur_idx <- get_cur_index
  return $ STE.STupleN elem_t_ppar producer_left_ppar producer_right_ppar cur_idx

sequence_to_partially_parallel type_rewrites@(NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.STupleAppendN out_len elem_t producer_left producer_right _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer_left
  -- using type_rewrites_tl for right input
  -- as the NonSeqR rewrite is for the STuple is introduced by the STupleN
  -- upstream on the right input doesn't have it
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl producer_right
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  cur_idx <- get_cur_index
  return $ STE.STupleAppendN out_len elem_t_ppar producer_left_ppar producer_right_ppar cur_idx

  
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.STupleToSeqN n elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let upstream_type_rewrites = SpaceR 1 : NonSeqR : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_remove_1_s (STE.STupleToSSeqN tr_n elem_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.STupleToSeqN n elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let upstream_type_rewrites = TimeR 1 (tr_n - 1 + tr_i) : NonSeqR : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  cur_idx <- get_cur_index
  return $ STE.SerializeN tr_n tr_i elem_t_ppar producer_ppar cur_idx

sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.STupleToSeqN n elem_t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  --traceShowM $ "t0"
  --traceShowM $ "tr0: " ++ show tr0
  --traceShowM $ "tr1: " ++ show tr1
  let types = Seq_Conv.expr_to_types seq_e
  -- ppar_AST_type applies the type_rewrites to match downstream
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)

  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr
  -- rewrite input seq to get same throuhgput of output,
  -- but this can be in whatever nesting structure rewrite_AST_type chooses
  -- only modifying seq 1 (n-1+i) as STuple has no timing options
  let seq_input_rewrite = case tr of
        SpaceR n -> SpaceR 1 -- <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
        TimeR tr_n tr_i -> TimeR 1 (tr_n + tr_i - 1)
        SplitR tr_no tr_io tr_ni -> SplitR 1 (tr_no + tr_io - 1) 1
        SplitNestedR (TimeR tr_no tr_io)
          (SplitNestedR (TimeR tr_ni tr_ii) NonSeqR) ->
          SplitNestedR (TimeR 1 (tr_no + tr_io - 1))
                          (SplitNestedR (TimeR 1 (tr_ni + tr_ii - 1)) NonSeqR)
        SplitNestedR _ _ -> NonSeqR
        NonSeqR -> NonSeqR
 
  let bad_input = case seq_input_rewrite of
        SplitNestedR (TimeR (-1) _) _ -> True
        NonSeqR -> True
        _ -> False
  -- input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT 1 (n-1+i) SeqT.IntT)
  -- let seq_input_rewrite : _ = input_rewrites
  -- the input is a seq of an stuple, and stuple rewrite is with NonSeqR
  let upstream_type_rewrites = seq_input_rewrite : NonSeqR : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)

  x <- ppar_unary_seq_operator upstream_type_rewrites
    (STE.ReshapeN in_t_ppar out_t_ppar) producer
  --traceShowM x
  if bad_input
    then do
    throwError $ Slowdown_Failure "STupleToSeq invalid output type rewrite"
    else return x

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR 1) : NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.SeqToSTupleN n elem_t producer _) = do
  -- can't check parameters as NonSeqR carries no information
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- since the space 1 is handled by the add_1_s, just pass the n from the STuple
  -- back
  let upstream_type_rewrites = SpaceR n : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_add_1_s (STE.SSeqToSTupleN n elem_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr : NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.SeqToSTupleN n elem_t producer _) = do
  -- can't check parameters as NonSeqR carries no information
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  -- ppar_AST_type applies the type_rewrites to match downstream
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)

  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr
  --traceM $ "slowdown: " ++ show slowdown
 
  -- rewrite inputs to get same throuhgput of output,
  -- have seq n i here instead of seq 1 (n-1+i) because upstream seq
  -- not bound to fully parallel
  let input_rewrite = case tr of
        SpaceR 1 -> SpaceR n -- <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
        --TimeR 1 tr_i -> TimeR 1 (tr_n + tr_i - 1)
        --SplitR tr_no tr_io tr_ni -> SplitR 1 (tr_no + tr_io - 1) 1
        TimeR 1 tr_i_down -> TimeR n (tr_i_down - n + 1)
        SplitR 1 tr_i_down 1 -> do
          let num_clocks = 1 + tr_i_down
          if num_clocks >= n
            then SplitR n (num_clocks - n) 1
            else do
            let n_divisors = ae_divisors_from_factors $ ae_factorize n
            let no = maximum $ S.filter (\x -> x <= num_clocks) n_divisors
            SplitR no (num_clocks - no) (n `div` no)
        SplitNestedR (TimeR 1 tr_io_down) (SplitNestedR (TimeR 1 tr_ii_down) NonSeqR) -> do
          let num_clocks_outer = 1 + tr_io_down
          let num_clocks_inner = 1 + tr_ii_down
          let n_divisors = ae_divisors_from_factors $ ae_factorize n
          let no = maximumOrDefault (-1) $ S.filter
                (\x -> (x <= num_clocks_outer) && ((n `div` x) <= num_clocks_inner))
                n_divisors
          let ni = n `div` no
          SplitNestedR (TimeR no (tr_io_down - no + 1))
            (SplitNestedR (TimeR ni (tr_ii_down - ni + 1)) NonSeqR)
        _ -> NonSeqR
        
  let bad_input = case input_rewrite of
        SplitNestedR (TimeR (-1) _) _ -> True
        NonSeqR -> True
        _ -> False
  let upstream_type_rewrites = input_rewrite : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)

  if bad_input
    then do
    throwError $ Slowdown_Failure "SeqToSTuple invalid output type rewrite"
    else ppar_unary_seq_operator upstream_type_rewrites
         (STE.ReshapeN in_t_ppar out_t_ppar) producer

sequence_to_partially_parallel type_rewrites seq_e@(SeqE.InputN t input_name _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_ppar <- ppar_AST_type type_rewrites t
  -- if same input appears multiple times, ok as inserting into set is idempotent
  add_input_type_rewrite (Input_Type_Rewrites type_rewrites input_name)
  cur_idx <- get_cur_index
  return $ STE.InputN t_ppar input_name cur_idx

sequence_to_partially_parallel type_rewrites seq_e@(SeqE.ErrorN s _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  cur_idx <- get_cur_index
  return $ STE.ErrorN s cur_idx
sequence_to_partially_parallel tr e =
  throwError $ Slowdown_Failure $
  "can't handle type_rewrites: " ++ show tr ++ "\n and expr: \n" ++ show e ++
  " note its printed out form " ++ Seq_Print.print_seq_str e

-- | Verifies that Type_Rewrite matches the output Seq that is being rewritten
parameters_match :: Type_Rewrite -> Int -> Int -> Bool
parameters_match (SpaceR tr_n) n _ = tr_n == n
parameters_match (TimeR tr_n tr_i) n i = tr_n == n && tr_i <= i
parameters_match (SplitR tr_n_outer tr_i_outer tr_n_inner) n i =
  tr_n_outer * tr_n_inner == n && tr_i_outer <= i
parameters_match _ _ _ = False

ppar_AST_type :: [Type_Rewrite] -> SeqT.AST_Type -> Partially_Parallel_MemoM STE.Expr STT.AST_Type
ppar_AST_type [NonSeqR] SeqT.UnitT = return STT.UnitT
ppar_AST_type [NonSeqR] SeqT.BitT = return STT.BitT
ppar_AST_type [NonSeqR] SeqT.Int8T = return STT.Int8T
ppar_AST_type [NonSeqR] SeqT.UInt8T = return STT.UInt8T
ppar_AST_type [NonSeqR] SeqT.FixP1_7T = return STT.FixP1_7T
ppar_AST_type [NonSeqR] SeqT.Int16T = return STT.Int16T
ppar_AST_type [NonSeqR] SeqT.UInt16T = return STT.UInt16T
ppar_AST_type [NonSeqR] SeqT.Int32T = return STT.Int32T
ppar_AST_type [NonSeqR] SeqT.UInt32T = return STT.UInt32T
ppar_AST_type [NonSeqR] (SeqT.ATupleT x y) = do
  x_stt <- ppar_AST_type [NonSeqR] x
  y_stt <- ppar_AST_type [NonSeqR] y
  return $ (STT.ATupleT x_stt y_stt) 
ppar_AST_type (tr@(SpaceR tr_n) : type_rewrites_tl) (SeqT.SeqT n t) = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.SSeqT n inner_type
ppar_AST_type (tr@(TimeR tr_n tr_i) : type_rewrites_tl) (SeqT.SeqT n t) = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.TSeqT n tr_i inner_type
ppar_AST_type (tr@(SplitR tr_n_outer tr_i_outer tr_n_inner) : type_rewrites_tl)
  (SeqT.SeqT n t) = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.TSeqT tr_n_outer tr_i_outer (STT.SSeqT tr_n_inner inner_type)
ppar_AST_type (tr@(SplitNestedR (TimeR tr_n tr_i) NonSeqR) : type_rewrites_tl)
  (SeqT.SeqT n t) | n `mod` tr_n == 0 = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.TSeqT tr_n tr_i inner_type
ppar_AST_type (tr@(SplitNestedR (TimeR tr_n tr_i) tr_tl) : type_rewrites_tl)
  (SeqT.SeqT n t) | n `mod` tr_n == 0 = do
  inner_type <- ppar_AST_type (tr_tl : type_rewrites_tl) (SeqT.SeqT (n `div` tr_n) t)
  return $ STT.TSeqT tr_n tr_i inner_type
ppar_AST_type (NonSeqR : type_rewrites_tl) (SeqT.STupleT n t) = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.STupleT n inner_type
ppar_AST_type type_rewrites t = throwError $ Slowdown_Failure $
  "type_rewrite " ++ show type_rewrites ++ " not valid for partially " ++
  "parallelizing AST type " ++ show t

ppar_AST_value :: [Type_Rewrite] -> SeqT.AST_Value -> Partially_Parallel_MemoM STE.Expr STT.AST_Value
ppar_AST_value [NonSeqR] SeqT.UnitV = return STT.UnitV
ppar_AST_value [NonSeqR] (SeqT.BitV b) = return (STT.BitV b)
ppar_AST_value [NonSeqR] (SeqT.Int8V i) = return (STT.Int8V i)
ppar_AST_value [NonSeqR] (SeqT.UInt8V i) = return (STT.UInt8V i)
ppar_AST_value [NonSeqR] (SeqT.FixP1_7V i) = return (STT.FixP1_7V i)
ppar_AST_value [NonSeqR] (SeqT.Int16V i) = return (STT.Int16V i)
ppar_AST_value [NonSeqR] (SeqT.UInt16V i) = return (STT.UInt16V i)
ppar_AST_value [NonSeqR] (SeqT.Int32V i) = return (STT.Int32V i)
ppar_AST_value [NonSeqR] (SeqT.UInt32V i) = return (STT.UInt32V i)
ppar_AST_value [NonSeqR] (SeqT.ATupleV x y) = do
  x_stv <- ppar_AST_value [NonSeqR] x
  y_stv <- ppar_AST_value [NonSeqR] y
  return $ (STT.ATupleV x_stv y_stv)
ppar_AST_value (tr@(SpaceR tr_n) : type_rewrites_tl) (SeqT.SeqV xs) = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  return $ STT.SSeqV xs_par
ppar_AST_value (tr@(TimeR tr_n tr_i) : type_rewrites_tl) (SeqT.SeqV xs) = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  return $ STT.TSeqV xs_par tr_i 
ppar_AST_value (tr@(SplitR tr_n_outer tr_i_outer tr_n_inner) : type_rewrites_tl)
  (SeqT.SeqV xs) = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  -- split the xs into chunks where each chunk is an sseq of length
  -- tr_n_inner
  -- and then group all the sseq into one tseq
  let xs_par_chunked = chunksOf tr_n_inner xs_par
  let xs_chunks_as_sseqs = fmap STT.SSeqV xs_par_chunked
  return $ STT.TSeqV xs_chunks_as_sseqs tr_i_outer
ppar_AST_value (tr@(SplitNestedR (TimeR tr_n tr_i) NonSeqR) : type_rewrites_tl)
  (SeqT.SeqV xs) = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  return $ STT.TSeqV xs_par tr_i
ppar_AST_value (tr@(SplitNestedR (TimeR tr_n tr_i) tr_tl) : type_rewrites_tl)
  (SeqT.SeqV xs) = do
  let chunk_lengths = (length xs) `div` tr_n
  let xs_chunked = chunksOf chunk_lengths xs
  xs_par_chunked <- sequence $ fmap (\xs_chunk -> ppar_AST_value
                              (tr_tl : type_rewrites_tl) (SeqT.SeqV xs_chunk))
                       xs_chunked
  return $ STT.TSeqV xs_par_chunked tr_i
ppar_AST_value (NonSeqR : type_rewrites_tl) (SeqT.STupleV xs) = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  return $ STT.STupleV xs_par
ppar_AST_value type_rewrites v = throwError $ Slowdown_Failure $
  "type_rewrite " ++ show type_rewrites ++ " not valid for partially " ++
  "parallelizing AST value " ++ show v
  
ppar_atom_operator :: [Type_Rewrite] -> (STE.Expr -> DAG_Index -> STE.Expr) ->
                      SeqE.Expr -> Partially_Parallel_MemoM STE.Expr STE.Expr
ppar_atom_operator [] atom_op_gen _ = do
  cur_idx <- get_cur_index
  throwError $ Slowdown_Failure $
    "type_rewrite list empty while processing " ++
    show (atom_op_gen (STE.ErrorN "place_holder" No_Index) cur_idx)
ppar_atom_operator [NonSeqR] atom_op_gen producer = do
  producer_ppar <- sequence_to_partially_parallel_with_reshape [NonSeqR] producer
  cur_idx <- get_cur_index
  return $ atom_op_gen producer_ppar cur_idx
ppar_atom_operator type_rewrites atom_op_gen _ = do
  cur_idx <- get_cur_index
  throwError $ Slowdown_Failure $
    "type_rewrite list " ++ show type_rewrites ++ " not just a NonSeqR for atom op " ++
    show (atom_op_gen (STE.ErrorN "place_holder" No_Index) cur_idx)

ppar_unary_seq_operator :: [Type_Rewrite] -> (STE.Expr -> DAG_Index -> STE.Expr) ->
                           SeqE.Expr -> Partially_Parallel_MemoM STE.Expr STE.Expr
ppar_unary_seq_operator producer_output_type_rewrites unary_seq_op_gen producer = do
  producer_ppar <- sequence_to_partially_parallel_with_reshape producer_output_type_rewrites producer
  cur_idx <- get_cur_index
  return $ unary_seq_op_gen producer_ppar cur_idx

-- |Rewrite the producer using memoization. Then check it's output type rewrite
-- if it's not the same as the one passed in, do a reshape
-- cur_type_rewrites are the rewrties for the current call to rewrite the producer
-- the producer may have been previously rewritten. That is the actual rewrite
-- this needs to introduce a reshape then to match actual and what the current
-- type that the consumer expects
sequence_to_partially_parallel_with_reshape :: [Type_Rewrite] -> SeqE.Expr ->
                                            Partially_Parallel_MemoM STE.Expr STE.Expr
sequence_to_partially_parallel_with_reshape cur_type_rewrites producer = do
  incr_num_calls
  nc <- get_num_calls
  let time = unsafePerformIO $ getCurrentTime
  --traceM $ "cur call count: " ++ show nc ++ " with seq producer index: " ++ (show $ get_index producer) ++ " and time: " ++ (show time)
  producer_ppar <- memo producer $ sequence_to_partially_parallel cur_type_rewrites producer
  actual_type_rewrites <- get_output_rewrites_for_node producer
  if actual_type_rewrites == cur_type_rewrites
    then return producer_ppar
    else do
    reshape_idx <- get_cur_index
    let producer_seq_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types producer
    actual_st_type <- ppar_AST_type actual_type_rewrites producer_seq_out_type 
    cur_st_type <- ppar_AST_type cur_type_rewrites producer_seq_out_type
    return $ STE.ReshapeN actual_st_type cur_st_type producer_ppar reshape_idx

maximumOrDefault :: (Foldable t, Ord a) => a -> t a -> a
maximumOrDefault x xs | length xs == 0 = x
maximumOrDefault _ xs = maximum xs

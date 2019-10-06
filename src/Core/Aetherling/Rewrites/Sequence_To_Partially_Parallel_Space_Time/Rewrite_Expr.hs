module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr where
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Monad_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import qualified Aetherling.Interpretations.Sequence_Printer as Seq_Print
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
import Data.List.Split (chunksOf)
import qualified Data.Set as S
import qualified Data.Map as M
import Debug.Trace
import Data.Time
import System.IO.Unsafe

rewrite_to_partially_parallel :: Int -> SeqE.Expr -> STE.Expr
rewrite_to_partially_parallel s seq_expr = do
  let (expr_par, state) = runState (evalStateT
                             (runExceptT $ rewrite_to_partially_parallel' s seq_expr)
                             empty_rewrite_data)
                 empty_ppar_state
  --trace ("num_calls : " ++ (show $ num_calls state)) $
  if isLeft expr_par
    then STE.ErrorN (rw_msg $ fromLeft undefined expr_par) No_Index
    else fromRight undefined expr_par

rewrite_to_partially_parallel' :: Int -> SeqE.Expr -> Partially_ParallelM STE.Expr
rewrite_to_partially_parallel' s seq_expr = do
  let seq_expr_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types seq_expr
  --traceShowM $ rewrite_AST_type_debug s seq_expr_out_type
  output_type_slowdowns <- rewrite_AST_type s seq_expr_out_type
  --traceM ("output type slowdown" ++ show output_type_slowdowns ++ "\n s" ++ show s ++ "\n seq_expr_out_type" ++ show seq_expr_out_type ++ "\n")
  startEvalMemoT $ sequence_to_partially_parallel output_type_slowdowns seq_expr

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
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.AbsN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.AbsN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.NotN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.NotN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.AddN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.AddN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.SubN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.SubN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.MulN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.MulN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.DivN producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  ppar_atom_operator type_rewrites STE.DivN producer
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.EqN t producer _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- can reuse all of type_rewrites in these calls as atom tuples
  -- and other atoms all have same Type_Rewrite object - NonSeqR
  t_ppar <- ppar_AST_type type_rewrites t
  ppar_atom_operator type_rewrites (STE.EqN t_ppar) producer

-- generators
sequence_to_partially_parallel _ node@(SeqE.Lut_GenN _ _ producer _) =
  throwError $ Expr_Failure $ "Can't parallelize LUTs: " ++ show node
sequence_to_partially_parallel type_rewrites seq_e@(SeqE.Const_GenN constant_val constant_type _) = do
  add_output_rewrite_for_node seq_e type_rewrites
  t_par <- ppar_AST_type type_rewrites constant_type
  v_par <- ppar_AST_value type_rewrites constant_val
  cur_idx <- get_cur_index
  return $ STE.Const_GenN v_par t_par cur_idx

-- sequence operators
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n i shift_amount elem_t producer _) |
  parameters_match tr n i = do
  out_idx_debug <- get_cur_index_no_increment
  if out_idx_debug == Index 18
    then do
    traceShowM $ "shift0: " ++ show seq_e
    else return ()
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_sN tr_n shift_amount elem_t_ppar) producer
  
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n i shift_amount elem_t producer _) |
  parameters_match tr n i = do
  out_idx_debug <- get_cur_index_no_increment
  if out_idx_debug == Index 18
    then do
    traceShowM $ "shift0: " ++ show seq_e
    else return ()
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tN tr_n tr_i shift_amount elem_t_ppar) producer

-- if only parallelism 1, then just treat it as a TSeq with an SSeq 1 input wrapping
-- the element type
sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io 1) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n i shift_amount elem_t producer _) |
  parameters_match tr n i = do
  out_idx_debug <- get_cur_index_no_increment
  if out_idx_debug == Index 18
    then do
    traceShowM $ "shift1: " ++ show seq_e
    else return ()
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tN no io shift_amount (STT.SSeqT 1 elem_t_ppar)) producer

sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n i shift_amount elem_t producer _) |
  parameters_match tr n i = do
  out_idx_debug <- get_cur_index_no_increment
  if out_idx_debug == Index 18
    then do
    traceShowM $ "shift2: " ++ show seq_e
    else do
    traceShowM $ "shift2: " ++ show seq_e
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer
  let repeated_inputs_with_index = zip [0..] $ replicate ni producer_ppar
  let inner_sseqs_shifted = fmap (
        \(i, in_seq) -> do
          (add_index $ STE.Shift_tN no io ((ni - i + shift_amount - 1) `div` ni) (STT.SSeqT 1 elem_t_ppar)) =<<
            (STB.make_map_t no io (
                STE.Down_1d_sN ni ((i - shift_amount) `mod` ni) elem_t_ppar
                ) $
              in_seq)
        ) repeated_inputs_with_index
  nested_stuple_of_shifted_rows <-
        STB.repeated_stuple (STE.Map2_tN no io) inner_sseqs_shifted (STT.SSeqT 1 elem_t_ppar)

  -- since added extra sseq 1, need to remove it after tuple to sseq
  unpartition_idx <- get_cur_index
  map_t_idx <- get_cur_index
  stuple_to_sseq <- STB.add_input_to_expr_for_map $ STE.STupleToSSeqN ni elem_t_ppar
  stuple_to_sseq_map <- STB.add_input_to_expr_for_map $ STE.Map_sN 1 stuple_to_sseq
  let stuple_to_sseq_and_unpartition =
        STE.Unpartition_s_ssN 1 ni elem_t_ppar stuple_to_sseq_map unpartition_idx
  return $ STE.Map_tN no io stuple_to_sseq_and_unpartition  nested_stuple_of_shifted_rows map_t_idx



sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.Up_1dN n i elem_t producer _) |
  parameters_match tr n i = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR 1 : type_rewrites_tl
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.Up_1d_sN tr_n elem_t_ppar) producer

sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.Up_1dN n i elem_t producer _) |
  parameters_match tr n i = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = TimeR 1 (tr_n + tr_i - 1) : type_rewrites_tl
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.Up_1d_tN tr_n tr_i elem_t_ppar) producer

sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  seq_e@(SeqE.Up_1dN n i elem_t producer _) |
  -- i for Up_1d indicates extra invalids not caused by this upsample
  -- so can use i here
  parameters_match tr n i = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SplitR 1 (no + io - 1) 1 : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_map_t no io (STE.Up_1d_sN ni elem_t_ppar) =<<
    add_index (STE.Up_1d_tN no io (STT.SSeqT 1 elem_t_ppar)) producer_ppar
 
sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.Down_1dN n i sel_idx elem_t producer _) |
  parameters_match tr 1 (n+i-1) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr

  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
  let input_rewrite : _ = input_rewrites
  --traceShowM $ "down"
  --traceShowM $ "i " ++ show i
  --traceShowM $ "tr " ++ show tr
  --traceShowM $ "in seq t slowed: " ++ show (SeqT.SeqT n i SeqT.IntT)
  --traceShowM $ "input_rewrite " ++ show input_rewrites

  let upstream_type_rewrites = input_rewrite : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t

  get_scheduled_down input_rewrite elem_t_ppar producer_ppar
  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_down :: Type_Rewrite -> STT.AST_Type -> STE.Expr ->
                          Partially_Parallel_MemoM STE.Expr STE.Expr
    get_scheduled_down (SpaceR in_n) elem_t_ppar producer_ppar =
      add_index (STE.Down_1d_sN in_n sel_idx elem_t_ppar) producer_ppar
    get_scheduled_down (TimeR in_n in_i) elem_t_ppar producer_ppar =
      add_index (STE.Down_1d_tN in_n in_i sel_idx elem_t_ppar) producer_ppar
    get_scheduled_down (SplitR in_no in_io in_ni) elem_t_ppar producer_ppar = do
      STB.make_map_t 1 (in_no + in_io - 1) ( 
        STE.Down_1d_sN in_ni (sel_idx `mod` in_ni) elem_t_ppar
        ) =<<
        (add_index
         (STE.Down_1d_tN in_no in_io (sel_idx `div` in_no) (STT.SSeqT in_ni elem_t_ppar))
         producer_ppar)
    get_scheduled_down NonSeqR _ _ = throwError $
      Slowdown_Failure "can't get nonseq for down_1d input"

sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr_no) : tr1@(SpaceR tr_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR (no*ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_s_ssN tr_no tr_ni elem_t_ppar) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr_no) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
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
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR tr1_no tr1_io (tr0_no*tr1_ni) : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_no tr_io) : tr1@(SpaceR tr_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- doing nothing. Since this emits a nested TSeq(SSeq), nothing to do for partition.
  -- this partition becomes a Noop.
  -- Just need to propagate the split as a single SplitR up pipeline
  let upstream_type_rewrites = SplitR tr_no tr_io tr_ni : type_rewrites_tl
  sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr_no tr_io) : tr1@(TimeR tr_ni tr_ii) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = TimeR (tr_no*tr_ni) ((tr_no * tr_ii) + (tr_io * (tr_ni + tr_ii))) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_t_ttN tr_no tr_ni tr_io tr_ii elem_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_no tr0_io) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- output is TSeq (TSeq (SSeq)), so do a partition_t_tt on the outer part of the split
  -- partition_t_tt's element type is the inner most SSeq 
  let partition_t_tt_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) tr1_ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_t_ttN tr0_no tr1_no tr0_io tr1_io partition_t_tt_elem_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SpaceR tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- split the SplitR's inner SSeq and the SpaceR's SSeq, leave outer TSeq alone
  let upstream_type_rewrites = SplitR tr0_no tr0_io (tr0_ni*tr1_ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_map_t tr0_no tr0_io (STE.Partition_s_ssN tr0_ni tr1_ni elem_t_ppar) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(TimeR tr1_n tr1_i) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR (tr0_no*tr1_n) ((tr0_no * tr1_i) + (tr0_io * (tr1_n + tr1_i))) tr0_ni : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) (tr0_ni*tr1_ni) : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   upstream_type_rewrites producer
  add_index (STE.ReshapeN in_t_ppar out_t_ppar) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_no) : type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni io ii elem_t producer _) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- this works as parameters_match makes sure no*ni equals tr_no
  -- and unpartition must accept same no and ni regardless of invalid clocks
  let upstream_type_rewrites = SpaceR no : SpaceR ni : type_rewrites_tl
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.Unpartition_s_ssN no ni elem_t_ppar) producer

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

sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.UnpartitionN no ni io ii elem_t producer _) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  -- ppar_AST_type applies the type_rewrites to match downstream
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)

  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr

  -- rewrite inputs to get same throuhgput of output,
  -- but this can be in whatever nesting structure rewrite_AST_type chooses
  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT no io
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

-- higher order operators
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.MapN n i f producer _) |
  parameters_match tr n i = do
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
  seq_e@(SeqE.MapN n i f producer _) |
  parameters_match tr n i = do
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
  seq_e@(SeqE.MapN n i f producer _) |
  parameters_match tr n i = do
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

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  seq_e@(SeqE.Map2N n i f producer_left producer_right _) |
  parameters_match tr n i = do
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
  seq_e@(SeqE.Map2N n i f producer_left producer_right _) |
  parameters_match tr n i = do
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
  seq_e@(SeqE.Map2N n i f producer_left producer_right _) |
  parameters_match tr n i = do
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

sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.ReduceN n i f producer _) |
  parameters_match tr 1 (n+i-1) = do
  add_output_rewrite_for_node seq_e type_rewrites

  -- clear the outer input type rewrites for subgraph f
  outer_input_type_rewrites <- get_input_types_rewrites
  set_input_types_rewrites $ S.empty

  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f
  
  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr

  -- this is input rewrite for reduce and not subgraph f
  input_rewrite' <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
  let input_rewrite : _ = input_rewrite'

  -- need to know what f_ppar's input type rewrites were
  -- as those are the inner type rewrites that the map must propagate up
  f_ppar_in_rewrites_tl_set <- get_input_types_rewrites
  let f_ppar_in_rewrites_tl = input_rewrites $ head $ S.toList f_ppar_in_rewrites_tl_set
  
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  
  let upstream_type_rewrites = input_rewrite : f_ppar_in_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer

  get_scheduled_partition input_rewrite f_ppar producer_ppar
  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_partition :: Type_Rewrite -> STE.Expr -> STE.Expr -> Partially_Parallel_MemoM STE.Expr STE.Expr
    get_scheduled_partition (SpaceR in_n) f_ppar producer_ppar =
      add_index (STE.Reduce_sN in_n f_ppar) producer_ppar
    get_scheduled_partition (TimeR in_n in_i) f_ppar producer_ppar =
      add_index (STE.Reduce_tN in_n in_i f_ppar) producer_ppar
    get_scheduled_partition (SplitR in_no in_io in_ni) f_ppar producer_ppar =
      STB.make_reduce_t in_no in_io (STE.Map_sN 1 f_ppar) =<<
        STB.make_map_t in_no in_io (STE.Reduce_sN in_ni f_ppar)
        producer_ppar
    get_scheduled_partition NonSeqR _ _ = throwError $
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


  
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr0_n) : tr1@(SpaceR tr1_n) :
                                              type_rewrites_tl)
  seq_e@(SeqE.STupleToSeqN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let upstream_type_rewrites = tr0 : NonSeqR : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_map_s tr0_n (STE.STupleToSSeqN tr1_n elem_t_ppar) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_n tr0_i) : tr1@(SpaceR tr1_n) :
                                              type_rewrites_tl)
  seq_e@(SeqE.STupleToSeqN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let upstream_type_rewrites = tr0 : NonSeqR : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_map_t tr0_n tr0_i (STE.STupleToSSeqN tr1_n elem_t_ppar) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0 : tr1 : type_rewrites_tl)
  seq_e@(SeqE.STupleToSeqN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  -- ppar_AST_type applies the type_rewrites to match downstream
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)

  -- to compute how to slowed input, get the number of clocks the output takes
  -- this is a product of outer and inner periods as repeat the inner seq for
  -- each element of the outer seq
  let slowdown = get_type_rewrite_periods tr0 * get_type_rewrite_periods tr1
  -- rewrite outer seq to get same throuhgput of output,
  -- but this can be in whatever nesting structure rewrite_AST_type chooses
  -- only modifying outer seq as inner will be the STuple that occurs on one clock cycle
  input_rewrites <- lift $ rewrite_AST_type slowdown
                    (SeqT.SeqT no ((no * (ni - 1 + ii)) + (io * (ni + ii))) SeqT.IntT)
  let seq_input_rewrite : _ = input_rewrites
  -- the input is a seq of an stuple, and stuple rewrite is with NonSeqR
  let upstream_type_rewrites = seq_input_rewrite : NonSeqR : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)

  ppar_unary_seq_operator upstream_type_rewrites
    (STE.ReshapeN in_t_ppar out_t_ppar) producer

sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_no) : NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.SeqToSTupleN no ni io ii elem_t producer _) = do
  -- can't check parameters as NonSeqR carries no information
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  -- this works as parameters_match makes sure no*ni equals tr_no
  -- and unpartition must accept same no and ni regardless of invalid clocks
  let upstream_type_rewrites = SpaceR no : SpaceR ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  STB.make_map_s no (STE.SSeqToSTupleN ni elem_t_ppar) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr : NonSeqR : type_rewrites_tl)
  seq_e@(SeqE.SeqToSTupleN no ni io ii elem_t producer _) = do
  -- can't check parameters as NonSeqR carries no information
  add_output_rewrite_for_node seq_e type_rewrites
  let types = Seq_Conv.expr_to_types seq_e
  -- ppar_AST_type applies the type_rewrites to match downstream
  out_t_ppar <- ppar_AST_type type_rewrites (Seq_Conv.e_out_type types)

  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr
  --traceM $ "slowdown: " ++ show slowdown
 
  -- rewrite inputs to get same throuhgput of output,
  -- but this can be in whatever nesting structure rewrite_AST_type chooses
  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT no io
                                                      (SeqT.SeqT ni ii SeqT.IntT))
  let input_rewrite_outer : input_rewrite_inner : _ = input_rewrites
  let upstream_type_rewrites = input_rewrite_outer : input_rewrite_inner : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)

  ppar_unary_seq_operator upstream_type_rewrites
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
  " note its printed out form " ++ Seq_Print.print_seq e

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
ppar_AST_type [NonSeqR] SeqT.IntT = return STT.IntT
ppar_AST_type [NonSeqR] (SeqT.ATupleT x y) = do
  x_stt <- ppar_AST_type [NonSeqR] x
  y_stt <- ppar_AST_type [NonSeqR] y
  return $ (STT.ATupleT x_stt y_stt) 
ppar_AST_type (tr@(SpaceR tr_n) : type_rewrites_tl) (SeqT.SeqT n i t) |
  parameters_match tr n i = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.SSeqT n inner_type
ppar_AST_type (tr@(TimeR tr_n tr_i) : type_rewrites_tl) (SeqT.SeqT n i t) |
  parameters_match tr n i = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.TSeqT n tr_i inner_type
ppar_AST_type (tr@(SplitR tr_n_outer tr_i_outer tr_n_inner) : type_rewrites_tl)
  (SeqT.SeqT n i t) |
  parameters_match tr n i = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.TSeqT tr_n_outer tr_i_outer (STT.SSeqT tr_n_inner inner_type)
ppar_AST_type (NonSeqR : type_rewrites_tl) (SeqT.STupleT n t) = do
  inner_type <- ppar_AST_type type_rewrites_tl t
  return $ STT.STupleT n inner_type
ppar_AST_type type_rewrites t = throwError $ Slowdown_Failure $
  "type_rewrite " ++ show type_rewrites ++ " not valid for partially " ++
  "parallelizing AST type " ++ show t

ppar_AST_value :: [Type_Rewrite] -> SeqT.AST_Value -> Partially_Parallel_MemoM STE.Expr STT.AST_Value
ppar_AST_value [NonSeqR] SeqT.UnitV = return STT.UnitV
ppar_AST_value [NonSeqR] (SeqT.BitV b) = return (STT.BitV b)
ppar_AST_value [NonSeqR] (SeqT.IntV i) = return (STT.IntV i)
ppar_AST_value [NonSeqR] (SeqT.ATupleV x y) = do
  x_stv <- ppar_AST_value [NonSeqR] x
  y_stv <- ppar_AST_value [NonSeqR] y
  return $ (STT.ATupleV x_stv y_stv)
ppar_AST_value (tr@(SpaceR tr_n) : type_rewrites_tl) (SeqT.SeqV xs i) |
  -- just sticking IntT here as need some type that won't be looked at
  parameters_match tr (length xs) i = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  return $ STT.SSeqV xs_par
ppar_AST_value (tr@(TimeR tr_n tr_i) : type_rewrites_tl) (SeqT.SeqV xs i) |
  parameters_match tr (length xs) i = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  return $ STT.TSeqV xs_par tr_i 
ppar_AST_value (tr@(SplitR tr_n_outer tr_i_outer tr_n_inner) : type_rewrites_tl)
  (SeqT.SeqV xs i) |
  parameters_match tr (length xs) i = do
  xs_par <- mapM (ppar_AST_value type_rewrites_tl) xs
  -- split the xs into chunks where each chunk is an sseq of length
  -- tr_n_inner
  -- and then group all the sseq into one tseq
  let xs_par_chunked = chunksOf tr_n_inner xs_par
  let xs_chunks_as_sseqs = fmap STT.SSeqV xs_par_chunked
  return $ STT.TSeqV xs_chunks_as_sseqs tr_i_outer
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

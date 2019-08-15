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
  trace ("num_calls : " ++ (show $ num_calls state)) $ if isLeft expr_par
    then STE.ErrorN (rw_msg $ fromLeft undefined expr_par) No_Index
    else fromRight undefined expr_par

rewrite_to_partially_parallel' :: Int -> SeqE.Expr -> Partially_ParallelM STE.Expr
rewrite_to_partially_parallel' s seq_expr = do
  let seq_expr_out_type = Seq_Conv.e_out_type $ Seq_Conv.expr_to_types seq_expr
  output_type_slowdowns <- rewrite_AST_type s seq_expr_out_type
  trace ("output type slowdown" ++ show output_type_slowdowns ++ "\n s" ++ show s ++ "\n seq_expr_out_type" ++ show seq_expr_out_type ++ "\n") $
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
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_sN tr_n shift_amount elem_t_ppar) producer
  
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n i shift_amount elem_t producer _) |
  parameters_match tr n i = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tN tr_n tr_i shift_amount elem_t_ppar) producer

-- if only parallelism 1, then just treat it as a TSeq with an SSeq 1 input wrapping
-- the element type
sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io 1) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n i shift_amount elem_t producer _) |
  parameters_match tr n i = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  ppar_unary_seq_operator type_rewrites
    (STE.Shift_tN no io shift_amount (STT.SSeqT 1 elem_t_ppar)) producer

sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  seq_e@(SeqE.ShiftN n i shift_amount elem_t producer _) |
  parameters_match tr n i = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  producer_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites producer
  let repeated_inputs_with_index = zip [0..] $ replicate ni producer_ppar
  let inner_sseqs_shifted = fmap (
        \(i, in_seq) -> do
          (add_index $ STE.Shift_tN no io ((ni - i + shift_amount - 1) `div` ni) elem_t_ppar) =<<
            (STB.make_map_t no io (
                STE.Down_1d_sN ni ((i - shift_amount) `mod` ni) elem_t_ppar
                ) $
              in_seq)
        ) repeated_inputs_with_index
  nested_stuple_of_shifted_rows <-
        STB.repeated_stuple (STE.Map2_tN no io) inner_sseqs_shifted elem_t_ppar

  STB.make_map_t no io (STE.STupleToSSeqN ni elem_t_ppar) nested_stuple_of_shifted_rows



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
{-
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  (SeqE.Down_1dN n i sel_idx elem_t producer) |
  parameters_match tr 1 (n+i-1) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- using n here rather than tr_n as tr_n is 1, indicating sequence length,
  -- an n is for amount of downsampling. Input is of length n
  let upstream_type_rewrites = SpaceR n : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Down_1d_sN n sel_idx elem_t_ppar producer_ppar

sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  (SeqE.Down_1dN n i sel_idx elem_t producer) |
  parameters_match tr 1 (n+i-1) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- using n here rather than tr_n as tr_n is 1, indicating sequence length,
  -- an n is for amount of downsampling. Input is of length n
  -- subtract 1 from n in invalid clocks compute as n-1 is minimum number
  -- of invalid clocks on output so 0 should be min invalid clocks on input
  let upstream_type_rewrites = TimeR n (tr_i - (n-1)) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel type_rewrites producer
  return $ STE.Down_1d_tN n i sel_idx elem_t_ppar producer_ppar

-- no*ni must be 1
-- have io + 1 total clocks to do downsample
-- throughput must be n / (io + 1)
sequence_to_partially_parallel type_rewrites@(tr@(SplitR no io ni) : type_rewrites_tl)
  (SeqE.Down_1dN n i sel_idx elem_t producer) |
  parameters_match tr 1 (n+i-1) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- using n here rather than no as tr_n is 1, indicating sequence length,
  -- an n is for amount of downsampling. Input is of length n
  -- subtract 1 from n in invalid clocks compute as n-1 is minimum number
  -- of invalid clocks on output so 0 should be min invalid clocks on input
  let upstream_type_rewrites = SplitR n (io - (n-1)) ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- if io+no >= n, then fully sequential downsample with
  -- space downsample just for type helping
  if no + io >= n
    then do
    let down_outer = STE.Down_1d_tN n i sel_idx (STT.SSeqT ni elem_t_ppar) producer_ppar
    let down_inner = STE.Map_tN n i ( STB.add_input_to_expr_for_map $
                                      STE.Down_1d_sN 1 0 elem_t_ppar
                                    ) down_outer
    return down_inner
    else do
    let outer_down_amount = no + io
    let down_outer = STE.Down_1d_tN outer_down_amount 0 (sel_idx `div` outer_down_amount) (STT.SSeqT ni elem_t_ppar) producer_ppar
    let down_inner = STE.Map_tN (no+io) 0 ( STB.add_input_to_expr_for_map $
                                            STE.Down_1d_sN (n `div` outer_down_amount) (sel_idx `mod` outer_down_amount) elem_t_ppar
                                          ) down_outer
    return down_inner
 -}                                    
sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.Down_1dN n i sel_idx elem_t producer _) |
  parameters_match tr 1 (n+i-1) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr

  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
  let input_rewrite : _ = input_rewrites

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
  {-
)ddSTE.Down_1d_tN no io (sel_idx `div` no) (STT.SSeqT ni elem_t_ppar) producer_ppar
  let up_inner = STE.Map_tN no i ( STB.add_input_to_expr_for_map $
                                   STE.Up_1d_sN ni elem_t_ppar
                                 ) up_outer
  return up_inner
-}


-- Partition must accept either an SSeq, TSeq, or TSeq (SSeq) and then emit one of the 9
-- combinations below.
-- Each method composes flips with partition_t_tt and partition_s_ss to create the match
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr_no) : tr1@(SpaceR tr_ni) : type_rewrites_tl)
  seq_e@(SeqE.PartitionN no ni io ii elem_t producer _) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  add_output_rewrite_for_node seq_e type_rewrites
  elem_t_ppar <- ppar_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR (no*ni) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  add_index (STE.Partition_s_ssN tr_no tr_ni elem_t_ppar) producer_ppar

{-
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR 1) : tr1@(TimeR tr1_no tr1_io) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let add_1_t_ppar = STT.TSeqT tr1_no tr1_io elem_t_ppar
  let upstream_type_rewrites = tr1 : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Add_1_sN add_1_t_ppar producer_ppar
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr0_no) : tr1@(TimeR tr1_no tr1_io) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) = throwError $ Slowdown_Failure $
  "Type rewrites " ++ show tr0 ++ show tr1 ++
  " for partition requires a flip, which is not supported. Partition: " ++ show op
-} 
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
  
  --return $ STE.Flip_ts_to_st tr_ni tr_ii tr_no elem_t_ppar producer_ppar
{-
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR 1) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let add_1_t_ppar = STT.TSeqT tr1_no tr1_io (STT.SSeqT tr1_ni elem_t_ppar)
  let upstream_type_rewrites = tr1 : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Add_1_sN add_1_t_ppar producer_ppar
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr0_no) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) = throwError $ Slowdown_Failure $
  "Type rewrites " ++ show tr0 ++ show tr1 ++
  " for partition requires a flip, which is not supported. Partition: " ++ show op
-}   
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

{- 
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io 1) : tr1@(TimeR tr1_no tr1_io) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let add_s_t_ppar = STT.TSeqT tr1_no tr1_io elem_t_ppar
  let upstream_type_rewrites = TimeR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Map_tN tr0_no tr0_io (
    STB.add_input_to_expr_for_map $
    STE.Add_1_sN add_s_t_ppar
    ) $
    STE.Partition_t_ttN tr0_no tr1_no tr0_io tr1_io elem_t_ppar producer_ppar
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(TimeR tr1_n tr1_i) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) = throwError $ Slowdown_Failure $
  "SplitR of TimeR into Parititon requires a flip, which is not supported. " ++
  "type rewrites: " ++ show type_rewrites ++ "\n Partition: " ++ show op
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io 1) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let partition_t_tt_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  let add_s_t_ppar = STT.TSeqT tr1_no tr1_io partition_t_tt_elem_t_ppar
  let upstream_type_rewrites = SplitR (tr0_no*tr1_no) ((tr0_no * tr1_io) + (tr0_io * (tr1_no + tr1_io))) tr1_ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Map_tN tr0_no tr0_io (
    STB.add_input_to_expr_for_map $
    STE.Add_1_sN add_s_t_ppar
    ) $
    STE.Partition_t_ttN tr0_no tr1_no tr0_io tr1_io partition_t_tt_elem_t_ppar producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SplitR tr1_no tr1_io tr1_ni) : type_rewrites_tl)
  op@(SeqE.PartitionN no ni io ii elem_t producer) = throwError $ Slowdown_Failure $
  "SplitR of SplitR into Parititon requires a flip, which is not supported. " ++
  "type rewrites: " ++ show type_rewrites ++ "\n Partition: " ++ show op
-}
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
  
  ppar_unary_seq_operator upstream_type_rewrites
    (STE.ReshapeN in_t_ppar out_t_ppar) producer


{-    
sequence_to_partially_parallel type_rewrites@(tr@(SpaceR tr_n) : type_rewrites_tl)
  op@(SeqE.UnpartitionN no ni io ii elem_t producer) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = SpaceR no : SpaceR ni : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Unpartition_s_ssN no ni elem_t_ppar producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr@(TimeR tr_n tr_i) : type_rewrites_tl)
  op@(SeqE.UnpartitionN no ni io ii elem_t producer) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- parameters match ensures that no * ii + io * (ni + ii) <= tr_i
  -- so therefore, the below calculutations cannot yield too large input_io and input_ii
  -- also, no * input_ii + input_io * (ni + input_ii) = tr_i
  -- by setting either ii to 0 or io to 0 this can be solved
  if ii == 0
    then do
    let input_io = tr_i `div` ni
    let upstream_type_rewrites = TimeR no input_io : TimeR ni 0 : type_rewrites_tl
    producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
    return $ STE.Unpartition_t_ttN no ni input_io 0 elem_t_ppar producer_ppar
    else if io == 0
    then do
    let input_ii = tr_i `div` no
    let upstream_type_rewrites = TimeR no 0 : TimeR ni input_ii : type_rewrites_tl
    producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
    return $ STE.Unpartition_t_ttN no ni 0 input_ii elem_t_ppar producer_ppar
    else
    throwError $ Slowdown_Failure $ "Can't handle type rewrite " ++ show tr ++
    " and with the following unpartition as neither io nor ii are 0 :" ++
    show op
    
sequence_to_partially_parallel type_rewrites@(tr@(SplitR tr_no tr_io tr_ni) : type_rewrites_tl)
  op@(SeqE.UnpartitionN no ni io ii elem_t producer) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) &&
  -- need extra check as if this divisibility doesn't hold,
  -- would need to flip tr_no and tr_ni, which I can't do.
  (tr_no `mod` no == 0 || no `mod` tr_no == 0) = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- know that no*ni == tr_no*tr_ni
  -- So three options:
  -- 1. output time tr_no equals input no and tr_io <= io, output space tr_ni equals ni, no partitions needed
  -- 1. output time tr_no equals input no and tr_io > io (only if io == ), output space tr_ni equals ni, inner input is SplitR and outer input is TimeR. SplitR's time is just there to make invalids work 
  -- 2. output time tr_no less than input no, output space tr_ni greater than ni,
  --      in this case, need to split output space, inner input is SplitR and outer input is SpaceR
  -- 3. output time tr_no greater than input no, output space tr_ni less than ni,
  --      in this case, need to split output time, inner input is SplitR and outer input is TimeR
  if tr_no == no && tr_io <= io
    then do
    let upstream_type_rewrites = TimeR tr_no tr_io : SpaceR tr_ni : type_rewrites_tl
    producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
    return producer_ppar
    else if tr_no == no && tr_io > io
    then do
    let outer_n = tr_no
    let inner_no = 1
    let inner_io = (tr_no + tr_io) `div` outer_n - 1
    let upstream_type_rewrites = TimeR outer_n 0 : SplitR 1 inner_io tr_ni : type_rewrites_tl
    producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
    elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
    let unpartition_elem_t_ppar = STT.SSeqT tr_ni elem_t_ppar
    return $ STE.Unpartition_t_ttN outer_n inner_no 0 inner_io unpartition_elem_t_ppar producer_ppar
    else if tr_no < no
    then do
    -- this may lead to extra invalids on outer input
    -- which will lead to issues if inner input is produced by downsample
    -- But no other efficient way to handle the case
    let outer_ni = no `div` tr_no
    let inner_n = ni `div` outer_ni
    let upstream_type_rewrites = SplitR no tr_io outer_ni : SpaceR inner_n : type_rewrites_tl
    producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
    return $ STE.Map_tN no tr_io (
      STB.add_input_to_expr_for_map $
      STE.Unpartition_s_ssN outer_ni inner_n elem_t_ppar
      ) producer_ppar
    else do
    let inner_no = ni `div` tr_ni
    -- the below let is a convoluted way of producing outer_n = no
    -- let outer_n = tr_no `div` inner_no
    let outer_n = no
    elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
    let unpartition_elem_t_ppar = STT.SSeqT tr_ni elem_t_ppar
    if ii == 0
      then do
      let input_io = tr_io `div` inner_no
      let upstream_type_rewrites = TimeR outer_n input_io : SplitR inner_no 0 tr_ni : type_rewrites_tl
      producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
      return $ STE.Unpartition_t_ttN outer_n inner_no input_io 0 unpartition_elem_t_ppar producer_ppar
      else if io == 0
      then do
      let input_ii = tr_io `div` outer_n
      let upstream_type_rewrites = TimeR outer_n 0 : SplitR inner_no input_ii tr_ni : type_rewrites_tl
      producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
      return $ STE.Unpartition_t_ttN outer_n inner_no 0 input_ii unpartition_elem_t_ppar producer_ppar
      else
      throwError $ Slowdown_Failure $ "Can't handle type rewrite " ++ show tr ++
      " and with the following unpartition as neither io nor ii are 0 :" ++
      show op
      {-
      then do
      let input_io = div tr_i ni
      let upstream_type_rewrites = TimeR outer_n input_io : SplitR inner_no 0 inner_n : type_rewrites_tl
      producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
      return $ STE.Unpartition_t_ttN outer_n inner_no input_io 0 unpartition_elem_t_ppar producer_ppar
      else if ii == 0
      then do
-}
      
     
      
  
    {-
  -- to compute how to slowdown input, get number of clocks for output 
  let slowdown = get_type_rewrite_periods tr

  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT no io (SeqT.SeqT ni ii SeqT.IntT))
  let (outer_input_rewrite : inner_input_rewrite : _) = input_rewrites
  
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = outer_input_rewrite : inner_input_rewrite : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
 -} 

  --trace (show type_rewrites) $ trace (show op) $ trace (show input_rewrites) $
  --get_scheduled_unpartition outer_input_rewrite inner_input_rewrite elem_t_ppar producer_ppar
{-
  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_unpartition :: Type_Rewrite -> Type_Rewrite -> STT.AST_Type -> STE.Expr -> Partially_Parallel_StateM STE.Expr
    get_scheduled_unpartition (SpaceR in0_n) (SpaceR in1_n) elem_t_ppar producer_ppar =
      return $ STE.Unpartition_s_ssN in0_n in1_n elem_t_ppar producer_ppar
    get_scheduled_unpartition (SpaceR 1) (TimeR in1_no in1_io) elem_t_ppar producer_ppar = do
      let remove_1_t_ppar = STT.TSeqT in1_no in1_io elem_t_ppar 
      return $ STE.Remove_1_sN remove_1_t_ppar producer_ppar
    get_scheduled_unpartition (SpaceR 1) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let remove_1_t_ppar = STT.TSeqT in1_no in1_io (STT.SSeqT in1_ni elem_t_ppar)
      return $ STE.Remove_1_sN remove_1_t_ppar producer_ppar
      {-
    get_scheduled_unpartition (SpaceR in0_n) (TimeR in1_n in1_i) elem_t_ppar producer_ppar =
      return $ STE.Flip_st_to_ts in1_n in1_i in0_n elem_t_ppar producer_ppar
    get_scheduled_unpartition (SpaceR in0_n) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let flip_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Map_tN in1_no in1_io (STB.add_input_to_expr_for_map $ 
                                         STE.Unpartition_s_ssN in0_n in1_ni elem_t_ppar) $
        STE.Flip_st_to_ts in1_no in1_io in0_n flip_elem_t_ppar producer_ppar
-}
    get_scheduled_unpartition (TimeR in0_n in0_i) (SpaceR in1_n) elem_t_ppar producer_ppar = do
      return producer_ppar
    get_scheduled_unpartition (TimeR in0_n in0_i) (TimeR in1_n in1_i) elem_t_ppar producer_ppar = 
      return $ STE.Unpartition_t_ttN in0_n in1_n in0_i in1_i elem_t_ppar producer_ppar
    get_scheduled_unpartition (TimeR in0_n in0_i) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let unpartition_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Unpartition_t_ttN in0_n in1_no in0_i in1_io unpartition_elem_t_ppar producer_ppar
    get_scheduled_unpartition (SplitR in0_no in0_io in0_ni) (SpaceR in1_n) elem_t_ppar producer_ppar = do
      return $ STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                         STE.Unpartition_s_ssN in0_ni in1_n elem_t_ppar)
        producer_ppar
    get_scheduled_unpartition (SplitR in0_no in0_io 1) (TimeR in1_no in1_io) elem_t_ppar producer_ppar = do
      let remove_1_t_ppar = STT.TSeqT in1_no in1_io elem_t_ppar 
      return $ STE.Unpartition_t_ttN in0_no in1_no in0_io in1_io elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $
                                  STE.Remove_1_sN remove_1_t_ppar)
        producer_ppar
    get_scheduled_unpartition (SplitR in0_no in0_io 1) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let unpartition_t_tt_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      let remove_1_t_ppar = STT.TSeqT in1_no in1_io unpartition_t_tt_elem_t_ppar 
      return $ STE.Unpartition_t_ttN in0_no in1_no in0_io in1_io unpartition_t_tt_elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $
                                  STE.Remove_1_sN remove_1_t_ppar)
        producer_ppar
        {-
    get_scheduled_unpartition (SplitR in0_no in0_io in0_ni) (TimeR in1_n in1_i) elem_t_ppar producer_ppar = do
      let unpartition_elem_t_ppar = STT.SSeqT in0_ni elem_t_ppar
      return $ STE.Unpartition_t_ttN in0_ni in1_n in0_io in1_i unpartition_elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                   STE.Flip_st_to_ts in1_n in1_i in0_ni elem_t_ppar) $
        producer_ppar
    get_scheduled_unpartition (SplitR in0_no in0_io in0_ni) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let unpartition_t_tt_elem_t_ppar = STT.SSeqT in0_ni (STT.SSeqT in1_ni elem_t_ppar)
      let flip_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Map_tN (in0_no*in1_no) (Seq_Conv.invalid_clocks_from_nested in0_no in1_no in0_io in1_io) (
        STB.add_input_to_expr_for_map $ STE.Unpartition_s_ssN in0_ni in1_ni elem_t_ppar
        ) $
        STE.Unpartition_t_ttN in0_no in1_no in0_io in1_io unpartition_t_tt_elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                   STE.Flip_st_to_ts in1_no in1_io in0_ni flip_elem_t_ppar) $
        producer_ppar
-}
    get_scheduled_unpartition NonSeqR _ _ _ = throwError $
      Slowdown_Failure "can't get nonseq for unpartition input"
    get_scheduled_unpartition _ NonSeqR _ _ = throwError $
      Slowdown_Failure "can't get nonseq for unpartition input"
    get_scheduled_unpartition tr0 tr1 elem_t_ppar _ = throwError $ Slowdown_Failure $
      show op ++ "\n with the outer input type rewrite " ++ show tr0 ++
      " and inner input type rewrite " ++ show tr1 ++ " requires a flip, which is not supported."
-}
-}
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
  producer_ppar <- sequence_to_partially_parallel_with_reshape
                   (tr : f_ppar_in_rewrites_tl) producer
  STB.make_map_t tr_no tr_io (STE.Map_sN tr_ni f_ppar) producer_ppar

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
  -- reset the input type rewrites for the current graph
  set_input_types_rewrites outer_input_type_rewrites
  producer_left_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_l) producer_left
  producer_right_ppar <- sequence_to_partially_parallel_with_reshape
                        (tr : f_ppar_in_rewrites_tl_r) producer_right
  inner_map_s <- STB.add_input_to_expr_for_map2 $ STE.Map2_sN tr_ni f_ppar
  outer_map2_idx <- get_cur_index
  return $ STE.Map2_tN tr_no tr_io inner_map_s
    producer_left_ppar producer_right_ppar outer_map2_idx

sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  seq_e@(SeqE.ReduceN n i f producer _) |
  parameters_match tr 1 (n+i-1) = do
  add_output_rewrite_for_node seq_e type_rewrites
  -- to compute how to slowed input, get the number of clocks the output takes
  let slowdown = get_type_rewrite_periods tr

  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT n i SeqT.IntT)
  let input_rewrite : _ = input_rewrites

  let upstream_type_rewrites = input_rewrite : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel_with_reshape upstream_type_rewrites producer
  f_ppar <- sequence_to_partially_parallel_with_reshape type_rewrites_tl f

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

{-
{-
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr0_n) : tr1@(TimeR tr1_n tr1_i) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let upstream_type_rewrites = SplitR 1 (tr1_i + tr1_n - 1) tr0_n : NonSeqR : type_rewrites_tl
  let flip_elem_t_ppar = STT.SSeqT tr1_n elem_t_ppar
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- producing cirucit where all the invalid clocks needed by the inner TimeR output
  -- are provided by the outer TSeq input. Since the outer output is a space,
  -- the outer input must be a SplitR 
  -- map_t 1 (tr1_i + (tr1_n - 1)) (map_s tr0_n (STupleToSSeq tr1_n)) >>>
  -- flip_ts_to_st (sseq tr1_n) >>>
  -- map_s tr0_n (Serialize tr1_n tr1_i)
  -- the input is a TSeq 1 (tr1_i + (tr1_n) - 1) (SSeq tr0_n (STuple tr1_n))
  -- as the output only has tr1_n + tr1_i clocks and tr0_n elements
  return $ STE.Map_sN tr0_n (STB.add_input_to_expr_for_map $
                             STE.SerializeN tr1_n tr1_i elem_t_ppar) $
    STE.Flip_ts_to_st 1 (tr1_i + (tr1_n - 1)) tr0_n flip_elem_t_ppar $
    STE.Map_tN 1 (tr1_i + (tr1_n - 1)) (STB.add_input_to_expr_for_map $
                                       STE.Map_sN tr0_n (
                                           STB.add_input_to_expr_for_map $
                                           STE.STupleToSSeqN tr1_n elem_t_ppar
                                           )
                                       ) producer_ppar
  
sequence_to_partially_parallel type_rewrites@(tr0@(SpaceR tr0_n) : tr1@(SplitR tr1_no tr1_io tr1_ni) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  -- the SplitR doesn't need tr1_ni in it's invalid inputted clocks as those are emitted
  -- in parallel
  let upstream_type_rewrites = SplitR 1 (tr1_io + tr1_no - 1) tr0_n : NonSeqR : type_rewrites_tl
  let flip_elem_t_ppar = STT.SSeqT (tr1_no * tr1_ni) elem_t_ppar
  let serialize_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- producing cirucit where all the invalid clocks needed by the inner SplitR output
  -- are provided by the outer TSeq input. Since the outer output is a space,
  -- the outer input must be a SplitR
  -- difference between this pattern (SpaceR SplitR) and the above (SpaceR TimeR)
  -- is that the STuple has elements that are split to become both the Split
  -- map_t 1 (tr1_io + (tr1_no - 1)) (map_s tr0_n (STupleToSSeq (tr1_no * tr1_ni))) >>>
  -- flip_ts_to_st (sseq (tr1_no * tr1_ni)) >>>
  -- map_s tr0_no (
  --               map_t 1 (tr1_io + (tr1_no - 1)) (Partition_s_ss tr1_no tr1_ni) >>>
  --               Serialize tr1_no tr1_io (sseq tr1_ni elem_t))
  -- the input is a TSeq 1 (tr1_i + (tr1_n) - 1) (SSeq tr0_n)
  -- as the output only has tr1_n + tr1_i clocks and tr0_n elements
  return $ STE.Map_sN tr0_n (STE.SerializeN tr1_no tr1_io serialize_elem_t_ppar $
                             STB.add_input_to_expr_for_map $
                             STE.Map_tN 1 (tr1_io + (tr1_no - 1)) (
                                STB.add_input_to_expr_for_map $
                                STE.Partition_s_ssN tr1_no tr1_ni elem_t_ppar)) $
    STE.Flip_ts_to_st 1 (tr1_io + (tr1_no - 1)) tr0_n flip_elem_t_ppar $
    STE.Map_tN 1 (tr1_io + (tr1_no - 1)) (STB.add_input_to_expr_for_map $
                                          STE.Map_sN tr0_n (
                                             STB.add_input_to_expr_for_map $
                                             STE.STupleToSSeqN (tr1_no * tr1_ni) elem_t_ppar
                                             )
                                         ) producer_ppar
 -}   
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_n tr0_i) : tr1@(SpaceR tr1_n) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let upstream_type_rewrites = tr0 : NonSeqR : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Map_tN tr0_n tr0_i (STB.add_input_to_expr_for_map $
                                   STE.STupleToSSeqN tr1_n elem_t_ppar) producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_n tr0_i) : tr1@(TimeR tr1_n tr1_i) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let input_invalid_clocks =
        Seq_Conv.invalid_clocks_from_nested tr0_n 1 tr0_i (tr1_i + (tr1_n - 1))
  let upstream_type_rewrites = TimeR tr0_n input_invalid_clocks : NonSeqR : type_rewrites_tl
  let partition_elem_t_ppar = STT.SSeqT tr1_n elem_t_ppar
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- producing cirucit where all the invalid clocks needed by the inner TimeR output
  -- are provided by the outer TSeq input. Since the outer output is a TimeR,
  -- the outer input must be a TimeR that is partitioned by the circuit
  -- partition_t_tt tr0_n 1 tr0_i (tr1_i + (tr_n - 1)) ::
  --     tr0_n (invalid_clocks_from_nested tr0_n 1 tr0_i (tr1_i + (tr1_n - 1))) ->
  --     TSeq tr0_n tr0_i (TSeq 1 (tr1_i + (tr_n - 1)))
  -- the circuit is:
  -- map_t tr0_n (invalid_clocks_from_nested tr0_n 1 tr0_i (tr1_i + (tr_n - 1)))
  --             (STupleToSSeq tr1_n) >>>
  -- partition_t_tt tr0_n 1 tr0_i (tr1_i + (tr1_n - 1)) (sseq tr1_n) >>>
  -- map_t tr0_n tr0_i (Serialize tr1_n tr1_i)
  return $ STE.Map_tN tr0_n tr0_i (STB.add_input_to_expr_for_map $
                                   STE.SerializeN tr1_n tr1_i elem_t_ppar) $
    STE.Partition_t_ttN tr0_n 1 tr0_i (tr1_i + (tr1_n - 1)) partition_elem_t_ppar $
    STE.Map_tN tr0_n input_invalid_clocks (STB.add_input_to_expr_for_map $
                                           STE.STupleToSSeqN tr1_n elem_t_ppar
                                           ) producer_ppar
    
sequence_to_partially_parallel type_rewrites@(tr0@(TimeR tr0_n tr0_i) :
                                              tr1@(SplitR tr1_no tr1_io tr1_ni) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  -- the TimeR doesn't consider tr1_ni as those are emitted in parallel by the
  -- STupleToSSeq
  let input_invalid_clocks =
        Seq_Conv.invalid_clocks_from_nested tr0_n 1 tr0_i (tr1_io + (tr1_no - 1))
  let upstream_type_rewrites = TimeR tr0_n input_invalid_clocks : NonSeqR : type_rewrites_tl
  let partition_elem_t_ppar = STT.SSeqT (tr1_no*tr1_ni) elem_t_ppar
  let serialize_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- producing cirucit where all the invalid clocks needed by the inner SplitR output
  -- are provided by the outer TSeq input. Since the outer output is a TimeR,
  -- the outer input must be a TimeR
  -- difference between this pattern (TimeR SplitR) and the above (TimeR TimeR)
  -- is that the STuple has elements that are split to become both the Split components
  -- the circuit is:
  -- map_t tr0_n (invalid_clocks_from_nested tr0_n 1 tr0_i (tr1_io + (tr1_no - 1)))
  --             (STupleToSSeq (tr1_no*tr1_ni)) >>>
  -- partition_t_tt tr0_n 1 tr0_i (tr1_io + (tr1_no - 1)) (sseq (tr1_no*tr1_ni)) >>>
  -- map_t tr0_n tr0_i (
  --               map_t 1 (tr1_io + (tr1_no - 1)) (Partition_s_ss tr1_no tr1_ni) >>>
  --               Serialize tr1_no tr1_io (sseq tr1_ni elem_t))
  return $ STE.Map_tN tr0_n tr0_i (STE.SerializeN tr1_no tr1_io serialize_elem_t_ppar $
                                   STB.add_input_to_expr_for_map $
                                   STE.Map_tN 1 (tr1_io + (tr1_no - 1)) (
                                      STB.add_input_to_expr_for_map $
                                      STE.Partition_s_ssN tr1_no tr1_ni elem_t_ppar)) $
    STE.Partition_t_ttN tr0_n 1 tr0_i (tr1_io + (tr1_no - 1)) partition_elem_t_ppar $
    STE.Map_tN tr0_n input_invalid_clocks (STB.add_input_to_expr_for_map $
                                            STE.STupleToSSeqN (tr1_no * tr1_ni) elem_t_ppar
                                          ) producer_ppar

sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SpaceR tr1_n) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let upstream_type_rewrites = tr0 : NonSeqR : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  return $ STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                                    STE.Map_sN tr0_ni (
                                        STB.add_input_to_expr_for_map $
                                        STE.STupleToSSeqN tr1_n elem_t_ppar
                                        )
                                   ) producer_ppar

{-
sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(TimeR tr1_n tr1_i) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let input_invalid_clocks =
        Seq_Conv.invalid_clocks_from_nested tr0_no 1 tr0_io (tr1_i + (tr1_n - 1))
  let upstream_type_rewrites = SplitR tr0_no input_invalid_clocks tr0_ni : NonSeqR : type_rewrites_tl
  let flip_elem_t_ppar = STT.SSeqT tr1_n elem_t_ppar
  let partition_elem_t_ppar = STT.SSeqT tr0_ni (STT.SSeqT tr1_n elem_t_ppar)
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- producing cirucit where all the invalid clocks needed by the inner TimeR output
  -- are provided by the outer TSeq input. Since the outer output is a SplitR,
  -- the outer input must be a SplitR that is partitioned by the circuit
  -- partition_t_tt tr0_no 1 tr0_io (tr1_i + (tr_n - 1)) ::
  --     tr0_no (invalid_clocks_from_nested tr0_no 1 tr0_io (tr1_i + (tr1_n - 1))) ->
  --     TSeq tr0_no tr0_io (TSeq 1 (tr1_i + (tr_n - 1)))
  -- the circuit is:
  -- map_t tr0_no (invalid_clocks_from_nested tr0_no 1 tr0_io (tr1_i + (tr1_n - 1)))
  --             map_s tr0_ni ((STupleToSSeq tr1_n)) >>>
  -- partition_t_tt tr0_n 1 tr0_i (tr1_i + (tr1_n - 1)) (sseq tr0_ni (sseq tr1_n)) >>>
  -- map_t tr0_no tr0_io (flip_ts_to_st 1 (tr1_i + (tr1_n - 1)) tr0_ni)
  -- map_t tr0_no tr0_io (map_s tr0_ni (Serialize tr1_n tr1_i))
  return $ STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                                     STE.Map_sN tr0_ni (
                                        STB.add_input_to_expr_for_map $
                                        STE.SerializeN tr1_n tr1_i elem_t_ppar
                                        )
                                    ) $
    STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                              STE.Flip_ts_to_st 1 (tr1_i + (tr1_n - 1)) tr0_ni flip_elem_t_ppar) $
    STE.Partition_t_ttN tr0_no 1 tr0_io (tr1_i + (tr1_n - 1)) partition_elem_t_ppar $
    STE.Map_tN tr0_no input_invalid_clocks (STB.add_input_to_expr_for_map $
                                           STE.Map_sN tr0_ni (
                                               STB.add_input_to_expr_for_map $
                                               STE.STupleToSSeqN tr1_n elem_t_ppar
                                                         )
                                           ) producer_ppar


sequence_to_partially_parallel type_rewrites@(tr0@(SplitR tr0_no tr0_io tr0_ni) : tr1@(SplitR tr1_no tr1_io tr1_ni) :
                                              type_rewrites_tl)
  (SeqE.STupleToSeqN no ni io ii elem_t producer) |
  parameters_match tr0 no io && parameters_match tr1 ni ii = do
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  -- the stuple input is not a seq, so no type rewrite, so its a NonSeqR
  let input_invalid_clocks =
        Seq_Conv.invalid_clocks_from_nested tr0_no 1 tr0_io (tr1_io + (tr1_no - 1))
  let upstream_type_rewrites = SplitR tr0_no input_invalid_clocks tr0_ni : NonSeqR : type_rewrites_tl
  let flip_elem_t_ppar = STT.SSeqT (tr1_no*tr1_ni) elem_t_ppar
  let partition_elem_t_ppar = STT.SSeqT tr0_ni (STT.SSeqT (tr1_no*tr1_ni) elem_t_ppar)
  let serialize_elem_t_ppar = STT.SSeqT tr1_ni elem_t_ppar
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer
  -- producing cirucit where all the invalid clocks needed by the inner TimeR output
  -- are provided by the outer TSeq input. Since the outer output is a SplitR,
  -- the outer input must be a SplitR that is partitioned by the circuit
  -- partition_t_tt tr0_no 1 tr0_io (tr1_i + (tr_n - 1)) ::
  --     tr0_no (invalid_clocks_from_nested tr0_no 1 tr0_io (tr1_i + (tr1_n - 1))) ->
  --     TSeq tr0_no tr0_io (TSeq 1 (tr1_i + (tr_n - 1)))
  -- the circuit is:
  -- map_t tr0_no (invalid_clocks_from_nested tr0_no 1 tr0_io (tr1_i + (tr1_n - 1)))
  --             map_s tr0_ni ((STupleToSSeq (tr1_no*tr1_n1))) >>>
  -- partition_t_tt tr0_n 1 tr0_i (tr1_i + (tr1_n - 1)) (sseq tr0_ni (sseq (tr1_no*tr1_ni))) >>>
  -- map_t tr0_no tr0_io (flip_ts_to_st 1 (tr1_i + (tr1_n - 1)) tr0_ni)
  -- map_t tr0_no tr0_io (map_s tr0_ni (
  --               map_t 1 (tr1_io + (tr1_no - 1)) (Partition_s_ss tr1_no tr1_ni) >>>
  --               Serialize tr1_no tr1_io (sseq tr1_ni elem_t)
  --               )
  return $ STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                                     STE.Map_sN tr0_ni (STE.SerializeN tr1_no tr1_io serialize_elem_t_ppar $
                                                        STB.add_input_to_expr_for_map $
                                                        STE.Map_tN 1 (tr1_io + (tr1_no - 1)) (
                                                           STB.add_input_to_expr_for_map $
                                                           STE.Partition_s_ssN tr1_no tr1_ni elem_t_ppar)
                                                       )
                                    ) $
    STE.Map_tN tr0_no tr0_io (STB.add_input_to_expr_for_map $
                              STE.Flip_ts_to_st 1 (tr1_io + (tr1_no - 1)) tr0_ni flip_elem_t_ppar) $
    STE.Partition_t_ttN tr0_no 1 tr0_io (tr1_io + (tr1_no - 1)) partition_elem_t_ppar $
    STE.Map_tN tr0_no input_invalid_clocks (STB.add_input_to_expr_for_map $
                                           STE.Map_sN tr0_ni (
                                               STB.add_input_to_expr_for_map $
                                               STE.STupleToSSeqN (tr1_no*tr1_ni) elem_t_ppar
                                                         )
                                           ) producer_ppar
-}
-}
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
 
  -- rewrite inputs to get same throuhgput of output,
  -- but this can be in whatever nesting structure rewrite_AST_type chooses
  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT no io
                                                      (SeqT.SeqT ni ii SeqT.IntT))
  let input_rewrite_outer : input_rewrite_inner : _ = input_rewrites
  let upstream_type_rewrites = input_rewrite_outer : input_rewrite_inner : type_rewrites_tl
  in_t_ppar <- ppar_AST_type upstream_type_rewrites (head $ Seq_Conv.e_in_types types)

  ppar_unary_seq_operator upstream_type_rewrites
    (STE.ReshapeN in_t_ppar out_t_ppar) producer
{-
    
sequence_to_partially_parallel type_rewrites@(tr : type_rewrites_tl)
  (SeqE.SeqToSTupleN no ni io ii elem_t producer) |
  parameters_match tr (no*ni) (Seq_Conv.invalid_clocks_from_nested no ni io ii) = do
  -- to compute how to slowdown input, get the amount output is slowed 
  let slowdown = get_type_rewrite_periods tr

  input_rewrites <- lift $ rewrite_AST_type slowdown (SeqT.SeqT no io (SeqT.SeqT ni ii SeqT.IntT))
  let (outer_input_rewrite : inner_input_rewrite : _) = input_rewrites
  
  elem_t_ppar <- part_par_AST_type type_rewrites_tl elem_t
  let upstream_type_rewrites = outer_input_rewrite : inner_input_rewrite : type_rewrites_tl
  producer_ppar <- sequence_to_partially_parallel upstream_type_rewrites producer

  get_scheduled_seq_to_stuple outer_input_rewrite inner_input_rewrite elem_t_ppar producer_ppar
  where
    -- note: these type_rewrites represent how the input is rewritten, not the output
    -- like all the type_rewrites passed to sequence_to_partially_parallel
    get_scheduled_seq_to_stuple :: Type_Rewrite -> Type_Rewrite -> STT.AST_Type -> STE.Expr -> Partially_Parallel_StateM STE.Expr
    get_scheduled_seq_to_stuple (SpaceR in0_n) (SpaceR in1_n) elem_t_ppar producer_ppar =
      return $ STE.Map_sN in0_n (STB.add_input_to_expr_for_map $
                                 STE.SSeqToSTupleN in1_n elem_t_ppar) producer_ppar
     {- 
    get_scheduled_seq_to_stuple (SpaceR in0_n) (TimeR in1_n in1_i) elem_t_ppar producer_ppar = do

      -- after deserializing, inner TSeq input becomes a TSeq (SSeq) where
      -- all clocks are invalid but the first
      let post_deser_invalid_clocks = in1_i + (in1_n - 1)
      let flip_elem_t_ppar = STT.STupleT in1_n elem_t_ppar
      return $ STE.Flip_st_to_ts 1 post_deser_invalid_clocks in0_n flip_elem_t_ppar $
        STE.Map_sN in0_n (STE.Map_tN 1 post_deser_invalid_clocks (
                             STB.add_input_to_expr_for_map $
                             STE.SSeqToSTupleN in1_n elem_t_ppar
                             ) $
                          STB.add_input_to_expr_for_map $
                          STE.DeserializeN in1_n in1_i elem_t_ppar) producer_ppar
        
    get_scheduled_seq_to_stuple (SpaceR in0_n) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do

      -- input is SSeq (TSeq (SSeq))
      -- after deserializing TSeq, need to merge inner most SSeqs
      -- and the flip the TSeq 1 (in1_io + (in1_no - 1)) to outside of all other sseqs
      -- all clocks are invalid but the first
      let post_deser_invalid_clocks = in1_io + (in1_no - 1)
      let deser_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      let flip_elem_t_ppar = STT.STupleT (in1_no*in1_ni) elem_t_ppar
      return $ STE.Flip_st_to_ts 1 post_deser_invalid_clocks in0_n flip_elem_t_ppar $
        STE.Map_sN in0_n (STE.Map_tN 1 post_deser_invalid_clocks (
                             STE.SSeqToSTupleN (in1_no*in1_ni) elem_t_ppar $
                             STB.add_input_to_expr_for_map $
                             STE.Unpartition_s_ssN in1_no in1_ni elem_t_ppar
                             ) $
                          STB.add_input_to_expr_for_map $
                          STE.DeserializeN in1_no in1_io deser_elem_t_ppar) producer_ppar
      -}  
    get_scheduled_seq_to_stuple (TimeR in0_n in0_i) (SpaceR in1_n) elem_t_ppar producer_ppar =
      return $ STE.Map_tN in0_n in0_i (STB.add_input_to_expr_for_map $
                                       STE.SSeqToSTupleN in1_n elem_t_ppar) producer_ppar
      
    get_scheduled_seq_to_stuple (TimeR in0_n in0_i) (TimeR in1_n in1_i) elem_t_ppar producer_ppar = do

      -- after deserializing, inner TSeq input becomes a TSeq (SSeq) where
      -- all clocks are invalid but the first
      let post_deser_inner_invalid_clocks = in1_i + (in1_n - 1)
      let unpartition_elem_t_ppar = STT.STupleT in1_n elem_t_ppar
      return $
        STE.Unpartition_t_ttN in0_n 1 in0_i post_deser_inner_invalid_clocks unpartition_elem_t_ppar $
        STE.Map_tN in0_n in0_i (STE.Map_tN 1 post_deser_inner_invalid_clocks (
                                   STB.add_input_to_expr_for_map $
                                   STE.SSeqToSTupleN in1_n elem_t_ppar
                                   ) $
                                STB.add_input_to_expr_for_map $
                                STE.DeserializeN in1_n in1_i elem_t_ppar) producer_ppar
        
      {-
-- THIS ONE WAS WRITTEN BUT IS WRONG
    get_scheduled_seq_to_stuple (TimeR in0_n in0_i) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do

      -- after deserializing, inner TSeq input becomes a TSeq (SSeq) where
      -- all clocks are invalid but the first
      let post_deser_inner_invalid_clocks = in1_io + (in1_no - 1)
      let unpartition_elem_t_ppar = STT.STupleT (in1_no*in1_ni) elem_t_ppar
      return $
        STE.Unpartition_t_ttN in0_n 1 in0_i post_deser_inner_invalid_clocks unpartition_elem_t_ppar $
        STE.Map_tN in0_n in0_i (STE.Map_tN 1 post_deser_inner_invalid_clocks (
                                   STB.add_input_to_expr_for_map $
                                   STE.SSeqToSTupleN in1_n elem_t_ppar
                                   ) $
                                STB.add_input_to_expr_for_map $
                                STE.DeserializeN in1_n in1_i elem_t_ppar) producer_ppar


    get_scheduled_seq_to_stuple (TimeR in0_n in0_i) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let unpartition_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Unpartition_t_ttN in0_n in1_no in0_i in1_ni unpartition_elem_t_ppar producer_ppar
    get_scheduled_seq_to_stuple (SplitR in0_no in0_io in0_ni) (SpaceR in1_n) elem_t_ppar producer_ppar = do
      return $ STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                         STE.Unpartition_s_ssN in0_ni in1_n elem_t_ppar)
        producer_ppar
    get_scheduled_seq_to_stuple (SplitR in0_no in0_io in0_ni) (TimeR in1_n in1_i) elem_t_ppar producer_ppar = do
      let unpartition_elem_t_ppar = STT.SSeqT in0_ni elem_t_ppar
      return $ STE.Unpartition_t_ttN in0_ni in1_n in0_io in1_i unpartition_elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                   STE.Flip_st_to_ts in1_n in1_i in0_ni elem_t_ppar) $
        producer_ppar
    get_scheduled_seq_to_stuple (SplitR in0_no in0_io in0_ni) (SplitR in1_no in1_io in1_ni) elem_t_ppar producer_ppar = do
      let unpartition_t_tt_elem_t_ppar = STT.SSeqT in0_ni (STT.SSeqT in1_ni elem_t_ppar)
      let flip_elem_t_ppar = STT.SSeqT in1_ni elem_t_ppar
      return $ STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ STE.Map_tN in1_no in1_io $
                                         STB.add_input_to_expr_for_map $ STE.Unpartition_s_ssN in0_ni in1_ni elem_t_ppar
                                        ) $
        STE.Unpartition_t_ttN in0_no in1_no in0_io in1_io unpartition_t_tt_elem_t_ppar $
        STE.Map_tN in0_no in0_io (STB.add_input_to_expr_for_map $ 
                                   STE.Flip_st_to_ts in1_no in1_io in0_ni flip_elem_t_ppar) $
        producer_ppar
    get_scheduled_seq_to_stuple NonSeqR _ _ _ = throwError $
      Slowdown_Failure "can't get nonseq for unpartition input"
    get_scheduled_seq_to_stuple _ NonSeqR _ _ = throwError $
      Slowdown_Failure "can't get nonseq for unpartition input"



sequence_to_partially_parallel (SeqE.SeqToSTupleN no ni io ii elem_t producer) = do
  t_par <- parallelize_AST_type elem_t
  producer_par <- sequence_to_partially_parallel producer
  return $ STE.Map_sN no (STE.SSeqToSTupleN ni t_par
                          -- need to wrap t_par for input as STuple takes
                          -- in an stuple of elements
                          (STE.InputN (STT.SSeqT ni t_par) "seq_in")) producer_par

-}
-}
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
  traceM $ "cur call count: " ++ show nc ++ " with seq producer index: " ++ (show $ get_index producer) ++ (show time)
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

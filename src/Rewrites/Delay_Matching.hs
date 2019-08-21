module Aetherling.Rewrites.Delay_Matching where
{-
import Aetherling.ASTs.Space_Time
import Aetherling.Types.Declarations
import Aetherling.Helpers.DAG_Helpers
import qualified Data.Map as M

data Clock_Word = Clock_Word {clks :: [Bool]} deriving (Show, Eq)

type CT_Var_Index = Int

data Clock_Type =
  CT_Var {ct_var_index :: CT_Var_Index}
  | CT_Word {ct_word :: Clock_Word}
  deriving (Show, Eq)

data Clock_Signature =
  Clock_Signature {in_ct :: Clock_Type, out_ct :: Clock_Type,
                   -- the delays are clock cycles from start of circuit
                   -- to start of each clock type
                   in_delay :: Int, out_delay :: Int
  }
  deriving (Show, Eq)

-- | return the next clock type index (if this clock signature has any
-- variables) or Nothing
get_next_index :: Clock_Signature -> Maybe CT_Var_Index
get_next_index (Clock_Signature (CT_Var n) (CT_Var m) _ _) = Just $ (max n m) + 1
get_next_index (Clock_Signature _ (CT_Var m) _ _) = Just $ m + 1
get_next_index (Clock_Signature (CT_Var n) _ _ _) = Just $ n + 1
get_next_index _ = Nothing

one_ct_variable next_index cur_delay =
  Clock_Signature (CT_Var next_index) (CT_Var next_index) cur_delay cur_delay

two_ct_variables next_index cur_delay =
  Clock_Signature (CT_Var next_index) (CT_Var (next_index + 1)) cur_delay cur_delay

-- | Return the clock word for an Aetherling type.
-- A type from this word combined with another type becomes a clock signature.
-- The default clock type is used when the function is not clearly more optimal
-- (aka lower hardware utilization) with another clock type
type_clock_word :: AST_Type -> Clock_Word
type_clock_word UnitT = Clock_Word [True]
type_clock_word IntT = Clock_Word [True]
type_clock_word BitT = Clock_Word [True]
type_clock_word (ATupleT _ _) = Clock_Word [True]
type_clock_word (STupleT _ elem_w) = type_clock_word elem_w
-- Seq's aren'word Space-Time IR, so no clock signature
type_clock_word (SeqT _ _ _) = undefined
type_clock_word (SSeqT _ elem_w) = type_clock_word elem_w
type_clock_word (TSeqT n v elem_w) =
  Clock_Word $ replicated_elem_w_clock_type ++ invalid_replicated
  where
    elem_w_clocks = clks $ type_clock_word elem_w
    -- repeat elem_w's clock type n times
    replicated_elem_w_clock_type = concat $ replicate n elem_w_clocks
    -- then replicat 0 equal to len(elem_w clock_type) * v
    invalid_replicated = concat $ replicate v $ replicate (length elem_w_clocks) False

type_clock_signature :: AST_Type -> AST_Type -> Int -> Int -> Clock_Signature
type_clock_signature in_t out_t in_delay out_delay =
  Clock_Signature in_clock_type out_clock_type in_delay out_delay
  where
    in_clock_type = CT_Word $ type_clock_word in_t
    out_clock_type = CT_Word $ type_clock_word out_t

type ST_Clock_Sigs = M.Map DAG_Index Clock_Signature

-- | given a ST_Clock_Sigs dag and a list of indices, get all output delays
-- for nodes with non-negative indices (aka those that exist)
get_input_delays :: ST_Clock_Sigs -> [DAG_Index] -> [Int]
get_input_delays clock_sigs indices =
  map (\index -> out_delay $ clock_sigs M.! index) (filter ((>= 0) . dag_index) indices)

-- | Given a source and a sink, find the maximum clocks the sink is ahead of the source
max_clocks_sink_ahead :: Clock_Type -> Clock_Type -> Int
max_clocks_sink_ahead (CT_Var _) _ = 0
max_clocks_sink_ahead _ (CT_Var _) = 0
max_clocks_sink_ahead (CT_Word source_word) (CT_Word sink_word) = do
  let zipped_words = zip (clks source_word) (clks sink_word)
  let update_ahead_counters (cur_ahead, max_ahead) (source_active, sink_active) =
        (new_counter, max new_counter max_ahead)
        where
          sink_inc = if source_active then 1 else 0
          source_inc = if source_active then (-1) else 0
          new_counter = cur_ahead + sink_inc + source_inc
  let (_, max_ahead) = foldl update_ahead_counters (0,0) zipped_words
  max_ahead

-- | Given a next clock type variable index, current delay, current DAG index,
-- ST_Clock_Sigs map for all indices prior to this one, 
-- and a space-time IR DAG, return the ST_Clock_Sigs map with the current object
-- added, along with any new FIFOs,
-- and the new graph with FIFOs added where needed to make clock sigs work
match_next_node_clock_sig :: Int -> Int -> DAG_Index -> ST_Clock_Sigs ->
                             ST_DAG -> (ST_Clock_Sigs, ST_DAG)
match_next_node_clock_sig next_var_index cur_delay cur_dag_index clk_sigs_so_far
  dag@(DAG nodes edges) = do
  let edges_to_current_node =
        filter (\edge -> sink edge == cur_dag_index) edges
  -- filter out any edges with negative numbers for inputs as aren't real
  let real_edges_to_current_node =
        filter (\edge -> (dag_index . source) edge >= 0)
        
        {-
  let nodes_emitting_to_each_node =
        map (\index -> map (\edge -> source edge) (edges_to_each_node !! index))
        nodes_range
-}
  --foldl 
  undefined

{-
-- | Given the next clock type variable index, current delay, and a node in the
-- space-time IR, match delays for any subdags and
-- return the clock signature and the node with fixed subdags
get_fixed_node_clock_sig :: Int -> Int -> Space_Time_Language_AST ->
                            (Clock_Signature, Space_Time_Language_AST)
get_fixed_node_clock_sig next_index cur_delay IdN =
  (one_ct_variable next_index cur_delay, IdN)
get_node_clock_sig next_index cur_delay AbsN =
  (one_ct_variable next_index cur_delay, AbsN)
get_node_clock_sig next_index cur_delay NotN =
  (one_ct_variable next_index cur_delay, NotN)
get_node_clock_sig next_index cur_delay AddN =
  (one_ct_variable next_index cur_delay, AddN)
get_node_clock_sig next_index cur_delay (EqN t) =
  (one_ct_variable next_index cur_delay, (EqN t))

-- generators
{-
get_node_clock_sig next_index cur_delay (Lut_GenN _ t) =
  (default_clock_signature IntT t cur_delay cur_delay
-- constant has no input, so no input delay and 0 output delay
get_node_clock_sig next_index cur_delay (Const_GenN _ t) =
  default_clock_signature t t 0 0
-}

-- sequence operators
get_node_clock_sig next_index cur_delay (FIFON _ _ delay_clks _) =
  sig_without_added_delay { out_delay = cur_delay + delay_clks }
  where sig_without_added_delay = two_ct_variables next_index cur_delay
get_node_clock_sig next_index cur_delay (Shift_sN _ _ t) =
  default_clock_signature t t cur_delay cur_delay
get_node_clock_sig next_index cur_delay (Shift_tN n v _ t) =
  default_clock_signature (TSeqT n v t) (TSeqT n v t) cur_delay cur_delay
get_node_clock_sig next_index cur_delay (Up_1d_sN _ t) =
  default_clock_signature t t cur_delay cur_delay
get_node_clock_sig next_index cur_delay (Up_1d_tN n v t) =
  default_clock_signature (TSeqT 1 (n+v-1) t) (TSeqT n v t) cur_delay cur_delay
get_node_clock_sig next_index cur_delay (Down_1d_sN _ t) =
  default_clock_signature t t cur_delay cur_delay
get_node_clock_sig next_index cur_delay (Down_1d_tN n v t) =
  default_clock_signature (TSeqT n v t) (TSeqT 1 (n+v-1) t) cur_delay cur_delay

-}
-- higher order operators
--get_node_clock_sig next_index cur_delay (Map_sN )


{-

    Tuple :: y -> y
    Map_s n (f :: t -> t' :c: y -> y) :: SSeq n t -> SSeq n t :c: y -> y
    Map_s n f :: SSeq n t -> SSeq n t' :c: type_clock_signature(t) -> type_clock_signature(t')
        We don't need to use type_clock_signature(SSeq n t) because nesting t in an SSeq doesn't change the pattern.
    Map_t n (f :: t -> t' :c: y -> y) :: TSeq n v t -> TSeq n v t' :c: y' -> y'
    Map_t n f :: TSeq n v t -> TSeq n v t' :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq n v t')
    Map2_s n (f :: t -> t' -> t'' :c: y -> y -> y) :: SSeq n t -> SSeq n t' -> SSeq n t'' :c: y -> y -> y
    Map2_s n f :: SSeq n t -> SSeq n t' -> SSeq n t'' :c: type_clock_signature(t) -> type_clock_signature(t') -> type_clock_signature(t'')
    Map2_t n (f :: t -> t' -> t'' :c: y -> y -> y) :: TSeq n v t -> SSeq n v t' -> SSeq n v t'' :c: y' -> y' -> y'
    Map2_t n f :: TSeq n v t -> SSeq n v t' -> SSeq n v t'' :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq n v t') -> type_clock_signature(TSeq n v t')
    Reduce_s n :: (t -> t -> t) -> SSeq n t -> SSeq 1 t :c: type_clock_signature(t) -> type_clock_signature(t)
    Reduce_t n :: (t -> t -> t) -> TSeq n v t -> TSeq 1 (n+v-1) 1 :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq 1 (n+v-1) t)
    Up_1d_s n :: SSeq 1 t -> SSeq n t :c: type_clock_signature(t) -> type_clock_signature(t)
    Up_1d_t n :: TSeq 1 (n+v-1) t -> TSeq n v t :c: type_clock_signature(TSeq 1 (n+v-1) t) -> type_clock_signature(TSeq n v t)
    Select_1d_s n idx :: SSeq n t -> SSeq 1 t :c: type_clock_signature(t) -> type_clock_signature(t)
    Select_1d_t n idx :: TSeq n v t -> TSeq 1 (n+v-1) t :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq 1 (n+v-1) t)
    Tuple_To_SSeq n :: NTuple n t -> SSeq n t :c: type_clock_signature(t) -> type_clock_signature(t)
    Serialize no ni :: TSeq no (vo+no*vi) (SSeq ni t) -> TSeq no vo (TSeq ni vi t) :c: type_clock_signature(TSeq no vo (TSeq 1 (ni+vi-1) t)) -> type_clock_signature(TSeq no vo (TSeq ni vi t))
        Input clock pattern is get SSeq ni t on first clock, emit it over ni clocks, wait vi, then repeat.
    SSeq_To_Tuple n :: SSeq n t -> NTuple n t :c: type_clock_signature(t) -> type_clock_signature(t)
    Deserialize no ni :: TSeq no vo (TSeq ni vi t) -> TSeq no (vo+no*vi) (SSeq ni t) :c: type_clock_signature(TSeq no vo (TSeq ni vi t)) -> type_clock_signature(TSeq no vo (TSeq 1 (ni+vi-1) t))
        Output clock pattern is same as input pattern to Serialize. Can do this by delaying the output of Deserialize relative to its input by type_clock_signature(TSeq 1 (ni+vi-1) t) - 1 clocks.
    Partition_t_tt no ni :: TSeq (no*ni) (vo + no*vi) t -> TSeq no vo (TSeq ni vi t) :c: type_clock_signature(TSeq no vo (TSeq ni vi t)) -> type_clock_signature(TSeq no vo (TSeq ni vi t))
        This clock signature enables Partition_t_tt to become a nop.
    Unpartition_t_tt no ni :: TSeq no vo (TSeq ni vi t) -> TSeq (no*ni) (vo + no*vi) t :c: type_clock_signature(TSeq no vo (TSeq ni vi t)) -> type_clock_signature(TSeq no vo (TSeq ni vi t))
    Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t) :c: type_clock_signature(t) -> type_clock_signature(t)
    Unpartition_s_ss no ni :: SSeq no (SSeq ni t) -> SSeq no (SSeq ni t) :c: type_clock_signature(t) -> type_clock_signature(t)
    Shift_s n init :: SSeq n t -> SSeq n t :c: type_clock_signature(t) -> type_clock_signature(t)
    Shift_t n init :: TSeq n v t -> TSeq n v t :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq n v t)

-}
-}

module Aetherling.Functional_Models.Reshape where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Safe
import qualified Data.Map as M
import qualified Data.List as L
import Debug.Trace

data Port_And_Time = PT {port :: Int, time :: Int} deriving (Show, Eq)
data ST_Element_Locations = ST_Element_Locations {
  st_coordinates :: [Int],
  port_and_time :: Port_And_Time
  } deriving (Show, Eq)

data ST_Element_Input_And_Output_Times = ST_Elem_IO_Times {
  input_time :: Int,
  output_time :: Int
  } deriving (Show, Eq)

type Flat_Idxs_To_Locations = M.Map Int ST_Element_Locations

-- | compute when the first output comes relative to the first input.
-- this is a complex calculation in order to preserve causality
-- (see get_output_latencies in Aetherling's magma code and Section 5 of
-- the streaming arbitrary permutations paper for more info on this)
get_output_delay :: Flat_Idxs_To_Locations -> Flat_Idxs_To_Locations -> Int
get_output_delay idxs_to_input_locs idxs_to_undelayed_output_locs = do
  let idxs = M.keys idxs_to_input_locs
  -- for each flat element, get the input and undelayed output clock
  let input_and_undelayed_out_times =
        map (\idx -> ST_Elem_IO_Times
                     (time $ port_and_time $ idxs_to_input_locs M.! idx)
                     (time $ port_and_time $ idxs_to_undelayed_output_locs M.! idx))
        idxs
  -- for each undelayed output clock, get all the inputs
  -- this is called the neighborhood in Magma implementation and is the incoming
  -- edges for a node in the paper's bipartite graph
  let undelayed_out_to_input_times = M.fromAscList $
        map (\xs -> (output_time $ head xs, map input_time xs)) $
        L.groupBy (\x y -> (output_time x) == (output_time y)) $
        L.sortBy (\x y -> compare (output_time x) (output_time y))
        input_and_undelayed_out_times
  -- for each undelayed output time (aka output node in the bipartite graph
  -- from paper)
  -- get the least delayed output time necessary for it to preserve causality
  -- and come after all inputs in its neighborhood.
  -- adding 1 to account for writing to memory.
  -- this is per_node_min_latencies in Magma.
  -- This only considers the neighborhood so it's a min estimate.
  -- later code will need to ensure all outputs are delayed relative to each
  -- other
  let min_delayed_output_time_per_node_given_neighborhood =
        M.map (+1) $
        M.map maximum undelayed_out_to_input_times
  -- get the maximum of these mins. This is equivalent to the forward and backward
  -- passes. everything just gets delayed by max of the per node min delays
  maximum $ map (\(out_time, in_time) -> in_time - out_time) $
        M.toList min_delayed_output_time_per_node_given_neighborhood

-- | compute a map from flat idx to nested st coordinates and port and time,
-- aka flat st coordinates
compute_element_locations :: AST_Type -> Flat_Idxs_To_Locations
compute_element_locations t = do
  let ts_elem_xs = st_types_to_ts_elem_list t
  let num_el = get_num_els ts_elem_xs
  -- drop the top t or s type as multiplying each index by inner types
  let ts_elem_tl = Prelude.drop 1 ts_elem_xs
  let divisors = get_divisors_for_els ts_elem_tl
  let nested_indices =
        Prelude.map (compute_nested_indices divisors) [0..num_el - 1]
  let multipliers = get_multipliers_for_els ts_elem_tl
  M.fromAscList $ zip [0..num_el-1] $
    Prelude.map (\nested_index ->
                   ST_Element_Locations nested_index
                   (compute_port_and_time multipliers ts_elem_xs nested_index))
    nested_indices

data TS_Elem = T_Elem Int Int | S_Elem Int deriving (Show, Eq)
-- | Convert an AST_Type to a form that is easier to do timing computations on:
-- it merges types that are identical for timing purposes (like STuple and SSeq)
-- and removes atoms
st_types_to_ts_elem_list :: AST_Type -> [TS_Elem]
st_types_to_ts_elem_list UnitT = []
st_types_to_ts_elem_list BitT = []
st_types_to_ts_elem_list Int8T = []
st_types_to_ts_elem_list UInt8T = []
st_types_to_ts_elem_list FixP1_7T = []
st_types_to_ts_elem_list Int16T = []
st_types_to_ts_elem_list UInt16T = []
st_types_to_ts_elem_list Int32T = []
st_types_to_ts_elem_list UInt32T = []
st_types_to_ts_elem_list (ATupleT _ _) = []
st_types_to_ts_elem_list (STupleT n t) = S_Elem n : st_types_to_ts_elem_list t
st_types_to_ts_elem_list (SSeqT n t) = S_Elem n : st_types_to_ts_elem_list t
st_types_to_ts_elem_list (TSeqT n i t) = T_Elem n i : st_types_to_ts_elem_list t

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

-- given a flat index and divisors indicating dimensions,
-- compute the nested st index
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
get_multipliers_for_els [] = [ST_Multiplier 1 1]
get_multipliers_for_els (T_Elem n i : tl) = do
  let inner = get_multipliers_for_els tl
  let prior_mul = Safe.headDef (ST_Multiplier 1 1) inner
  let t_mul = (n+i) * t_multiplier prior_mul
  prior_mul { t_multiplier = t_mul } : inner
get_multipliers_for_els (S_Elem n : tl) = do
  let inner = get_multipliers_for_els tl
  let prior_mul = Safe.headDef (ST_Multiplier 1 1) inner
  let t_mul = n * t_multiplier prior_mul
  prior_mul { s_multiplier = t_mul } : inner

-- | compute the flat space-time coordinates (port and time)
-- given derivatives of the AST Type - multipliers for how many elements are
-- below each layer of the type and TS_Eleme which describe if the current
-- layer is in space or time
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

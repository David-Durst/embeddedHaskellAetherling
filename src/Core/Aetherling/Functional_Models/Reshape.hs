module Aetherling.Functional_Models.Reshape where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Safe
import qualified Data.Map as M

data Port_And_Time = PT {port :: Int, time :: Int} deriving (Show, Eq)
data ST_Element_Locations = ST_Element_Locations {
  st_coordinates :: [Int],
  port_and_time :: Port_And_Time
  } deriving (Show, Eq)

type Flat_Idxs_To_Locations = M.Map Int ST_Element_Locations

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
st_types_to_ts_elem_list :: AST_Type -> [TS_Elem]
st_types_to_ts_elem_list UnitT = []
st_types_to_ts_elem_list BitT = []
st_types_to_ts_elem_list IntT = []
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

module Aetherling.Interpretations.Resource_Estimator where
import Aetherling.ASTs.Space_Time
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Interpretations.Monad_Helpers
import Control.Monad.Except
import Control.Monad.Identity

estimate_resources :: ST_DAG -> Either String Resources_Data
estimate_resources dag =
  runIdentity $ runExceptT $ foldM estimate_resourcesM empty_resources (nodes dag)

data Resources_Data = Resources_Data {
  computeResources :: Int,
  memoryResources :: Int,
  wireResources :: Int
  } deriving (Show, Eq)

empty_resources = Resources_Data 0 0 0

type Resources_Env = Except String Resources_Data

increase_resources :: Resources_Data -> Resources_Data -> Resources_Env
increase_resources prior_resources new_resources = return result_resources
  where result_resources =
          Resources_Data
          (computeResources new_resources + computeResources prior_resources)
          (memoryResources new_resources + memoryResources prior_resources)
          (wireResources new_resources + wireResources prior_resources)
  
-- Int is for the size to count to
add_counter_to_resources :: Resources_Data -> Int -> Resources_Data
add_counter_to_resources (Resources_Data orig_comp orig_mem orig_wire) n =
  -- a counter is a memory into an adder, with adder back into memory
  -- bits_for_int extra compute for the adder incrementing by 1 each clock
  -- bits_for_int extra memory to store counter value
  -- add 1 extra memory bit to store the 1 for incrementing the counter
  -- 2 * bits_for_int extra wires as both adder and counter have wires out
  Resources_Data (orig_comp + bits_for_int) (orig_mem + bits_for_int)
  (orig_wire + 2 * bits_for_int)
  where
    bits_for_int = fromInteger $ ceiling $ logBase 2 (fromInteger $ toInteger n)

estimate_resourcesM :: Resources_Data -> Space_Time_Language_AST -> Resources_Env
  -- unary operators
estimate_resourcesM r IdN = return r

estimate_resourcesM r AbsN =
  increase_resources r (Resources_Data size_int 0 size_int)

estimate_resourcesM r NotN =
  increase_resources r (Resources_Data size_bit 0 size_bit)

-- binary operators
estimate_resourcesM r AddN =
  increase_resources r (Resources_Data size_int 0 size_int) 

estimate_resourcesM r (EqN t) =
  increase_resources r (Resources_Data (size_t t) 0 size_bit) 

-- generators
{-
estimate_resourcesM r (Lut_GenN tbl@(tbl_hd : _)) =
  increase_resources r (Resources_Data size_int size_tbl size_el)
    where
      size_el = size_v tbl_hd
      size_tbl = length tbl * size_el

estimate_resourcesM r (Lut_GenN _) = throwError $
  "LUT can't have empty lookup table"
estimate_resourcesM r (Const_GenN v) =
  increase_resources r (Resources_Data 0 size_const size_const)
    where
      size_const = size_v v
-}

-- sequence operator
estimate_resourcesM r (Up_1d_sN n t) =
  increase_resources r (Resources_Data 0 0 (n * size_t t)) 

estimate_resourcesM r (Up_1d_tN n v t) =
  increase_resources r resources_with_counter
    where
      size_el = size_t t
      resources_pre_counter = Resources_Data 0 size_el size_el
      resources_with_counter = add_counter_to_resources resources_pre_counter (n+v)

estimate_resourcesM r (Down_1d_sN n t) =
  increase_resources r (Resources_Data 0 0 (size_t t))

estimate_resourcesM r (Down_1d_tN n v t) =
  increase_resources r resources_with_counter
    where
      size_el = size_t t
      resources_pre_counter = Resources_Data 0 size_el size_el
      resources_with_counter = add_counter_to_resources resources_pre_counter (n+v)

estimate_resourcesM r (Partition_ssN _ _ _) = return r

estimate_resourcesM r (Unpartition_ssN _ _ _) = return r

estimate_resourcesM r (Partition_ttN _ _ _ _ _) = return r

estimate_resourcesM r (Unpartition_ttN _ _ _ _ _) = return r

estimate_resourcesM r node@(Map_sN n inner_dag) =
  case estimate_resources inner_dag of
    Left fail_string -> throwError ("Fail inside " ++ show node ++ ": " ++ fail_string)
    Right (Resources_Data inner_compute inner_memory inner_wiring) ->
      return $ Resources_Data (n*inner_compute) (n*inner_memory) (n*inner_wiring)

estimate_resourcesM r node@(Map_tN n v inner_dag) =
  case estimate_resources inner_dag of
    Left fail_string -> throwError ("Fail inside " ++ show node ++ ": " ++ fail_string)
    Right inner_resources ->
      increase_resources r resources_with_counter
      where
        resources_with_counter =
          if v > 0
          then add_counter_to_resources inner_resources (n+v)
          else inner_resources

estimate_resourcesM r node@(Map2_sN n inner_dag) =
  case estimate_resources inner_dag of
    Left fail_string -> throwError ("Fail inside " ++ show node ++ ": " ++ fail_string)
    Right (Resources_Data inner_compute inner_memory inner_wiring) ->
      return $ Resources_Data (n*inner_compute) (n*inner_memory) (n*inner_wiring)

estimate_resourcesM r node@(Map2_tN n v inner_dag) =
  case estimate_resources inner_dag of
    Left fail_string -> throwError ("Fail inside " ++ show node ++ ": " ++ fail_string)
    Right inner_resources ->
      increase_resources r resources_with_counter
      where
        resources_with_counter =
          if v > 0
          then add_counter_to_resources inner_resources (n+v)
          else inner_resources

-- tuple operations
-- these require no size as they are just for connecting other nodes
estimate_resourcesM r (FstN _ _) = return r
estimate_resourcesM r (SndN _ _) = return r

estimate_resourcesM r (InputN _) = return r

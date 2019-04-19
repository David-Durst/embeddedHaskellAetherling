module Aetherling.Interpretations.Resource_Estimator where
import Aetherling.Declarations.Space_Time
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Types.Isomorphisms
import Aetherling.Interpretations.Monad_Helpers
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Identity
import Data.Typeable
import Unsafe.Coerce
import GHC.TypeLits
import GHC.TypeLits.Extra
import qualified Data.Vector.Sized as V
  

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

estimate_resourcesM r (Partition_ttN no vo_in ni vi_in t) =
  increase_resources r resources_with_counter
    where
      size_el = size_t t
      resources_pre_counter = Resources_Data 0 ((no-1)*ni*size_el) (ni*size_el)
      resources_with_counter = add_counter_to_resources resources_pre_counter
        (no + vo_in * (ni + vi_in))
{-
  partition_tsC :: forall a no ni . (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                                     KnownNat (Type_Size a),
                                     Check_Type_Is_Atom_Or_Nested a,
                                     Typeable (Proxy a)) =>
                   Proxy no -> Proxy ni ->
                   TSeq 1 (no-1) (SSeq (no GHC.TypeLits.* ni) a) ->
                   Resources_Env (TSeq no 0 (SSeq ni a))
  partition_tsC _ _ (TSeq_Resources (SSeq_Resources x)) =
    increase_resources with_counter_resources (TSeq_Resources (SSeq_Resources x))
    where
      t_size = size (Proxy :: Proxy a)
      no_val = fromInteger $ natVal (Proxy :: Proxy no)
      ni_val = fromInteger $ natVal (Proxy :: Proxy ni)
      pre_counter_resources = Resources_Data 0 ((no_val-1)*ni_val*t_size)
        (ni_val*t_size)
      with_counter_resources = add_counter_to_resources pre_counter_resources
        no_val
  partition_tsC _ _ _ = throwError $
    fail_message "partition_tsC" "TSeq_Resources (SSeq_Resources)"

  unpartition_tsC :: forall a no ni . (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                                       KnownNat (Type_Size a),
                                       Check_Type_Is_Atom_Or_Nested a,
                                       Typeable (Proxy a)) =>
                     Proxy no -> Proxy ni ->
                     TSeq no 0 (SSeq ni a) ->
                     Resources_Env (TSeq 1 (no-1) (SSeq (no GHC.TypeLits.* ni) a))
  unpartition_tsC _ _ (TSeq_Resources (SSeq_Resources x)) =
    increase_resources with_counter_resources (TSeq_Resources (SSeq_Resources x))
    where
      t_size = size (Proxy :: Proxy a)
      no_val = fromInteger $ natVal (Proxy :: Proxy no)
      ni_val = fromInteger $ natVal (Proxy :: Proxy ni)
      pre_counter_resources = Resources_Data 0 ((no_val-1)*ni_val*t_size)
        (no_val*ni_val*t_size)
      with_counter_resources = add_counter_to_resources pre_counter_resources
        no_val
  unpartition_tsC _ _ _ = throwError $
    fail_message "partition_tsC" "TSeq_Resources (SSeq_Resources)"

  partition_ssC _ _ (SSeq_Resources x) = return (SSeq_Resources (SSeq_Resources x))
  partition_ssC _ _ _ = throwError $
    fail_message "partition_ssC" "SSeq_Resources"

  unpartition_ssC _ _ (SSeq_Resources (SSeq_Resources x)) =
    return (SSeq_Resources x)
  unpartition_ssC _ _ _ = throwError $
    fail_message "partition_ssC" "SSeq_Resources (SSeq_Resources)"

  map_sC :: forall a b n . (KnownNat n) =>
    Proxy n -> (a -> Resources_Env b) -> (SSeq n a -> Resources_Env (SSeq n b))
  map_sC _ f (SSeq_Resources x) = do
    -- save the current state, get the resources of the inner state
    -- multiply all them by n, and then add them to current state
    current_resources <- get
    put empty_resources
    f_output <- f x
    Resources_Data f_compute f_memory f_wiring <- get
    put current_resources
    let n_val = fromInteger $ natVal $ (Proxy :: Proxy n)
    increase_resources
      (Resources_Data (n_val*f_compute) (n_val*f_memory) (n_val*f_wiring))
      (SSeq_Resources f_output)
  map_sC _ _ _ = throwError $
    fail_message "map_sC" "SSeq_Resources"

  map_tC _ f (TSeq_Resources x) = do
    -- let f add resources to current amount of resources
    f_output <- f x
    return $ TSeq_Resources f_output
  map_tC _ _ _ = throwError $
    fail_message "map_tC" "TSeq_Resources"

  map2_sC :: forall a b c n . (KnownNat n) =>
    Proxy n -> (a -> b -> Resources_Env c) ->
    (SSeq n a -> SSeq n b -> Resources_Env (SSeq n c))
  map2_sC _ f (SSeq_Resources x) (SSeq_Resources y) = do
    -- save the current state, get the resources of the inner state
    -- multiply all them by n, and then add them to current state
    current_resources <- get
    put empty_resources
    f_output <- f x y
    Resources_Data f_compute f_memory f_wiring <- get
    put current_resources
    let n_val = fromInteger $ natVal $ (Proxy :: Proxy n)
    increase_resources
      (Resources_Data (n_val*f_compute) (n_val*f_memory) (n_val*f_wiring))
      (SSeq_Resources f_output)
  map2_sC _ _ _ _ = throwError $
    fail_message "map2_sC" "SSeq_Resources, SSeq_Resources"

  map2_tC _ f (TSeq_Resources x) (TSeq_Resources y) = do
    -- let f add resources to current amount of resources
    f_output <- f x y
    return $ TSeq_Resources f_output
  map2_tC _ _ _ _ = throwError $
    fail_message "map2_tC" "TSeq_Resources, TSeq_Resources"
-}
{-
estimate_resourcesM (DAG (Map2_tN n v inner_dag :: tail)) = do

-}

-- tuple operations
-- these require no size as they are just for connecting other nodes
estimate_resourcesM r (FstN _ _) = return r

estimate_resourcesM r (SndN _ _) = return r

estimate_resourcesM r (ZipN _ _) = return r

{-
  -- composition operators
  (>>>) f g x = f x >>= g

instance Symbolic_Space_Time_Language Resources_Env where
  input_unit = return $ Atom_Unit_Resources
  input_int = return $ Atom_Int_Resources
  input_bit = return $ Atom_Bit_Resources
  input_tuple x y = return $ Atom_Tuple_Resources (x, y)
  input_sseq x = return $ SSeq_Resources x
  input_tseq x = return $ TSeq_Resources x
-}

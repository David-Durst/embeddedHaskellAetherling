module Aetherling.Interpretations.Resource_Estimator where
import Aetherling.Declarations.SpaceTime
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
  

estimate_resources :: Resources_Env a -> Either String Resources_Data
estimate_resources resources_monad =
  runIdentity $ runExceptT $ execStateT resources_monad empty_resources

data Resources_Data = Resources_Data {
  computeResources :: Int,
  memoryResources :: Int,
  wireResources :: Int
  } deriving (Show, Eq)

empty_resources = Resources_Data 0 0 0

type Resources_Env = StateT Resources_Data (ExceptT String Identity)

increase_resources :: Resources_Data -> a -> Resources_Env a
increase_resources new_resources result = do
  prior_resources <- get
  let new_resources = Resources_Data
        (computeResources new_resources + computeResources prior_resources)
        (memoryResources new_resources + memoryResources prior_resources)
        (wireResources new_resources + wireResources prior_resources)
  return result

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

instance Space_Time_Language Resources_Env where
  -- unary operators
  idC x = return $ x
  absC x = increase_resources (Resources_Data int_size 0 int_size) x
    where int_size = size (Proxy :: Proxy Atom_Int)

  notC x = increase_resources (Resources_Data bit_size 0 bit_size) x
    where bit_size = size (Proxy :: Proxy Atom_Bit)

  -- binary operators
  addC x = increase_resources (Resources_Data int_size 0 int_size)
    Atom_Int_Resources
    where int_size = size (Proxy :: Proxy Atom_Bit)

  eqC x = increase_resources (Resources_Data bit_size 0 bit_size)
    Atom_Bit_Resources
    where bit_size = size (Proxy :: Proxy Atom_Bit)

  lut_genC :: forall a . (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
              [a] -> Atom_Int -> Resources_Env a
  lut_genC x _ = increase_resources (Resources_Data t_size t_size t_size)
    (head x)
    where t_size = size (Proxy :: Proxy a)

  const_genC :: forall a . (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
                a -> Atom_Unit -> Resources_Env a
  const_genC x _ = increase_resources (Resources_Data 0 t_size t_size) x
    where t_size = size (Proxy :: Proxy a)

  -- sequence operators
  up_1d_sC :: forall a n . (KnownNat n, 1 <= n, KnownNat (Type_Size a),
                            Check_Type_Is_Atom_Or_Nested a, Typeable (Proxy a)) =>
    Proxy n -> SSeq 1 a -> Resources_Env (SSeq n a)
  up_1d_sC _ (SSeq_Resources x) =
    increase_resources (Resources_Data 0 0 (n_val*t_size))
    (SSeq_Resources x)
    where
      t_size = size (Proxy :: Proxy a)
      n_val = fromInteger $ natVal (Proxy :: Proxy n)
  up_1d_sC _ _ = throwError $ fail_message "up_1d_sC" "SSeq_Resources"

  up_1d_tC :: forall a n . (KnownNat n, 1 <= n, KnownNat (Type_Size a),
               Check_Type_Is_Atom_Or_Nested a, Typeable (Proxy a)) =>
    Proxy n -> TSeq 1 (n-1) a -> Resources_Env (TSeq n 0 a)
  up_1d_tC _ (TSeq_Resources x) =
    increase_resources with_counter_resources (TSeq_Resources x)
    where
      t_size = size (Proxy :: Proxy a)
      n_val = fromInteger $ natVal (Proxy :: Proxy n)
      pre_counter_resources = Resources_Data 0 t_size t_size
      with_counter_resources = add_counter_to_resources pre_counter_resources
        n_val
  up_1d_tC _ _ = throwError $ fail_message "up_1d_tC" "TSeq_Resources"

  down_1d_sC :: forall a n . (KnownNat n, KnownNat (Type_Size a),
                  Check_Type_Is_Atom_Or_Nested a, Typeable (Proxy a)) =>
     Proxy n -> SSeq (1+n) a -> Resources_Env (SSeq 1 a)
  down_1d_sC _ (SSeq_Resources x) =
    increase_resources (Resources_Data 0 0 t_size) (SSeq_Resources x)
    where
      t_size = size (Proxy :: Proxy a)
  down_1d_sC _ _ = throwError $ fail_message "down_1d_sC" "SSeq_Resources"

  down_1d_tC :: forall a n . (KnownNat n, KnownNat (Type_Size a),
                 Check_Type_Is_Atom_Or_Nested a, Typeable (Proxy a)) =>
    Proxy n -> TSeq (1+n) 0 a -> Resources_Env (TSeq 1 n a)
  down_1d_tC _ (TSeq_Resources x) =
    increase_resources with_counter_resources (TSeq_Resources x)
    where
      t_size = size (Proxy :: Proxy a)
      n_val = fromInteger $ natVal (Proxy :: Proxy n)
      pre_counter_resources = Resources_Data 0 0 t_size
      with_counter_resources = add_counter_to_resources pre_counter_resources
        n_val
  down_1d_tC _ _ = throwError $ fail_message "down_1d_tC" "TSeq_Resources"
  
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
  
{-
  map_sC :: forall a b n . (KnownNat n) =>
    Proxy n -> (a -> Resources_Env b) -> (Seq n a -> Resources_Env (Seq n b))
  map_sC _ f = do
    let f_resources_either = estimate_resources f 
    increase_resources
    where
  {-
  map_tC :: (KnownNat n) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  map2_sC :: (KnownNat n) =>
    Proxy n -> (a -> b -> m c) -> (Seq n a -> Seq n b -> m (Seq n c))
-}
  -- composition operators
  (>>>) f g x = f x >>= g
--}

instance Symbolic_Space_Time_Language Resources_Env where
  input_unit = return $ Atom_Unit_Resources
  input_int = return $ Atom_Int_Resources
  input_bit = return $ Atom_Bit_Resources
  input_tuple = return $ Atom_Tuple_Resources
  input_sseq x = return $ SSeq_Resources x
  input_tseq x = return $ TSeq_Resources x

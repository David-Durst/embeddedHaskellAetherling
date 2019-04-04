module Aetherling.Interpretations.Sequence_To_Space_Time where
import qualified Aetherling.Declarations.Sequence as S
import qualified Aetherling.Declarations.Space_Time as ST
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
import Data.Dynamic
import qualified Data.Vector.Sized as V
  

lower_seq_to_st :: S_To_ST_Env m out_t a -> Either String (S_To_ST_Data m out_t)
lower_seq_to_st program_monad =
  runIdentity $ runExceptT $ execStateT program_monad empty_program

data S_To_ST_Data m out_t = S_To_ST_Data {
  space_time_program :: Maybe (m out_t),
  next_node_index :: Int,
  index_to_output_map :: [Dynamic]
  } deriving (Show)

empty_program = S_To_ST_Data Nothing 0 []

type S_To_ST_Env m out_t = StateT (S_To_ST_Data m out_t) (ExceptT String Identity)

instance S.Sequence_Language (S_To_ST_Env m out_t) where
  -- unary operators
  idC x = return x
  
  absC x = increase_resources (Resources_Data int_size 0 int_size) x
    where int_size = size (Proxy :: Proxy Atom_Int)

  {-
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

  -- tuple operations
  fstC (Atom_Tuple_Resources (x, _)) = return x
  fstC _ = throwError $ fail_message "fstC" "Atom_Tuple_Resources"

  sndC (Atom_Tuple_Resources (_, y)) = return y
  sndC _ = throwError $ fail_message "sndC" "Atom_Tuple_Resources"

  zipC x y = return $ Atom_Tuple_Resources (x, y)

  -- composition operators
  (>>>) f g x = f x >>= g
-}

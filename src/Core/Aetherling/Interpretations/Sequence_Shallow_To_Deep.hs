module Aetherling.Interpretations.Sequence_Shallow_To_Deep where
import Aetherling.Declarations.Sequence
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Types.Isomorphisms
import Aetherling.Interpretations.Monad_Helpers
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Identity
import Data.Typeable
import Data.Maybe
import Control.Applicative
import GHC.TypeLits
import Unsafe.Coerce
import qualified Data.Vector.Sized as V
import Util

get_deep_dag :: Seq_Shallow_To_Deep_Env a -> Either String DAG_Builder
get_deep_dag shallow_embedding =
  runIdentity $ runExceptT $ execStateT shallow_embedding empty_dag

empty_dag = DAG_Builder (Seq_DAG [] []) 0

data DAG_Builder = DAG_Builder {
  get_builder_dag :: Seq_DAG,
  next_DAG_index :: DAG_Index
  } deriving (Show, Eq)

type Seq_Shallow_To_Deep_Env = StateT DAG_Builder (ExceptT String Identity)

add_to_DAG :: (Convertible_To_DAG_Data a) =>
  Sequence_Language_AST -> Maybe [DAG_Index] -> String -> String ->
  Seq_Shallow_To_Deep_Env a
add_to_DAG new_node input_indices_maybe node_name args_name = do
  prior_DAG <- get
  let cur_node_index = next_DAG_index prior_DAG
  if isJust input_indices_maybe
    then do
    let input_indices = fromJust input_indices_maybe
    let new_edges = fmap (\idx -> DAG_Edge idx cur_node_index) input_indices
    let old_edges = edges $ get_builder_dag prior_DAG
    let old_nodes = nodes $ get_builder_dag prior_DAG
    let new_DAG = DAG_Builder
          (Seq_DAG (old_nodes ++ [new_node]) (old_edges ++ new_edges))
          (next_DAG_index prior_DAG + 1)
    put new_DAG
    return (convert_index_to_value cur_node_index)
    else do
    fail $ fail_message node_name args_name

input_to_maybe_indices :: (Convertible_To_DAG_Data a) =>
  a -> Maybe [DAG_Index]
input_to_maybe_indices input = traverse convert_to_index [input]

instance Sequence_Language Seq_Shallow_To_Deep_Env where
  -- unary operators
  idC x = add_to_DAG IdN (input_to_maybe_indices x) "idC" "any_input_edge"
  absC x = add_to_DAG AbsN (input_to_maybe_indices x) "absC" "Atom_Int_Edge"
  notC x = add_to_DAG NotN (input_to_maybe_indices x) "absC" "Atom_Bit_Edge"

  -- binary operators
  addC x = add_to_DAG AddN (input_to_maybe_indices x) "addC" "Atom_Tuple_Edge"
  eqC x = add_to_DAG EqN (input_to_maybe_indices x) "eqC" "Atom_Tuple_Edge"

  -- generators
  lut_genC table x = do
    let lut_table_maybe = traverse convert_atom_to_AST_Value table
    if isJust lut_table_maybe
      then do
      add_to_DAG (Lut_GenN $ fromJust lut_table_maybe) (input_to_maybe_indices x)
        "lut_genC" "Atom_Int_edge"
      else do
      fail $ fail_message "lut_genC" "[a_Edge]"

  const_genC const x = do
    let const_maybe = convert_atom_to_AST_Value const
    if isJust const_maybe
      then do
      add_to_DAG (Const_GenN $ fromJust const_maybe) (input_to_maybe_indices x)
        "const_genC" "Atom_Unit_Edge"
      else do
      fail $ fail_message "const_genC" "a_Edge"

  -- sequence operators
  up_1dC :: forall n a . (KnownNat n, KnownNat (Type_Size a),
                          Check_Type_Is_Atom a, Typeable (Proxy a),
                          Convertible_To_DAG_Data a) =>
            Proxy n -> Seq 1 a -> Seq_Shallow_To_Deep_Env (Seq n a)
  up_1dC proxyN x = add_to_DAG
    (Up_1dN n_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "up_1dC" "Seq_Edge"
    where
      n_val = fromInteger $ natVal proxyN

  down_1dC :: forall n a . (KnownNat n, KnownNat (Type_Size a),
                Check_Type_Is_Atom a, Typeable (Proxy a),
                Convertible_To_DAG_Data a) =>
              Proxy (1+n) -> Seq (1+n) a -> Seq_Shallow_To_Deep_Env (Seq 1 a)
  down_1dC proxyN x = add_to_DAG
    (Down_1dN n_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "down_1dC" "Seq_Edge"
    where
      n_val = fromInteger $ natVal proxyN


  partitionC :: forall no ni a . (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                                  Convertible_To_DAG_Data a) =>
                Proxy no -> Proxy ni ->
                Seq (no GHC.TypeLits.* ni) a ->
                Seq_Shallow_To_Deep_Env (Seq no (Seq ni a))
  partitionC proxyNO proxyNI x = add_to_DAG
    (PartitionN no_val ni_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "partition_1dC" "Seq_Edge"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI

  unpartitionC :: forall no ni a . (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                                    Convertible_To_DAG_Data a) =>
                  Proxy no -> Proxy ni ->
                  Seq no (Seq ni a) ->
                  Seq_Shallow_To_Deep_Env (Seq (no GHC.TypeLits.* ni) a)
  unpartitionC proxyNO proxyNI x = add_to_DAG
    (UnpartitionN no_val ni_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "partition_1dC" "Seq_Edge"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI


  -- higher order operators
  mapC :: forall n a b . (KnownNat n, Convertible_To_DAG_Data a,
                          Convertible_To_DAG_Data b) =>
          Proxy n -> (a -> Seq_Shallow_To_Deep_Env b) ->
          (Seq n a -> Seq_Shallow_To_Deep_Env (Seq n b))
  mapC proxyN f x = do
    let n_val = fromInteger $ natVal proxyN
    outer_dag <- get
    put empty_dag
    put $ empty_dag {next_DAG_index = 1}
    f $ convert_index_to_value 0
    f_dag <- get
    put outer_dag
    add_to_DAG (MapN n_val (get_builder_dag f_dag)) (input_to_maybe_indices x)
      "mapC" "Seq_Edge"
    
  map2C :: forall n a b c . (KnownNat n,
                             Convertible_To_DAG_Data a,
                             Convertible_To_DAG_Data b,
                             Convertible_To_DAG_Data c) =>
    Proxy n -> (a -> b -> Seq_Shallow_To_Deep_Env c) ->
    (Seq n a -> Seq n b -> Seq_Shallow_To_Deep_Env (Seq n c))
  map2C proxyN f x y = do
    let n_val = fromInteger $ natVal proxyN
    outer_dag <- get
    put $ empty_dag {next_DAG_index = 2}
    f (convert_index_to_value 0) (convert_index_to_value 1)
    f_dag <- get
    put outer_dag
    let maybe_indices = liftA2 (++)
          (input_to_maybe_indices x) (input_to_maybe_indices y)
    add_to_DAG (Map2N n_val (get_builder_dag f_dag)) maybe_indices "mapC" "Seq_Edge"

  fstC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Convertible_To_DAG_Data a,
                        Convertible_To_DAG_Data b) =>
    Atom_Tuple a b -> Seq_Shallow_To_Deep_Env a
  fstC x = add_to_DAG (SndN (get_AST_type (Proxy :: Proxy a))
                       (get_AST_type (Proxy :: Proxy b)))
           (input_to_maybe_indices x) "fstC" "Atom_Tuple_Edge"

  sndC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Convertible_To_DAG_Data a,
                        Convertible_To_DAG_Data b) =>
    Atom_Tuple a b -> Seq_Shallow_To_Deep_Env b
  sndC x = add_to_DAG (SndN (get_AST_type (Proxy :: Proxy a))
                       (get_AST_type (Proxy :: Proxy b)))
           (input_to_maybe_indices x) "sndC" "Atom_Tuple_Edge"

  zipC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Convertible_To_DAG_Data a,
                        Convertible_To_DAG_Data b) =>
    a -> b -> Seq_Shallow_To_Deep_Env (Atom_Tuple a b)
  zipC x y = add_to_DAG (ZipN (get_AST_type (Proxy :: Proxy a))
                         (get_AST_type (Proxy :: Proxy b)))
             maybe_indices "zipC" "Atom_Tuple_Edge"
    where
      maybe_indices = liftA2 (++) (input_to_maybe_indices x)
        (input_to_maybe_indices y)

  -- composition operators
  (>>>) f g x = f x >>= g

instance Symbolic_Sequence_Language Seq_Shallow_To_Deep_Env where
  sym_input_unit = add_to_DAG (InputN UnitT) (Just []) "sym_input_unit" ""
  sym_input_bit = add_to_DAG (InputN BitT) (Just []) "sym_input_bit" ""
  sym_input_int = add_to_DAG (InputN IntT) (Just []) "sym_input_int" ""

  sym_input_tuple :: forall a b . (Convertible_To_DAG_Data a,
                                   Convertible_To_DAG_Data b) =>
                     Seq_Shallow_To_Deep_Env (Atom_Tuple a b)
  sym_input_tuple = add_to_DAG (InputN tuple_type) (Just []) "sym_input_tuple" ""
    where
     a_proxy = Proxy :: Proxy a
     b_proxy = Proxy :: Proxy b
     tuple_type = TupleT (get_AST_type a_proxy) (get_AST_type b_proxy)

  sym_input_seq :: forall a n . (KnownNat n, Convertible_To_DAG_Data a) =>
    Proxy n -> Seq_Shallow_To_Deep_Env (Seq n a)
  sym_input_seq proxyN = add_to_DAG (InputN seq_type) (Just []) "sym_input_tuple" ""
    where
      a_proxy = Proxy :: Proxy a
      n_val = fromInteger $ natVal $ proxyN
      seq_type = SeqT n_val (get_AST_type a_proxy)

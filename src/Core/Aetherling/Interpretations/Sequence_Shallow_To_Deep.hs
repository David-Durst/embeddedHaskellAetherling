module Aetherling.Interpretations.Sequence_Shallow_To_Deep where
import Aetherling.ASTs.Sequence
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

empty_dag = DAG_Builder (DAG [] []) 0

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
          (DAG (old_nodes ++ [new_node]) (old_edges ++ new_edges))
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

  eqC :: forall a . (Convertible_To_DAG_Data a, Check_Type_Is_Atom a, Eq a) =>
    Atom_Tuple a a -> Seq_Shallow_To_Deep_Env Atom_Bit
  eqC x = add_to_DAG eq_node (input_to_maybe_indices x) "eqC" "Atom_Tuple_Edge"
    where
      input_type_proxy = Proxy :: Proxy a
      eq_node = EqN (get_AST_type input_type_proxy)

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
  up_1dC :: forall n a i . (KnownNat n, KnownNat i,
                          KnownNat (Type_Size a), Typeable (Proxy a),
                          Convertible_To_DAG_Data a) =>
            Proxy (1+n) -> 
            Seq 1 (n + i) a -> Seq_Shallow_To_Deep_Env (Seq (1+n) i a)
  up_1dC proxyN x = add_to_DAG
    (Up_1dN n_val i_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "up_1dC" "Seq_Edge"
    where
      n_val = fromInteger $ natVal proxyN
      i_val = fromInteger $ natVal (Proxy :: Proxy i)

  down_1dC :: forall n a i . (KnownNat n, KnownNat i,
                              KnownNat (Type_Size a), Typeable (Proxy a),
                              Convertible_To_DAG_Data a) =>
              Proxy (1+n) -> 
              Seq (1+n) i a -> Seq_Shallow_To_Deep_Env (Seq 1 (n + i) a)
  down_1dC proxyN x = add_to_DAG
    (Down_1dN n_val i_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "down_1dC" "Seq_Edge"
    where
      n_val = fromInteger $ natVal proxyN
      i_val = fromInteger $ natVal (Proxy :: Proxy i)


  partitionC :: forall no ni io ii a .
    (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
      KnownNat io, KnownNat ii,
      Convertible_To_DAG_Data a) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a ->
    Seq_Shallow_To_Deep_Env (Seq no io (Seq ni ii a))
  partitionC proxyNO proxyNI x = add_to_DAG
    (PartitionN no_val ni_val io_val ii_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "partition_1dC" "Seq_Edge"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)

  unpartitionC :: forall no ni io ii a .
    (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
      KnownNat io, KnownNat ii,
      Convertible_To_DAG_Data a) =>
    Proxy no -> Proxy ni ->
    Seq no io (Seq ni ii a) ->
    Seq_Shallow_To_Deep_Env (Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a)
  unpartitionC proxyNO proxyNI x = add_to_DAG
    (UnpartitionN no_val ni_val io_val ii_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "partition_1dC" "Seq_Edge"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)


  -- higher order operators
  mapC :: forall n i a b . (KnownNat n, KnownNat i,
                            Convertible_To_DAG_Data a,
                            Convertible_To_DAG_Data b) =>
          Proxy n -> (a -> Seq_Shallow_To_Deep_Env b) ->
          (Seq n i a -> Seq_Shallow_To_Deep_Env (Seq n i b))
  mapC proxyN f x = do
    let n_val = fromInteger $ natVal proxyN
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    outer_dag <- get
    put empty_dag
    put $ empty_dag {next_DAG_index = 1}
    f $ convert_index_to_value 0
    f_dag <- get
    put outer_dag
    add_to_DAG (MapN n_val i_val (get_builder_dag f_dag)) (input_to_maybe_indices x)
      "mapC" "Seq_Edge"
    
  map2C :: forall n i a b c . (KnownNat n, KnownNat i,
                                Convertible_To_DAG_Data a,
                               Convertible_To_DAG_Data b,
                               Convertible_To_DAG_Data c) =>
    Proxy n -> (a -> b -> Seq_Shallow_To_Deep_Env c) ->
    (Seq n i a -> Seq n i b -> Seq_Shallow_To_Deep_Env (Seq n i c))
  map2C proxyN f x y = do
    let n_val = fromInteger $ natVal proxyN
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    outer_dag <- get
    put $ empty_dag {next_DAG_index = 2}
    f (convert_index_to_value 0) (convert_index_to_value 1)
    f_dag <- get
    put outer_dag
    let maybe_indices = liftA2 (++)
          (input_to_maybe_indices x) (input_to_maybe_indices y)
    add_to_DAG (Map2N n_val i_val (get_builder_dag f_dag)) maybe_indices "mapC" "Seq_Edge"

  reduceC :: forall n i a . (KnownNat n, KnownNat i, Convertible_To_DAG_Data a) =>
    Proxy (1+n) -> (a -> a -> Seq_Shallow_To_Deep_Env a) -> Seq (1+n) i a ->
    Seq_Shallow_To_Deep_Env (Seq 1 (n + i) a)
  reduceC proxyN f x = do
    let n_val = fromInteger $ natVal proxyN
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    outer_dag <- get
    put empty_dag
    put $ empty_dag {next_DAG_index = 2}
    f (convert_index_to_value 0) (convert_index_to_value 1)
    f_dag <- get
    put outer_dag
    add_to_DAG (MapN n_val i_val (get_builder_dag f_dag)) (input_to_maybe_indices x)
      "mapC" "Seq_Edge"

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

  atom_tupleC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Convertible_To_DAG_Data a,
                        Convertible_To_DAG_Data b) =>
    a -> b -> Seq_Shallow_To_Deep_Env (Atom_Tuple a b)
  atom_tupleC x y = add_to_DAG (ATupleN (get_AST_type (Proxy :: Proxy a))
                                (get_AST_type (Proxy :: Proxy b)))
                    maybe_indices "zipC" "Atom_Tuple_Edge"
    where
      maybe_indices = liftA2 (++) (input_to_maybe_indices x)
        (input_to_maybe_indices y)

  seq_tupleC :: forall n i a . (Convertible_To_DAG_Data (Seq n i a)) =>
    Seq n i a -> Seq n i a -> Seq_Shallow_To_Deep_Env (Seq_Tuple 2 (Seq n i a))
  seq_tupleC x y = add_to_DAG (STupleN (get_AST_type (Proxy :: Proxy (Seq n i a))))
                   maybe_indices "seq_tupleC" "Seq_Tuple_Edge"
    where
      maybe_indices = liftA2 (++) (input_to_maybe_indices x)
        (input_to_maybe_indices y)


  seq_tuple_appendC :: forall n a .
    (KnownNat n, Convertible_To_DAG_Data (Seq_Tuple n a),
     Convertible_To_DAG_Data a,
     Convertible_To_DAG_Data (Seq_Tuple (n+1) a)) =>
    Seq_Tuple n a -> a -> Seq_Shallow_To_Deep_Env (Seq_Tuple (n+1) a)
  seq_tuple_appendC input_seq input_el =
    add_to_DAG (STupleAppendN (get_AST_type (Proxy :: Proxy (Seq_Tuple (n+1) a)))) 
    maybe_indices "seq_tuple_appendC" "Seq_Tuple_Edge"
    where
      maybe_indices = liftA2 (++) (input_to_maybe_indices input_seq)
        (input_to_maybe_indices input_el)


  seq_tuple_to_seqC :: forall n i a . (KnownNat n, KnownNat i,
                        Convertible_To_DAG_Data a,
                        Convertible_To_DAG_Data (Seq n i a)) =>
    Seq_Tuple n a -> Seq_Shallow_To_Deep_Env (Seq n i a)
  seq_tuple_to_seqC input_tuple =
    add_to_DAG (STupleToSeqN (get_AST_type (Proxy :: Proxy (Seq n i a))))
    (input_to_maybe_indices input_tuple) "seq_tuple_appendC" "Seq_Tuple_Edge"

  seq_to_seq_tupleC :: forall n i a . (KnownNat n,
                        Convertible_To_DAG_Data (Seq n i a),
                        Convertible_To_DAG_Data (Seq_Tuple n a)) =>
    Seq n i a -> Seq_Shallow_To_Deep_Env (Seq_Tuple n a)
  seq_to_seq_tupleC input_tuple =
    add_to_DAG (SeqToSTupleN (get_AST_type (Proxy :: Proxy (Seq_Tuple n a))))
    (input_to_maybe_indices input_tuple) "seq_tuple_appendC" "Seq_Tuple_Edge"

  shiftC :: forall n r i a . (KnownNat n, KnownNat r, KnownNat i,
                             Convertible_To_DAG_Data (Seq (n+r) i a)) =>
    Proxy (n+r) -> Proxy r -> Seq (n+r) i a -> Seq_Shallow_To_Deep_Env (Seq (n+r) i a)
  shiftC proxyLen proxyShiftAmount input_seq =
    add_to_DAG (ShiftN len_val i_val shift_amount_val ast_type)
    (input_to_maybe_indices input_seq) "shiftC" "Seq_Tuple_Edge"
    where
      len_val = fromInteger $ natVal proxyLen
      shift_amount_val = fromInteger $ natVal proxyShiftAmount
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      ast_type = get_AST_type (Proxy :: Proxy (Seq (n+r) i a))

  -- composition operators
  (>>>) f g x = f x >>= g

sym_input_unit :: Seq_Shallow_To_Deep_Env Atom_Unit
sym_input_unit = add_to_DAG (InputN UnitT) (Just []) "sym_input_unit" ""
sym_input_int :: Seq_Shallow_To_Deep_Env Atom_Int
sym_input_int = add_to_DAG (InputN IntT) (Just []) "sym_input_int" ""
sym_input_bit :: Seq_Shallow_To_Deep_Env Atom_Bit
sym_input_bit = add_to_DAG (InputN BitT) (Just []) "sym_input_bit" ""
sym_input_atom_tuple :: forall a b .
  (Convertible_To_DAG_Data a, Convertible_To_DAG_Data b) =>
                    Seq_Shallow_To_Deep_Env (Atom_Tuple a b)
sym_input_atom_tuple = add_to_DAG (InputN tuple_type) (Just []) "sym_input_tuple" ""
  where
    a_proxy = Proxy :: Proxy a
    b_proxy = Proxy :: Proxy b
    tuple_type = ATupleT (get_AST_type a_proxy) (get_AST_type b_proxy)
sym_input_seq :: forall a n i . (KnownNat n, KnownNat i,
                                  Convertible_To_DAG_Data a) =>
  Proxy n -> Seq_Shallow_To_Deep_Env (Seq n i a)
sym_input_seq proxyN = add_to_DAG (InputN seq_type) (Just []) "sym_input_tuple" ""
  where
    a_proxy = Proxy :: Proxy a
    n_val = fromInteger $ natVal proxyN
    i_val = fromInteger $ natVal (Proxy :: Proxy i)
    seq_type = SeqT n_val i_val (get_AST_type a_proxy)



module Aetherling.Interpretations.Sequence_Shallow_To_Deep where
import Aetherling.ASTs.Sequence
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Types.Isomorphisms
import Aetherling.Interpretations.Monad_Helpers
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Identity
import Data.Proxy
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

add_to_DAG :: (Aetherling_Value a) =>
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
    return (convert_index_to_ae_value cur_node_index)
    else do
    throwError $ fail_message_edge node_name args_name

input_to_maybe_indices :: (Aetherling_Value a) =>
  a -> Maybe [DAG_Index]
input_to_maybe_indices input = traverse convert_ae_value_to_index [input]

instance Sequence_Language Seq_Shallow_To_Deep_Env where
  -- unary operators
  idC x = add_to_DAG IdN (input_to_maybe_indices x) "idC" "any_input_edge"
  absC x = add_to_DAG AbsN (input_to_maybe_indices x) "absC" "Atom_Int"
  notC x = add_to_DAG NotN (input_to_maybe_indices x) "absC" "Atom_Bit"

  -- binary operators
  addC x = add_to_DAG AddN (input_to_maybe_indices x) "addC" "Atom_Tuple"

  eqC :: forall a . (Aetherling_Value a, Check_Type_Is_Atom a, Eq a) =>
    Atom_Tuple a a -> Seq_Shallow_To_Deep_Env Atom_Bit
  eqC x = add_to_DAG eq_node (input_to_maybe_indices x) "eqC" "Atom_Tuple"
    where
      input_type_proxy = Proxy :: Proxy a
      eq_node = EqN (get_AST_type input_type_proxy)

  -- generators
  lut_genC table x = do
    let lut_table_maybe = traverse get_AST_value table
    if isJust lut_table_maybe
      then do
      add_to_DAG (Lut_GenN $ fromJust lut_table_maybe) (input_to_maybe_indices x)
        "lut_genC" "Atom_Int_edge"
      else do
      throwError $ fail_message_edge "lut_genC" "[a]"

  const_genC const = do
    let const_maybe = get_AST_value const
    if isJust const_maybe
      then do
      add_to_DAG (Const_GenN $ fromJust const_maybe) (Just [])
        "const_genC" "Atom_Unit"
      else do
      throwError $ fail_message_edge "const_genC" "a"

  -- sequence operators
  shiftC :: forall n r i a . (KnownNat n, KnownNat r, KnownNat i,
                             Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> Seq (n+r) i a -> Seq_Shallow_To_Deep_Env (Seq (n+r) i a)
  shiftC proxyLen proxyShiftAmount input_seq =
    add_to_DAG (ShiftN len_val i_val shift_amount_val ast_type)
    (input_to_maybe_indices input_seq) "shiftC" "Seq_Tuple"
    where
      len_val = fromInteger $ natVal proxyLen
      shift_amount_val = fromInteger $ natVal proxyShiftAmount
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      ast_type = get_AST_type (Proxy :: Proxy a)

  up_1dC :: forall n a i . (KnownNat n, KnownNat i,
                          Aetherling_Value a) =>
            Proxy (1+n) -> 
            Seq 1 (n + i) a -> Seq_Shallow_To_Deep_Env (Seq (1+n) i a)
  up_1dC proxyN x = add_to_DAG
    (Up_1dN n_val i_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "up_1dC" "Seq"
    where
      n_val = fromInteger $ natVal proxyN
      i_val = fromInteger $ natVal (Proxy :: Proxy i)

  down_1dC :: forall n a i . (KnownNat n, KnownNat i,
                              Aetherling_Value a) =>
              Proxy (1+n) -> 
              Seq (1+n) i a -> Seq_Shallow_To_Deep_Env (Seq 1 (n + i) a)
  down_1dC proxyN x = add_to_DAG
    (Down_1dN n_val i_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "down_1dC" "Seq"
    where
      n_val = fromInteger $ natVal proxyN
      i_val = fromInteger $ natVal (Proxy :: Proxy i)


  partitionC :: forall no ni io ii a .
    (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
      KnownNat io, KnownNat ii,
      Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a ->
    Seq_Shallow_To_Deep_Env (Seq no io (Seq ni ii a))
  partitionC proxyNO proxyNI x = add_to_DAG
    (PartitionN no_val ni_val io_val ii_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "partitionC" "Seq"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)

  unpartitionC :: forall no ni io ii a .
    (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
      KnownNat io, KnownNat ii,
      Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    Seq no io (Seq ni ii a) ->
    Seq_Shallow_To_Deep_Env (Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a)
  unpartitionC proxyNO proxyNI x = add_to_DAG
    (UnpartitionN no_val ni_val io_val ii_val (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices x) "unpartitionC" "Seq"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)


  -- higher order operators
  mapC :: forall n i a b . (KnownNat n, KnownNat i,
                            Aetherling_Value a,
                            Aetherling_Value b) =>
          Proxy n -> (a -> Seq_Shallow_To_Deep_Env b) ->
          (Seq n i a -> Seq_Shallow_To_Deep_Env (Seq n i b))
  mapC proxyN f x = do
    let n_val = fromInteger $ natVal proxyN
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    outer_dag <- get
    put empty_dag
    put $ empty_dag {next_DAG_index = 0}
    f $ convert_index_to_ae_value (-1)
    f_dag <- get
    put outer_dag
    add_to_DAG (MapN n_val i_val (get_builder_dag f_dag)) (input_to_maybe_indices x)
      "mapC" "Seq"
    
  map2C :: forall n i a b c . (KnownNat n, KnownNat i,
                                Aetherling_Value a,
                               Aetherling_Value b,
                               Aetherling_Value c) =>
    Proxy n -> (a -> b -> Seq_Shallow_To_Deep_Env c) ->
    (Seq n i a -> Seq n i b -> Seq_Shallow_To_Deep_Env (Seq n i c))
  map2C proxyN f x y = do
    let n_val = fromInteger $ natVal proxyN
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    outer_dag <- get
    put $ empty_dag {next_DAG_index = 0}
    f (convert_index_to_ae_value (-2)) (convert_index_to_ae_value (-1))
    f_dag <- get
    put outer_dag
    let maybe_indices = liftA2 (++)
          (input_to_maybe_indices x) (input_to_maybe_indices y)
    add_to_DAG (Map2N n_val i_val (get_builder_dag f_dag)) maybe_indices "mapC" "Seq"

  reduceC :: forall n i a . (KnownNat n, KnownNat i, Aetherling_Value a) =>
    Proxy (1+n) -> (Atom_Tuple a a -> Seq_Shallow_To_Deep_Env a) ->
    Seq (1+n) i a -> Seq_Shallow_To_Deep_Env (Seq 1 (n + i) a)
  reduceC proxyN f x = do
    let n_val = fromInteger $ natVal proxyN
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    outer_dag <- get
    put empty_dag
    put $ empty_dag {next_DAG_index = 0}
    f (convert_index_to_ae_value (-1))
    f_dag <- get
    put outer_dag
    add_to_DAG (ReduceN n_val i_val (get_builder_dag f_dag)) (input_to_maybe_indices x)
      "reduceC" "Seq"

  fstC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Atom_Tuple a b -> Seq_Shallow_To_Deep_Env a
  fstC x = add_to_DAG (SndN (get_AST_type (Proxy :: Proxy a))
                       (get_AST_type (Proxy :: Proxy b)))
           (input_to_maybe_indices x) "fstC" "Atom_Tuple"

  sndC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Atom_Tuple a b -> Seq_Shallow_To_Deep_Env b
  sndC x = add_to_DAG (SndN (get_AST_type (Proxy :: Proxy a))
                       (get_AST_type (Proxy :: Proxy b)))
           (input_to_maybe_indices x) "sndC" "Atom_Tuple"

  atom_tupleC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    a -> b -> Seq_Shallow_To_Deep_Env (Atom_Tuple a b)
  atom_tupleC x y = add_to_DAG (ATupleN (get_AST_type (Proxy :: Proxy a))
                                (get_AST_type (Proxy :: Proxy b)))
                    maybe_indices "atom_tupleC" "Atom_Tuple"
    where
      maybe_indices = liftA2 (++) (input_to_maybe_indices x)
        (input_to_maybe_indices y)

  seq_tupleC :: forall n i a . (Aetherling_Value (Seq n i a)) =>
    Seq n i a -> Seq n i a -> Seq_Shallow_To_Deep_Env (Seq_Tuple 2 (Seq n i a))
  seq_tupleC x y = add_to_DAG (STupleN (get_AST_type (Proxy :: Proxy (Seq n i a))))
                   maybe_indices "seq_tupleC" "Seq_Tuple"
    where
      maybe_indices = liftA2 (++) (input_to_maybe_indices x)
        (input_to_maybe_indices y)


  seq_tuple_appendC :: forall n a .
    (KnownNat n, Aetherling_Value a,
     Aetherling_Value (Seq_Tuple (n+1) a)) =>
    Seq_Tuple n a -> a -> Seq_Shallow_To_Deep_Env (Seq_Tuple (n+1) a)
  seq_tuple_appendC input_seq input_el =
    add_to_DAG (STupleAppendN output_length (get_AST_type (Proxy :: Proxy a)))
    maybe_indices "seq_tuple_appendC" "Seq_Tuple"
    where
      output_length = fromInteger $ natVal (Proxy :: Proxy (n+1))
      maybe_indices = liftA2 (++) (input_to_maybe_indices input_seq)
        (input_to_maybe_indices input_el)


  seq_tuple_to_seqC :: forall n i a . (KnownNat n,
                        Aetherling_Value a,
                        Aetherling_Value (Seq n i a)) =>
    Seq_Tuple n a -> Seq_Shallow_To_Deep_Env (Seq n i a)
  seq_tuple_to_seqC input_tuple =
    add_to_DAG (STupleToSeqN tuple_length (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices input_tuple) "seq_tuple_appendC" "Seq_Tuple"
    where
      tuple_length = fromInteger $ natVal (Proxy :: Proxy n)

  seq_to_seq_tupleC :: forall n i a . (KnownNat n, KnownNat i,
                        Aetherling_Value a,
                        Aetherling_Value (Seq_Tuple n a)) =>
    Seq n i a -> Seq_Shallow_To_Deep_Env (Seq_Tuple n a)
  seq_to_seq_tupleC input_tuple =
    add_to_DAG (SeqToSTupleN tuple_length (get_AST_type (Proxy :: Proxy a)))
    (input_to_maybe_indices input_tuple) "seq_tuple_appendC" "Seq_Tuple"
    where
      tuple_length = fromInteger $ natVal (Proxy :: Proxy n)

  -- composition operators
  (>>>) f g x = f x >>= g

sym_input_unit :: Seq_Shallow_To_Deep_Env Atom_Unit
sym_input_unit = add_to_DAG (InputN UnitT) (Just []) "sym_input_unit" ""
sym_input_int :: Seq_Shallow_To_Deep_Env Atom_Int
sym_input_int = add_to_DAG (InputN IntT) (Just []) "sym_input_int" ""
sym_input_bit :: Seq_Shallow_To_Deep_Env Atom_Bit
sym_input_bit = add_to_DAG (InputN BitT) (Just []) "sym_input_bit" ""
sym_input_atom_tuple :: forall a b .
  (Aetherling_Value a, Aetherling_Value b) =>
                    Seq_Shallow_To_Deep_Env (Atom_Tuple a b)
sym_input_atom_tuple = add_to_DAG (InputN tuple_type) (Just []) "sym_input_tuple" ""
  where
    a_proxy = Proxy :: Proxy a
    b_proxy = Proxy :: Proxy b
    tuple_type = ATupleT (get_AST_type a_proxy) (get_AST_type b_proxy)
sym_input_seq :: forall a n i . (KnownNat n, KnownNat i,
                                  Aetherling_Value a) =>
  Seq_Shallow_To_Deep_Env (Seq n i a)
sym_input_seq = add_to_DAG (InputN seq_type) (Just []) "sym_input_tuple" ""
  where
    a_proxy = Proxy :: Proxy a
    n_val = fromInteger $ natVal (Proxy :: Proxy n)
    i_val = fromInteger $ natVal (Proxy :: Proxy i)
    seq_type = SeqT n_val i_val (get_AST_type a_proxy)



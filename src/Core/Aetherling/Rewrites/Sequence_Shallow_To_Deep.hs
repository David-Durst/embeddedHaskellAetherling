module Aetherling.Rewrites.Sequence_Shallow_To_Deep where
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Shallow.Functions
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Isomorphisms
import Aetherling.Monad_Helpers
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Identity
import Data.Proxy
import Data.Maybe
import Control.Applicative
import GHC.TypeLits
import Unsafe.Coerce
import Data.Either
import qualified Data.Vector.Sized as V
import qualified Data.Map.Lazy as M
import Util

compile :: (Aetherling_Value a) => Compilation_Env a -> Expr
compile (Compilation_Env shallow_program) = do
  let expr_maybe = edge_to_maybe_expr shallow_program 
  if isJust expr_maybe
    then fromJust expr_maybe
    else ErrorN "Not an edge, please pass in the result of calling compile"
    
instance Sequence_Language Compilation_Env where
  -- unary operators
  idC x = x
    --add_to_DAG IdN (input_to_maybe_indices x) "idC" "any_input_edge"
  absC (Compilation_Env (Atom_Int_Edge x)) = return $ Atom_Int_Edge $ AbsN x
  absC _ = fail $ fail_message_edge "absC" "Atom_Int"

  notC (Compilation_Env (Atom_Bit_Edge x)) = return $ Atom_Bit_Edge $ NotN x
  notC _ = fail $ fail_message_edge "absC" "Atom_Bit"

  -- binary operators
  addC (Compilation_Env (Atom_Tuple_Edge x)) = return $ Atom_Int_Edge $ AddN x
  addC _ = fail $ fail_message_edge "addC" "Atom_Tuple Atom_Int Atom_Int"

  subC (Compilation_Env (Atom_Tuple_Edge x)) = return $ Atom_Int_Edge $ SubN x
  subC _ = fail $ fail_message_edge "subC" "Atom_Tuple Atom_Int Atom_Int"

  mulC (Compilation_Env (Atom_Tuple_Edge x)) = return $ Atom_Int_Edge $ MulN x
  mulC _ = fail $ fail_message_edge "mulC" "Atom_Tuple Atom_Int Atom_Int"

  divC (Compilation_Env (Atom_Tuple_Edge x)) = return $ Atom_Int_Edge $ DivN x
  divC _ = fail $ fail_message_edge "divC" "Atom_Tuple Atom_Int Atom_Int"

  eqC :: forall a . (Aetherling_Value a, Check_Type_Is_Atom a, Eq a) =>
    Compilation_Env (Atom_Tuple a a) -> Compilation_Env Atom_Bit
  eqC (Compilation_Env (Atom_Tuple_Edge x)) = return $ Atom_Bit_Edge $
    EqN (get_AST_type (Proxy :: Proxy a)) x
  eqC _ = fail $ fail_message_edge "eqC" "Atom_Tuple Atom_Int Atom_Int"

  -- generators
  lut_genC :: forall a . Aetherling_Value a => [a] -> Compilation_Env Atom_Int ->
    Compilation_Env a
  lut_genC table (Compilation_Env x) = do
    let x_expr_maybe = edge_to_maybe_expr x
    let a_proxy = Proxy :: Proxy a
    let lut_table_maybe = traverse get_AST_value table
    if isJust lut_table_maybe && isJust x_expr_maybe
      then do
      return $ expr_to_edge $
        Lut_GenN (fromJust lut_table_maybe) (get_AST_type a_proxy) (fromJust x_expr_maybe)
      else do
      fail $ fail_message_edge "lut_genC" "[a] -> Atom_Int"

  const_genC :: forall a b . Aetherling_Value a => a -> Compilation_Env b ->
    Compilation_Env a
  const_genC const _ = do
    let const_expr_maybe = get_AST_value const
    if isJust const_expr_maybe
      then do
      return $ expr_to_edge $
        Const_GenN (fromJust const_expr_maybe) (get_AST_type (Proxy :: Proxy a))
      else do
      fail $ fail_message_edge "const_genC" "any_edge"

  -- generators
  shiftC shift_amount_proxy input_vec = shiftC' Proxy shift_amount_proxy input_vec
  
  shiftC' :: forall n r i a . (KnownNat n, KnownNat r, KnownNat i,
                             Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> Compilation_Env (Seq (n+r) i a) -> Compilation_Env (Seq (n+r) i a)
  shiftC' len_proxy shift_amount_proxy (Compilation_Env (Seq_Edge x)) = return $
    Seq_Edge $ ShiftN len shift i_val a_type x
    where
      len = fromInteger $ natVal len_proxy
      shift = fromInteger $ natVal shift_amount_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)
  shiftC' _ _ _ = fail $ fail_message_edge "shiftC" "Seq"
  
  up_1dC :: forall a n i . (KnownNat n, KnownNat i,
             Aetherling_Value a) =>
    Proxy (1+n) -> Compilation_Env (Seq 1 (n + i) a) -> Compilation_Env (Seq (1+n) i a)
  up_1dC len_proxy (Compilation_Env (Seq_Edge x)) = return $ Seq_Edge $
    Up_1dN len i_val a_type x
    where
      len = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)
  up_1dC _ _ = fail $ fail_message_edge "up_1dC" "Seq"

  down_1dC sel_idx x = down_1dC' Proxy sel_idx x
  
  down_1dC' :: forall a n i . (KnownNat n, KnownNat i,
                Aetherling_Value a) =>
    Proxy (1+n) -> Int -> Compilation_Env (Seq (1+n) i a) ->
    Compilation_Env (Seq 1 (n + i) a)
  down_1dC' len_proxy sel_idx (Compilation_Env (Seq_Edge x)) = return $ Seq_Edge $
    Down_1dN len i_val sel_idx a_type x
    where
      len = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)
  down_1dC' _ _ _ = fail $ fail_message_edge "down_1dC" "Seq"
  
  partitionC :: forall no ni io ii a .
                (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                 KnownNat io, KnownNat ii,
                 Aetherling_Value a) =>
    Proxy no -> Proxy ni -> Proxy io -> Proxy ii ->
    Compilation_Env (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                io GHC.TypeLits.* (ni + ii)) a) ->
    Compilation_Env (Seq no io (Seq ni ii a))
  partitionC proxyNO proxyNI proxyIO proxyII (Compilation_Env (Seq_Edge x)) =
    return $ Seq_Edge $ PartitionN no_val ni_val io_val ii_val a_type x
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal proxyIO
      ii_val = fromInteger $ natVal proxyII
      a_type = get_AST_type (Proxy :: Proxy a)
  partitionC _ _ _ _ _ = fail $ fail_message_edge "partitionC" "Seq"

  unpartitionC x = unpartitionC' Proxy Proxy x

  unpartitionC' :: forall no ni io ii a .
                   (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                    KnownNat io, KnownNat ii,
                    Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    Compilation_Env (Seq no io (Seq ni ii a)) ->
    Compilation_Env (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                   io GHC.TypeLits.* (ni + ii)) a)
  unpartitionC' proxyNO proxyNI (Compilation_Env (Seq_Edge x)) =
    return $ Seq_Edge $ UnpartitionN no_val ni_val io_val ii_val a_type x
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)
      a_type = get_AST_type (Proxy :: Proxy a)
  unpartitionC' _ _ _ = fail $ fail_message_edge "unpartitionC" "Seq"
  
  -- higher order operators

  mapC f x = mapC' Proxy f x

  mapC' :: forall n i a b . (KnownNat n, KnownNat i,
           Aetherling_Value a,
           Aetherling_Value b) =>
    Proxy n -> (Compilation_Env a -> Compilation_Env b) ->
    Compilation_Env (Seq n i a) -> Compilation_Env (Seq n i b)
  mapC' len_proxy f (Compilation_Env (Seq_Edge x)) = return $ Seq_Edge $
    MapN len_val i_val f_ast x
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      f_ast = compile $ f (return $ get_input_edge "f_in")
  mapC' _ _ _ = fail $ fail_message_edge "mapC" "Seq"

  map2C f x y = map2C' Proxy f x y

  map2C' :: forall n i a b c . (KnownNat n, KnownNat i,
                                Aetherling_Value a,
                                Aetherling_Value b,
                                Aetherling_Value c) =>
    Proxy n ->
    (Compilation_Env a -> Compilation_Env b -> Compilation_Env c) ->
    Compilation_Env (Seq n i a) -> Compilation_Env (Seq n i b) -> Compilation_Env (Seq n i c)
  map2C' len_proxy f (Compilation_Env (Seq_Edge x)) (Compilation_Env (Seq_Edge y)) =
    return $ Seq_Edge $ Map2N len_val i_val f_ast x y
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      f_ast = compile $
        f (return $ get_input_edge "f_in1") (return $ get_input_edge "f_in2")
  map2C' _ _ _ _ = fail $ fail_message_edge "mapC" "Seq"

  reduceC f x = reduceC' Proxy f x

  reduceC' :: forall n i a . (KnownNat n, KnownNat i,
                              Aetherling_Value a) =>
    Proxy (1+n) -> (Compilation_Env (Atom_Tuple a a) -> Compilation_Env a) ->
    Compilation_Env (Seq (1+n) i a) -> Compilation_Env (Seq 1 (n + i) a)
  reduceC' len_proxy f (Compilation_Env (Seq_Edge x)) = return $ Seq_Edge $
    ReduceN len_val i_val f_ast x
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      f_ast = compile $ f (return $ get_input_edge "f_in")
  reduceC' _ _ _ = fail $ fail_message_edge "reduceC" "Seq"
  
  fstC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Compilation_Env (Atom_Tuple a b) -> Compilation_Env a
  fstC (Compilation_Env (Atom_Tuple_Edge x)) = return $ expr_to_edge $
    FstN a_type b_type x
    where
      a_type = get_AST_type (Proxy :: Proxy a)
      b_type = get_AST_type (Proxy :: Proxy b)
  fstC _ = fail $ fail_message_edge "fstC" "Atom_Tuple"

  sndC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Compilation_Env (Atom_Tuple a b) -> Compilation_Env b
  sndC (Compilation_Env (Atom_Tuple_Edge x)) = return $ expr_to_edge $
    SndN a_type b_type x
    where
      a_type = get_AST_type (Proxy :: Proxy a)
      b_type = get_AST_type (Proxy :: Proxy b)
  sndC _ = fail $ fail_message_edge "sndC" "Atom_Tuple"

  atom_tupleC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                               Aetherling_Value a,
                               Aetherling_Value b) =>
    Compilation_Env a -> Compilation_Env b -> Compilation_Env (Atom_Tuple a b)
  atom_tupleC (Compilation_Env x) (Compilation_Env y) = do
    let a_type = get_AST_type (Proxy :: Proxy a)
    let b_type = get_AST_type (Proxy :: Proxy b)
    let x_expr_maybe = edge_to_maybe_expr x
    let y_expr_maybe = edge_to_maybe_expr y
    if isJust x_expr_maybe && isJust y_expr_maybe
      then return $ Atom_Tuple_Edge $
           ATupleN a_type b_type (fromJust x_expr_maybe) (fromJust y_expr_maybe)
      else fail $ fail_message_edge "atom_tupleC" "any_atom"

  seq_tupleC :: forall a . (Aetherling_Value a) =>
    Compilation_Env a -> Compilation_Env a ->
    Compilation_Env (Seq_Tuple 2 a)
  seq_tupleC (Compilation_Env x) (Compilation_Env y) = do
    let a_type = get_AST_type (Proxy :: Proxy a)
    let x_expr_maybe = edge_to_maybe_expr x
    let y_expr_maybe = edge_to_maybe_expr y
    if isJust x_expr_maybe && isJust y_expr_maybe
      then return $ Seq_Tuple_Edge $
           STupleN a_type (fromJust x_expr_maybe) (fromJust y_expr_maybe)
      else fail $ fail_message_edge "seq_tupleC" "any"

  zipC :: forall a l n i . (Aetherling_Value a, KnownNat l, KnownNat n, KnownNat i) =>
    Proxy l -> [Compilation_Env (Seq n i a)] -> Compilation_Env (Seq n i (Seq_Tuple l a))
  zipC len_proxy wrapped_x | natVal len_proxy > 2 = do
    let x = fmap compile wrapped_x
    let a_type = get_AST_type (Proxy :: Proxy a)
    let n_val = fromInteger $ natVal len_proxy
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    -- this will be used after initial step in the fold
    let map_stuple_append out_len in_left in_right = Map2N n_val i_val
                                                      (STupleAppendN out_len
                                                        a_type
                                                        (InputN a_type "tuple_in_1")
                                                        (InputN a_type "tuple_in_2"))
                                                      in_left in_right
    -- the initial step in the fold
    let map_stuple_initial = Map2N n_val i_val
                              (STupleN a_type 
                                (InputN a_type "tuple_in_1")
                                (InputN a_type "tuple_in_2")
                              )
                              (x !! 0) (x !! 1)
    let tupled_expr = foldl (\prior_tuples cur_len -> map_stuple_append
                                                      cur_len
                                                      prior_tuples
                                                      (x !! (cur_len - 1)))
                      -- start at 3 to set
                      map_stuple_initial [3 .. length x]
    return $ Seq_Edge tupled_expr
  zipC _ _ = fail "zipC must have at least 3 inputs, otherwise use seq_tupleC"

  
  seq_tuple_appendC :: forall n a . (KnownNat n, Aetherling_Value (Seq_Tuple n a),
                                     Aetherling_Value a,
                                     Aetherling_Value (Seq_Tuple (n+1) a)) =>
    Compilation_Env (Seq_Tuple n a) -> Compilation_Env a ->
    Compilation_Env (Seq_Tuple (n+1) a)
  seq_tuple_appendC (Compilation_Env (Seq_Tuple_Edge x)) (Compilation_Env wrapped_y) = do
    let y_expr_maybe = edge_to_maybe_expr wrapped_y
    if isJust y_expr_maybe
      then do
      let y = fromJust y_expr_maybe
      let out_len = fromInteger $ natVal (Proxy :: Proxy (n+1))
      let a_type = get_AST_type (Proxy :: Proxy a)
      return $ Seq_Tuple_Edge $ STupleAppendN out_len a_type x y
      else fail $ fail_message_edge "seq_tuple_appendC" "for second input any"
  seq_tuple_appendC _ _ = fail $ fail_message_edge "seq_tuple_appendC" "for first input seq_tuple"
  
  seq_tuple_to_seqC :: forall no ni io ii a .
                       (KnownNat no, KnownNat ni,
                        KnownNat io, KnownNat ii,
                        Aetherling_Value a) =>
    Proxy io -> Proxy ii ->
    Compilation_Env (Seq no ((no GHC.TypeLits.* ((ni - 1) + ii)) + (io GHC.TypeLits.* (ni + ii)))
       (Seq_Tuple ni a)) ->
    Compilation_Env (Seq no io (Seq ni ii a))
  seq_tuple_to_seqC proxyIO proxyII (Compilation_Env (Seq_Edge x)) =
    return $ Seq_Edge $ STupleToSeqN no_val ni_val io_val ii_val a_type x
    where
      no_val = fromInteger $ natVal (Proxy :: Proxy no)
      ni_val = fromInteger $ natVal (Proxy :: Proxy ni)
      io_val = fromInteger $ natVal proxyIO
      ii_val = fromInteger $ natVal proxyII
      a_type = get_AST_type (Proxy :: Proxy a)
  seq_tuple_to_seqC _ _ _ = fail $ fail_message_edge "seq_tuple_to_seqC" "seq_tuple"
  
  seq_to_seq_tupleC :: forall no ni io ii a .
                       (KnownNat no, KnownNat ni, 
                        KnownNat io, KnownNat ii,
                        Aetherling_Value a) =>
    Compilation_Env (Seq no io (Seq ni ii a)) ->
    Compilation_Env (Seq no ((no GHC.TypeLits.* ((ni - 1) + ii)) + (io GHC.TypeLits.* (ni + ii)))
       (Seq_Tuple ni a))
  seq_to_seq_tupleC (Compilation_Env (Seq_Edge x)) = 
    return $ Seq_Edge $ SeqToSTupleN no_val ni_val io_val ii_val a_type x
    where
      no_val = fromInteger $ natVal (Proxy :: Proxy no)
      ni_val = fromInteger $ natVal (Proxy :: Proxy ni)
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)
      a_type = get_AST_type (Proxy :: Proxy a)
  seq_to_seq_tupleC _ = fail $ fail_message_edge "seq_to_seq_tupleC" "seq"
  
  -- composition operators
  (>>>) f g = g . f

data Compilation_Env a = Compilation_Env a
  deriving (Show, Eq, Functor)

instance Applicative Compilation_Env where
  pure a = Compilation_Env a
  Compilation_Env f <*> Compilation_Env a = Compilation_Env $ f a

instance Monad Compilation_Env where
  (Compilation_Env a) >>= f = f a
  return a = Compilation_Env a
  
com_input_unit :: String -> Compilation_Env Atom_Unit
com_input_unit s = return $ Atom_Unit_Edge $ InputN UnitT s
com_input_int :: String -> Compilation_Env Atom_Int
com_input_int s = return $ Atom_Int_Edge $ InputN IntT s
com_input_bit :: String -> Compilation_Env Atom_Bit
com_input_bit s = return $ Atom_Bit_Edge $ InputN BitT s
com_input_atom_tuple :: (Aetherling_Value a, Aetherling_Value b) => String ->
  Proxy (Atom_Tuple a b) -> Compilation_Env (Atom_Tuple a b)
com_input_atom_tuple s a_proxy =
  return $ Atom_Tuple_Edge $ InputN (get_AST_type a_proxy) s
com_input_seq :: (KnownNat n, KnownNat i, Aetherling_Value a) => String ->
  Proxy (Seq n i a) -> Compilation_Env (Seq n i a)
com_input_seq s a_proxy =
  return $ Seq_Edge $ InputN (get_AST_type a_proxy) s
{-
com_input_atom_tuple :: forall a b .
  (Aetherling_Value a, Aetherling_Value b) =>
                    Seq_Shallow_To_Deep_Env (Atom_Tuple a b)
com_input_atom_tuple = add_to_DAG (InputN tuple_type) (Just []) "com_input_tuple" ""
  where
    a_proxy = Proxy :: Proxy a
    b_proxy = Proxy :: Proxy b
    tuple_type = ATupleT (get_AST_type a_proxy) (get_AST_type b_proxy)
com_input_seq :: forall a n i . (KnownNat n, KnownNat i,
                                  Aetherling_Value a) =>
  Seq_Shallow_To_Deep_Env (Seq n i a)
com_input_seq = add_to_DAG (InputN seq_type) (Just []) "com_input_tuple" ""
  where
    a_proxy = Proxy :: Proxy a
    n_val = fromInteger $ natVal (Proxy :: Proxy n)
    i_val = fromInteger $ natVal (Proxy :: Proxy i)
    seq_type = SeqT n_val i_val (get_AST_type a_proxy)


-}

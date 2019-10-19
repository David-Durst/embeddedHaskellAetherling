module Aetherling.Rewrites.Sequence_Shallow_To_Deep where
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Shallow.Expr_Type_Conversions
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

seq_shallow_to_deep :: (Aetherling_Value a) => Rewrite_StateM a -> Expr
seq_shallow_to_deep shallow_programM = do
  let shallow_program = fromRight undefined $
        evalState (runExceptT shallow_programM) empty_rewrite_data
  let expr_maybe = edge_to_maybe_expr shallow_program 
  if isJust expr_maybe
    then fromJust expr_maybe
    else ErrorN "Not an edge, please pass in the result of calling compile" No_Index
    
instance Sequence_Language Rewrite_StateM where
  -- unary operators
  idC x = x
    --add_to_DAG IdN (input_to_maybe_indices x) "idC" "any_input_edge"
  absC inputM = do
    input <- inputM
    case input of
      Atom_Int_Edge x -> return $ Atom_Int_Edge $ AbsN x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "absC" "Atom_Int"

  notC inputM = do
    input <- inputM
    case input of
      Atom_Bit_Edge x -> return $ Atom_Bit_Edge $ NotN x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "absC" "Atom_Bit"

  -- binary operators
  addC inputM = do
    input <- inputM
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ AddN x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "addC" "Atom_Tuple Atom_Int Atom_Int"

  subC inputM = do
    input <- inputM
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ SubN x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "subC" "Atom_Tuple Atom_Int Atom_Int"

  mulC inputM = do
    input <- inputM
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ MulN x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "mulC" "Atom_Tuple Atom_Int Atom_Int"

  divC inputM = do
    input <- inputM
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ DivN x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "divC" "Atom_Tuple Atom_Int Atom_Int"

  eqC :: forall a . (Aetherling_Value a, Check_Type_Is_Atom a, Eq a) =>
    Rewrite_StateM (Atom_Tuple a a) -> Rewrite_StateM Atom_Bit
  eqC inputM = do
    input <- inputM
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Bit_Edge $
        EqN (get_AST_type (Proxy :: Proxy a)) x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "eqC" "Atom_Tuple any_type any_type"
      
  -- generators
  lut_genC :: forall a . Aetherling_Value a => [a] -> Rewrite_StateM Atom_Int ->
    Rewrite_StateM a
  lut_genC table inputM = do
    input <- inputM
    let input_expr_maybe = edge_to_maybe_expr input
    let a_proxy = Proxy :: Proxy a
    let lut_table_maybe = traverse get_AST_value table
    if isJust lut_table_maybe && isJust input_expr_maybe
      then do
      return $ expr_to_edge $
        Lut_GenN (fromJust lut_table_maybe)
        (get_AST_type a_proxy) (fromJust input_expr_maybe) No_Index
      else do
      throwError $ Expr_Failure $ fail_message_edge "lut_genC" "[a] -> Atom_Int"

  const_genC :: forall a b . Aetherling_Value a => a -> Rewrite_StateM b ->
    Rewrite_StateM a
  const_genC const _ = do
    let const_expr_maybe = get_AST_value const
    if isJust const_expr_maybe
      then do
      return $ expr_to_edge $
        Const_GenN (fromJust const_expr_maybe) (get_AST_type (Proxy :: Proxy a)) No_Index
      else do
      throwError $ Expr_Failure $ fail_message_edge "const_genC" "any_edge"

  -- sequence operators
  -- generators
  shiftC shift_amount_proxy input_vec = shiftC' Proxy shift_amount_proxy input_vec
  
  shiftC' :: forall n r i a . (KnownNat n, KnownNat r, KnownNat i,
                             Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> Rewrite_StateM (Seq (n+r) i a) -> Rewrite_StateM (Seq (n+r) i a)
  shiftC' len_proxy shift_amount_proxy inputM = do
    input <- inputM
    case input of
      Seq_Edge x -> return $ Seq_Edge $ ShiftN len i_val shift a_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "shiftC" "Seq"
    where
      len = fromInteger $ natVal len_proxy
      shift = fromInteger $ natVal shift_amount_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)
  
  up_1dC :: forall a n i . (KnownNat n, KnownNat i,
             Aetherling_Value a) =>
    Proxy (1+n) -> Rewrite_StateM (Seq 1 (n + i) a) -> Rewrite_StateM (Seq (1+n) i a)
  up_1dC len_proxy inputM = do
    input <- inputM
    case input of
      Seq_Edge x -> return $ Seq_Edge $ Up_1dN len i_val a_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "up_1dC" "Seq"
    where
      len = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)

  down_1dC sel_idx x = down_1dC' Proxy sel_idx x
  
  down_1dC' :: forall a n i . (KnownNat n, KnownNat i,
                Aetherling_Value a) =>
    Proxy (1+n) -> Int -> Rewrite_StateM (Seq (1+n) i a) ->
    Rewrite_StateM (Seq 1 (n + i) a)
  down_1dC' len_proxy sel_idx inputM = do
    input <- inputM
    case input of
      Seq_Edge x -> return $ Seq_Edge $ Down_1dN len i_val sel_idx a_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "down_1dC" "Seq"
    where
      len = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)
  
  partitionC :: forall no ni io ii a .
                (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                 KnownNat io, KnownNat ii,
                 Aetherling_Value a) =>
    Proxy no -> Proxy ni -> Proxy io -> Proxy ii ->
    Rewrite_StateM (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                io GHC.TypeLits.* (ni + ii)) a) ->
    Rewrite_StateM (Seq no io (Seq ni ii a))
  partitionC proxyNO proxyNI proxyIO proxyII inputM = do
    input <- inputM
    case input of
      Seq_Edge x -> return $ Seq_Edge $ PartitionN no_val ni_val io_val ii_val a_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "partitionC" "Seq"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal proxyIO
      ii_val = fromInteger $ natVal proxyII
      a_type = get_AST_type (Proxy :: Proxy a)

  unpartitionC x = unpartitionC' Proxy Proxy x

  unpartitionC' :: forall no ni io ii a .
                   (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                    KnownNat io, KnownNat ii,
                    Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    Rewrite_StateM (Seq no io (Seq ni ii a)) ->
    Rewrite_StateM (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                   io GHC.TypeLits.* (ni + ii)) a)
  unpartitionC' proxyNO proxyNI inputM = do
    input <- inputM
    case input of
      Seq_Edge x -> return $ Seq_Edge $ UnpartitionN no_val ni_val io_val ii_val a_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "unpartitionC" "Seq"
    where
      no_val = fromInteger $ natVal proxyNO
      ni_val = fromInteger $ natVal proxyNI
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)
      a_type = get_AST_type (Proxy :: Proxy a)

  -- higher order operators
  mapC f x = mapC' Proxy f x

  mapC' :: forall n i a b . (KnownNat n, KnownNat i,
           Aetherling_Value a,
           Aetherling_Value b) =>
    Proxy n -> (Rewrite_StateM a -> Rewrite_StateM b) ->
    Rewrite_StateM (Seq n i a) -> Rewrite_StateM (Seq n i b)
  mapC' len_proxy f inputM = do
    input <- inputM
    f_ast <- f (com_input_any "I")
    let f_edge_maybe = edge_to_maybe_expr f_ast
    case (input, f_edge_maybe) of
      (Seq_Edge x, Just f_ast_edge) -> return $ Seq_Edge $ MapN len_val i_val f_ast_edge x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "mapC" "Seq"
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)

  map2C f x y = map2C' Proxy f x y

  map2C' :: forall n i a b c . (KnownNat n, KnownNat i,
                                Aetherling_Value a,
                                Aetherling_Value b,
                                Aetherling_Value c) =>
    Proxy n ->
    (Rewrite_StateM a -> Rewrite_StateM b -> Rewrite_StateM c) ->
    Rewrite_StateM (Seq n i a) -> Rewrite_StateM (Seq n i b) -> Rewrite_StateM (Seq n i c)
  map2C' len_proxy f input1M input2M = do
    input1 <- input1M
    input2 <- input2M
    f_ast <- f (com_input_any "I0") (com_input_any "I1")
    let f_edge_maybe = edge_to_maybe_expr f_ast
    case (input1, input2, f_edge_maybe) of
      (Seq_Edge x, Seq_Edge y, Just f_edge) -> return $ Seq_Edge $ Map2N len_val i_val f_edge x y No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "map2C" "Seq Seq"
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)

  reduceC f x = reduceC' Proxy f x

  reduceC' :: forall n i a . (KnownNat n, KnownNat i,
                              Aetherling_Value a) =>
    Proxy (1+n) -> (Rewrite_StateM (Atom_Tuple a a) -> Rewrite_StateM a) ->
    Rewrite_StateM (Seq (1+n) i a) -> Rewrite_StateM (Seq 1 (n + i) a)
  reduceC' len_proxy f inputM = do
    input <- inputM
    f_ast <- f (com_input_any "I")
    let f_edge_maybe = edge_to_maybe_expr f_ast
    case (input, f_edge_maybe) of
      (Seq_Edge x, Just f_edge) -> return $ Seq_Edge $ ReduceN len_val i_val f_edge x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "reduceC" "Seq"
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)

  fstC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Rewrite_StateM (Atom_Tuple a b) -> Rewrite_StateM a
  fstC inputM = do
    input <- inputM
    case input of
      Atom_Tuple_Edge x -> return $ expr_to_edge $ FstN a_type b_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "fstC" "Atom_Tuple"
    where
      a_type = get_AST_type (Proxy :: Proxy a)
      b_type = get_AST_type (Proxy :: Proxy b)

  sndC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Rewrite_StateM (Atom_Tuple a b) -> Rewrite_StateM b
  sndC inputM = do
    input <- inputM
    case input of
      Atom_Tuple_Edge x -> return $ expr_to_edge $ SndN a_type b_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "sndC" "Atom_Tuple"
    where
      a_type = get_AST_type (Proxy :: Proxy a)
      b_type = get_AST_type (Proxy :: Proxy b)

  atom_tupleC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                               Aetherling_Value a,
                               Aetherling_Value b) =>
    Rewrite_StateM a -> Rewrite_StateM b -> Rewrite_StateM (Atom_Tuple a b)
  atom_tupleC input1M input2M = do
    input1 <- input1M
    input2 <- input2M
    let a_type = get_AST_type (Proxy :: Proxy a)
    let b_type = get_AST_type (Proxy :: Proxy b)
    let input1_expr_maybe = edge_to_maybe_expr input1
    let input2_expr_maybe = edge_to_maybe_expr input2
    if isJust input1_expr_maybe && isJust input2_expr_maybe
      then return $ Atom_Tuple_Edge $
           ATupleN a_type b_type
           (fromJust input1_expr_maybe) (fromJust input2_expr_maybe) No_Index
      else throwError $ Expr_Failure $ fail_message_edge "atom_tupleC" "any_atom"

  seq_tupleC :: forall a . (Aetherling_Value a) =>
    Rewrite_StateM a -> Rewrite_StateM a ->
    Rewrite_StateM (Seq_Tuple 2 a)
  seq_tupleC input1M input2M = do
    input1 <- input1M
    input2 <- input2M
    let a_type = get_AST_type (Proxy :: Proxy a)
    let input1_expr_maybe = edge_to_maybe_expr input1
    let input2_expr_maybe = edge_to_maybe_expr input2
    if isJust input1_expr_maybe && isJust input2_expr_maybe
      then return $ Seq_Tuple_Edge $
           STupleN a_type (fromJust input1_expr_maybe) (fromJust input2_expr_maybe)
           No_Index
      else throwError $ Expr_Failure $ fail_message_edge "seq_tupleC" "any"
{-
  zipC :: forall a l n i . (Aetherling_Value a, KnownNat l, KnownNat n, KnownNat i) =>
    Proxy l -> [Rewrite_StateM (Seq n i a)] -> Rewrite_StateM (Seq n i (Seq_Tuple l a))
  zipC len_proxy inputsM | natVal len_proxy > 2 = do
    let inputs = fmap seq_shallow_to_deep inputsM
    let a_type = get_AST_type (Proxy :: Proxy a)
    let n_val = fromInteger $ natVal (Proxy :: Proxy n)
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    -- this will be used after initial step in the fold
    let map_stuple_append out_len in_left in_right = do
          return $
            Map2N n_val i_val
            (STupleAppendN out_len
              a_type
              (InputN (STupleT (out_len - 1) a_type) "I0" No_Index)
              (InputN a_type "I1" No_Index)
              No_Index)
            in_left in_right No_Index
    -- the initial step in the fold
    let map_stuple_initial = do
          return $
            Map2N n_val i_val
            (STupleN a_type 
              (InputN a_type "I0" No_Index)
              (InputN a_type "I1" No_Index)
              No_Index)
            (inputs !! 0) (inputs !! 1) No_Index
    tupled_expr <- foldl (\prior_tuplesM cur_len -> do
                             prior_tuples <- prior_tuplesM
                             map_stuple_append
                               cur_len
                               prior_tuples
                               (inputs !! (cur_len - 1)))
                   -- start at 3 to set
                   map_stuple_initial [3 .. length inputs]
    return $ Seq_Edge tupled_expr
  zipC _ _ = throwError $ Expr_Failure "zipC must have at least 3 inputs, otherwise use seq_tupleC"
-}
  
  seq_tuple_appendC :: forall n a . (KnownNat n, Aetherling_Value (Seq_Tuple n a),
                                     Aetherling_Value a,
                                     Aetherling_Value (Seq_Tuple (n+1) a)) =>
    Rewrite_StateM (Seq_Tuple n a) -> Rewrite_StateM a ->
    Rewrite_StateM (Seq_Tuple (n+1) a)
  seq_tuple_appendC input1M input2M = do
    input1 <- input1M
    let input1_expr_maybe = edge_to_maybe_expr input1
    input2 <- input2M
    let input2_expr_maybe = edge_to_maybe_expr input2
    if isJust input1_expr_maybe && isJust input2_expr_maybe
      then do
      let input1_expr = fromJust input1_expr_maybe
      let input2_expr = fromJust input2_expr_maybe
      let out_len = fromInteger $ natVal (Proxy :: Proxy (n+1))
      let a_type = get_AST_type (Proxy :: Proxy a)
      return $ Seq_Tuple_Edge $ STupleAppendN out_len a_type input1_expr input2_expr No_Index
      else throwError $ Expr_Failure $ fail_message "seq_tuple_appendC" "inputs must be edges"
  
  seq_tuple_to_seqC :: forall n i a .
                       (KnownNat n, KnownNat i,
                        Aetherling_Value a) =>
    Rewrite_StateM (Seq 1 (n-1+i) (Seq_Tuple n a)) ->
    Rewrite_StateM (Seq n i a)
  seq_tuple_to_seqC inputM = do
    input <- inputM
    case input of
      Seq_Edge x -> return $ Seq_Edge $ STupleToSeqN n_val i_val a_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "seq_tuple_to_seqC" "seq_tuple"
    where
      n_val = fromInteger $ natVal (Proxy :: Proxy n)
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)

  seq_to_seq_tupleC :: forall n i a .
                       (KnownNat n, KnownNat i,
                        Aetherling_Value a) =>
    Rewrite_StateM (Seq n i a) ->
    Rewrite_StateM (Seq 1 (n-1+i) (Seq_Tuple n a))
  seq_to_seq_tupleC inputM = do
    input <- inputM
    case input of
      Seq_Edge x -> return $ Seq_Edge $ SeqToSTupleN n_val i_val a_type x No_Index
      _ -> throwError $ Expr_Failure $ fail_message_edge "seq_to_seq_tupleC" "seq"
    where
      n_val = fromInteger $ natVal (Proxy :: Proxy n)
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)

  -- composition operators
  (>>>) f g = g . f

com_input_unit :: String -> Rewrite_StateM Atom_Unit
com_input_unit s = do
  return $ Atom_Unit_Edge $ InputN UnitT s No_Index
com_input_int :: String -> Rewrite_StateM Atom_Int
com_input_int s = do
  return $ Atom_Int_Edge $ InputN IntT s No_Index
com_input_bit :: String -> Rewrite_StateM Atom_Bit
com_input_bit s = do
  return $ Atom_Bit_Edge $ InputN BitT s No_Index
com_input_atom_tuple :: (Aetherling_Value a, Aetherling_Value b) => String ->
  Proxy (Atom_Tuple a b) -> Rewrite_StateM (Atom_Tuple a b)
com_input_atom_tuple s a_proxy = do
  return $ Atom_Tuple_Edge $ InputN (get_AST_type a_proxy) s No_Index
com_input_seq :: (KnownNat n, KnownNat i, Aetherling_Value a) => String ->
  Proxy (Seq n i a) -> Rewrite_StateM (Seq n i a)
com_input_seq s a_proxy = do
  return $ Seq_Edge $ InputN (get_AST_type a_proxy) s No_Index
com_input_any :: Aetherling_Value a => String -> Rewrite_StateM a
com_input_any s = do
  return $ get_input_edge s No_Index
com_input :: Aetherling_Value a => String -> Proxy a -> Rewrite_StateM a
com_input s _ = do
  return $ get_input_edge s No_Index
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

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

compile :: (Aetherling_Value a) => Compilation_Env a -> Expr
compile shallow_programM = do
  let shallow_program = fromRight undefined $
        evalState (runExceptT shallow_programM) empty_compilation_data
  let expr_maybe = edge_to_maybe_expr shallow_program 
  if isJust expr_maybe
    then fromJust expr_maybe
    else ErrorN "Not an edge, please pass in the result of calling compile" No_Index
    
instance Sequence_Language Compilation_Env where
  -- unary operators
  idC x = x
    --add_to_DAG IdN (input_to_maybe_indices x) "idC" "any_input_edge"
  absC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Int_Edge x -> return $ Atom_Int_Edge $ AbsN x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "absC" "Atom_Int"

  notC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Bit_Edge x -> return $ Atom_Bit_Edge $ NotN x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "absC" "Atom_Bit"

  -- binary operators
  addC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ AddN x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "addC" "Atom_Tuple Atom_Int Atom_Int"

  subC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ SubN x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "subC" "Atom_Tuple Atom_Int Atom_Int"

  mulC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ MulN x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "mulC" "Atom_Tuple Atom_Int Atom_Int"

  divC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Int_Edge $ DivN x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "divC" "Atom_Tuple Atom_Int Atom_Int"

  eqC :: forall a . (Aetherling_Value a, Check_Type_Is_Atom a, Eq a) =>
    Compilation_Env (Atom_Tuple a a) -> Compilation_Env Atom_Bit
  eqC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Tuple_Edge x -> return $ Atom_Bit_Edge $
        EqN (get_AST_type (Proxy :: Proxy a)) x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "eqC" "Atom_Tuple any_type any_type"
      
  -- generators
  lut_genC :: forall a . Aetherling_Value a => [a] -> Compilation_Env Atom_Int ->
    Compilation_Env a
  lut_genC table inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    let input_expr_maybe = edge_to_maybe_expr input
    let a_proxy = Proxy :: Proxy a
    let lut_table_maybe = traverse get_AST_value table
    if isJust lut_table_maybe && isJust input_expr_maybe
      then do
      return $ expr_to_edge $
        Lut_GenN (fromJust lut_table_maybe)
        (get_AST_type a_proxy) (fromJust input_expr_maybe) cur_idx
      else do
      throwError $ Expr_Failure $ fail_message_edge "lut_genC" "[a] -> Atom_Int"

  const_genC :: forall a b . Aetherling_Value a => a -> Compilation_Env b ->
    Compilation_Env a
  const_genC const _ = do
    let const_expr_maybe = get_AST_value const
    cur_idx <- get_cur_index
    if isJust const_expr_maybe
      then do
      return $ expr_to_edge $
        Const_GenN (fromJust const_expr_maybe) (get_AST_type (Proxy :: Proxy a)) cur_idx
      else do
      throwError $ Expr_Failure $ fail_message_edge "const_genC" "any_edge"

  -- sequence operators
  -- generators
  shiftC shift_amount_proxy input_vec = shiftC' Proxy shift_amount_proxy input_vec
  
  shiftC' :: forall n r i a . (KnownNat n, KnownNat r, KnownNat i,
                             Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> Compilation_Env (Seq (n+r) i a) -> Compilation_Env (Seq (n+r) i a)
  shiftC' len_proxy shift_amount_proxy inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ ShiftN len i_val shift a_type x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "shiftC" "Seq"
    where
      len = fromInteger $ natVal len_proxy
      shift = fromInteger $ natVal shift_amount_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)
  
  up_1dC :: forall a n i . (KnownNat n, KnownNat i,
             Aetherling_Value a) =>
    Proxy (1+n) -> Compilation_Env (Seq 1 (n + i) a) -> Compilation_Env (Seq (1+n) i a)
  up_1dC len_proxy inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ Up_1dN len i_val a_type x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "up_1dC" "Seq"
    where
      len = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      a_type = get_AST_type (Proxy :: Proxy a)

  down_1dC sel_idx x = down_1dC' Proxy sel_idx x
  
  down_1dC' :: forall a n i . (KnownNat n, KnownNat i,
                Aetherling_Value a) =>
    Proxy (1+n) -> Int -> Compilation_Env (Seq (1+n) i a) ->
    Compilation_Env (Seq 1 (n + i) a)
  down_1dC' len_proxy sel_idx inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ Down_1dN len i_val sel_idx a_type x cur_idx
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
    Compilation_Env (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                io GHC.TypeLits.* (ni + ii)) a) ->
    Compilation_Env (Seq no io (Seq ni ii a))
  partitionC proxyNO proxyNI proxyIO proxyII inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ PartitionN no_val ni_val io_val ii_val a_type x cur_idx
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
    Compilation_Env (Seq no io (Seq ni ii a)) ->
    Compilation_Env (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                   io GHC.TypeLits.* (ni + ii)) a)
  unpartitionC' proxyNO proxyNI inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ UnpartitionN no_val ni_val io_val ii_val a_type x cur_idx
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
    Proxy n -> (Compilation_Env a -> Compilation_Env b) ->
    Compilation_Env (Seq n i a) -> Compilation_Env (Seq n i b)
  mapC' len_proxy f inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ MapN len_val i_val f_ast x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "mapC" "Seq"
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      f_ast = compile $ f (com_input_any "f_in")

  map2C f x y = map2C' Proxy f x y

  map2C' :: forall n i a b c . (KnownNat n, KnownNat i,
                                Aetherling_Value a,
                                Aetherling_Value b,
                                Aetherling_Value c) =>
    Proxy n ->
    (Compilation_Env a -> Compilation_Env b -> Compilation_Env c) ->
    Compilation_Env (Seq n i a) -> Compilation_Env (Seq n i b) -> Compilation_Env (Seq n i c)
  map2C' len_proxy f input1M input2M = do
    input1 <- input1M
    input2 <- input2M
    cur_idx <- get_cur_index
    case (input1, input2) of
      (Seq_Edge x, Seq_Edge y) -> return $ Seq_Edge $ Map2N len_val i_val f_ast x y cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "map2C" "Seq Seq"
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      f_ast = compile $
        f (com_input_any "f_in1") (com_input_any "f_in2")

  reduceC f x = reduceC' Proxy f x

  reduceC' :: forall n i a . (KnownNat n, KnownNat i,
                              Aetherling_Value a) =>
    Proxy (1+n) -> (Compilation_Env (Atom_Tuple a a) -> Compilation_Env a) ->
    Compilation_Env (Seq (1+n) i a) -> Compilation_Env (Seq 1 (n + i) a)
  reduceC' len_proxy f inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ ReduceN len_val i_val f_ast x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "reduceC" "Seq"
    where
      len_val = fromInteger $ natVal len_proxy
      i_val = fromInteger $ natVal (Proxy :: Proxy i)
      f_ast = compile $ f (com_input_any "f_in")

  fstC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Compilation_Env (Atom_Tuple a b) -> Compilation_Env a
  fstC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Tuple_Edge x -> return $ expr_to_edge $ FstN a_type b_type x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "fstC" "Atom_Tuple"
    where
      a_type = get_AST_type (Proxy :: Proxy a)
      b_type = get_AST_type (Proxy :: Proxy b)

  sndC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                        Aetherling_Value a,
                        Aetherling_Value b) =>
    Compilation_Env (Atom_Tuple a b) -> Compilation_Env b
  sndC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Atom_Tuple_Edge x -> return $ expr_to_edge $ SndN a_type b_type x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "sndC" "Atom_Tuple"
    where
      a_type = get_AST_type (Proxy :: Proxy a)
      b_type = get_AST_type (Proxy :: Proxy b)

  atom_tupleC :: forall a b . (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                               Aetherling_Value a,
                               Aetherling_Value b) =>
    Compilation_Env a -> Compilation_Env b -> Compilation_Env (Atom_Tuple a b)
  atom_tupleC input1M input2M = do
    input1 <- input1M
    input2 <- input2M
    cur_idx <- get_cur_index
    let a_type = get_AST_type (Proxy :: Proxy a)
    let b_type = get_AST_type (Proxy :: Proxy b)
    let input1_expr_maybe = edge_to_maybe_expr input1
    let input2_expr_maybe = edge_to_maybe_expr input2
    if isJust input1_expr_maybe && isJust input2_expr_maybe
      then return $ Atom_Tuple_Edge $
           ATupleN a_type b_type
           (fromJust input1_expr_maybe) (fromJust input2_expr_maybe) cur_idx
      else throwError $ Expr_Failure $ fail_message_edge "atom_tupleC" "any_atom"

  seq_tupleC :: forall a . (Aetherling_Value a) =>
    Compilation_Env a -> Compilation_Env a ->
    Compilation_Env (Seq_Tuple 2 a)
  seq_tupleC input1M input2M = do
    input1 <- input1M
    input2 <- input2M
    cur_idx <- get_cur_index
    let a_type = get_AST_type (Proxy :: Proxy a)
    let input1_expr_maybe = edge_to_maybe_expr input1
    let input2_expr_maybe = edge_to_maybe_expr input2
    if isJust input1_expr_maybe && isJust input2_expr_maybe
      then return $ Seq_Tuple_Edge $
           STupleN a_type (fromJust input1_expr_maybe) (fromJust input2_expr_maybe)
           cur_idx
      else throwError $ Expr_Failure $ fail_message_edge "seq_tupleC" "any"

  zipC :: forall a l n i . (Aetherling_Value a, KnownNat l, KnownNat n, KnownNat i) =>
    Proxy l -> [Compilation_Env (Seq n i a)] -> Compilation_Env (Seq n i (Seq_Tuple l a))
  zipC len_proxy inputsM | natVal len_proxy > 2 = do
    let inputs = fmap compile inputsM
    let a_type = get_AST_type (Proxy :: Proxy a)
    let n_val = fromInteger $ natVal (Proxy :: Proxy n)
    let i_val = fromInteger $ natVal (Proxy :: Proxy i)
    -- this will be used after initial step in the fold
    let map_stuple_append out_len in_left in_right = do
          map2_idx <- get_cur_index
          stuple_append_idx <- get_cur_index
          input1_idx <- get_cur_index
          input2_idx <- get_cur_index
          return $
            Map2N n_val i_val
            (STupleAppendN out_len
              a_type
              (InputN (STupleT (out_len - 1) a_type) "tuple_in_1" input1_idx)
              (InputN a_type "tuple_in_2" input2_idx)
              stuple_append_idx)
            in_left in_right map2_idx
    -- the initial step in the fold
    let map_stuple_initial = do
          map2_idx <- get_cur_index
          stuple_idx <- get_cur_index
          input1_idx <- get_cur_index
          input2_idx <- get_cur_index
          return $
            Map2N n_val i_val
            (STupleN a_type 
              (InputN a_type "tuple_in_1" input1_idx)
              (InputN a_type "tuple_in_2" input2_idx)
              stuple_idx)
            (inputs !! 0) (inputs !! 1) map2_idx
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

  
  seq_tuple_appendC :: forall n a . (KnownNat n, Aetherling_Value (Seq_Tuple n a),
                                     Aetherling_Value a,
                                     Aetherling_Value (Seq_Tuple (n+1) a)) =>
    Compilation_Env (Seq_Tuple n a) -> Compilation_Env a ->
    Compilation_Env (Seq_Tuple (n+1) a)
  seq_tuple_appendC input1M input2M = do
    input1 <- input1M
    let input1_expr_maybe = edge_to_maybe_expr input1
    input2 <- input2M
    let input2_expr_maybe = edge_to_maybe_expr input2
    cur_idx <- get_cur_index
    if isJust input1_expr_maybe && isJust input2_expr_maybe
      then do
      let input1_expr = fromJust input1_expr_maybe
      let input2_expr = fromJust input2_expr_maybe
      let out_len = fromInteger $ natVal (Proxy :: Proxy (n+1))
      let a_type = get_AST_type (Proxy :: Proxy a)
      return $ Seq_Tuple_Edge $ STupleAppendN out_len a_type input1_expr input2_expr cur_idx
      else throwError $ Expr_Failure $ fail_message "seq_tuple_appendC" "inputs must be edges"
  
  seq_tuple_to_seqC :: forall no ni io ii a .
                       (KnownNat no, KnownNat ni,
                        KnownNat io, KnownNat ii,
                        Aetherling_Value a) =>
    Proxy io -> Proxy ii ->
    Compilation_Env (Seq no ((no GHC.TypeLits.* ((ni - 1) + ii)) + (io GHC.TypeLits.* (ni + ii)))
       (Seq_Tuple ni a)) ->
    Compilation_Env (Seq no io (Seq ni ii a))
  seq_tuple_to_seqC proxyIO proxyII inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ STupleToSeqN no_val ni_val io_val ii_val a_type x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "seq_tuple_to_seqC" "seq_tuple"
    where
      no_val = fromInteger $ natVal (Proxy :: Proxy no)
      ni_val = fromInteger $ natVal (Proxy :: Proxy ni)
      io_val = fromInteger $ natVal proxyIO
      ii_val = fromInteger $ natVal proxyII
      a_type = get_AST_type (Proxy :: Proxy a)

  seq_to_seq_tupleC :: forall no ni io ii a .
                       (KnownNat no, KnownNat ni, 
                        KnownNat io, KnownNat ii,
                        Aetherling_Value a) =>
    Compilation_Env (Seq no io (Seq ni ii a)) ->
    Compilation_Env (Seq no ((no GHC.TypeLits.* ((ni - 1) + ii)) + (io GHC.TypeLits.* (ni + ii)))
       (Seq_Tuple ni a))
  seq_to_seq_tupleC inputM = do
    input <- inputM
    cur_idx <- get_cur_index
    case input of
      Seq_Edge x -> return $ Seq_Edge $ SeqToSTupleN no_val ni_val io_val ii_val a_type x cur_idx
      _ -> throwError $ Expr_Failure $ fail_message_edge "seq_to_seq_tupleC" "seq"
    where
      no_val = fromInteger $ natVal (Proxy :: Proxy no)
      ni_val = fromInteger $ natVal (Proxy :: Proxy ni)
      io_val = fromInteger $ natVal (Proxy :: Proxy io)
      ii_val = fromInteger $ natVal (Proxy :: Proxy ii)
      a_type = get_AST_type (Proxy :: Proxy a)

  -- composition operators
  (>>>) f g = g . f

data Compilation_Data = Compilation_Data {
  cur_index :: DAG_Index
  } deriving (Show, Eq)

empty_compilation_data = Compilation_Data $ Index 0

type Compilation_Env = ExceptT Rewrite_Failure (State Compilation_Data)

get_cur_index :: Compilation_Env DAG_Index
get_cur_index = do
  cur_data <- get
  case cur_index cur_data of
    Index cur_idx -> do
      put $ Compilation_Data $ Index (cur_idx + 1)
      return $ Index cur_idx
    _ -> return No_Index

com_input_unit :: String -> Compilation_Env Atom_Unit
com_input_unit s = do
  cur_idx <- get_cur_index
  return $ Atom_Unit_Edge $ InputN UnitT s cur_idx
com_input_int :: String -> Compilation_Env Atom_Int
com_input_int s = do
  cur_idx <- get_cur_index
  return $ Atom_Int_Edge $ InputN IntT s cur_idx
com_input_bit :: String -> Compilation_Env Atom_Bit
com_input_bit s = do
  cur_idx <- get_cur_index
  return $ Atom_Bit_Edge $ InputN BitT s cur_idx
com_input_atom_tuple :: (Aetherling_Value a, Aetherling_Value b) => String ->
  Proxy (Atom_Tuple a b) -> Compilation_Env (Atom_Tuple a b)
com_input_atom_tuple s a_proxy = do
  cur_idx <- get_cur_index
  return $ Atom_Tuple_Edge $ InputN (get_AST_type a_proxy) s cur_idx
com_input_seq :: (KnownNat n, KnownNat i, Aetherling_Value a) => String ->
  Proxy (Seq n i a) -> Compilation_Env (Seq n i a)
com_input_seq s a_proxy = do
  cur_idx <- get_cur_index
  return $ Seq_Edge $ InputN (get_AST_type a_proxy) s cur_idx
com_input_any :: Aetherling_Value a => String -> Compilation_Env a
com_input_any s = do
  cur_idx <- get_cur_index
  return $ get_input_edge s cur_idx
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

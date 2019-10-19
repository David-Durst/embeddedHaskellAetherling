module Aetherling.Interpretations.Simulator where
import Aetherling.Monad_Helpers
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Shallow.Expr_Type_Conversions
import Aetherling.Languages.Isomorphisms
import Data.Typeable
import Unsafe.Coerce
import qualified Data.Vector.Sized as V
import Util
import GHC.TypeLits
import GHC.TypeLits.Extra
import Text.Printf
import Data.List
import Control.Applicative
  

simulate :: Simulation_Env a -> a
simulate (Simulation_Env a) = a

instance Sequence_Language Simulation_Env where
  -- unary operators
  idC x = x

  absC (Simulation_Env (Atom_Int x)) = return $ Atom_Int $ abs x
  absC _ = fail $ fail_message "absC" "Atom_Int"
  
  notC (Simulation_Env (Atom_Bit x)) = return $ Atom_Bit $ not x
  notC _ = fail $ fail_message "absC" "Atom_Bit"

  -- binary operators
  addC (Simulation_Env (Atom_Tuple (Atom_Int x) (Atom_Int y))) = return $ Atom_Int $ x+y
  addC _ = fail $ fail_message "addC" "Atom_Tuple Atom_Int Atom_Int"

  subC (Simulation_Env (Atom_Tuple (Atom_Int x) (Atom_Int y))) = return $ Atom_Int $ x-y
  subC _ = fail $ fail_message "subC" "Atom_Tuple Atom_Int Atom_Int"
  
  mulC (Simulation_Env (Atom_Tuple (Atom_Int x) (Atom_Int y))) = return $ Atom_Int $ x*y
  mulC _ = fail $ fail_message "mulC" "Atom_Tuple Atom_Int Atom_Int"
  
  divC (Simulation_Env (Atom_Tuple (Atom_Int x) (Atom_Int y))) = return $ Atom_Int $ x `div` y
  divC _ = fail $ fail_message "divC" "Atom_Tuple Atom_Int Atom_Int"

  eqC (Simulation_Env (Atom_Tuple x y)) = return $ Atom_Bit $ x == y 
  eqC _ = fail $ fail_message "eqC" "Atom_Tuple"

  -- generators
  lut_genC xs (Simulation_Env (Atom_Int i)) | i < length xs = return $ xs !! i 
  lut_genC xs (Simulation_Env (Atom_Int i)) = fail "lut lookup index out of bounds"
  lut_genC _ _ = fail $ fail_message "lut_genC" "Atom_Int"

  const_genC x _ = return x

  -- sequence operators
  shiftC shift_amount_proxy input_vec = shiftC' Proxy shift_amount_proxy input_vec
  
  shiftC' :: forall n r i a . (KnownNat n, KnownNat r, KnownNat i,
                             Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> Simulation_Env (Seq (n+r) i a) -> Simulation_Env (Seq (n+r) i a)
  shiftC' _ shift_amount_proxy input_vec =
    -- put the last r elements at the start, since undefined what is there.
    return $ Seq $ dropped_elements V.++ kept_elements
    where
      kept_length_proxy = Proxy :: Proxy n
      input_vec_val = sVec $ simulate input_vec
      kept_elements = V.take' kept_length_proxy input_vec_val
      dropped_elements = V.drop' kept_length_proxy input_vec_val
      
  up_1dC proxyN (Simulation_Env (Seq elem)) = return $ Seq $
    V.replicate' proxyN $ V.head elem
  up_1dC _ _ = fail $ fail_message "up_1dC" "Seq"

  down_1dC sel_idx input = down_1dC' Proxy sel_idx input
  
  down_1dC' proxyN sel_idx (Simulation_Env (Seq vec)) = return $ Seq $
    V.replicate' (Proxy @1) $ (V.toList vec !! sel_idx)
  down_1dC' _ _ _ = fail $ fail_message "down_1dC" "Seq"

  partitionC _ proxy_ni _ proxy_ii (Simulation_Env unnested_seq) =
    return $ seqToSeqOfSeq proxy_ni proxy_ii unnested_seq

  unpartitionC (Simulation_Env unflattened_seq) =
    return $ seqOfSeqToSeq unflattened_seq

  unpartitionC' _ _ (Simulation_Env unflattened_seq) =
    return $ seqOfSeqToSeq unflattened_seq

  -- higher order operators
  mapC f input = mapC' Proxy f input

  mapC' _ f input = do
    let f_unwrapped_ags input_inner = do
          let input_inner_unwrapped = Simulation_Env input_inner
          f input_inner_unwrapped
    input_val <- input
    traverse f_unwrapped_ags input_val

  map2C f input1 input2 = map2C' Proxy f input1 input2

  map2C' _ f input1 input2 = do
    let f_unrwapped_args i1_val i2_val = do
          let i1 = Simulation_Env i1_val
          let i2 = Simulation_Env i2_val
          f i1 i2
    input1_val <- input1
    input2_val <- input2
    traverse2 f_unrwapped_args input1_val input2_val

  reduceC f input = reduceC' Proxy f input
  
  reduceC' _ f (Simulation_Env (Seq input_vec)) = do
    let f_unrwapped_args i_val = do
          let i_m = Simulation_Env i_val
          f i_m
    fmap (\out_el -> Seq $ V.singleton out_el) $
      V.fold1M (\x y -> f_unrwapped_args (Atom_Tuple x y)) input_vec
  reduceC' _ _ _ = fail $ fail_message "reduceC" "Seq"
  fstC (Simulation_Env (Atom_Tuple x _)) = return x
  fstC _ = fail $ fail_message "fstC" "Atom_Tuple"

  sndC (Simulation_Env (Atom_Tuple _ y)) = return y
  sndC _ = fail $ fail_message "sndC" "Atom_Tuple"
  
  atom_tupleC x y = do
    x_val <- x
    y_val <- y
    return $ Atom_Tuple x_val y_val
    
  seq_tupleC x y = do
    x_val <- x
    y_val <- y
    return $ Seq_Tuple (listToVector (Proxy @2) [x_val, y_val])
    
  zipC :: forall no io ii a l . (Aetherling_Value a, KnownNat l,
                                 KnownNat no, KnownNat io, KnownNat ii) =>
    Proxy l -> Simulation_Env (Seq no io (Seq 1 ii [a])) ->
    Simulation_Env (Seq no io (Seq 1 ii (Seq_Tuple l a)))
  zipC proxyL xs = do
    let list_xss = fmap seq_to_list $ seq_to_list $ simulate xs
    if all (\x -> length x == l_val) (concat list_xss)
      then do
      let tuple_xss = fmap (fmap $ Seq_Tuple . listToVector proxyL) list_xss
      return $ list_to_seq Proxy $ (fmap $ list_to_seq Proxy) tuple_xss
      else fail $
           printf "zipC where length proxy %d doesn't match length of input"
           (natVal proxyL)
    --let tuple_xss = fmap (fmap (list_to_seq (Proxy :: Proxy l))) list_xss
    --let zipped_lists = transpose xs_lists
    --return $ Seq $ listToVector proxyN $ fmap (Seq_Tuple . listToVector proxyL) zipped_lists
    where
      proxyN = Proxy :: Proxy n
      l_val = fromInteger $ natVal proxyL

  seq_tuple_appendC (Simulation_Env (Seq_Tuple input_vec)) (Simulation_Env x) =
    return $ Seq_Tuple $ V.snoc input_vec x
  seq_tuple_appendC _ _ = fail $ fail_message "seq_tuple_appendC" "Seq_Tuple"

  seq_tuple_to_seqC (Simulation_Env (Seq input_vec_tuples)) = do
    let (Seq_Tuple vals) = V.head input_vec_tuples
    return $ Seq vals
  seq_tuple_to_seqC _ = fail $ fail_message "seq_tuple_to_seqC" "Seq_Tuple"

  seq_to_seq_tupleC (Simulation_Env (Seq input_vals)) =
    return $ list_to_seq (Proxy @1) $ [Seq_Tuple input_vals]
  seq_to_seq_tupleC _ = fail $ fail_message "seq_to_seq_tupleC" "Seq"

  -- composition operators
  (>>>) f g = g . f

data Simulation_Env a = Simulation_Env a
  deriving (Show, Eq, Functor)

instance Applicative Simulation_Env where
  pure a = Simulation_Env a
  Simulation_Env f <*> Simulation_Env a = Simulation_Env $ f a

instance Monad Simulation_Env where
  (Simulation_Env a) >>= f = f a
  return a = Simulation_Env a

sim_input_unit :: () -> Simulation_Env Atom_Unit
sim_input_unit _ = return $ Atom_Unit
sim_input_int :: Int -> Simulation_Env Atom_Int
sim_input_int x = return $ Atom_Int x
sim_input_bit :: Bool -> Simulation_Env Atom_Bit
sim_input_bit x = return $ Atom_Bit x
sim_input_atom_tuple :: (a,b) -> Simulation_Env (Atom_Tuple a b)
sim_input_atom_tuple (x, y) = return $ Atom_Tuple x y
sim_input_seq :: forall n i a . (KnownNat n, KnownNat i) =>
  [a] -> Simulation_Env (Seq n i a)
sim_input_seq input_list
  | length input_list == n_val = return $ Seq $ listToVector n_proxy input_list
  | otherwise = fail $ "tried to create Seq from list of incorrect size"
  where
    n_proxy = Proxy :: Proxy n
    n_val = fromInteger $ natVal n_proxy
sim_input_seq' proxyN input_list
  | length input_list == (fromInteger $ natVal proxyN) = return $ Seq $ listToVector proxyN input_list
  | otherwise = fail $ "tried to create Seq from list of incorrect size"

seq_to_list :: Seq n i a -> [a]
seq_to_list (Seq vec) = V.toList vec
seq_to_list _ = []

atom_int_to_int :: Atom_Int -> Int
atom_int_to_int (Atom_Int x) = x
atom_int_to_int _ = (-100)

atom_bit_to_bool :: Atom_Bit -> Bool
atom_bit_to_bool (Atom_Bit b) = b
atom_bit_to_bool _ = False


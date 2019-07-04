module Aetherling.Interpretations.Simulator where
import Aetherling.ASTs.Sequence
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Types.Isomorphisms
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
  idC x = return x

  absC (Atom_Int x) = return $ Atom_Int $ abs x
  absC _ = fail $ fail_message "absC" "Atom_Int"
  
  notC (Atom_Bit x) = return $ Atom_Bit $ not x
  notC _ = fail $ fail_message "absC" "Atom_Bit"

  -- binary operators
  addC (Simulation_Env (Atom_Tuple (Atom_Int x) (Atom_Int y))) = return $ Atom_Int $ x+y
  addC _ = fail $ fail_message "addC" "Atom_Tuple Atom_Int Atom_Int"

  mulC (Simulation_Env (Atom_Tuple (Atom_Int x) (Atom_Int y))) = return $ Atom_Int $ x*y
  mulC _ = fail $ fail_message "mulC" "Atom_Tuple Atom_Int Atom_Int"
  
  divC (Simulation_Env (Atom_Tuple (Atom_Int x) (Atom_Int y))) = return $ Atom_Int $ x `div` y
  divC _ = fail $ fail_message "mulC" "Atom_Tuple Atom_Int Atom_Int"

  eqC (Atom_Tuple x y) = return $ Atom_Bit $ x == y 
  eqC _ = fail $ fail_message "eqC" "Atom_Tuple"

  -- generators
  lut_genC xs (Atom_Int i) | i < length xs = return $ xs !! i 
  lut_genC xs (Atom_Int i) = fail "lut lookup index out of bounds"
  lut_genC _ _ = fail $ fail_message "lut_genC" "Atom_Int"

  const_genC x = return x
  
  const_genC' x _ = return x

  -- sequence operators
  shiftC :: forall n r i a . (KnownNat n, KnownNat r, KnownNat i,
                             Aetherling_Value a) =>
    Proxy r -> Simulation_Env (Seq (n+r) i a) -> Simulation_Env (Seq (n+r) i a)
  shiftC shift_amount_proxy input_vec =
    -- put the last r elements at the start, since undefined what is there.
    return $ Seq $ dropped_elements V.++ kept_elements
    where
      kept_length_proxy = Proxy :: Proxy n
      input_vec_val = sVec $ simulate input_vec
      kept_elements = V.take' kept_length_proxy input_vec_val
      dropped_elements = V.drop' kept_length_proxy input_vec_val
  
  up_1dC proxyN (Seq elem) = return $ Seq $
    V.replicate' proxyN $ V.head elem
  up_1dC _ _ = fail $ fail_message "up_1dC" "Seq"

  down_1dC proxyN sel_idx (Seq vec) = return $ Seq $
    V.replicate' (Proxy @1) $ (V.toList vec !! sel_idx)
  down_1dC _ _ _ = fail $ fail_message "down_1dC" "Seq"

  partitionC :: forall no ni io ii a .
    (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
      KnownNat io, KnownNat ii,
      Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                io GHC.TypeLits.* (ni + ii)) a ->
    Simulation_Env (Seq no io (Seq ni ii a))
  partitionC _ proxy_ni unnested_seq =
    return $ seqToSeqOfSeq proxy_ni (Proxy :: Proxy ii) unnested_seq

  partitionC' _ proxy_ni proxy_ii unnested_seq =
    return $ seqToSeqOfSeq proxy_ni proxy_ii unnested_seq
    
  partitionC'' _ proxy_ni _ proxy_ii unnested_seq =
    return $ seqToSeqOfSeq proxy_ni proxy_ii unnested_seq

  unpartitionC _ _ unflattened_seq =
    return $ seqOfSeqToSeq unflattened_seq

  unpartitionC' (Simulation_Env unflattened_seq) =
    return $ seqOfSeqToSeq unflattened_seq

  -- higher order operators
  mapC _ f input = mapM f input
  mapC' f input = do
    input_val <- input
    mapM f input_val

  mapC'' f (Simulation_Env input) = do
    let f_unrwapped_args i_val = do
          let i_m = Simulation_Env i_val
          f i_m
    traverse f_unrwapped_args input
    
  map2C _ f input = traverse2 f input
  
  map2C' f input = traverse2 f input

  map2C'' f input1 input2 = do
    let f_unrwapped_args i1_val i2_val = do
          let i1 = Simulation_Env i1_val
          let i2 = Simulation_Env i2_val
          f i1 i2
    input1_val <- input1
    input2_val <- input2
    traverse2 f_unrwapped_args input1_val input2_val
    --traverse2 f input
  
  reduceC _ f (Simulation_Env (Seq input_vec)) = do
    let f_unrwapped_args i_val = do
          let i_m = Simulation_Env i_val
          f i_m
    fmap (\out_el -> Seq $ V.singleton out_el) $
      V.fold1M (\x y -> f_unrwapped_args (Atom_Tuple x y)) input_vec
  reduceC _ _ _ = fail $ fail_message "reduceC" "Seq"

  -- tuple operations
  fstC (Atom_Tuple x _) = return x
  fstC _ = fail $ fail_message "fstC" "Atom_Tuple"

  sndC (Atom_Tuple _ y) = return y
  sndC _ = fail $ fail_message "sndC" "Atom_Tuple"

  atom_tupleC x y = return $ Atom_Tuple x y

  seq_tupleC x y = return $ Seq_Tuple (listToVector (Proxy @2) [x, y])
  
  zipC :: forall n i a l . (Aetherling_Value (Seq n i a), KnownNat l, KnownNat n) =>
    Proxy l -> [Simulation_Env (Seq n i a)] -> Simulation_Env (Seq n i (Seq_Tuple l a))
  zipC proxyL xs | length xs == (fromInteger $ natVal proxyL) = do
    let xs_vals = fmap simulate xs
    let xs_lists = fmap (V.toList . sVec) xs_vals
    let zipped_lists = transpose xs_lists
    return $ Seq $ listToVector proxyN $ fmap (Seq_Tuple . listToVector proxyL) zipped_lists
    -- return $ Seq_Tuple (listToVector proxyL (fmap simulate xs))
    where
      proxyN = Proxy :: Proxy n
  zipC proxyL xs = fail $
    printf "zipC where length proxy %d doesn't match length of input %d"
    (natVal proxyL) (length xs)

  seq_tuple_appendC (Seq_Tuple input_vec) x = return $ Seq_Tuple $ V.snoc input_vec x
  seq_tuple_appendC _ _ = fail $ fail_message "seq_tuple_appendC" "Seq_Tuple"

  seq_tuple_to_seqC (Seq_Tuple input_vec) = return $ Seq input_vec
  seq_tuple_to_seqC _ = fail $ fail_message "seq_tuple_to_seqC" "Seq_Tuple"
  
  seq_to_seq_tupleC (Seq input_vec) = return $ Seq_Tuple input_vec
  seq_to_seq_tupleC _ = fail $ fail_message "seq_to_seq_tupleC" "Seq"

  -- composition operators
  (>>>) f g x = f x >>= g

fail_message fName tName = fName ++ " must receive " ++ tName ++
  "not " ++ tName ++ "_Wires or " ++ tName ++ "_Resources."

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

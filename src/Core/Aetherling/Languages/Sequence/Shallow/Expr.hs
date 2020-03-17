module Aetherling.Languages.Sequence.Shallow.Expr where
import Aetherling.Languages.Sequence.Shallow.Types
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import GHC.Exts (Constraint)
import qualified Data.Vector.Sized as V

class Monad m => Sequence_Language m where
  -- unary operators
  idC :: (Aetherling_Value a, Check_Type_Is_Atom a) => m a -> m a
  absC :: (Aetherling_Value a, Aetherling_Int a, Signed_Int a) => m a -> m a
  notC :: m Atom_Bit -> m Atom_Bit
  andC :: m (Atom_Tuple Atom_Bit Atom_Bit) -> m Atom_Bit
  orC :: m (Atom_Tuple Atom_Bit Atom_Bit) -> m Atom_Bit

  -- binary operators
  addC :: (Aetherling_Value a, Aetherling_Int a) => m (Atom_Tuple a a) -> m a
  subC :: (Aetherling_Value a, Aetherling_Int a) => m (Atom_Tuple a a) -> m a
  mulC :: (Aetherling_Value a, Aetherling_Int a) => m (Atom_Tuple a a) -> m a
  divC :: (Aetherling_Value a, Aetherling_Int a) => m (Atom_Tuple a Atom_FixP1_7) -> m a
  lsrC :: (Aetherling_Value a, Aetherling_Int a) => m (Atom_Tuple a Atom_UInt8) -> m a
  lslC :: (Aetherling_Value a, Aetherling_Int a) => m (Atom_Tuple a Atom_UInt8) -> m a
  ltC :: (Aetherling_Value a, Aetherling_Int a) => m (Atom_Tuple a a) -> m Atom_Bit
  eqC :: (Aetherling_Value a, Check_Type_Is_Atom a, Eq a) =>
    m (Atom_Tuple a a) -> m Atom_Bit
  ifC :: (Aetherling_Value a, Check_Type_Is_Atom a) =>
         m (Atom_Tuple Atom_Bit (Atom_Tuple a a)) -> m a

  -- generators
  lut_genC :: Aetherling_Value a =>
    [a] -> m Atom_UInt8 -> m a

  const_genC :: Aetherling_Value a =>
    a -> m b -> m a
    
  counterC :: (KnownNat n, Aetherling_Value a, Aetherling_Int a) =>
    Proxy n -> Int -> m b -> m a
    
  -- sequence operators
  shiftC :: (KnownNat n, KnownNat r,
              Aetherling_Value a) =>
    Proxy r -> m (Seq (n+r) a) -> m (Seq (n+r) a)
    
  shiftC' :: (KnownNat n, KnownNat r,
              Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> m (Seq (n+r) a) -> m (Seq (n+r) a)

  up_1dC :: (KnownNat n,
             Aetherling_Value a) =>
    Proxy n -> m (Seq 1 a) -> m (Seq n a)

  down_1dC :: (KnownNat n,
                Aetherling_Value a) =>
    Int -> m (Seq n a) -> m (Seq 1 a)
    
  down_1dC' :: (KnownNat n,
                Aetherling_Value a) =>
    Proxy n -> Int -> m (Seq n a) -> m (Seq 1 a)

  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                 Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    m (Seq (no GHC.TypeLits.* ni) a) ->
    m (Seq no (Seq ni a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                   Aetherling_Value a) =>
    m (Seq no (Seq ni a)) ->
    m (Seq (no GHC.TypeLits.* ni) a)

  unpartitionC' :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                   Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    m (Seq no (Seq ni a)) ->
    m (Seq (no GHC.TypeLits.* ni) a)
  -- higher order operators
  mapC :: (KnownNat n, 
           Aetherling_Value a,
           Aetherling_Value b) =>
    (m a -> m b) -> m (Seq n a) -> m (Seq n b)

  mapC' :: (KnownNat n, 
           Aetherling_Value a,
           Aetherling_Value b) =>
    Proxy n -> (m a -> m b) -> m (Seq n a) -> m (Seq n b)
    
  map2C :: (KnownNat n, 
            Aetherling_Value a,
            Aetherling_Value b,
            Aetherling_Value c) =>
    (m a -> m b -> m c) -> m (Seq n a) -> m (Seq n b) -> m (Seq n c)
    
  map2C' :: (KnownNat n, 
            Aetherling_Value a,
            Aetherling_Value b,
            Aetherling_Value c) =>
    Proxy n -> (m a -> m b -> m c) -> m (Seq n a) -> m (Seq n b) -> m (Seq n c)

  reduceC :: (KnownNat n, Aetherling_Value a) =>
    (m (Atom_Tuple a a) -> m a) -> m (Seq n a) -> m (Seq 1 a)
    
  reduceC' :: (KnownNat n, Aetherling_Value a) =>
    Proxy n -> (m (Atom_Tuple a a) -> m a) -> m (Seq n a) -> m (Seq 1 a)
    
  reduceC'' :: (KnownNat no,
              Aetherling_Value a) =>
    (m (Seq 1 (Atom_Tuple a a)) -> m (Seq 1 a)) ->
    m (Seq no (Seq 1 a)) -> m (Seq 1 (Seq 1 a))

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a, Aetherling_Value b) =>
    m (Atom_Tuple a b) -> m a

  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a, Aetherling_Value b) =>
    m (Atom_Tuple a b) -> m b

  atom_tupleC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                  Aetherling_Value a, Aetherling_Value b) =>
    m a -> m b -> m (Atom_Tuple a b)

  seq_tupleC :: (Aetherling_Value a) =>
    m a -> m a -> m (Seq_Tuple 2 a)

  zipC :: (Aetherling_Value a, KnownNat l, KnownNat no) =>
    Proxy l -> [m (Seq no (Seq 1 a))] ->
    m (Seq no (Seq 1 (Seq_Tuple l a)))

  seq_tuple_appendC :: (KnownNat n, Aetherling_Value (Seq_Tuple n a),
                        Aetherling_Value a,
                        Aetherling_Value (Seq_Tuple (n+1) a)) =>
    m (Seq_Tuple n a) -> m a -> m (Seq_Tuple (n+1) a)

  seq_tuple_to_seqC :: (KnownNat n, Aetherling_Value a) =>
    m (Seq 1 (Seq_Tuple n a)) ->
    m (Seq n a)

  seq_to_seq_tupleC :: (KnownNat n, Aetherling_Value a) =>
    m (Seq n a) ->
    m (Seq 1 (Seq_Tuple n a))

  -- composition operators
  (>>>) :: (m a -> m b) -> (m b -> m c) -> (m a -> m c)

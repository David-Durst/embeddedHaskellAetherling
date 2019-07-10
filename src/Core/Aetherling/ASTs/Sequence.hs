module Aetherling.ASTs.Sequence where 
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import GHC.Exts (Constraint)
import qualified Data.Vector.Sized as V

class Monad m => Sequence_Language m where
  -- unary operators
  idC :: (Aetherling_Value a, Check_Type_Is_Atom a) => m a -> m a
  absC :: m Atom_Int -> m Atom_Int
  notC :: m Atom_Bit -> m Atom_Bit

  -- binary operators
  addC :: m (Atom_Tuple Atom_Int Atom_Int) -> m Atom_Int
  subC :: m (Atom_Tuple Atom_Int Atom_Int) -> m Atom_Int
  mulC :: m (Atom_Tuple Atom_Int Atom_Int) -> m Atom_Int
  divC :: m (Atom_Tuple Atom_Int Atom_Int) -> m Atom_Int
  eqC :: (Aetherling_Value a, Check_Type_Is_Atom a, Eq a) =>
    m (Atom_Tuple a a) -> m Atom_Bit

  -- generators
  lut_genC :: Aetherling_Value a =>
    [a] -> m Atom_Int -> m a

  const_genC :: Aetherling_Value a =>
    a -> m b -> m a
    
  -- sequence operators
  shiftC :: (KnownNat n, KnownNat r, KnownNat i,
              Aetherling_Value a) =>
    Proxy r -> m (Seq (n+r) i a) -> m (Seq (n+r) i a)
    
  shiftC' :: (KnownNat n, KnownNat r, KnownNat i,
              Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> m (Seq (n+r) i a) -> m (Seq (n+r) i a)

  up_1dC :: (KnownNat n, KnownNat i,
             Aetherling_Value a) =>
    Proxy (1+n) -> m (Seq 1 (n + i) a) -> m (Seq (1+n) i a)

  down_1dC :: (KnownNat n, KnownNat i,
                Aetherling_Value a) =>
    Int -> m (Seq (1+n) i a) -> m (Seq 1 (n + i) a)
    
  down_1dC' :: (KnownNat n, KnownNat i,
                Aetherling_Value a) =>
    Proxy (1+n) -> Int -> m (Seq (1+n) i a) -> m (Seq 1 (n + i) a)

  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                 KnownNat io, KnownNat ii,
                 Aetherling_Value a) =>
    Proxy no -> Proxy ni -> Proxy io -> Proxy ii ->
    m (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                io GHC.TypeLits.* (ni + ii)) a) ->
    m (Seq no io (Seq ni ii a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                   KnownNat io, KnownNat ii,
                   Aetherling_Value a) =>
    m (Seq no io (Seq ni ii a)) ->
    m (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                   io GHC.TypeLits.* (ni + ii)) a)

  unpartitionC' :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                   KnownNat io, KnownNat ii,
                   Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    m (Seq no io (Seq ni ii a)) ->
    m (Seq (no GHC.TypeLits.* ni) ((no GHC.TypeLits.* ii) +
                                   io GHC.TypeLits.* (ni + ii)) a)
  -- higher order operators
  mapC :: (KnownNat n, KnownNat i,
           Aetherling_Value a,
           Aetherling_Value b) =>
    (m a -> m b) -> m (Seq n i a) -> m (Seq n i b)

  mapC' :: (KnownNat n, KnownNat i,
           Aetherling_Value a,
           Aetherling_Value b) =>
    Proxy n -> (m a -> m b) -> m (Seq n i a) -> m (Seq n i b)
    
  map2C :: (KnownNat n, KnownNat i,
            Aetherling_Value a,
            Aetherling_Value b,
            Aetherling_Value c) =>
    (m a -> m b -> m c) -> m (Seq n i a) -> m (Seq n i b) -> m (Seq n i c)
    
  map2C' :: (KnownNat n, KnownNat i,
            Aetherling_Value a,
            Aetherling_Value b,
            Aetherling_Value c) =>
    Proxy n -> (m a -> m b -> m c) -> m (Seq n i a) -> m (Seq n i b) -> m (Seq n i c)

  reduceC :: (KnownNat n, KnownNat i,
              Aetherling_Value a) =>
    (m (Atom_Tuple a a) -> m a) -> m (Seq (1+n) i a) -> m (Seq 1 (n + i) a)
    
  reduceC' :: (KnownNat n, KnownNat i,
              Aetherling_Value a) =>
    Proxy (1+n) -> (m (Atom_Tuple a a) -> m a) -> m (Seq (1+n) i a) -> m (Seq 1 (n + i) a)

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a,
           Aetherling_Value b) =>
    m (Atom_Tuple a b) -> m a

  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a,
           Aetherling_Value b) =>
    m (Atom_Tuple a b) -> m b

  atom_tupleC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                  Aetherling_Value a,
                  Aetherling_Value b) =>
    m a -> m b -> m (Atom_Tuple a b)

  seq_tupleC :: (Aetherling_Value a) =>
    m a -> m a -> m (Seq_Tuple 2 a)

  zipC :: (Aetherling_Value a, KnownNat l, KnownNat n, KnownNat i) =>
    Proxy l -> [m (Seq n i a)] -> m (Seq n i (Seq_Tuple l a))

  seq_tuple_appendC :: (KnownNat n, Aetherling_Value (Seq_Tuple n a),
                        Aetherling_Value a,
                        Aetherling_Value (Seq_Tuple (n+1) a)) =>
    m (Seq_Tuple n a) -> m a -> m (Seq_Tuple (n+1) a)

  seq_tuple_to_seqC :: (KnownNat no, KnownNat ni,
                        KnownNat io, KnownNat ii,
                        Aetherling_Value a) =>
    Proxy io -> Proxy ii ->
    m (Seq no ((no GHC.TypeLits.* ((ni - 1) + ii)) + (io GHC.TypeLits.* (ni + ii)))
       (Seq_Tuple ni a)) ->
    m (Seq no io (Seq ni ii a))

  seq_to_seq_tupleC :: (KnownNat no, KnownNat ni,
                        KnownNat io, KnownNat ii,
                        Aetherling_Value a) =>
    m (Seq no io (Seq ni ii a)) ->
    m (Seq no ((no GHC.TypeLits.* ((ni - 1) + ii)) + (io GHC.TypeLits.* (ni + ii)))
       (Seq_Tuple ni a))

  -- composition operators
  (>>>) :: (m a -> m b) -> (m b -> m c) -> (m a -> m c)

module Aetherling.Interpretations.Simulator where
import Aetherling.Declarations.Sequence
import Aetherling.Types.Declarations

simulate :: Simulator a -> a
simulate (Simulator a) = a

instance Sequence_Language Simulator where
  -- unary operators
  id x = return x

  absC (Atom_Int x) = return $ Atom_Int $ abs x
  absC _ = fail "absC simulator must receive an int"
  
  notC (Atom_Bit x) = return $ Atom_Bit $ not x
  notC _ = fail "absC simulator must receive a bit"

{-
  -- binary operators
  addC :: Atom_Tuple Atom_Int Atom_Int -> m Atom_Int
  eqC :: (Check_Type_Is_Atom a) =>
    Atom_Tuple a a -> m Atom_Bit

  -- generators
  lut_genC :: (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
    [a] -> Atom_Int -> m a

  const_genC :: (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
    a -> Atom_Unit -> m a

  -- sequence operators
  up_1dC :: (KnownNat n, 1 <= n, KnownNat (Type_Size a),
             Check_Type_Is_Atom a, Typeable (Proxy a)) =>
    Proxy n -> Seq 1 a -> m (Seq n a)

  down_1dC :: (KnownNat n, 1 <= n, KnownNat (Type_Size a),
                Check_Type_Is_Atom a, Typeable (Proxy a)) =>
    Proxy n -> Seq n a -> m (Seq 1 a)

  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) a -> m (Seq no (Seq ni a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni) =>
    Proxy no -> Proxy ni ->
    Seq no (Seq ni a) -> m (Seq (no GHC.TypeLits.* ni) a)

  -- higher order operators
  mapC :: (KnownNat n) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    Atom_Tuple a b -> m a
  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    Atom_Tuple a b -> m b
  nthC :: (KnownNat i, KnownNat n, (i+1) <= n) =>
    Proxy i -> Atom_NTuple n a -> m a

  zipC :: (Check_Types_Conform a b) =>
    a -> b -> m (Zipped_Types a b)

  -- composition operators
  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)
 -} 

data Simulator a = Simulator a
  deriving (Show, Eq, Functor)

instance Applicative Simulator where
  pure a = Simulator a
  Simulator f <*> Simulator a = Simulator $ f a

instance Monad Simulator where
  (Simulator a) >>= f = f a
  return a = Simulator a

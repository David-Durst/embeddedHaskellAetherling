module Aetherling.Interpretations.Simulator where
import Aetherling.Declarations.Sequence
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Data.Typeable
import qualified Data.Vector.Sized as V

simulate :: Simulator a -> a
simulate (Simulator a) = a

instance Sequence_Language Simulator where
  -- unary operators
  id x = return x

  absC (Atom_Int x) = return $ Atom_Int $ abs x
  absC _ = fail "absC simulator must receive an Atom_Int"
  
  notC (Atom_Bit x) = return $ Atom_Bit $ not x
  notC _ = fail "absC simulator must receive an Atom_Bit"

  -- binary operators
  addC (Atom_Int x) (Atom_Int y) = return $ Atom_Int $ x+y
  addC _ _ = fail "addC simulator must received 2 Atom_Int values"

  eqC x y = return $ Atom_Bit $ x == y 

  -- generators
  lut_genC xs (Atom_Int i) | i < length xs = return $ xs !! i 
  lut_genC xs (Atom_Int i) = fail "lut lookup index out of bounds"
  lut_genC _ _ = fail "lut must receive an Atom_Int"

  const_genC x = return x

{-
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

  mapC proxyN f |
    typeOf f == typeOf Atom_Unit {-||
    typeOf f == typeOf Atom_Bit True ||
    typeOf f == typeOf Atom_Int 1-} =
    return $ Seq $ V.replicate' proxyN f
    
 -} 
  -- composition operators
  (>>>) f g x = f x >>= g

data Simulator a = Simulator a
  deriving (Show, Eq, Functor)

instance Applicative Simulator where
  pure a = Simulator a
  Simulator f <*> Simulator a = Simulator $ f a

instance Monad Simulator where
  (Simulator a) >>= f = f a
  return a = Simulator a

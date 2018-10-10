module DataTypes where
import GHC.TypeLits
import Data.Proxy
import Data.Finite
import Data.Vector.Sized

f :: forall n . KnownNat n => Proxy n -> Integer
f _ = natVal (Proxy :: Proxy n) +
      natVal (Proxy :: Proxy (n+2))

type Module a b = a -> b

class Atom a where
  addAtom :: Module a (a -> a)
  subAtom :: Module a (a -> a)
  divAtom :: Module a (a -> a)
  mulAtom :: Module a (a -> a)
  minAtom :: Module a a
  maxAtom :: Module a a
  

type IntAtom = Int
instance Atom IntAtom where
  addAtom = (+)
  subAtom = (-)
  divAtom = div
  mulAtom = (*)

type Array n a = Vector n a
type Sequence n a = Vector n a

sArray0_2 :: Array 2 IntAtom
sArray0_2 = fromTuple (2, 2)
sArray0_3 :: Array 3 IntAtom
sArray0_3 = fromTuple (2, 2, 3)

sArray1_2 :: Array 2 IntAtom
sArray1_2 = fromTuple (4, 6)
sArray1_3 :: Array 3 IntAtom
sArray1_3 = fromTuple (1, 2, 3)

tSeq0_2 :: Sequence 2 (Array 2 IntAtom)
tSeq0_2 = fromTuple (sArray0_2, sArray1_2)
tSeq0_3 :: Sequence 2 (Array 3 IntAtom)
tSeq0_3 = fromTuple (sArray0_3, sArray1_3)

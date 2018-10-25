module DataTypes where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Control.Applicative
import qualified Data.List as L

type Module a b = a -> b

class (Eq a) => Atom a
type Bit = Bool
instance Atom Int
instance Atom Bit
instance Atom ()

newtype STIOC n a = STIOC {stVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (STIOC n) where
  fmap f (STIOC vec) = STIOC (fmap f vec)

instance (KnownNat n) => Applicative (STIOC n) where
  pure a = (STIOC ((pure :: a -> Vector n a) a))
  (STIOC f) <*> (STIOC a) = STIOC (f <*> a)

newtype Array n a = Array {aVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (Array n) where
  fmap f (Array vec) = Array (fmap f vec)

instance (KnownNat n) => Applicative (Array n) where
  pure a = (Array ((pure :: a -> Vector n a) a))
  (Array f) <*> (Array a) = Array (f <*> a)
  
newtype Sequence n v a = Sequence {seqVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (Sequence n v) where
  fmap f (Sequence vec) = Sequence (fmap f vec)

instance (KnownNat n) => Applicative (Sequence n v) where
  pure a = (Sequence ((pure :: a -> Vector n a) a))
  (Sequence f) <*> (Sequence a) = Sequence (f <*> a)

data ContainerType = STIOCType | ArrayType | SequenceType

sArray0_2 :: Array 2 Int
sArray0_2 = Array $ fromTuple (2, 2)
sArray0_3 :: Array 3 Int
sArray0_3 = Array $ fromTuple (2, 2, 3)
sArray0_22 :: Array 2 (Array 2 Int)
sArray0_22 = Array $ fromTuple (sArray0_2, sArray0_2)

sArray1_2 :: Array 2 Int
sArray1_2 = Array $ fromTuple (4, 6)
sArray1_3 :: Array 3 Int
sArray1_3 = Array $ fromTuple (1, 2, 3)

tSeq0_2 :: Sequence 2 0 (Array 2 Int)
tSeq0_2 = Sequence $ fromTuple (sArray0_2, sArray1_2)
tSeq0_3 :: Sequence 2 0 (Array 3 Int)
tSeq0_3 = Sequence $ fromTuple (sArray0_3, sArray1_3)
tSeq1_3 :: Sequence 3 0 (Array 2 Int)
tSeq1_3 = Sequence $ fromTuple (sArray1_2, sArray1_2, sArray1_2)

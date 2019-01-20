module DataTypes where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Control.Applicative
import qualified Data.List as L

data Atom = Int Int | Bit Bool | Tuple (Atom, Atom) | CompilerResult String deriving (Show, Eq)

newtype Seq n a = Seq {stVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (Seq n) where
  fmap f (Seq vec) = Seq (fmap f vec)

instance (KnownNat n) => Applicative (Seq n) where
  pure a = (Seq ((pure :: a -> Vector n a) a))
  (Seq f) <*> (Seq a) = Seq (f <*> a)

newtype SSeq n a = SSeq {aVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (SSeq n) where
  fmap f (SSeq vec) = SSeq (fmap f vec)

instance (KnownNat n) => Applicative (SSeq n) where
  pure a = (SSeq ((pure :: a -> Vector n a) a))
  (SSeq f) <*> (SSeq a) = SSeq (f <*> a)
  
-- n is number of elements, v is number of clocks of delay
-- v is always 0 for now. Please ignore it for the time being
newtype TSeq n v a = TSeq {seqVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (TSeq n v) where
  fmap f (TSeq vec) = TSeq (fmap f vec)

instance (KnownNat n) => Applicative (TSeq n v) where
  pure a = (TSeq ((pure :: a -> Vector n a) a))
  (TSeq f) <*> (TSeq a) = TSeq (f <*> a)

data ContainerType = SeqType | SSeqType | TSeqType

sSSeq0_2 :: SSeq 2 Int
sSSeq0_2 = SSeq $ fromTuple (2, 2)
sSSeq0_3 :: SSeq 3 Int
sSSeq0_3 = SSeq $ fromTuple (2, 2, 3)
sSSeq0_22 :: SSeq 2 (SSeq 2 Int)
sSSeq0_22 = SSeq $ fromTuple (sSSeq0_2, sSSeq0_2)

sSSeq1_2 :: SSeq 2 Int
sSSeq1_2 = SSeq $ fromTuple (4, 6)
sSSeq1_3 :: SSeq 3 Int
sSSeq1_3 = SSeq $ fromTuple (1, 2, 3)

tSeq0_2 :: TSeq 2 0 (SSeq 2 Int)
tSeq0_2 = TSeq $ fromTuple (sSSeq0_2, sSSeq1_2)
tSeq0_3 :: TSeq 2 0 (SSeq 3 Int)
tSeq0_3 = TSeq $ fromTuple (sSSeq0_3, sSSeq1_3)
tSeq1_3 :: TSeq 3 0 (SSeq 2 Int)
tSeq1_3 = TSeq $ fromTuple (sSSeq1_2, sSSeq1_2, sSSeq1_2)

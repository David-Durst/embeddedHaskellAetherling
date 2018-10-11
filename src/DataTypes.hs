module DataTypes where
import GHC.TypeLits
import Data.Proxy
import Data.Finite
import Data.Vector.Sized
import Control.Applicative

type Module a b = a -> b

class (Eq a) => Atom a
type Bit = Bool
instance Atom Int
instance Atom Bit
instance Atom ()

type Array n a = Vector n a
type Sequence n a = Vector n a

sArray0_2 :: Array 2 Int
sArray0_2 = fromTuple (2, 2)
sArray0_3 :: Array 3 Int
sArray0_3 = fromTuple (2, 2, 3)
sArray0_22 :: Array 2 (Array 2 Int)
sArray0_22 = fromTuple (sArray0_2, sArray0_2)

sArray1_2 :: Array 2 Int
sArray1_2 = fromTuple (4, 6)
sArray1_3 :: Array 3 Int
sArray1_3 = fromTuple (1, 2, 3)

tSeq0_2 :: Sequence 2 (Array 2 Int)
tSeq0_2 = fromTuple (sArray0_2, sArray1_2)
tSeq0_3 :: Sequence 2 (Array 3 Int)
tSeq0_3 = fromTuple (sArray0_3, sArray1_3)


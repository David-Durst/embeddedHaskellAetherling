module DataTypes where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Proxy
import Data.Finite
import Data.Vector.Sized as V
import Control.Applicative
import qualified Data.List as L
import Data.Maybe
import Data.Finite
import Data.List.Split
import Data.Types.Injective
import Data.Types.Isomorphic

type Module a b = a -> b

class (Eq a) => Atom a
type Bit = Bool
instance Atom Int
instance Atom Bit
instance Atom ()

newtype STIOC n a = STIOC (Vector n a)
newtype Array n a = Array (Vector n a)
newtype Sequence n v a = Sequence (Vector n a)

class TotalElements n where
  numElements :: n -> Int

instance TotalElements Int where
  numElements _ = 1

instance TotalElements Bit where
  numElements _ = 1

instance TotalElements () where
  numElements _ = 1

-- way in values (but not types) to show two containers are same total size with different
-- amounts of nesting
instance (TotalElements a, KnownNat n, KnownNat m, n ~ (m+1)) => TotalElements (STIOC n a) where
  numElements (STIOC vec) = V.length vec + (numElements $ V.head vec)

instance (TotalElements a, KnownNat n, KnownNat m, n ~ (m+1)) => TotalElements (Array n a) where
  numElements (Array vec) = V.length vec + (numElements $ V.head vec)

instance (TotalElements a, KnownNat n, KnownNat m, n ~ (m+1)) => TotalElements (Sequence n v a) where
  numElements (Sequence vec) = V.length vec + (numElements $ V.head vec)


-- way to convert between time or space containers and independent contianers, no nesting yet
instance (KnownNat n) => Injective (STIOC n a) (Array n a) where
  to (STIOC vec) = Array vec

instance (KnownNat n) => Injective (Array n a) (STIOC n a) where
  to (Array vec) = STIOC vec

instance (KnownNat n) => Iso (Array n a) (STIOC n a)

instance (KnownNat n) => Injective (STIOC n a) (Sequence n v a) where
  to (STIOC vec) = Sequence vec

instance (KnownNat n) => Injective (Sequence n v a) (STIOC n a) where
  to (Sequence vec) = STIOC vec

instance (KnownNat n) => Iso (Sequence n v a) (STIOC n a)
{-
why does the above work and d1head and d2head, but not this:
instance (TotalElements a, KnownNat (n+1)) => TotalElements (Array (n+1) a) where
  numElements (Array vec) = V.length vec + (numElements $ V.head vec)





d1head :: (KnownNat n) => Vector (1+n) a -> a
d1head = V.head

d2head :: (TotalElements a, KnownNat n) => STIOC (1+n) a -> a
d2head (STIOC vec)= V.head vec
-- instance (TotalElements a, KnownNat n, (1+n) ~ nat) => TotalElements (STIOC (1+n) a)
dhead :: forall n a. Vector (1+n) a -> a
dhead = V.head
-}
{-totalSize :: TotalElements a -> Int
totalSize 
-}
--instance Functor (STIOC n a) where

-- mapSTIOCToST :: KnownNat n => Proxy n -> STIOC n

-- this is intentionally undefined if list length doesn't match claimed length
listToVector :: KnownNat n => Proxy n -> [a] -> Vector n a
listToVector p xs | fromIntegral (L.length xs) == natVal p  = fromJust $ fromList xs
{-
liftSTIOCToSpace :: (KnownNat n, KnownNat k) => Proxy k -> STIOC n a ->
  STIOC (Div n k) (Array k a)
liftSTIOCToSpace (proxyK :: Proxy k) (xs :: STIOC n a) | 1 <=? k =
  let
    kInteger :: Int
    kInteger = fromIntegral $ natVal proxyK
    listDividedIntoSpaceListChunks = chunksOf kInteger (toList xs)
    listDividedIntoSpaceVectorChunks = fmap (listToVector proxyK)
      listDividedIntoSpaceListChunks
    newOuterLength :: Proxy (Div n k)
    newOuterLength = Proxy
    vectorDividedIntoSpaceVectorChunks = listToVector newOuterLength
      listDividedIntoSpaceVectorChunks
  in
    vectorDividedIntoSpaceVectorChunks
-}   
    

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


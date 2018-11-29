module Isomorphism where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Proxy
import Data.Finite
import Data.Vector.Sized as V
import Control.Applicative
import qualified Data.List as L
import Data.Maybe
import Data.List.Split
import Data.Types.Injective
import Data.Types.Isomorphic
import DataTypes
  
-- way to convert between time or space containers and independent containers
instance (KnownNat n) => Injective (STIOC n a) (Array n a) where
  to (STIOC vec) = Array vec

instance (KnownNat n) => Injective (Array n a) (STIOC n a) where
  to (Array vec) = STIOC vec

instance (KnownNat n)  => Iso (Array n a) (STIOC n a)
instance (KnownNat n) => Iso (STIOC n a) (Array n a)

instance (KnownNat n) => Injective (STIOC n a) (Sequence n v a) where
  to (STIOC vec) = Sequence vec

instance (KnownNat n) => Injective (Sequence n v a) (STIOC n a) where
  to (Sequence vec) = STIOC vec

instance (KnownNat n) => Iso (Sequence n v a) (STIOC n a)
instance (KnownNat n) => Iso (STIOC n a) (Sequence n v a)

-- ability to convert nested STIOCs to flat, at one level

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Injective (STIOC n (STIOC m a)) (STIOC o a) where
  to (STIOC vecOfSTIOCs) =
    let
      vecOfVecs = fmap stVec vecOfSTIOCs
      flatVec = flattenNestedVector vecOfVecs
    in STIOC flatVec 
  
instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Injective (STIOC o a) (STIOC n (STIOC m a)) where
  to (STIOC flatVec) =
    let
      sublistLengthProxy :: Proxy m
      sublistLengthProxy = Proxy
      vecOfVecs = nestVector sublistLengthProxy flatVec
      vecOfSTIOCs = fmap STIOC vecOfVecs 
    in STIOC vecOfSTIOCs

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Iso (STIOC o a) (STIOC n (STIOC m a))

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Iso (STIOC n (STIOC m a)) (STIOC o a)

  
instance (KnownNat n, KnownNat m) =>
  Injective (STIOC n (STIOC m a)) (STIOC n (Array m a)) where
  to (STIOC vecOfSTIOCs) = STIOC (fmap to vecOfSTIOCs)

instance (KnownNat n, KnownNat m) =>
  Injective (STIOC n (Array m a)) (STIOC n (STIOC m a)) where
  to (STIOC vecOfArrays) = STIOC (fmap to vecOfArrays)

instance (KnownNat n, KnownNat m) =>
  Iso (STIOC n (Array m a)) (STIOC n (STIOC m a))

instance (KnownNat n, KnownNat m) =>
  Iso (STIOC n (STIOC m a)) (STIOC n (Array m a))

  
instance (KnownNat n, KnownNat m) =>
  Injective (STIOC n (STIOC m a)) (STIOC n (Sequence m v a)) where
  to (STIOC vecOfSTIOCs) = STIOC (fmap to vecOfSTIOCs)

instance (KnownNat n, KnownNat m) =>
  Injective (STIOC n (Sequence m v a)) (STIOC n (STIOC m a)) where
  to (STIOC vecOfSequences) = STIOC (fmap to vecOfSequences)

instance (KnownNat n, KnownNat m) =>
  Iso (STIOC n (Sequence m v a)) (STIOC n (STIOC m a))

instance (KnownNat n, KnownNat m) =>
  Iso (STIOC n (STIOC m a)) (STIOC n (Sequence m v a))

-- this is intentionally undefined if list length doesn't match claimed length
listToVector :: KnownNat n => Proxy n -> [a] -> Vector n a
listToVector p xs | fromIntegral (L.length xs) == natVal p  = fromJust $ fromList xs

vectorToList :: KnownNat n => Vector n a -> [a]
vectorToList = toList

flattenNestedVector :: (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
                       (Vector n (Vector m a)) -> (Vector o a)
flattenNestedVector (vectorOfVectors :: Vector n (Vector m a)) =
  let
    vectorOfLists = fmap vectorToList vectorOfVectors
    listOfLists = vectorToList vectorOfLists
    flatList = concat listOfLists
    totalLength :: Proxy (n*m)
    totalLength = Proxy
    flatVector = listToVector totalLength flatList
  in flatVector

nestVector :: (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
              Proxy m -> (Vector o a) -> (Vector n (Vector m a))
nestVector sublistLengthProxy (flatVector :: Vector o a) =
  let
    flatList = vectorToList flatVector
    sublistLength = fromIntegral $ natVal sublistLengthProxy
    listOfLists = chunksOf sublistLength flatList
    listOfVectors = fmap (listToVector sublistLengthProxy) listOfLists
    totalLengthProxy :: Proxy n
    totalLengthProxy = Proxy
    vectorOfVectors = listToVector totalLengthProxy listOfVectors
  in vectorOfVectors

-- an example of the ismorphisms
-- here taking a space-time, nested represnetation (a sequence of length 2
-- of an array of length 2 of a STIOC of 2) and flattening it to a sequence of
-- length 8
stioc2_0 :: STIOC 2 Int
stioc2_0 = STIOC (listToVector (Proxy @2) [0,1])
stioc2_1 :: STIOC 2 Int
stioc2_1 = STIOC (listToVector (Proxy @2) [2,3])
stioc2_2 :: STIOC 2 Int
stioc2_2 = STIOC (listToVector (Proxy @2) [4,5])
stioc2_3 :: STIOC 2 Int
stioc2_3 = STIOC (listToVector (Proxy @2) [6,7])
array2_0 :: Array 2 (STIOC 2 Int)
array2_0 = Array (listToVector (Proxy @2) [stioc2_0, stioc2_1])
array2_1 :: Array 2 (STIOC 2 Int)
array2_1 = Array (listToVector (Proxy @2) [stioc2_2, stioc2_3])
seqOfArrOfSTIOC :: Sequence 2 0 (Array 2 (STIOC 2 Int))
seqOfArrOfSTIOC = Sequence (listToVector (Proxy @2) [array2_0, array2_1])
seqOfSTIOCofSTIOC :: Sequence 2 0 (STIOC 2 (STIOC 2 Int))
seqOfSTIOCofSTIOC = fmap to seqOfArrOfSTIOC
seqOfFlatSTIOC :: Sequence 2 0 (STIOC 4 Int)
seqOfFlatSTIOC = fmap to seqOfSTIOCofSTIOC
stiocOfFlatSTIOC :: STIOC 2 (STIOC 4 Int)
stiocOfFlatSTIOC = to seqOfFlatSTIOC 
flatSTIOC :: STIOC 8 Int
flatSTIOC = to stiocOfFlatSTIOC 
flatSeq :: Sequence 8 0 Int
flatSeq = to flatSTIOC 
-- now that we've flattened completely, can renest to a sequence of length 1 of
-- an Array of length 8
stioc1OfSTIOC8 :: STIOC 1 (STIOC 8 Int)
stioc1OfSTIOC8 = to flatSTIOC
stioc1OfArray8 :: STIOC 1 (Array 8 Int)
stioc1OfArray8 = to stioc1OfSTIOC8
seq1OfArray8 :: Sequence 1 7 (Array 8 Int)
seq1OfArray8 = to stioc1OfArray8
-- the type system enforces total length, as seen here
-- as the following code fails to type check
--seq2OfArray8 :: Sequence 2 7 (Array 8 Int)
--seq2OfArray8 = to stioc1OfArray8

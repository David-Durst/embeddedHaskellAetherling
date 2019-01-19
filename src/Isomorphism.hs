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
instance (KnownNat n) => Injective (Seq n a) (SSeq n a) where
  to (Seq vec) = SSeq vec

instance (KnownNat n) => Injective (SSeq n a) (Seq n a) where
  to (SSeq vec) = Seq vec

instance (KnownNat n)  => Iso (SSeq n a) (Seq n a)
instance (KnownNat n) => Iso (Seq n a) (SSeq n a)

instance (KnownNat n) => Injective (Seq n a) (TSeq n v a) where
  to (Seq vec) = TSeq vec

instance (KnownNat n) => Injective (TSeq n v a) (Seq n a) where
  to (TSeq vec) = Seq vec

instance (KnownNat n) => Iso (TSeq n v a) (Seq n a)
instance (KnownNat n) => Iso (Seq n a) (TSeq n v a)

-- ability to convert nested Seqs to flat, at one level

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Injective (Seq n (Seq m a)) (Seq o a) where
  to (Seq vecOfSeqs) =
    let
      vecOfVecs = fmap stVec vecOfSeqs
      flatVec = flattenNestedVector vecOfVecs
    in Seq flatVec 
  
instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Injective (Seq o a) (Seq n (Seq m a)) where
  to (Seq flatVec) =
    let
      sublistLengthProxy :: Proxy m
      sublistLengthProxy = Proxy
      vecOfVecs = nestVector sublistLengthProxy flatVec
      vecOfSeqs = fmap Seq vecOfVecs 
    in Seq vecOfSeqs

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Iso (Seq o a) (Seq n (Seq m a))

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n*m)) =>
  Iso (Seq n (Seq m a)) (Seq o a)

  
instance (KnownNat n, KnownNat m) =>
  Injective (Seq n (Seq m a)) (Seq n (SSeq m a)) where
  to (Seq vecOfSeqs) = Seq (fmap to vecOfSeqs)

instance (KnownNat n, KnownNat m) =>
  Injective (Seq n (SSeq m a)) (Seq n (Seq m a)) where
  to (Seq vecOfSSeqs) = Seq (fmap to vecOfSSeqs)

instance (KnownNat n, KnownNat m) =>
  Iso (Seq n (SSeq m a)) (Seq n (Seq m a))

instance (KnownNat n, KnownNat m) =>
  Iso (Seq n (Seq m a)) (Seq n (SSeq m a))

  
instance (KnownNat n, KnownNat m) =>
  Injective (Seq n (Seq m a)) (Seq n (TSeq m v a)) where
  to (Seq vecOfSeqs) = Seq (fmap to vecOfSeqs)

instance (KnownNat n, KnownNat m) =>
  Injective (Seq n (TSeq m v a)) (Seq n (Seq m a)) where
  to (Seq vecOfTSeqs) = Seq (fmap to vecOfTSeqs)

instance (KnownNat n, KnownNat m) =>
  Iso (Seq n (TSeq m v a)) (Seq n (Seq m a))

instance (KnownNat n, KnownNat m) =>
  Iso (Seq n (Seq m a)) (Seq n (TSeq m v a))

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
-- of an array of length 2 of a Seq of 2) and flattening it to a sequence of
-- length 8
stioc2_0 :: Seq 2 Int
stioc2_0 = Seq (listToVector (Proxy @2) [0,1])
stioc2_1 :: Seq 2 Int
stioc2_1 = Seq (listToVector (Proxy @2) [2,3])
stioc2_2 :: Seq 2 Int
stioc2_2 = Seq (listToVector (Proxy @2) [4,5])
stioc2_3 :: Seq 2 Int
stioc2_3 = Seq (listToVector (Proxy @2) [6,7])
array2_0 :: SSeq 2 (Seq 2 Int)
array2_0 = SSeq (listToVector (Proxy @2) [stioc2_0, stioc2_1])
array2_1 :: SSeq 2 (Seq 2 Int)
array2_1 = SSeq (listToVector (Proxy @2) [stioc2_2, stioc2_3])
seqOfArrOfSeq :: TSeq 2 0 (SSeq 2 (Seq 2 Int))
seqOfArrOfSeq = TSeq (listToVector (Proxy @2) [array2_0, array2_1])
seqOfSeqofSeq :: TSeq 2 0 (Seq 2 (Seq 2 Int))
seqOfSeqofSeq = fmap to seqOfArrOfSeq
seqOfFlatSeq :: TSeq 2 0 (Seq 4 Int)
seqOfFlatSeq = fmap to seqOfSeqofSeq
stiocOfFlatSeq :: Seq 2 (Seq 4 Int)
stiocOfFlatSeq = to seqOfFlatSeq 
flatSeq :: Seq 8 Int
flatSeq = to stiocOfFlatSeq 
flatTSeq :: TSeq 8 0 Int
flatTSeq = to flatSeq 
-- now that we've flattened completely, can renest to a sequence of length 1 of
-- an SSeq of length 8
stioc1OfSeq8 :: Seq 1 (Seq 8 Int)
stioc1OfSeq8 = to flatSeq
stioc1OfSSeq8 :: Seq 1 (SSeq 8 Int)
stioc1OfSSeq8 = to stioc1OfSeq8
seq1OfSSeq8 :: TSeq 1 7 (SSeq 8 Int)
seq1OfSSeq8 = to stioc1OfSSeq8
-- the type system enforces total length, as seen here
-- as the following code fails to type check
--seq2OfSSeq8 :: TSeq 2 7 (SSeq 8 Int)
--seq2OfSSeq8 = to stioc1OfSSeq8

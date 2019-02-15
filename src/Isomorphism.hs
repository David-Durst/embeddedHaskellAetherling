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
instance Injective (Seq n a) (SSeq n a) where
  to (Seq vec) = SSeq vec
seqToSSeq :: Seq n a -> SSeq n a
seqToSSeq = to

instance Injective (SSeq n a) (Seq n a) where
  to (SSeq vec) = Seq vec
sseqToSeq :: SSeq n a -> Seq n a
sseqToSeq = to

instance Iso (SSeq n a) (Seq n a)
instance Iso (Seq n a) (SSeq n a)

instance Injective (Seq n a) (TSeq n v a) where
  to (Seq vec) = TSeq vec
seqToTSeq :: Seq n a -> TSeq n v a
seqToTSeq = to

instance Injective (TSeq n v a) (Seq n a) where
  to (TSeq vec) = Seq vec
tseqToSeq :: TSeq n v a -> Seq n a
tseqToSeq = to

instance Iso (TSeq n v a) (Seq n a)
instance Iso (Seq n a) (TSeq n v a)

instance Injective (TSeq n v a) (TSeq n u a) where
  to (TSeq vec) = TSeq vec

changeUtilTSeq :: TSeq n v a -> TSeq n u a
changeUtilTSeq (TSeq vec) = TSeq vec

instance Iso (TSeq n v a) (TSeq n u a)

tseqToSSeq = seqToSSeq . tseqToSeq
sseqToTSeq = seqToTSeq . sseqToSeq

-- ability to convert nested Seqs to flat, at one level

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
  Injective (Seq n (Seq m a)) (Seq o a) where
  to (Seq vecOfSeqs) =
    let
      vecOfVecs = fmap stVec vecOfSeqs
      flatVec = flattenNestedVector vecOfVecs
    in Seq flatVec 
seqOfSeqToSeq :: (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
  Seq n (Seq m a) -> Seq o a
seqOfSeqToSeq = to
  
instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
  Injective (Seq o a) (Seq n (Seq m a)) where
  to (Seq flatVec) =
    let
      sublistLengthProxy :: Proxy m
      sublistLengthProxy = Proxy
      vecOfVecs = nestVector sublistLengthProxy flatVec
      vecOfSeqs = fmap Seq vecOfVecs 
    in Seq vecOfSeqs
seqToSeqOfSeq :: (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
  Proxy m -> Seq o a -> Seq n (Seq m a)
seqToSeqOfSeq _ = to

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
  Iso (Seq o a) (Seq n (Seq m a))

instance (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
  Iso (Seq n (Seq m a)) (Seq o a)

  
instance Injective (Seq n (Seq m a)) (Seq n (SSeq m a)) where
  to (Seq vecOfSeqs) = Seq (fmap to vecOfSeqs)
seqOfSeqToSeqOfSSeq :: Seq n (Seq m a) -> Seq n (SSeq m a) 
seqOfSeqToSeqOfSSeq = to

instance Injective (Seq n (SSeq m a)) (Seq n (Seq m a)) where
  to (Seq vecOfSSeqs) = Seq (fmap to vecOfSSeqs)
seqOfSSeqToSeqOfSeq :: Seq n (SSeq m a) -> Seq n (Seq m a) 
seqOfSSeqToSeqOfSeq = to

instance Iso (Seq n (SSeq m a)) (Seq n (Seq m a))

instance Iso (Seq n (Seq m a)) (Seq n (SSeq m a))

  
instance Injective (Seq n (Seq m a)) (Seq n (TSeq m v a)) where
  to (Seq vecOfSeqs) = Seq (fmap to vecOfSeqs)
seqOfSeqToSeqOfTSeq :: Seq n (Seq m a) -> Seq n (TSeq m v a) 
seqOfSeqToSeqOfTSeq = to

instance Injective (Seq n (TSeq m v a)) (Seq n (Seq m a)) where
  to (Seq vecOfTSeqs) = Seq (fmap to vecOfTSeqs)
seqOfTSeqToSeqOfSeq :: Seq n (TSeq m v a) -> Seq n (Seq m a) 
seqOfTSeqToSeqOfSeq = to

instance Iso (Seq n (TSeq m v a)) (Seq n (Seq m a))

instance Iso (Seq n (Seq m a)) (Seq n (TSeq m v a))

-- this is intentionally undefined if list length doesn't match claimed length
listToVector :: KnownNat n => Proxy n -> [a] -> Vector n a
listToVector p xs | fromIntegral (L.length xs) == natVal p  = fromJust $ fromList xs

vectorToList :: KnownNat n => Vector n a -> [a]
vectorToList = toList

seqToVector :: (KnownNat n) => Seq n a -> Vector n a
seqToVector (Seq vec) = vec

seqOfSeqToVectorOfVector :: (KnownNat n, KnownNat m) => 
                            Seq n (Seq m a) -> Vector n (Vector m a)
seqOfSeqToVectorOfVector (Seq vecOfSeqs) = V.map (\(Seq vec) -> vec) vecOfSeqs

vectorToSeq :: (KnownNat n) => Vector n a -> Seq n a
vectorToSeq vec = Seq vec
  
vectorOfVectorToSeqOfSeq :: (KnownNat n, KnownNat m) => 
                            Vector n (Vector m a) -> Seq n (Seq m a) 
vectorOfVectorToSeqOfSeq vecOfVecs = Seq $ V.map (\vec -> Seq vec) vecOfVecs

flattenNestedVector :: (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
                       (Vector n (Vector m a)) -> (Vector o a)
flattenNestedVector (vectorOfVectors :: Vector n (Vector m a)) =
  let
    vectorOfLists = fmap vectorToList vectorOfVectors
    listOfLists = vectorToList vectorOfLists
    flatList = concat listOfLists
    totalLength :: Proxy (n GHC.TypeLits.* m)
    totalLength = Proxy
    flatVector = listToVector totalLength flatList
  in flatVector

nestVector :: (KnownNat n, KnownNat m, KnownNat o, o ~ (n GHC.TypeLits.* m)) =>
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

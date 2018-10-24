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
  
-- way to convert between time or space containers and independent contianers, no nesting yet
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

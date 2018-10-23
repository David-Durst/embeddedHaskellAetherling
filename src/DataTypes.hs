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

newtype STIOC n a = STIOC {stVec :: Vector n a}

instance (KnownNat n) => Functor (STIOC n) where
  fmap f (STIOC vec) = STIOC (fmap f vec)

instance (KnownNat n) => Applicative (STIOC n) where
  pure a = (STIOC ((pure :: a -> Vector n a) a))
  (STIOC f) <*> (STIOC a) = STIOC (f <*> a)

newtype Array n a = Array {aVec :: Vector n a}

instance (KnownNat n) => Functor (Array n) where
  fmap f (Array vec) = Array (fmap f vec)

instance (KnownNat n) => Applicative (Array n) where
  pure a = (Array ((pure :: a -> Vector n a) a))
  (Array f) <*> (Array a) = Array (f <*> a)
  
newtype Sequence n v a = Sequence {seqVec :: Vector n a}

instance (KnownNat n) => Functor (Sequence n v) where
  fmap f (Sequence vec) = Sequence (fmap f vec)

instance (KnownNat n) => Applicative (Sequence n v) where
  pure a = (Sequence ((pure :: a -> Vector n a) a))
  (Sequence f) <*> (Sequence a) = Sequence (f <*> a)

data ContainerType = STIOCType | ArrayType | SequenceType

{-
Why does this fail? How to embed tuple decomposition in type system?
type family STIOCList (typesAndLengths :: [(ContainerType, Nat)])  a  where
  STIOCList '[] a = a
  STIOCList ((STIOCType, outerLength) ': innerLengths) a = STIOC outerLength (STIOCList innerLengths a)
-}

-- this is a type constructor, that gives me the ability to talk about the deeply nested
-- types in my type system
type family ContainerList (lengths :: [Nat]) (containerTypes :: [ContainerType])
  (vVals :: [Nat]) elementType :: * where
  ContainerList '[] _ _ Bit = Bit
  ContainerList '[] _ _ Int = Int
  ContainerList '[] _ _ () = ()
  ContainerList (outerLength ': innerLengths) (STIOCType ': innerTypes) vVals elementType =
    STIOC outerLength (ContainerList innerLengths innerTypes vVals elementType)
  ContainerList (outerLength ': innerLengths) (ArrayType ': innerTypes) vVals elementType =
    Array outerLength (ContainerList innerLengths innerTypes vVals elementType)
  ContainerList (outerLength ': innerLengths) (SequenceType ': innerTypes) (vVal ': innerVVals) elementType =
    Sequence outerLength vVal (ContainerList innerLengths innerTypes innerVVals elementType)

exampleFromTypeFunction :: (ContainerList '[1] '[STIOCType] '[] Bit)
exampleFromTypeFunction = STIOC (listToVector (Proxy @1) [True])

-- this takes in any type (elementOrContainer) and emits the total length
-- where its the length times the lengths of the nested elements if the
-- container is a STIOC, Array, or Sequence. Otherwise, its 1 as anything else
-- is stored as an atomic element in these arrays
type family NestedContainersSize (elementOrContainer :: *) :: Nat where
  NestedContainersSize Int = 1
  NestedContainersSize Bit = 1
  NestedContainersSize () = 1
  NestedContainersSize (STIOC n a) = n * (NestedContainersSize a)
  NestedContainersSize (Array n a) = n * (NestedContainersSize a)
  NestedContainersSize (Sequence n _ a) = n * (NestedContainersSize a)

flattenContainerList :: (KnownNat n,
                         NestedContainersSize (ContainerList lengths
                                               containerTypes vVales elementType)
                          ~ n) =>
                        ContainerList lengths containerTypes vVales elementType ->
                        STIOC n elementType
flattenContainerList (x :: ContainerList '[] _ _ Bit) =STIOC (listToVector (Proxy @1) [x])
{-
instance (NestedContainersSize a ~ NestedContainersSize b) =>
  Injective a b
-}
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
instance (TotalElements a, KnownNat n, KnownNat m, n ~ (m+1)) =>
  TotalElements (STIOC n a) where
  numElements (STIOC vec) = V.length vec + (numElements $ V.head vec)

instance (TotalElements a, KnownNat n, KnownNat m, n ~ (m+1)) =>
  TotalElements (Array n a) where
  numElements (Array vec) = V.length vec + (numElements $ V.head vec)

instance (TotalElements a, KnownNat n, KnownNat m, n ~ (m+1)) =>
  TotalElements (Sequence n v a) where
  numElements (Sequence vec) = V.length vec + (numElements $ V.head vec)


-- way to convert between time or space containers and independent contianers, no nesting yet
instance (KnownNat n) => Injective (STIOC n a) (Array n a) where
  to (STIOC vec) = Array vec

instance (KnownNat n) => Injective (Array n a) (STIOC n a) where
  to (Array vec) = STIOC vec

instance (KnownNat n) => Iso (Array n a) (STIOC n a)
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

-- trying for autoderiving isomorphisms
class CustomIso a b where
  customTo :: a -> b
  customFrom :: b -> a

instance CustomIso Int Int where
  customTo = id
  customFrom = id

instance CustomIso Bit Bit where
  customTo = id
  customFrom = id

instance CustomIso () () where
  customTo = id
  customFrom = id



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

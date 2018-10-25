module Scheduling where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Proxy
import Data.Finite
import Data.Vector.Sized as V
import Control.Applicative
import qualified Data.List as L
import Data.Maybe
import Data.List.Split
import DataTypes
import Data.Types.Injective
import Data.Types.Isomorphic
import Isomorphism

liftSTIOCToSpace :: (KnownNat n, KnownNat m) => (STIOC n a -> STIOC m b) -> Array n a -> Array m b
liftSTIOCToSpace f = to . f . to

liftSTIOCToTime :: (KnownNat n, KnownNat m, KnownNat v) => Proxy v -> (STIOC n a -> STIOC m b) -> Sequence n v a -> Sequence m v b
liftSTIOCToTime _ f = to . f . to

-- https://kseo.github.io/posts/2017-01-16-type-level-functions-using-closed-type-families.html
-- https://wiki.haskell.org/GHC/Type_families#Type_class_instances_of_family_instances
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

data Container n v a = STC (STIOC n a)
  | AC (Array n a)
  | SEQC (Sequence n v a)
--  | STNestedC (STIOC i (STIOC o a))
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (Container n v) where
  fmap f (STC (STIOC vec)) = STC (STIOC (fmap f vec))
  fmap f (AC (Array vec)) = AC (Array (fmap f vec))
  fmap f (SEQC (Sequence vec)) = SEQC (Sequence (fmap f vec))
--  fmap f (STNestedC (STIOC stoicOfVecs)) = STNestedC (STOIC (fmap f stoicOfVecs))



-- Intentionally leaving interactions between different containers undefined
-- As the operators shouldn't mix
instance (KnownNat n) => Applicative (Container n v) where
  pure a = STC (STIOC ((pure :: a -> Vector n a) a))
  STC (STIOC f) <*> STC (STIOC a) = STC (STIOC (f <*> a))
  AC (Array f) <*> AC (Array a) = AC (Array (f <*> a))
  SEQC (Sequence f) <*> SEQC (Sequence a) = SEQC (Sequence (f <*> a))


-- custom join for the container monad as the defualt one depends on >>=, and need
-- this to implement >>=
joinC :: (KnownNat n, KnownNat m, n ~ (m + 1)) => Container n v (Container n v b) -> Container n v b
joinC (STC (STIOC a)) = V.head a 
joinC (AC (Array a)) = V.head a 
joinC (SEQC (Sequence a)) = V.head a 

getVectorC :: Container n v a -> Vector n a
getVectorC (STC (STIOC a)) = a
getVectorC (AC (Array a)) = a
getVectorC (SEQC (Sequence a)) = a

mergeC :: forall n m o v a. (KnownNat n, KnownNat m, KnownNat o, n ~ (o + 1)) => Vector n (Container m v a) -> Container (n*m) v a
mergeC inVec =
  let
    vecOfVecs = fmap getVectorC inVec
    listOfLists = vectorToList $ fmap vectorToList vecOfVecs 
    flatList = concat listOfLists
    totalLength :: Proxy (n*m)
    totalLength = Proxy
    outVec = listToVector totalLength flatList
  in
    case V.head inVec of
      (STC (STIOC _)) -> STC (STIOC outVec) 
      (AC (Array _)) -> AC (Array outVec)
      (SEQC (Sequence _)) -> SEQC (Sequence outVec)

-- this will never work. Lifting Int twice will create n*n elements ofit.
-- even if you have the monad with the join natural transofmraiton so
-- can get container m from container n (container n), m ~ n*n, so wrong size
-- can't do lifting, need morphisms between functions, not lifting
{-
instance (KnownNat n, KnownNat m, n ~ (m + 1)) => Monad (Container n v) where
  --c >>= f = mergeC $ getVectorC $ fmap f c 
  (STC (STIOC vec)) >>= f = mergeC $ fmap f vec
-}
-- example of monad for rewriting a wrapper
liftToSTIOCContainer x = STC (STIOC (listToVector (Proxy @1) [x]))
liftToArrayContainer x = AC (Array (listToVector (Proxy @1) [x]))
--stiocConvertedToArray = liftToSTIOCContainer 2 >>= liftToArrayContainer
--y :: Container 2 0 Integer
y = STC (STIOC (listToVector (Proxy @2) [1,2]))
--x = y >>= (\z -> AC (Array z))
x = joinC $ fmap (\x -> AC (Array x)) y
o = STIOC (listToVector (Proxy @3) [1,2,3])
k :: Container 3 0 Integer
k = STC o
j = fmap (\x -> AC (Array (listToVector (Proxy @1) [x]))) k
h = getVectorC j
l = mergeC h

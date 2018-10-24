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

data (KnownNat n) => Container n a =
  forall m. (KnownNat m, NestedContainersSize(STIOC m a) ~ n) => STC (STIOC n a)
  | forall m. (KnownNat m, NestedContainersSize(STIOC m a) ~ n) => AC (Array n a)
  | forall m v. (KnownNat m, NestedContainersSize(STIOC m a) ~ n) => SEQC (Sequence n v a)

instance (KnownNat n) => Functor (Container n) where
  fmap f (STC (STIOC vec)) = STC (STIOC (fmap f vec))
  fmap f (AC (Array vec)) = AC (Array (fmap f vec))
  fmap f (SEQC (Sequence vec)) = SEQC (Sequence (fmap f vec))
--data (Functor a) => Container n a = forall b. Container (a b)
{-
instance (Functor a) => Functor (Container n) where

instance (KnownNat n, Functor a) => Functor (Container n) where
  fmap f (Container mappable) = Container (fmap f mappable)

instance (KnownNat n) => Applicative (Sequence n v) where
  pure a = (Sequence ((pure :: a -> Vector n a) a))
  (Sequence f) <*> (Sequence a) = Sequence (f <*> a)
instance (Functor a) => Functor (Container n) where
-}
--instance (Applicative a, KnownNat n, NestedContainersSize(a) ~ n) => Monad (Container n) 

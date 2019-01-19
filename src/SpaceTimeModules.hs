module SpaceTimeModules where
import DataTypes
import GHC.TypeLits
import Data.Proxy
import Control.Applicative
import Control.Arrow
import Isomorphism
import Data.Types.Injective
import Data.Types.Isomorphic
import Data.Vector.Sized as V
  
-- lifting to higher space or time dimensions
liftUnaryModule :: (Applicative f) => (a -> b) -> (f a -> f b)
liftUnaryModule = liftA 

liftBinaryModule :: (Applicative f) => ((a, b) -> c) -> ((f a, f b) -> f c)
liftBinaryModule = uncurry . liftA2 . curry

liftUnaryModuleToSpace :: (KnownNat n) => Proxy n -> (a -> b) ->
  (SSeq n a -> SSeq n b)
liftUnaryModuleToSpace _ = liftUnaryModule

liftUnaryModuleToTime :: (KnownNat n, KnownNat v) => Proxy n -> Proxy v -> (a -> b) ->
  (TSeq n v a -> TSeq n v b)
liftUnaryModuleToTime _ _ = liftUnaryModule

liftBinaryModuleToSpace :: (KnownNat n) => Proxy n -> ((a, b) -> c) ->
  ((SSeq n a, SSeq n b) -> SSeq n c)
liftBinaryModuleToSpace _ = liftBinaryModule

liftBinaryModuleToTime :: (KnownNat n, KnownNat v) => Proxy n -> Proxy v -> ((a, b) -> c) ->
  ((TSeq n v a, TSeq n v b) -> TSeq n v c)
liftBinaryModuleToTime _ _ = liftBinaryModule

-- changing a dimension to space or time
mapSeqToSpace :: (KnownNat n, KnownNat m) => (Seq n a -> Seq m b) -> SSeq n a -> SSeq m b
mapSeqToSpace f = to . f . to

type family IfGreaterEq (x :: Nat) (y :: Nat) (tResult :: Nat) (fResult :: Nat) :: Nat where
  IfGreaterEq 0 0 tRes _ = tRes
  IfGreaterEq 0 _ tRes _ = tRes
  IfGreaterEq _ 0 _ fRes = fRes
  IfGreaterEq x y tRes fRes = IfGreaterEq (x-1) (y-1) tRes fRes

mapSeqToTime :: (KnownNat n, KnownNat m) => (Seq n a -> Seq m b) ->
  TSeq n (IfGreaterEq m n 0 (m-n)) a -> TSeq m (IfGreaterEq n m 0 (n-m)) b
mapSeqToTime f = to . f . to

-- HIGHER ORDER MODULES
forkJoin :: (a -> c) -> (b -> d) -> (a, b) -> (c, d)
forkJoin f g = \(a, b) -> (f a, g b)

pipeline :: (a -> b) -> (b -> c) -> a -> c
pipeline = (>>>)

iter :: (KnownNat n, KnownNat m, KnownNat o) => Proxy o ->
  (Seq n a -> Seq m a) ->
  Seq o (Seq n a) -> Seq o (Seq m a)
iter _ f = liftUnaryModule f

{-
-- examples of programs in space and time
addFullyParallel = liftBinaryModuleToTime (Proxy @1) (Proxy @0) (liftBinaryModuleToSpace (Proxy @4) addInt)
unscheduled4 :: Seq 4 Int
unscheduled4 = Seq $ fromTuple (1, 2, 3, 4) 
unscheduled4Nested :: Seq 1 (Seq 4 Int)
unscheduled4Nested = to unscheduled4
partiallyScheduledFullyParallel4Nested :: Seq 1 (SSeq 4 Int)
partiallyScheduledFullyParallel4Nested = to unscheduled4Nested
fullyParallel4Nested :: TSeq 1 0 (SSeq 4 Int)
fullyParallel4Nested = to partiallyScheduledFullyParallel4Nested
resultFullyParallel = addFullyParallel (fullyParallel4Nested, fullyParallel4Nested)

addPartiallyParallel = liftBinaryModuleToTime (Proxy @2) (Proxy @0) (liftBinaryModuleToSpace (Proxy @2) addInt)
unscheduled4Split :: Seq 2 (Seq 2 Int)
unscheduled4Split = to unscheduled4
partiallyScheduled4Split :: Seq 2 (SSeq 2 Int)
partiallyScheduled4Split = to unscheduled4Split
partiallyParallel4 :: TSeq 2 0 (SSeq 2 Int)
partiallyParallel4 = to partiallyScheduled4Split 
resultPartiallyParallel = addPartiallyParallel (partiallyParallel4, partiallyParallel4)
-}

module SpaceTimeModules where
import DataTypes
import AtomModules
import GHC.TypeLits
import Data.Proxy
import Control.Applicative
import Control.Arrow
import Isomorphism
import Data.Types.Injective
import Data.Types.Isomorphic
--spaceUnzip :: Space n (a, b)
--liftToSpace :: ()
  
-- lifting to higher space or time dimensions
liftUnaryModule :: (Applicative f) => (a -> b) -> (f a -> f b)
liftUnaryModule = liftA 

liftBinaryModule :: (Applicative f) => ((a, b) -> c) -> ((f a, f b) -> f c)
liftBinaryModule = uncurry . liftA2 . curry

liftUnaryModuleToSpace :: (KnownNat n) => Proxy n -> (a -> b) ->
  (Array n a -> Array n b)
liftUnaryModuleToSpace _ = liftUnaryModule

liftUnaryModuleToTime :: (KnownNat n, KnownNat v) => Proxy n -> Proxy v -> (a -> b) ->
  (Sequence n v a -> Sequence n v b)
liftUnaryModuleToTime _ _ = liftUnaryModule

liftBinaryModuleToSpace :: (KnownNat n) => Proxy n -> ((a, b) -> c) ->
  ((Array n a, Array n b) -> Array n c)
liftBinaryModuleToSpace _ = liftBinaryModule

liftBinaryModuleToTime :: (KnownNat n, KnownNat v) => Proxy n -> Proxy v -> ((a, b) -> c) ->
  ((Sequence n v a, Sequence n v b) -> Sequence n v c)
liftBinaryModuleToTime _ _ = liftBinaryModule

-- changing a dimension to space or time
mapSTIOCToSpace :: (KnownNat n, KnownNat m) => (STIOC n a -> STIOC m b) -> Array n a -> Array m b
mapSTIOCToSpace f = to . f . to

type family IfGreaterEq (x :: Nat) (y :: Nat) (tResult :: Nat) (fResult :: Nat) :: Nat where
  IfGreaterEq 0 0 tRes _ = tRes
  IfGreaterEq 0 _ tRes _ = tRes
  IfGreaterEq _ 0 _ fRes = fRes
  IfGreaterEq x y tRes fRes = IfGreaterEq (x-1) (y-1) tRes fRes

mapSTIOCToTime :: (KnownNat n, KnownNat m) => (STIOC n a -> STIOC m b) ->
  Sequence n (IfGreaterEq m n 0 (m-n)) a -> Sequence m (IfGreaterEq n m 0 (n-m)) b
mapSTIOCToTime f = to . f . to

-- HIGHER ORDER MODULES
forkJoin :: (a -> c) -> (b -> d) -> Module (a, b) (c, d)
forkJoin f g = \(a, b) -> (f a, g b)

pipeline :: (a -> b) -> (b -> c) -> a -> c
pipeline = (>>>)
{-
iter :: (KnownNat n, KnownNat m, KnownNat o) => Proxy o ->
  (Sequence n v a -> Sequence m  a) ->
  (Sequence  v a) -> Sequence (n*m)
-}

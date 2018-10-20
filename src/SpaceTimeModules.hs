module SpaceTimeModules where
import DataTypes
import AtomModules
import GHC.TypeLits
import Data.Proxy
import Control.Applicative
import Control.Arrow

--spaceUnzip :: Space n (a, b)
--liftToSpace :: ()
  
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
{-
liftUnarySTIOCToST :: (KnownNat n, KnownNat m, KnownNat s, KnownNat v) =>
  Proxy n -> Proxy s -> Proxy v ->
  ((STIOC n a) -> (STIOC m b)) ->
  (Sequence (div n s) v (Array s a)) -> (Sequence (div n s) v (Array s b))
liftUnarySTIOCToST _ _ _ = liftUnaryModule . liftUnaryModule
-} 
-- HIGHER ORDER MODULES
forkJoin :: (a -> c) -> (b -> d) -> Module (a, b) (c, d)
forkJoin f g = \(a, b) -> (f a, g b)

pipeline :: (a -> b) -> (b -> c) -> a -> c
pipeline = (>>>)

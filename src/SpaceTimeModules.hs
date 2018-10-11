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

liftBinaryModuleToSpace :: (KnownNat n) => Proxy n -> ((a, b) -> c) ->
  ((Array n a, Array n b) -> Array n c)
liftBinaryModuleToSpace _ = liftBinaryModule

liftBinaryModuleToTime :: (KnownNat n) => Proxy n -> ((a, b) -> c) ->
  ((Sequence n a, Sequence n b) -> Sequence n c)
liftBinaryModuleToTime _ = liftBinaryModule

-- HIGHER ORDER MODULES
forkJoin :: (a -> c) -> (b -> d) -> Module (a, b) (c, d)
forkJoin f g = \(a, b) -> (f a, g b)

pipeline :: (a -> b) -> (b -> c) -> a -> c
pipeline = (>>>)

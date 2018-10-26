module Scheduling where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Proxy
import Data.Types.Injective
import Data.Types.Isomorphic
import DataTypes
import Isomorphism

liftSTIOCToSpace :: (KnownNat n, KnownNat m) => (STIOC n a -> STIOC m b) -> Array n a -> Array m b
liftSTIOCToSpace f = to . f . to

liftSTIOCToTime :: (KnownNat n, KnownNat m, KnownNat v) => Proxy v -> (STIOC n a -> STIOC m b) -> Sequence n v a -> Sequence m v b
liftSTIOCToTime _ f = to . f . to

module Scheduling where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Proxy
import Data.Types.Injective
import Data.Types.Isomorphic
import DataTypes
import Isomorphism

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

--upTime = mapSTIOCToTime (up (Proxy @2))

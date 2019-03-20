module Aetherling.Interpretations.Simulator where
import Aetherling.Declarations.Sequence

simulate :: Simulator a -> a


data Simulator a = Simulator a
  deriving (Show, Eq, Functor)

instance Applicative Simulator where
  pure a = Simulator a
  Simulator f <*> Simulator a = Simulator $ f a

instance Monad Simulator where
  (Simulator a) >>= f = f a
  return a = Simulator a

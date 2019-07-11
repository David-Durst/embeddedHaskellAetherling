module Aetherling.Languages.Sequence.Shallow.Types where
import Aetherling.Languages.Sequence.Deep.Expr
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Map.Lazy as M
import Data.Proxy
import GHC.Exts (Constraint)

{-
Each atomic type has version for simulation.
Also have version for wiring up connected nodes in a graph
when doing shallow to deep embedding.
-}

data Atom_Unit =
  Atom_Unit
  | Atom_Unit_Edge Expr
  deriving (Show, Eq)

data Atom_Bit =
  Atom_Bit Bool
  | Atom_Bit_Edge Expr
  deriving (Show, Eq)

data Atom_Int =
  Atom_Int Int
  | Atom_Int_Edge Expr
  deriving (Show, Eq)

data Atom_Tuple a b =
  Atom_Tuple a b
  | Atom_Tuple_Edge Expr
  deriving (Show, Eq)

data Seq_Tuple n a =
  Seq_Tuple {sTuple :: Vector n a}
  | Seq_Tuple_Edge Expr
  deriving (Show, Eq)

data Seq n i a =
  Seq {sVec :: Vector n a}
  | Seq_Edge Expr
  deriving (Functor, Foldable, Traversable, Show, Eq)

seq_length :: Seq n i a -> Proxy n
seq_length _ = Proxy :: Proxy n

seq_invalid :: Seq n i a -> Proxy i
seq_invalid _ = Proxy :: Proxy i

instance (KnownNat n, KnownNat i) => Applicative (Seq n i) where
  pure a = (Seq ((pure :: a -> Vector n a) a))
  (Seq f) <*> (Seq a) = Seq (f <*> a)
  _ <*> _ = undefined

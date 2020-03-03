module Aetherling.Languages.Space_Time.Shallow.Types where
import Aetherling.Languages.Space_Time.Deep.Expr
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Map.Lazy as M
import Data.Proxy
import GHC.Exts (Constraint)
import Data.Int
import Data.Word

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

data Atom_Int n s =
  Atom_Int8 Int8
  | Atom_Int8_Edge Expr
  | Atom_UInt8 Word8
  | Atom_UInt8_Edge Expr
  | Atom_Int16 Int16
  | Atom_Int16_Edge Expr
  | Atom_UInt16 Word16
  | Atom_UInt16_Edge Expr
  | Atom_Int32 Int32
  | Atom_Int32_Edge Expr
  | Atom_UInt32 Word32
  | Atom_UInt32_Edge Expr
  deriving (Show, Eq)

data Atom_Tuple a b =
  Atom_Tuple a b
  | Atom_Tuple_Edge Expr
  deriving (Show, Eq)

data Seq_Tuple n a =
  Seq_Tuple {sTuple :: Vector n a}
  | Seq_Tuple_Edge Expr
  deriving (Show, Eq)

data SSeq n a =
  SSeq {ssVec :: Vector n a}
  | SSeq_Edge Expr
  deriving (Functor, Foldable, Traversable, Show, Eq)

instance (KnownNat n) => Applicative (SSeq n) where
  pure a = (SSeq ((pure :: a -> Vector n a) a))
  (SSeq f) <*> (SSeq a) = SSeq (f <*> a)
  _ <*> _ = undefined

data TSeq n i a =
  TSeq {tsVec :: Vector n a}
  | TSeq_Edge Expr
  deriving (Functor, Foldable, Traversable, Show, Eq)

instance (KnownNat n) => Applicative (TSeq n i) where
  pure a = (TSeq ((pure :: a -> Vector n a) a))
  (TSeq f) <*> (TSeq a) = TSeq (f <*> a)
  _ <*> _ = undefined

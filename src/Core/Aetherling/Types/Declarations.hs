module Aetherling.Types.Declarations where
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

  {-
data Atom_NTuple n a =
  Atom_NTuple (V.Vector n a)
  | Atom_NTuple_Graph Wires
  | Atom_NTuple_Resources
  Int :: Int -> Atom Int
  Bit :: Bool -> Atom Bool
  Tuple :: Atom a -> Atom b -> Atom (Atom a, Atom b)
  -- example of how I'm going to restrict to sseqs of atoms or sseqs
  NTuple :: V.Vector n a -> Atom (V.Vector n (Atom a))
-}

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

data SSeq n a =
  SSeq {ssVec :: Vector n a}
  | SSeq_Edge Expr
  deriving (Functor, Foldable, Traversable, Show, Eq)

instance (KnownNat n) => Applicative (SSeq n) where
  pure a = (SSeq ((pure :: a -> Vector n a) a))
  (SSeq f) <*> (SSeq a) = SSeq (f <*> a)
  _ <*> _ = undefined

-- n is number of elements, v is number of clocks of delay
-- v is always 0 for now. Please ignore it for the time being
data TSeq n v a =
  TSeq {tsVec :: Vector n a}
  | TSeq_Edge Expr
  deriving (Functor, Foldable, Traversable, Show, Eq)

instance (KnownNat n) => Applicative (TSeq n v) where
  pure a = (TSeq ((pure :: a -> Vector n a) a))
  (TSeq f) <*> (TSeq a) = TSeq (f <*> a)
  _ <*> _ = undefined

data AST_Type =
  UnitT
  | BitT
  | IntT
  | ATupleT AST_Type AST_Type
  | STupleT Int AST_Type
  | SeqT Int Int AST_Type
  | SSeqT Int AST_Type
  | TSeqT Int Int AST_Type
  deriving (Show, Eq)

-- these exist only because it's easier to have a value that is an Aetherling value
-- rather than a value that's a member of a type class of aetherling values,
-- like the above data types
data AST_Value =
  UnitV
  | BitV Bool
  | IntV Int
  | ATupleV AST_Value AST_Value
  | STupleV [AST_Value]
  | SeqV {vals :: [AST_Value], i_v :: Int}
  | SSeqV [AST_Value]
  | TSeqV {vals :: [AST_Value], i_v :: Int}
  deriving (Show, Eq)

data Expr =
  IdN {seq_in :: Expr}
  | AbsN {seq_in :: Expr}
  | NotN {seq_in :: Expr}
  | AddN {seq_in :: Expr}
  | EqN {t :: AST_Type, seq_in :: Expr}

  -- generators
  | Lut_GenN {
      lookup_table :: [AST_Value],
      lookup_types :: AST_Type,
      seq_in :: Expr
      }
  | Const_GenN {
      constant :: AST_Value,
      constant_type :: AST_Type
      }

  -- sequence operators
  | ShiftN {
      n :: Int,
      i :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Up_1dN {
      n :: Int,
      i :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Down_1dN {
      n :: Int,
      i :: Int,
      sel_idx :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | PartitionN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      t :: AST_Type,
      seq_in :: Expr
      }
  | UnpartitionN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      t :: AST_Type,
      seq_in :: Expr
      }

  -- higher order operators
  | MapN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in :: Expr
      }
  | Map2N {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in_left :: Expr,
      seq_in_right :: Expr
      }
  | ReduceN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in :: Expr
      }
  | FstN {
      t0 :: AST_Type,
      t1 :: AST_Type,
      seq_in :: Expr
      }
  | SndN {
      t0 :: AST_Type,
      t1 :: AST_Type,
      seq_in :: Expr
      }
  | ATupleN {
      t0 :: AST_Type,
      t1 :: AST_Type,
      seq_in_left :: Expr,
      seq_in_right :: Expr
      }
  | STupleN {
      tuple_elem_t :: AST_Type,
      seq_in_left :: Expr,
      seq_in_right :: Expr
      }
  | STupleAppendN {
      out_len :: Int,
      tuple_elem_t :: AST_Type,
      seq_in_left :: Expr,
      seq_in_right :: Expr
      }
  | STupleToSeqN {
      tuple_len :: Int,
      tuple_elem_t :: AST_Type,
        seq_in :: Expr
      }
  | SeqToSTupleN {
      tuple_len :: Int,
      tuple_elem_t :: AST_Type,
        seq_in :: Expr
      }
  | InputN {t :: AST_Type}
  | ErrorN
  deriving (Show, Eq)

sSSeq0_2 :: SSeq 2 Int
sSSeq0_2 = SSeq $ fromTuple (2, 2)
sSSeq0_3 :: SSeq 3 Int
sSSeq0_3 = SSeq $ fromTuple (2, 2, 3)
sSSeq0_22 :: SSeq 2 (SSeq 2 Int)
sSSeq0_22 = SSeq $ fromTuple (sSSeq0_2, sSSeq0_2)

sSSeq1_2 :: SSeq 2 Int
sSSeq1_2 = SSeq $ fromTuple (4, 6)
sSSeq1_3 :: SSeq 3 Int
sSSeq1_3 = SSeq $ fromTuple (1, 2, 3)

tSeq0_2 :: TSeq 2 0 (SSeq 2 Int)
tSeq0_2 = TSeq $ fromTuple (sSSeq0_2, sSSeq1_2)
tSeq0_3 :: TSeq 2 0 (SSeq 3 Int)
tSeq0_3 = TSeq $ fromTuple (sSSeq0_3, sSSeq1_3)
tSeq1_3 :: TSeq 3 0 (SSeq 2 Int)
tSeq1_3 = TSeq $ fromTuple (sSSeq1_2, sSSeq1_2, sSSeq1_2)

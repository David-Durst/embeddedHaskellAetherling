module Aetherling.Types.Declarations where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Proxy
import GHC.Exts (Constraint)
import qualified Data.List as L

{-
Each atomic type has version for simulation.
Also have version for wiring up connected nodes in a graph
when doing shallow to deep embedding.
-}
type DAG_Index = Int
data DAG_Edge = DAG_Edge {source :: DAG_Index, sink :: DAG_Index}
  deriving (Show, Eq)

data DAG a = DAG {
  nodes :: [a],
  edges :: [DAG_Edge]
  } deriving (Show, Eq)

data Atom_Unit =
  Atom_Unit
  | Atom_Unit_Edge DAG_Index
  deriving (Show, Eq)

data Atom_Bit =
  Atom_Bit Bool
  | Atom_Bit_Edge DAG_Index
  deriving (Show, Eq)

data Atom_Int =
  Atom_Int Int
  | Atom_Int_Edge DAG_Index
  deriving (Show, Eq)

data Atom_Tuple a b =
  Atom_Tuple a b
  | Atom_Tuple_Edge DAG_Index
  deriving (Show, Eq)

data Seq_Tuple n a =
  Seq_Tuple {sTuple :: Vector n a}
  | Seq_Tuple_Edge DAG_Index
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
  | Seq_Edge DAG_Index
  deriving (Functor, Foldable, Traversable, Show, Eq)

instance (KnownNat n, KnownNat i) => Applicative (Seq n i) where
  pure a = (Seq ((pure :: a -> Vector n a) a))
  (Seq f) <*> (Seq a) = Seq (f <*> a)
  _ <*> _ = undefined

data SSeq n a =
  SSeq {ssVec :: Vector n a}
  | SSeq_Edge DAG_Index
  deriving (Functor, Foldable, Traversable, Show, Eq)

instance (KnownNat n) => Applicative (SSeq n) where
  pure a = (SSeq ((pure :: a -> Vector n a) a))
  (SSeq f) <*> (SSeq a) = SSeq (f <*> a)
  _ <*> _ = undefined

-- n is number of elements, v is number of clocks of delay
-- v is always 0 for now. Please ignore it for the time being
data TSeq n v a =
  TSeq {tsVec :: Vector n a}
  | TSeq_Edge DAG_Index
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

data AST_Value =
  UnitV
  | BitV Bool
  | IntV Int
  | TupleV AST_Value AST_Value
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

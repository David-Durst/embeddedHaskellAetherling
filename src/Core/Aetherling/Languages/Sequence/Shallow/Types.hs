module Aetherling.Languages.Sequence.Shallow.Types where
import Aetherling.Monad_Helpers
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Sequence.Deep.Expr
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

type Signed = 0
type Unsigned = 1

data Atom_Int8 =
  Atom_Int8 Int8
  | Atom_Int8_Edge Expr
  deriving (Show, Eq)

data Atom_UInt8 =
  Atom_UInt8 Word8
  | Atom_UInt8_Edge Expr
  deriving (Show, Eq)

data Atom_FixP1_7 =
  Atom_FixP1_7 Double
  | Atom_FixP1_7_Edge Expr
  deriving (Show, Eq)

data Atom_Int16 =
  Atom_Int16 Int16
  | Atom_Int16_Edge Expr
  deriving (Show, Eq)

data Atom_UInt16 =
  Atom_UInt16 Word16
  | Atom_UInt16_Edge Expr
  deriving (Show, Eq)

data Atom_Int32 =
  Atom_Int32 Int32
  | Atom_Int32_Edge Expr
  deriving (Show, Eq)

data Atom_UInt32 =
  Atom_UInt32 Word32
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

data Seq n a =
  Seq {sVec :: Vector n a}
  | Seq_Edge Expr
  deriving (Functor, Foldable, Traversable, Show, Eq)

seq_length :: Seq n a -> Proxy n
seq_length _ = Proxy :: Proxy n

instance (KnownNat n) => Applicative (Seq n) where
  pure a = (Seq ((pure :: a -> Vector n a) a))
  (Seq f) <*> (Seq a) = Seq (f <*> a)
  _ <*> _ = undefined

{-
Type families for computing whether types satisfy constraints
-}

type family Check_Signed_Or_Unsigned (x :: Nat) :: Constraint where
  Check_Signed_Or_Unsigned Signed = True ~ True
  Check_Signed_Or_Unsigned Unsigned = True ~ True
  Check_Signed_Or_Unsigned x =
    TypeError (ShowType x :<>: Text " is not Signed or Unsigned.")

type family Check_Type_Is_Atom (x :: *) :: Constraint where
  Check_Type_Is_Atom Atom_Unit = True ~ True
  Check_Type_Is_Atom Atom_Int8 = True ~ True
  Check_Type_Is_Atom Atom_UInt8 = True ~ True
  Check_Type_Is_Atom Atom_FixP1_7 = True ~ True
  Check_Type_Is_Atom Atom_Int16 = True ~ True
  Check_Type_Is_Atom Atom_UInt16 = True ~ True
  Check_Type_Is_Atom Atom_Int32 = True ~ True
  Check_Type_Is_Atom Atom_UInt32 = True ~ True
  Check_Type_Is_Atom (Atom_Bit) = True ~ True
  Check_Type_Is_Atom (Atom_Tuple a b) = True ~ True
  Check_Type_Is_Atom x =
    TypeError (ShowType x :<>: Text " is not an atom.")

type family Check_Type_Is_Atom_Or_Nested (x :: *) :: Constraint where
  Check_Type_Is_Atom_Or_Nested Atom_Unit = True ~ True
  Check_Type_Is_Atom_Or_Nested Atom_Int8 = True ~ True
  Check_Type_Is_Atom_Or_Nested Atom_UInt8 = True ~ True
  Check_Type_Is_Atom_Or_Nested Atom_Int16 = True ~ True
  Check_Type_Is_Atom_Or_Nested Atom_UInt16 = True ~ True
  Check_Type_Is_Atom_Or_Nested Atom_Int32 = True ~ True
  Check_Type_Is_Atom_Or_Nested Atom_UInt32 = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Bit) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Tuple a b) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Seq _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested x =
    TypeError (ShowType x :<>: Text " is not an atom, a Seq containing atoms,"
              :<>: Text " an SSeq containing atoms, or a TSeq containing atoms.")

-- | A typeclass that shows how to convert all valid Aetherling values between
-- shallow and deep representations. This requires
-- converting between expr, edges, index of the nodes, and types
class Aetherling_Value a where
  edge_to_maybe_expr :: a -> Maybe Expr
  expr_to_edge :: Expr -> a
  get_AST_type :: Proxy a -> AST_Type
  get_AST_value :: a -> Maybe AST_Value
  get_input_edge :: String -> DAG_Index -> a

class Aetherling_Int a where
  is_signed :: a -> Bool
  get_width :: a -> Int

class Signed_Int a

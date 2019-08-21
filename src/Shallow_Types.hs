module Aetherling.Languages.Sequence.Shallow_Types where
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
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

-- A typeclass that indicates all the valid Aetherling values
-- For each Aetherling value, when converting from shallow to deep representation,
-- must be able to convert between edges' types and the index of the node they
-- are produced by
class Aetherling_Value a where
  edge_to_maybe_expr :: a -> Maybe Expr
  expr_to_edge :: Expr -> a
  get_AST_type :: Proxy a -> AST_Type
  get_AST_value :: a -> Maybe AST_Value
  get_input_edge :: String -> a

instance Aetherling_Value Atom_Unit where
  edge_to_maybe_expr (Atom_Unit_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Atom_Unit_Edge x
  get_AST_type _ = UnitT
  get_AST_value Atom_Unit = Just $ UnitV
  get_AST_value _ = Nothing
  get_input_edge s = Atom_Unit_Edge (InputN UnitT s)

instance Aetherling_Value Atom_Bit where
  edge_to_maybe_expr (Atom_Bit_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Atom_Bit_Edge x
  get_AST_type _ = BitT
  get_AST_value (Atom_Bit b) = Just $ BitV b
  get_AST_value _ = Nothing
  get_input_edge s = Atom_Bit_Edge (InputN BitT s)

instance Aetherling_Value Atom_Int where
  edge_to_maybe_expr (Atom_Int_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Atom_Int_Edge x
  get_AST_type _ = IntT
  get_AST_value (Atom_Int i) = Just $ IntV i
  get_AST_value _ = Nothing
  get_input_edge s = Atom_Int_Edge (InputN IntT s)

instance (Aetherling_Value a, Aetherling_Value b) =>
  Aetherling_Value (Atom_Tuple a b) where
  edge_to_maybe_expr (Atom_Tuple_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Atom_Tuple_Edge x
  get_AST_type _ =
    ATupleT (get_AST_type (Proxy :: Proxy a)) (get_AST_type (Proxy :: Proxy b))
  get_AST_value (Atom_Tuple x y) = do
    x_val <- get_AST_value x
    y_val <- get_AST_value y
    Just $ ATupleV x_val y_val
  get_AST_value _ = Nothing
  get_input_edge s = Atom_Tuple_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (Atom_Tuple a b))) s)

instance (KnownNat n, Aetherling_Value a) =>
  Aetherling_Value (Seq_Tuple n a)  where
  edge_to_maybe_expr (Seq_Tuple_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Seq_Tuple_Edge x
  get_AST_type _ = STupleT nVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
  get_AST_value (Seq_Tuple vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    Just $ STupleV elements_as_AST_values
  get_AST_value _ = Nothing
  get_input_edge s = Seq_Tuple_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (Seq_Tuple n a))) s)

instance (KnownNat n, KnownNat i, Aetherling_Value a) =>
  Aetherling_Value (Seq n i a) where
  edge_to_maybe_expr (Seq_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Seq_Edge x
  get_AST_type _ = SeqT nVal iVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
      iVal = fromInteger $ natVal (Proxy :: Proxy i)
  get_AST_value (Seq vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    let iVal = fromInteger $ natVal (Proxy :: Proxy i)
    Just $ SeqV elements_as_AST_values iVal
  get_AST_value _ = Nothing
  get_input_edge s = Seq_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (Seq n i a))) s)

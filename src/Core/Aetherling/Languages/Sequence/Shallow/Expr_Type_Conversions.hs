module Aetherling.Languages.Sequence.Shallow.Expr_Type_Conversions where
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions
import Aetherling.Monad_Helpers
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Proxy
import GHC.Exts (Constraint)

instance Aetherling_Value Atom_Unit where
  edge_to_maybe_expr (Atom_Unit_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Atom_Unit_Edge x
  get_AST_type _ = UnitT
  get_AST_value Atom_Unit = Just $ UnitV
  get_AST_value _ = Nothing
  get_input_edge s idx = Atom_Unit_Edge (InputN UnitT s idx)

instance Aetherling_Value Atom_Bit where
  edge_to_maybe_expr (Atom_Bit_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Atom_Bit_Edge x
  get_AST_type _ = BitT
  get_AST_value (Atom_Bit b) = Just $ BitV b
  get_AST_value _ = Nothing
  get_input_edge s idx = Atom_Bit_Edge (InputN BitT s idx)

instance (KnownNat n, Check_Int_Valid_Length n,
          KnownNat s, Check_Signed_Or_Unsigned s) =>
  Aetherling_Value (Atom_Int n s) where
  edge_to_maybe_expr (Atom_Int8_Edge x) = Just x
  edge_to_maybe_expr (Atom_Int32_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x | (e_out_type $ expr_to_types x) == Int8T = Atom_Int8_Edge x
  expr_to_edge x = Atom_Int32_Edge x
  get_AST_type _ =
    case (bit_width, signed_flag) of
      (8, 0) -> Int8T
      (8, 1) -> UInt8T
      (16, 0) -> Int16T
      (16, 1) -> UInt16T
      (32, 0) -> Int32T
      (32, 1) -> UInt32T
      _ -> error "can't convert int of wrong length or signing to AST type"
    where
      bit_width = fromInteger $ natVal (Proxy :: Proxy n)
      signed_flag = fromInteger $ natVal (Proxy :: Proxy s)
  get_AST_value (Atom_Int8 i) = Just $ Int8V i
  get_AST_value (Atom_Int32 i) = Just $ Int32V i
  get_AST_value _ = Nothing
  get_input_edge s idx = 
    case (bit_width, signed_flag) of
      (8, 0) -> Atom_Int8_Edge (InputN Int8T s idx)
      (8, 1) -> Atom_UInt8_Edge (InputN UInt8T s idx)
      (16, 0) -> Atom_Int16_Edge (InputN Int16T s idx)
      (16, 1) -> Atom_UInt16_Edge (InputN UInt16T s idx)
      (32, 0) -> Atom_Int32_Edge (InputN Int32T s idx)
      (32, 1) -> Atom_UInt32_Edge (InputN UInt32T s idx)
      _ -> error "can't convert int of wrong length or signing to input edge"
    where
      bit_width = fromInteger $ natVal (Proxy :: Proxy n)
      signed_flag = fromInteger $ natVal (Proxy :: Proxy s)

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
  get_input_edge s idx = Atom_Tuple_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (Atom_Tuple a b))) s idx)

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
  get_input_edge s idx = Seq_Tuple_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (Seq_Tuple n a))) s idx)

instance (KnownNat n, Aetherling_Value a) =>
  Aetherling_Value (Seq n a) where
  edge_to_maybe_expr (Seq_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = Seq_Edge x
  get_AST_type _ = SeqT nVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
  get_AST_value (Seq vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    Just $ SeqV elements_as_AST_values
  get_AST_value _ = Nothing
  get_input_edge s idx = Seq_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (Seq n a))) s idx)

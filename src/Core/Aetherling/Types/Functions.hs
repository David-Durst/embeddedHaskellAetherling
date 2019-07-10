module Aetherling.Types.Functions where
import Aetherling.Types.Declarations
import Aetherling.Types.Isomorphisms
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Proxy
import GHC.Exts (Constraint)
import Data.Typeable
import Data.List.Split
import qualified Data.List as L

{-
Below are type families for computing types depending on other types
These are mainly used in function declarations
-}
size_int :: Int
size_int = 8
size_bit :: Int
size_bit = 1

size_t :: AST_Type -> Int
size_t UnitT = 0
size_t BitT = size_bit
size_t IntT = size_int
size_t (ATupleT t0 t1) = size_t t0 + size_t t1
size_t (STupleT n t) = n * size_t t
size_t (SeqT _ _ _) = 0
size_t (SSeqT n t) = n * size_t t
size_t (TSeqT n _ t) = size_t t

type family Check_Type_Is_Atom (x :: *) :: Constraint where
  Check_Type_Is_Atom Atom_Unit = True ~ True
  Check_Type_Is_Atom (Atom_Int) = True ~ True
  Check_Type_Is_Atom (Atom_Bit) = True ~ True
  Check_Type_Is_Atom (Atom_Tuple a b) = True ~ True
  Check_Type_Is_Atom x =
    TypeError (ShowType x :<>: Text " is not an atom.")

type family Check_Type_Is_Atom_Or_Nested (x :: *) :: Constraint where
  Check_Type_Is_Atom_Or_Nested Atom_Unit = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Int) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Bit) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Tuple a b) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Seq _ _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested (SSeq _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested (TSeq _ _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested x =
    TypeError (ShowType x :<>: Text " is not an atom, a Seq containing atoms,"
              :<>: Text " an SSeq containing atoms, or a TSeq containing atoms.")

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

instance (KnownNat n, Aetherling_Value a) =>
  Aetherling_Value (SSeq n a) where
  edge_to_maybe_expr (SSeq_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = SSeq_Edge x
  get_AST_type _ = SSeqT nVal (get_AST_type (Proxy :: Proxy a))
    where nVal = fromInteger $ natVal (Proxy :: Proxy n)
  get_AST_value (SSeq vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    Just $ SSeqV elements_as_AST_values
  get_AST_value _ = Nothing
  get_input_edge s = SSeq_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (SSeq n a))) s)

instance (KnownNat n, KnownNat i, Aetherling_Value a) =>
  Aetherling_Value (TSeq n i a) where
  edge_to_maybe_expr (TSeq_Edge x) = Just x
  edge_to_maybe_expr _ = Nothing
  expr_to_edge x = TSeq_Edge x
  get_AST_type _ = TSeqT nVal vVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
      vVal = fromInteger $ natVal (Proxy :: Proxy i)
  get_AST_value (TSeq vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    let iVal = fromInteger $ natVal (Proxy :: Proxy i)
    Just $ TSeqV elements_as_AST_values iVal
  get_AST_value _ = Nothing
  get_input_edge s = TSeq_Edge
                     (InputN (get_AST_type (Proxy :: Proxy (TSeq n i a))) s)

{-
Below functions are for converting a type representation to a string
for compilation to Magma
-}

-- first one is string to replace
-- second one is string to replace it with
-- third string is string to operate on
replaceAString :: String -> String -> String -> String
replaceAString toReplace subtitute input = replaced 
  where
    (hdSplit:tlSplit) = splitOn toReplace input
    replaced = L.foldl (\x -> \y -> x L.++ subtitute L.++ y)
      hdSplit tlSplit

-- | input and outputs for an expression when not considering the
-- input expressions to it
data Expr_Types = Expr_Types { e_in_types :: [AST_Type], e_out_type :: AST_Type}
  deriving (Show, Eq, Ord)

-- | Convert an Expr to it's input and output tpyes not considering the input
-- expressions to it
expr_to_types :: Expr -> Expr_Types
expr_to_types (IdN in_e) = Expr_Types [input_type] input_type
  where input_type = e_out_type $ expr_to_types in_e
expr_to_types (AbsN _) = Expr_Types [IntT] IntT
expr_to_types (NotN _) = Expr_Types [BitT] BitT
expr_to_types (AddN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (SubN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (MulN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (DivN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (EqN t _) = Expr_Types [ATupleT t t] BitT

-- generators
expr_to_types (Lut_GenN _ t _) = Expr_Types [IntT] t
expr_to_types (Const_GenN _ t) = Expr_Types [] t

-- sequence operators
expr_to_types (ShiftN n i _ elem_t _) = Expr_Types [seq_type] seq_type
  where seq_type = SeqT n i elem_t
expr_to_types (Up_1dN n i elem_t _) = Expr_Types in_types out_type
  where
    in_types = [SeqT 1 (n - 1 + i) elem_t]
    out_type = SeqT n i elem_t
expr_to_types (Down_1dN n i _ elem_t _) = Expr_Types in_types out_type
  where
    in_types = [SeqT n i elem_t]
    out_type = SeqT 1 (n - 1 + i) elem_t
expr_to_types (PartitionN no ni io ii elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [SeqT (no * ni) ((no * ii) + (io * (ni + ii))) elem_t]
    out_type = SeqT no io (SeqT ni ii elem_t)
expr_to_types (UnpartitionN no ni io ii elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [SeqT no io (SeqT ni ii elem_t)]
    out_type = SeqT (no * ni) ((no * ii) + (io * (ni + ii))) elem_t

-- higher order operators
expr_to_types (MapN n i f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (SeqT n i) $ e_in_types inner_types
    out_type = SeqT n i $ e_out_type inner_types
expr_to_types (Map2N n i f _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (SeqT n i) $ e_in_types inner_types
    out_type = SeqT n i $ e_out_type inner_types
expr_to_types (ReduceN n i f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (SeqT n i) $ e_in_types inner_types
    out_type = SeqT n i $ e_out_type inner_types

-- tuple operators
expr_to_types (FstN t0 t1 _) = Expr_Types [ATupleT t0 t1] t0
expr_to_types (SndN t0 t1 _) = Expr_Types [ATupleT t0 t1] t1
expr_to_types (ATupleN t0 t1 _ _) = Expr_Types [t0, t1] (ATupleT t0 t1)
expr_to_types (STupleN elem_t _ _) =
  Expr_Types [elem_t, elem_t] (STupleT 2 elem_t)
expr_to_types (STupleAppendN out_len elem_t _ _) =
  Expr_Types [STupleT (out_len - 1) elem_t, elem_t] (STupleT out_len elem_t)
  {-
expr_to_types (STupleToSeqN tuple_len tuple_elem_t _) =
  Expr_Types [STupleT tuple_len tuple_elem_t] (SeqT tuple_len 0 tuple_elem_t)
expr_to_types (SeqToSTupleN tuple_len tuple_elem_t _) =
  Expr_Types [SeqT tuple_len 0 tuple_elem_t] (STupleT tuple_len tuple_elem_t)
-}
expr_to_types (InputN t _) = Expr_Types [] t
expr_to_types (FIFON n i _ elem_t _) =
  Expr_Types [SeqT n i elem_t] (SeqT n i elem_t)
  
-- SSeq equivalents
expr_to_types (Shift_sN n _ elem_t _) = Expr_Types [seq_type] seq_type
  where seq_type = SSeqT n elem_t
expr_to_types (Shift_tN n i _ elem_t _) = Expr_Types [seq_type] seq_type
  where seq_type = SeqT n i elem_t
expr_to_types (Up_1d_sN n elem_t _) = Expr_Types in_types out_type
  where
    in_types = [SSeqT 1 elem_t]
    out_type = SSeqT n elem_t
expr_to_types (Up_1d_tN n i elem_t _) = Expr_Types in_types out_type
  where
    in_types = [TSeqT 1 (n - 1 + i) elem_t]
    out_type = TSeqT n i elem_t
expr_to_types (Down_1d_sN n _ elem_t _) = Expr_Types in_types out_type
  where
    in_types = [SSeqT n elem_t]
    out_type = SSeqT 1 elem_t
expr_to_types (Down_1d_tN n i _ elem_t _) = Expr_Types in_types out_type
  where
    in_types = [TSeqT n i elem_t]
    out_type = TSeqT 1 (n - 1 + i) elem_t
expr_to_types (Partition_s_ssN no ni elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [SSeqT (no * ni) elem_t]
    out_type = SSeqT no (SSeqT ni elem_t)
expr_to_types (Partition_t_ttN no ni io ii elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [TSeqT (no * ni) ((no * ii) + (io * (ni + ii))) elem_t]
    out_type = TSeqT no io (TSeqT ni ii elem_t)
expr_to_types (Unpartition_s_ssN no ni elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [SSeqT no (SSeqT ni elem_t)]
    out_type = SSeqT (no * ni) elem_t
expr_to_types (Unpartition_t_ttN no ni io ii elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [TSeqT no io (TSeqT ni ii elem_t)]
    out_type = TSeqT (no * ni) ((no * ii) + (io * (ni + ii))) elem_t

-- higher order operators
expr_to_types (Map_sN n f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (SSeqT n) $ e_in_types inner_types
    out_type = SSeqT n $ e_out_type inner_types
expr_to_types (Map_tN n i f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (TSeqT n i) $ e_in_types inner_types
    out_type = TSeqT n i $ e_out_type inner_types
expr_to_types (Map2_sN n f _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (SSeqT n) $ e_in_types inner_types
    out_type = SSeqT n $ e_out_type inner_types
expr_to_types (Map2_tN n i f _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (TSeqT n i) $ e_in_types inner_types
    out_type = TSeqT n i $ e_out_type inner_types
expr_to_types (Reduce_sN n f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (SSeqT n) $ e_in_types inner_types
    out_type = SSeqT n $ e_out_type inner_types
expr_to_types (Reduce_tN n i f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_types f
    in_types = fmap (TSeqT n i) $ e_in_types inner_types
    out_type = TSeqT n i $ e_out_type inner_types

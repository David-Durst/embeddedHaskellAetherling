module Aetherling.Languages.Space_Time.Deep.Functions where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr

size_int :: Int
size_int = 8
size_bit :: Int
size_bit = 1

-- | The size in bits of types
size_t :: AST_Type -> Int
size_t UnitT = 0
size_t BitT = size_bit
size_t IntT = size_int
size_t (ATupleT t0 t1) = size_t t0 + size_t t1
size_t (STupleT n t) = n * size_t t
size_t (SSeqT n t) = n * size_t t
size_t (TSeqT n _ t) = size_t t

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
expr_to_types (Shift_sN n _ elem_t _) = Expr_Types [seq_type] seq_type
  where seq_type = SSeqT n elem_t
expr_to_types (Shift_tN n i _ elem_t _) = Expr_Types [seq_type] seq_type
  where seq_type = TSeqT n i elem_t
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

expr_to_types (SerializeN no ni io ii tuple_elem_t _) =
  Expr_Types [TSeqT no ((no * ((ni - 1) + ii)) + (io * (ni + ii))) (SSeqT ni tuple_elem_t)]
  (TSeqT no ni (TSeqT no ni tuple_elem_t))
expr_to_types (DeserializeN no ni io ii tuple_elem_t _) =
  Expr_Types [TSeqT no ni (TSeqT no ni tuple_elem_t)]
  (TSeqT no ((no * ((ni - 1) + ii)) + (io * (ni + ii))) (SSeqT ni tuple_elem_t))
  
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

-- tuple operators
expr_to_types (FstN t0 t1 _) = Expr_Types [ATupleT t0 t1] t0
expr_to_types (SndN t0 t1 _) = Expr_Types [ATupleT t0 t1] t1
expr_to_types (ATupleN t0 t1 _ _) = Expr_Types [t0, t1] (ATupleT t0 t1)
expr_to_types (STupleN elem_t _ _) =
  Expr_Types [elem_t, elem_t] (STupleT 2 elem_t)
  
expr_to_types (STupleAppendN out_len elem_t _ _) =
  Expr_Types [STupleT (out_len - 1) elem_t, elem_t] (STupleT out_len elem_t)
  
expr_to_types (STupleToSSeqN tuple_len tuple_elem_t _) =
  Expr_Types [STupleT tuple_len tuple_elem_t] (SSeqT tuple_len tuple_elem_t)
expr_to_types (SSeqToSTupleN tuple_len tuple_elem_t _) =
  Expr_Types [SSeqT tuple_len tuple_elem_t] (STupleT tuple_len tuple_elem_t)
  
expr_to_types (InputN t _) = Expr_Types [] t
expr_to_types (ErrorN _) = Expr_Types [] UnitT

expr_to_types (FIFON n i _ elem_t _) =
  Expr_Types [TSeqT n i elem_t] (TSeqT n i elem_t)

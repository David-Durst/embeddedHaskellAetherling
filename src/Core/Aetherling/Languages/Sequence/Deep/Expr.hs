module Aetherling.Languages.Sequence.Deep.Expr where
import Aetherling.Languages.Sequence.Deep.Types

data Expr =
  IdN {seq_in :: Expr}
  | AbsN {seq_in :: Expr}
  | NotN {seq_in :: Expr}
  | AddN {seq_in :: Expr}
  | SubN {seq_in :: Expr}
  | MulN {seq_in :: Expr}
  | DivN {seq_in :: Expr}
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
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | UnpartitionN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      elem_t :: AST_Type,
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
  -- no need for an SSeq or TSeq Tuple as this applies to the
  -- elements, a map is used to lift it onto the SSeq or TSeqs
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
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr
      }
  | SeqToSTupleN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr
      }
  | InputN {t :: AST_Type, input_name :: String}
  | ErrorN {error_msg :: String}
  deriving (Show, Eq, Ord)


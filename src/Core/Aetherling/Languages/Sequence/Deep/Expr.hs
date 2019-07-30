module Aetherling.Languages.Sequence.Deep.Expr where
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Monad_Helpers

data Expr =
  IdN {seq_in :: Expr, index :: DAG_Index}
  | AbsN {seq_in :: Expr, index :: DAG_Index}
  | NotN {seq_in :: Expr, index :: DAG_Index}
  | AddN {seq_in :: Expr, index :: DAG_Index}
  | SubN {seq_in :: Expr, index :: DAG_Index}
  | MulN {seq_in :: Expr, index :: DAG_Index}
  | DivN {seq_in :: Expr, index :: DAG_Index}
  | EqN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}

  -- generators
  | Lut_GenN {
      lookup_table :: [AST_Value],
      lookup_types :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Const_GenN {
      constant :: AST_Value,
      constant_type :: AST_Type,
      index :: DAG_Index
      }

  -- sequence operators
  | ShiftN {
      n :: Int,
      i :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Up_1dN {
      n :: Int,
      i :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Down_1dN {
      n :: Int,
      i :: Int,
      sel_idx :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | PartitionN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | UnpartitionN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }

  -- higher order operators
  | MapN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Map2N {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in_left :: Expr,
      seq_in_right :: Expr,
      index :: DAG_Index
      }
  | ReduceN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | FstN {
      t0 :: AST_Type,
      t1 :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | SndN {
      t0 :: AST_Type,
      t1 :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | ATupleN {
      t0 :: AST_Type,
      t1 :: AST_Type,
      seq_in_left :: Expr,
      seq_in_right :: Expr,
      index :: DAG_Index
      }
  -- no need for an SSeq or TSeq Tuple as this applies to the
  -- elements, a map is used to lift it onto the SSeq or TSeqs
  | STupleN {
      tuple_elem_t :: AST_Type,
      seq_in_left :: Expr,
      seq_in_right :: Expr,
      index :: DAG_Index
      }
  | STupleAppendN {
      out_len :: Int,
      tuple_elem_t :: AST_Type,
      seq_in_left :: Expr,
      seq_in_right :: Expr,
      index :: DAG_Index
      }
  | STupleToSeqN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | SeqToSTupleN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | InputN {t :: AST_Type, input_name :: String, index :: DAG_Index}
  | ErrorN {error_msg :: String, index :: DAG_Index}
  deriving (Show, Eq, Ord)


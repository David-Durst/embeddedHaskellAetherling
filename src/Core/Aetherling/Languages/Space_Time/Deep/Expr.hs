module Aetherling.Languages.Space_Time.Deep.Expr where
import Aetherling.Languages.Space_Time.Deep.Types

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
  | Shift_sN {
      n :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Shift_tN {
      n :: Int,
      i :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Up_1d_sN {
      n :: Int,
      t :: AST_Type,
      seq_in :: Expr
      }
  | Up_1d_tN {
      n :: Int,
      i :: Int,
      t :: AST_Type,
      seq_in :: Expr
      }
  | Down_1d_sN {
      n :: Int,
      sel_idx :: Int,
      t :: AST_Type,
      seq_in :: Expr
      }
  | Down_1d_tN {
      n :: Int,
      i :: Int,
      sel_idx :: Int,
      t :: AST_Type,
      seq_in :: Expr
      }
  | Partition_s_ssN {
      no :: Int,
      ni :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Partition_t_ttN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Unpartition_s_ssN {
      no :: Int,
      ni :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Unpartition_t_ttN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | SerializeN {
      n :: Int,
      i :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | DeserializeN {
      n :: Int,
      i :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Add_1_sN {
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Add_1_0_tN {
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Remove_1_sN {
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  | Remove_1_0_tN {
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  -- higher order operators
  | Map_sN {
      n :: Int,
      f :: Expr,
      seq_in :: Expr
      }
  | Map_tN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in :: Expr
      }
  | Map2_sN {
      n :: Int,
      f :: Expr,
      seq_in_left :: Expr,
      seq_in_right :: Expr
      }
  | Map2_tN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in_left :: Expr,
      seq_in_right :: Expr
      }
  | Reduce_sN {
      n :: Int,
      f :: Expr,
      seq_in :: Expr
      }
  | Reduce_tN {
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
  | STupleToSSeqN {
      tuple_len :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr
      }
  | SSeqToSTupleN {
      tuple_len :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr
      }
  | InputN {t :: AST_Type, input_name :: String}
  | ErrorN {error_msg :: String}
  -- FIFO serve three roles:
  --   1. align clock signatures - delay clks
  --   2. break up combinational paths - does this by default
  --   3. match delays - delay_clks used on a per clock cycle basis
  -- note that delay_clks is number of clks, not number of periods
  | FIFON {
      n :: Int,
      i :: Int,
      delay_clks :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr
      }
  deriving (Show, Eq, Ord)

is_error_node :: Expr -> Bool
is_error_node (ErrorN _) = True
is_error_node _ = False

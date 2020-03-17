module Aetherling.Languages.Space_Time.Deep.Expr where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Monad_Helpers
import Control.DeepSeq
import GHC.Generics (Generic)

data Expr =
  IdN {seq_in :: Expr, index :: DAG_Index}
  | AbsN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | NotN {seq_in :: Expr, index :: DAG_Index}
  | AndN {seq_in :: Expr, index :: DAG_Index}
  | OrN {seq_in :: Expr, index :: DAG_Index}
  | AddN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | SubN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | MulN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | DivN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | LSRN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | LSLN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | LtN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | EqN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}
  | IfN {t :: AST_Type, seq_in :: Expr, index :: DAG_Index}

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
      delay :: Int,
      index :: DAG_Index
      }
  | Counter_sN {
      n :: Int,
      incr_amount :: Int,
      int_type :: AST_Type,
      delay :: Int,
      index :: DAG_Index
      }
  | Counter_tN {
      n :: Int,
      i :: Int,
      incr_amount :: Int,
      int_type :: AST_Type,
      delay :: Int,
      index :: DAG_Index
      }

  -- sequence operators
  | Shift_sN {
      n :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Shift_tN {
      n :: Int,
      i :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Shift_tsN {
      no :: Int,
      io :: Int,
      ni :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Shift_ttN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Shift_tnN {
      no :: Int,
      nis :: [Int],
      io :: Int,
      iis :: [Int],
      shift_amount :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Up_1d_sN {
      n :: Int,
      t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Up_1d_tN {
      n :: Int,
      i :: Int,
      t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Down_1d_sN {
      n :: Int,
      sel_idx :: Int,
      t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Down_1d_tN {
      n :: Int,
      i :: Int,
      sel_idx :: Int,
      t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Partition_s_ssN {
      no :: Int,
      ni :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Partition_t_ttN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Unpartition_s_ssN {
      no :: Int,
      ni :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Unpartition_t_ttN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | SerializeN {
      n :: Int,
      i :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | DeserializeN {
      n :: Int,
      i :: Int,
      elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Add_1_sN {
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Add_1_0_tN {
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Remove_1_sN {
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Remove_1_0_tN {
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  -- higher order operators
  | Map_sN {
      n :: Int,
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Map_tN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Map2_sN {
      n :: Int,
      f :: Expr,
      seq_in_left :: Expr,
      seq_in_right :: Expr,
      index :: DAG_Index
      }
  | Map2_tN {
      n :: Int,
      i :: Int,
      f :: Expr,
      seq_in_left :: Expr,
      seq_in_right :: Expr,
      index :: DAG_Index
      }
  | Reduce_sN {
      n :: Int,
      f :: Expr,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | Reduce_tN {
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
  | STupleToSSeqN {
      tuple_len :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | SSeqToSTupleN {
      tuple_len :: Int,
      tuple_elem_t :: AST_Type,
      seq_in :: Expr,
      index :: DAG_Index
      }
  | InputN {t :: AST_Type, input_name :: String, index :: DAG_Index}
  | ErrorN {error_msg :: String, index :: DAG_Index}
  -- FIFO serve three roles:
  --   1. align clock signatures - delay clks
  --   2. break up combinational paths - does this by default
  --   3. match delays - delay_clks used on a per clock cycle basis
  -- note that delay_clks is number of clks, not number of periods
  | FIFON {
      t :: AST_Type,
      delay_clks :: Int,
      seq_in :: Expr,
      index :: DAG_Index
      }
   | ReshapeN {
       in_t :: AST_Type,
       out_t :: AST_Type,
       seq_in :: Expr,
       index :: DAG_Index
       }
  deriving (Show, Eq, Ord, Generic, NFData)

is_error_node :: Expr -> Bool
is_error_node (ErrorN _ _) = True
is_error_node _ = False

instance Indexible Expr where
  get_index e = index e
  set_index e i = e { index = i }

non_input_with_no_inputs (Const_GenN _ _ _ _) = True
non_input_with_no_inputs (Counter_sN _ _ _ _ _) = True
non_input_with_no_inputs (Counter_tN _ _ _ _ _ _) = True
non_input_with_no_inputs _ = False

has_two_inputs (Map2_sN _ _ _ _ _) = True
has_two_inputs (Map2_tN _ _ _ _ _ _) = True
has_two_inputs (ATupleN _ _ _ _ _) = True
has_two_inputs (STupleN _ _ _ _) = True
has_two_inputs (STupleAppendN _ _ _ _ _) = True
has_two_inputs _ = False

seq_in_st = seq_in
seq_in_left_st = seq_in_left
seq_in_right_st = seq_in_right
seq_in_n_st 0 e = seq_in e
seq_in_n_st n e = do
  let inner_e = seq_in_n_st (n-1) e
  if has_two_inputs inner_e
  then seq_in_left inner_e
  else seq_in inner_e
f_st = f

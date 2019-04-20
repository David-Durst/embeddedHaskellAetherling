module Aetherling.Declarations.Space_Time where 
import Aetherling.Types.Declarations

type ST_DAG = DAG Space_Time_Language_AST

data Space_Time_Language_AST =
  IdN
  | AbsN
  | NotN
  | AddN
  | EqN {t :: AST_Type}

  -- generators
  | Lut_GenN {lookup_table :: [AST_Value]}
  | Const_GenN {constant :: AST_Value}

  -- sequence operators
  | Up_1d_sN {n :: Int, t :: AST_Type}
  | Up_1d_tN {n :: Int, v :: Int, t :: AST_Type}
  | Down_1d_sN {n :: Int, t :: AST_Type}
  | Down_1d_tN {n :: Int, v :: Int, t :: AST_Type}
  | Partition_ssN {no :: Int, ni :: Int, t :: AST_Type}
  | Unpartition_ssN {no :: Int, ni :: Int, t :: AST_Type}
  | Partition_ttN {no :: Int, vo_in :: Int,
                   ni :: Int, vi_in :: Int, t :: AST_Type}
  | Unpartition_ttN {no :: Int, vo_out :: Int,
                     ni :: Int, vi_out :: Int, t :: AST_Type}
  | Partition_tsN {no :: Int, ni :: Int, v_in :: Int, t :: AST_Type}
  | Unpartition_tsN {no :: Int, ni :: Int, v_out :: Int, t :: AST_Type}
  | Map_sN {n :: Int, f :: DAG Space_Time_Language_AST}
  | Map_tN {n :: Int,  v :: Int, f :: DAG Space_Time_Language_AST}
  | Map2_sN {n :: Int, f :: DAG Space_Time_Language_AST}
  | Map2_tN {n :: Int, v :: Int, f :: DAG Space_Time_Language_AST}
  | FstN {t0 :: AST_Type, t1 :: AST_Type}
  | SndN {t0 :: AST_Type, t1 :: AST_Type}
  | ZipN {t0 :: AST_Type, t1 :: AST_Type}
  | InputN {t :: AST_Type}
  deriving (Show, Eq)

module Aetherling.Interpretations.Valid_Slowdowns where
import Aetherling.ASTs.Space_Time
import Aetherling.Types.Declarations
import Data.Map
import Data.Maybe

get_next_valid_slowdown :: ST_DAG -> Int -> Int
get_next_valid_slowdown dag@(DAG nodes _) factor = do
  let is_cur_factor_valid = and $ fmap (is_slowdown_valid factor) nodes
  if is_cur_factor_valid
    then factor
    else get_next_valid_slowdown dag (factor+1)

-- check if this slowdown amount is valid
-- always slowing down parallel _s operators, so don't worry about _t
is_slowdown_valid :: Int -> Space_Time_Language_AST -> Bool
-- these don't impact ability to slow down
is_slowdown_valid _ IdN = True
is_slowdown_valid _ AbsN = True
is_slowdown_valid _ NotN = True
is_slowdown_valid _ AddN = True
is_slowdown_valid _ (EqN _) = True

-- generators
is_slowdown_valid _ (Lut_GenN _) = True
is_slowdown_valid _ (Const_GenN _) = True

-- sequence operators
is_slowdown_valid factor (Up_1d_sN n _) = factor_valid n factor
is_slowdown_valid _ (Up_1d_tN n _ _) = undefined 
is_slowdown_valid factor (Down_1d_sN n _) = factor_valid n factor
is_slowdown_valid _ (Down_1d_tN _ _ _) = undefined
is_slowdown_valid factor (Partition_ssN no ni _) =
  factor_valid no factor || factor_valid (no*ni) factor
is_slowdown_valid factor (Unpartition_ssN no ni _) =
  factor_valid no factor || factor_valid (no*ni) factor
is_slowdown_valid _ (Partition_ttN _ _ _ _ _) = undefined
is_slowdown_valid _ (Unpartition_ttN _ _ _ _ _) = undefined
is_slowdown_valid _ (Partition_tsN _ _ _ _) = undefined
is_slowdown_valid _ (Unpartition_tsN _ _ _ _) = undefined 
is_slowdown_valid factor (Map_sN n f) =
  factor_valid n factor || (get_next_valid_slowdown f factor == factor)
is_slowdown_valid _ (Map_tN _ _ _) = undefined
is_slowdown_valid factor (Map2_sN n f) =
  factor_valid n factor || (get_next_valid_slowdown f factor == factor)
is_slowdown_valid _ (Map2_tN _ _ _) = undefined

is_slowdown_valid _ (FstN _ _) = True
is_slowdown_valid _ (SndN _ _) = True
is_slowdown_valid _ (ZipN _ _) = True
is_slowdown_valid _ (InputN _) = True

-- true if factor divides into n, slow down, or if n divides into factr,
-- underutilizing
factor_valid :: Int -> Int -> Bool
factor_valid n factor = (n `mod` factor == 0) || (factor `mod` n == 0)

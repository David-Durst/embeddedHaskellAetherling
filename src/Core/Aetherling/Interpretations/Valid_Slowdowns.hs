module Aetherling.Interpretations.Valid_Slowdowns where
import Aetherling.ASTs.Space_Time
import Aetherling.Types.Declarations
import Data.Map
import Data.Maybe
import Math.NumberTheory.Primes.Factorisation

get_valid_slowdowns :: ST_DAG -> [Int]
get_valid_slowdowns (DAG nodes _) = do
  let prime_factors = fmap get_valid_slowdowns_for_node nodes
  let shared_prime_factors = Prelude.foldl (unionWith max) empty prime_factors
  -- expand each prime factor, num occurrences pair to a list of the prime
  -- factor copies
  concat $ fmap (\(prime_factor,n) -> replicate n prime_factor) $
    toList shared_prime_factors

-- empty list represents that this is not a node on SSeqs and TSeqs, so
-- slowing it down is meaningless
get_valid_slowdowns_for_node :: Space_Time_Language_AST -> Map Int Int
get_valid_slowdowns_for_node IdN = empty
get_valid_slowdowns_for_node AbsN = empty
get_valid_slowdowns_for_node NotN = empty
get_valid_slowdowns_for_node AddN = empty
get_valid_slowdowns_for_node (EqN _) = empty

  -- generators
get_valid_slowdowns_for_node (Lut_GenN _) = empty
get_valid_slowdowns_for_node (Const_GenN _) = empty

  -- sequence operators
get_valid_slowdowns_for_node (Up_1d_sN n _) = factor n 
get_valid_slowdowns_for_node (Up_1d_tN n _ ) {n :: Int, v :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Down_1d_sN {n :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Down_1d_tN {n :: Int, v :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Partition_ssN {no :: Int, ni :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Unpartition_ssN {no :: Int, ni :: Int, t :: AST_Type}
{-
get_valid_slowdowns_for_node Partition_ttN {no :: Int, vo_in :: Int,
                   ni :: Int, vi_in :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Unpartition_ttN {no :: Int, vo_out :: Int,
                     ni :: Int, vi_out :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Partition_tsN {no :: Int, ni :: Int, v_in :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Unpartition_tsN {no :: Int, ni :: Int, v_out :: Int, t :: AST_Type}
get_valid_slowdowns_for_node Map_sN {n :: Int, f :: DAG Space_Time_Language_AST}
get_valid_slowdowns_for_node Map_tN {n :: Int,  v :: Int, f :: DAG Space_Time_Language_AST}
get_valid_slowdowns_for_node Map2_sN {n :: Int, f :: DAG Space_Time_Language_AST}
get_valid_slowdowns_for_node Map2_tN {n :: Int, v :: Int, f :: DAG Space_Time_Language_AST}
get_valid_slowdowns_for_node FstN {t0 :: AST_Type, t1 :: AST_Type}
get_valid_slowdowns_for_node SndN {t0 :: AST_Type, t1 :: AST_Type}
get_valid_slowdowns_for_node ZipN {t0 :: AST_Type, t1 :: AST_Type}
get_valid_slowdowns_for_node InputN {t :: AST_Type}
-}

-- Get the prime factorization of an Int.
-- Returns a map where key is the prime factor and value is the number of times
-- the prime appears in the factorization
factor :: Int -> Map Int Int
factor n = fromDistinctAscList $ fmap (\(k,v) -> (fromInteger k, v)) $ factorise (toInteger n)

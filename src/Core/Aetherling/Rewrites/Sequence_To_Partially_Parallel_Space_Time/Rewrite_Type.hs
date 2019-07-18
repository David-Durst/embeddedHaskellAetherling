module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type where
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import Control.Monad.Except
import Data.List
import Data.Maybe
import Data.Either
import qualified Data.Set as S
import Text.Printf
import Math.NumberTheory.Primes.Factorisation
import Debug.Trace
{-
get_max_length_per_layer :: Lengths_Per_Layer -> [Int]
get_max_length_per_layer (Unary_Atom_Layer e_cur_layer) = get_max_length_per_layer e_cur_layer
get_max_length_per_layer (Binary_Atom_Layer e_left_cur_layer e_right_cur_layer) =
  fmap (uncurry max) $ zip
  (get_max_length_per_layer e_left_cur_layer)
  (get_max_length_per_layer e_right_cur_layer)
-}

data Type_Rewrite =
  SpaceR { tr_n :: Int}
  | TimeR { tr_n :: Int, tr_i :: Int}
  | SplitR { tr_n_outer :: Int, tr_i_outer :: Int, tr_n_inner :: Int }
  | NonSeqR
  deriving (Show, Eq)

get_type_rewrite_periods :: Type_Rewrite -> Int
get_type_rewrite_periods (SpaceR _) = 1
get_type_rewrite_periods (TimeR tr_n tr_i) = tr_n + tr_i
get_type_rewrite_periods (SplitR tr_no tr_io _) = tr_no + tr_io
get_type_rewrite_periods NonSeqR = -1

rewrite_AST_type :: Int -> SeqT.AST_Type -> Rewrite_StateM [Type_Rewrite]
rewrite_AST_type s e = do
  let s_factors = ae_factorize s
  let (t_rewrites, s_remaining) = rewrite_AST_type' s_factors e
  if ae_all_non_one_factors_used s_remaining
    then return t_rewrites
    else throwError $ Slowdown_Failure $ show s_remaining ++ " slowdown not 1 " ++
         "with t_rewrites "

rewrite_AST_type' :: Factors -> SeqT.AST_Type -> ([Type_Rewrite], Factors)
rewrite_AST_type' s_remaining_factors SeqT.UnitT = ([NonSeqR], s_remaining_factors)
rewrite_AST_type' s_remaining_factors SeqT.BitT = ([NonSeqR], s_remaining_factors)
rewrite_AST_type' s_remaining_factors SeqT.IntT = ([NonSeqR], s_remaining_factors)
rewrite_AST_type' s_remaining_factors (SeqT.ATupleT _ _) = ([NonSeqR], s_remaining_factors)
rewrite_AST_type' s_remaining_factors (SeqT.SeqT n i t) = do
  let n_factors = ae_factorize n
  let n_i_factors = ae_factorize (n+i)
  let n_i_s_factors = ae_factors_intersect s_remaining_factors n_i_factors
  
   -- speedup if amount of output to produce divides into speedup amount
  if n_i_factors `ae_factors_subset` s_remaining_factors
    then do
    let result_s_remaining_factors = ae_renumber_factors $
          ae_factors_diff s_remaining_factors n_i_factors
    let (inner_rewrites, final_factors) = rewrite_AST_type' result_s_remaining_factors t
    (SpaceR n : inner_rewrites, final_factors)

    -- if there are common factors between total runtime and speedup
    -- use them to do speedup
    else if n_i_s_factors /= S.empty
    then do
    let speedup_factors = n_i_s_factors
    let speedup = ae_factors_product speedup_factors
    let no_factors = ae_factors_intersect n_factors n_i_s_factors
    let no = ae_factors_product no_factors
    let ni = n `div` no
    let io = ((n + i) `div` speedup) - no
    let result_s_remaining_factors = ae_renumber_factors $
          ae_factors_diff s_remaining_factors speedup_factors
    let (inner_rewrites, final_factors) = rewrite_AST_type' result_s_remaining_factors t
    (SplitR no io ni : inner_rewrites, final_factors)

    else do
    let (inner_rewrites, final_factors) = rewrite_AST_type' s_remaining_factors t
    (TimeR n i : inner_rewrites, final_factors)
rewrite_AST_type' s_remaining_factors (SeqT.STupleT n t) = do
  let (inner_rewrites, final_factors) = rewrite_AST_type' s_remaining_factors t
  (NonSeqR : inner_rewrites, final_factors)

data Factor = Factor { factor_val :: Int, factor_num :: Int }
  deriving (Show, Eq, Ord)

type Factors = S.Set Factor

factor_num_pair_to_factor_list :: (Integer, Int) -> Factors
factor_num_pair_to_factor_list (factor, copies) = do
  let factor_int = fromInteger factor
  S.fromList $ [Factor factor_int i | i <- [0 .. copies - 1]]
  
ae_factorize :: Int -> Factors
ae_factorize n = do
  let factors = factorise $ fromIntegral n
  let nested_factors = S.fromList $ fmap factor_num_pair_to_factor_list factors
  S.foldl S.union S.empty nested_factors

ae_all_non_one_factors_used :: Factors -> Bool
ae_all_non_one_factors_used fs = fs == S.empty

ae_factors_to_int_list :: Factors -> [Int]
ae_factors_to_int_list factors = do
  let factors_list = S.toList factors
  fmap factor_val factors_list

ae_renumber_factors :: Factors -> Factors
ae_renumber_factors input_factors = do
  let input_factors_list = ae_factors_to_int_list input_factors
  -- note: group only combines adjacent elements
  -- which is fine since ae_factors_to_int_list puts all equivalent ints adjacent
  let grouped_factors_list = group input_factors_list
  let indices :: [Int] = [0..]
  let factors_with_indices = fmap (\x -> zip x indices) grouped_factors_list
  let flattened_factors_with_indices = foldl (++) [] factors_with_indices
  let typed_factors = fmap
        (\(factor, idx) -> Factor factor idx)
        flattened_factors_with_indices
  S.fromList typed_factors

ae_factors_product :: Factors -> Int
ae_factors_product = product . ae_factors_to_int_list

ae_factors_subset :: Factors -> Factors -> Bool
ae_factors_subset = S.isSubsetOf

ae_factors_diff :: Factors -> Factors -> Factors
ae_factors_diff = S.difference

ae_factors_intersect :: Factors -> Factors -> Factors
ae_factors_intersect = S.intersection

ae_factors_union :: Factors -> Factors -> Factors
ae_factors_union = S.union

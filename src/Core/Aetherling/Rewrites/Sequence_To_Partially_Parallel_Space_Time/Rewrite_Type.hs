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
{-
rewrite_AST_type :: Int -> 
partially_parallelize_AST_type e SeqT.UnitT = do
  slowdown_factor <- get_remaining_slowdown
  if slowdown_factor /= 1
    then throw_partially_parallel_error e
    else return STT.UnitT
partially_parallelize_AST_type e SeqT.BitT = do
  slowdown_factor <- get_remaining_slowdown
  if slowdown_factor /= 1
    then throw_partially_parallel_error e
    else return STT.BitT
partially_parallelize_AST_type e SeqT.IntT = do
  slowdown_factor <- get_remaining_slowdown
  if slowdown_factor /= 1
    then throw_partially_parallel_error e
    else return STT.IntT
partially_parallelize_AST_type e (SeqT.ATupleT x y) = do
  x_stt <- partially_parallelize_AST_type e x
  y_stt <- partially_parallelize_AST_type e y
  return $ (STT.ATupleT x_stt y_stt) 
partially_parallelize_AST_type e (SeqT.SeqT n _ t) = do
  slowdown_factor <- get_remaining_slowdown
  -- fully sequential as factor is only part of length of seq
  -- what about i? Need to consider divisibility of i as well
  if n `mod` slowdown_factor == 0
    then do
    let par_amount = n `div` slowdown_factor
    set_remaining_slowdown n slowdown_factor
    inner_type <- partially_parallelize_AST_type t
    return $ STT.TSeqT n inner_type
    else undefined
partially_parallelize_AST_type e (SeqT.STupleT n t) = do
  inner_type <- partially_parallelize_AST_type e t
  return $ STT.STupleT n inner_type
-}
{-
get_max_length_per_layer :: Lengths_Per_Layer -> [Int]
get_max_length_per_layer (Lengths_Per_Layer lengths) = do
  fmap maximum $ fmap (fmap fromJust) $ fmap (filter isJust) lengths

get_lengths_at_layer :: Int -> Lengths_Per_Layer -> [Int]
get_lengths_at_layer layer (Lengths_Per_Layer lengths) = do
  fmap fromJust $ filter isJust (lengths !! layer)
  
get_lengths :: Lengths_Per_Layer -> [[Int]]
get_lengths (Lengths_Per_Layer lengths) = do
  fmap (fmap fromJust) $ fmap (filter isJust) lengths

compute_slowdown_per_layer :: Int -> Lengths_Per_Layer -> Rewrite_StateM [Layer_Slowdown]
compute_slowdown_per_layer slowdown layers = do
  possible_slowdowns <- compute_slowdown_per_layer' slowdown $ get_lengths layers
  if product possible_slowdowns == slowdown
    then do
    let max_per_layer = get_max_length_per_layer layers
    let max_and_slowdown_per_layer = zip possible_slowdowns max_per_layer
    return $
      fmap (\(s_this_layer, max_this_layer) ->
              Layer_Slowdown s_this_layer max_this_layer (s_this_layer == max_this_layer))
      max_and_slowdown_per_layer
    else throwError $ Slowdown_Failure $ "Didn't achieve slowdown " ++ show slowdown ++
         ", instead got slowdown " ++ (show $ product possible_slowdowns) ++
         " with nested slowdowns " ++ show possible_slowdowns

slowdown_lte_and_mod_condition :: Int -> Int -> Bool
slowdown_lte_and_mod_condition s seq_length =
  (s <= seq_length) && ((seq_length `mod` s) == 0)

slowdown_greater_than_max_and_mod_condition :: Int -> [Int] -> Bool
slowdown_greater_than_max_and_mod_condition s seq_length =
  (s > seq_length) && ()
  (all (\n -> (s `mod` n) == 0) cur_layer_lengths) &&
  (all (\n -> n == (head cur_layer_lengths)) cur_layer_lengths)
{-
compute_slowdown_per_layer' :: Int -> [[Int]] -> Rewrite_StateM [Int]
-- if called with no layers, mistake
compute_slowdown_per_layer' _ [] = throwError $ Slowdown_Failure $
  "Can't slowdown with 0 layers. Should be " ++
  "impossible as even layers just with atoms should produce tombstones."
-- if this is last layer and its empty, return 1 as no slowdown
compute_slowdown_per_layer' s [[]] = return [1]
-- if this is last layer and its not empty, error
compute_slowdown_per_layer' s [_] =
  throwError $ Slowdown_Failure "last layer lengths not empty"
-- if this is not the layer layer but its empty, return 1 for slowdown on
-- this layer as not doing anything here
compute_slowdown_per_layer' s ([] : lower_lengths) = do
  lower_layer_slowdowns <- compute_slowdown_per_layer' s lower_lengths
  return $ 1 : lower_layer_slowdowns
-- if s <= min(layer lengths) and length `mod` s == 0 for all lengths in a layer
-- then slow down all op's for this layer by s and done
-- show done by making slowdown of 1 for all lower_layers
compute_slowdown_per_layer' s (cur_layer_lengths : lower_lengths) |
  slowdown_less_than_min_and_mod_condition s cur_layer_lengths =
  return $ s : replicate 1 (length lower_lengths)
-- if s >= max(layer lengths) and s `mod` length == 0 for all lengths in a layer
-- and all layer lengths equal
-- then slow down all op's for this layer by s and propagate s / (max layer lengths)
compute_slowdown_per_layer' s (cur_layer_lengths : lower_lengths) |
   slowdown_greater_than_max_and_mod_condition s cur_layer_lengths = do
    let s_this_layer = s `div` maximum cur_layer_lengths
    let s_remainder = s `div` (s_this_layer)
    lower_layer_slowdowns <- compute_slowdown_per_layer' s_remainder lower_lengths
    return $ s_this_layer : lower_layer_slowdowns
-- if s >= min(layer lengths) and s <= max(layer lengths) and
-- length `mod` s == 0 or length >= s for all, then split current layer
-- split by slowing down all op's for this layer by s and done
-- show done by making slowdown of 1 for all lower_layers
compute_slowdown_per_layer' s (cur_layer_lengths : lower_lengths) |
   slowdown_between_min_max_and_mod_condition s cur_layer_lengths =
  return $ s : replicate 1 (length lower_lengths)
-- if s >= max(layer lengths) and for all lengths in a layer
-- try slowing down lower layers, if result is not using up all of s and then try
-- using it here either by:
-- using it all if s_remainder >= all layer lengths for all layer lengths
-- using it all if s_remainder <= all layer lengths and length `mod` s_remainder == 0 for all layer lengths
-- using it all if s_remainder between min and max of layer lengths and mod conditions hold
-- else no slowdown and propagate up
compute_slowdown_per_layer' s (cur_layer_lengths : lower_lengths) |
  s >= maximum cur_layer_lengths = do
    lower_layer_slowdowns <- compute_slowdown_per_layer' s lower_lengths
    let s_used = product lower_layer_slowdowns
    let s_remainder = s `div` s_used
    if all (\n -> s_remainder >= n) cur_layer_lengths
      then return $ s_remainder : lower_layer_slowdowns
      else if slowdown_less_than_min_and_mod_condition s_remainder cur_layer_lengths
           then return $ s_remainder : lower_layer_slowdowns
           else if slowdown_between_min_max_and_mod_condition s_remainder cur_layer_lengths
                then return $ s_remainder : lower_layer_slowdowns
                else return $ 1 : lower_layer_slowdowns
-- else s < max(layer lengths) but divisibility conditions don't hold,
-- so propagate slowdown down
compute_slowdown_per_layer' s (cur_layer_lengths : lower_lengths) =
  compute_slowdown_per_layer' s lower_lengths
-}
-}

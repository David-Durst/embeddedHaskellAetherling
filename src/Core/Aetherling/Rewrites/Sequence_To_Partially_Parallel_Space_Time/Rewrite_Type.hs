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
  let (t_rewrites_no_underutil, s_remaining_no_underutil) =
        rewrite_AST_type_no_underutil s_factors e
  let (t_rewrites, s_remaining) =
        rewrite_AST_type_add_underutil s_remaining_no_underutil t_rewrites_no_underutil e
  if ae_all_non_one_factors_used s_remaining
    then return t_rewrites
    else throwError $ Slowdown_Failure $ show s_remaining ++ " slowdown not 1 " ++
         "with t_rewrites "

rewrite_AST_type_no_underutil :: Factors -> SeqT.AST_Type -> ([Type_Rewrite], Factors)
rewrite_AST_type_no_underutil s_remaining_factors (SeqT.SeqT n i t) = do
  let n_factors = ae_factorize n
  if ae_factors_intersect n_factors s_remaining_factors /= S.empty
    then do
    let slowdown_factors = ae_factors_intersect n_factors s_remaining_factors
    let slowdown = ae_factors_product slowdown_factors
    let no = slowdown
    let ni = n `div` no
    let io = 0
    let result_s_remaining_factors = ae_renumber_factors $
          ae_factors_diff s_remaining_factors slowdown_factors
    let (inner_rewrites, final_factors) = rewrite_AST_type_no_underutil result_s_remaining_factors t
    (SplitR no io ni : inner_rewrites, final_factors)

    else do
    let (inner_rewrites, final_factors) = rewrite_AST_type_no_underutil s_remaining_factors t
    (SpaceR n : inner_rewrites, final_factors)
rewrite_AST_type_no_underutil s_remaining_factors (SeqT.STupleT n t) = do
  let (inner_rewrites, final_factors) = rewrite_AST_type_no_underutil s_remaining_factors t
  (NonSeqR : inner_rewrites, final_factors)
rewrite_AST_type_no_underutil s_remaining_factors _ = ([NonSeqR], s_remaining_factors)

rewrite_AST_type_add_underutil :: Factors -> [Type_Rewrite] -> SeqT.AST_Type -> ([Type_Rewrite], Factors)
rewrite_AST_type_add_underutil s_remaining_factors (cur_tr_no_under : no_under_tl)
  (SeqT.SeqT n i t) = do
  let max_slowdown = (n + i) `div` get_type_rewrite_periods cur_tr_no_under
  let max_slowdown_factors = ae_factorize max_slowdown
  if ae_factors_intersect max_slowdown_factors s_remaining_factors /= S.empty
    then do
    let slowdown_factors = ae_factors_intersect max_slowdown_factors s_remaining_factors
    let slowdown = ae_factors_product slowdown_factors
    let result_s_remaining_factors = ae_renumber_factors $
          ae_factors_diff s_remaining_factors slowdown_factors
    let (inner_rewrites, final_factors) = rewrite_AST_type_add_underutil
                                          result_s_remaining_factors no_under_tl t
    (add_invalid_clocks cur_tr_no_under slowdown : inner_rewrites, final_factors)

    else do
    let (inner_rewrites, final_factors) = rewrite_AST_type_add_underutil
                                          s_remaining_factors no_under_tl t
    (cur_tr_no_under : inner_rewrites, final_factors)
    where
      add_invalid_clocks :: Type_Rewrite -> Int -> Type_Rewrite
      -- if going to emit only 1 valid per clock and using all possible clocks
      -- then fully sequential so only a time
      add_invalid_clocks (SpaceR 1) slowdown |
        slowdown == (n+i) =
        TimeR 1 (slowdown - 1)
      add_invalid_clocks (SplitR no io 1) slowdown |
        slowdown*(no+io) == (n+i) =
        -- need to subtract no from invalids as total time should be (no+io) * slowdown
        TimeR no (slowdown*(no+io) - no)
      -- otherwise, just make it a splitr and slow down by requested amount
      add_invalid_clocks (SpaceR n) slowdown =
        SplitR 1 (slowdown - 1) n
      add_invalid_clocks (SplitR no io ni) slowdown =
        SplitR no (slowdown*(no+io) - no) ni
      add_invalid_clocks _ _ = traceShow "calling add_invalid_wrong" undefined
rewrite_AST_type_add_underutil s_remaining_factors (_ : no_under_tl) (SeqT.STupleT n t) = do
  let (inner_rewrites, final_factors) =
        rewrite_AST_type_add_underutil s_remaining_factors no_under_tl t
  (NonSeqR : inner_rewrites, final_factors)
rewrite_AST_type_add_underutil s_remaining_factors _ _ = ([NonSeqR], s_remaining_factors)

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

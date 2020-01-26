module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types where
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Control.Monad.Except
import Data.List
import Data.Maybe
import Data.Either
import qualified Data.Set as S
import Text.Printf
import Math.NumberTheory.Primes.Factorisation
import Math.NumberTheory.Powers.Squares
import Debug.Trace

num_seq_layers :: SeqT.AST_Type -> Int
num_seq_layers (SeqT.SeqT n i t) = 1 + num_seq_layers t
num_seq_layers (SeqT.STupleT n t) = num_seq_layers t
num_seq_layers _ = 0

crossr [] = [[]]
crossr (x:xs) = [ a:as |  a <- x,  as <- crossr xs ]

type Out_Type_Rewrites = [Type_Rewrite]

data Level_Factor_Pair = LFP {level :: Int, factor :: Factor}
  deriving (Show, Eq)

data Level_Factor_Val_Pair = LFVP {level_v :: Int, factor_v :: Int}
  deriving (Show, Eq, Ord)

level_eq :: Level_Factor_Pair -> Level_Factor_Pair -> Bool
level_eq (LFP l0 _) (LFP l1 _) = l0 == l1

factor_eq :: Level_Factor_Pair -> Level_Factor_Pair -> Bool
factor_eq (LFP _ f0) (LFP _ f1) = f0 == f1

factor_cmp (LFP _ f0) (LFP _ f1) = compare f0 f1

level_v_eq (LFVP l0 _) (LFVP l1 _) = l0 == l1

level_v_cmp (LFVP l0 _) (LFVP l1 _) = compare l0 l1

level_factor_vals_to_total_slowdown :: [Level_Factor_Val_Pair] -> Level_Factor_Val_Pair
level_factor_vals_to_total_slowdown [] = LFVP (-1) (-1)
level_factor_vals_to_total_slowdown xs = LFVP (level_v $ head xs) (product $ fmap factor_v xs)

rewrite_all_AST_types_debug :: Int -> SeqT.AST_Type -> IO [Out_Type_Rewrites]
rewrite_all_AST_types_debug s seq_t = do
  let l = num_seq_layers seq_t
  let s_factors = S.toList $ ae_factorize s
  -- for each s, get all levels it can be at
  let s_for_each_level = groupBy factor_eq $ sortBy factor_cmp
        [ LFP x y | x <- [0..l-1], y <- s_factors]
  --traceShowM s_for_each_level
  -- each inner list is a possible distribution of factors among levels without using a factor twice
  -- collection of lists is all possible distributions of factors among all levels
  let all_possible_s_distributions = crossr s_for_each_level
  -- for each distribution, for each factor, remove the factor index and just get the value
  let all_possible_levels_and_s_int =
        fmap (fmap (\(LFP level factor) -> (LFVP level (factor_val factor))))
        all_possible_s_distributions
  -- for each distribution, for each level, the slowdown factors
  let all_possible_slowdown_factors_per_level =
        fmap (groupBy level_v_eq . sortBy level_v_cmp) all_possible_levels_and_s_int
  -- for each distribution, for each level, the level and the product of slowdown factors
  let all_possible_slowdowns_per_level_with_dups =
        fmap (fmap level_factor_vals_to_total_slowdown) all_possible_slowdown_factors_per_level
  --traceShowM all_possible_slowdowns_per_level_with_dups
  -- sending to set to remove duplicate distributions of factors
  let all_possible_slowdowns_per_level = S.toList $ S.fromList $
        fmap (sortBy (\x y -> compare (level_v x) (level_v y)))
        all_possible_slowdowns_per_level_with_dups
  --traceShowM all_possible_slowdowns_per_level
  -- get all possible slowdowns for each factor distribution
  return $ concat $ fmap (\l_and_s_xs -> rewrite_AST_type_given_slowdowns l_and_s_xs 0 seq_t)
    all_possible_slowdowns_per_level
    
all_possible_s s seq_t = do
  let l = num_seq_layers seq_t
  let s_factors = S.toList $ ae_factorize s
  -- for each s, get all levels it can be at
  let s_for_each_level = groupBy factor_eq $ sortBy factor_cmp
        [ LFP x y | x <- [0..l-1], y <- s_factors]
  --traceShowM s_for_each_level
  -- each inner list is a possible distribution of factors among levels without using a factor twice
  -- collection of lists is all possible distributions of factors among all levels
  crossr s_for_each_level

-- | recursive algorithm that recurs on the slowdown factors
-- base case is to assign 1 to each level.
-- inductive case is for each element of the set output from the prior set,
-- make n new elements (n is number of levels) where each layer is multiplied by
-- slowdown factor.
get_all_slowdowns_of_all_levels :: [Factor] -> Int -> S.Set [Int]
get_all_slowdowns_of_all_levels (hd_factor:tail_factors) num_levels = do
  let slowdowns_for_prior_factors = S.toList $ get_all_slowdowns_of_all_levels
                                    tail_factors num_levels
  S.fromList $ concatMap
    (apply_slowdown_to_all_levels $ factor_val hd_factor)
    slowdowns_for_prior_factors
  where
    apply_slowdown_to_all_levels :: Int -> [Int] -> [[Int]]
    apply_slowdown_to_all_levels s (hd_levels:tl_levels) =
      [s*hd_levels:tl_levels] ++
      (map (\xs -> [hd_levels] ++ xs) $ apply_slowdown_to_all_levels s tl_levels)
    apply_slowdown_to_all_levels s [] = []
get_all_slowdowns_of_all_levels [] num_levels =
  S.singleton $ replicate num_levels 1
  
all_possible_slowdowns_per_level' s seq_t = do
  let l = num_seq_layers seq_t
  let s_factors = S.toList $ ae_factorize s
  -- for each s, get all levels it can be at
  let s_for_each_level = groupBy factor_eq $ sortBy factor_cmp
        [ LFP x y | x <- [0..l-1], y <- s_factors]
  --traceShowM s_for_each_level
  -- each inner list is a possible distribution of factors among levels without using a factor twice
  -- collection of lists is all possible distributions of factors among all levels
  let all_possible_s_distributions = crossr s_for_each_level
  -- for each distribution, for each factor, remove the factor index and just get the value
  let all_possible_levels_and_s_int =
        fmap (fmap (\(LFP level factor) -> (LFVP level (factor_val factor))))
        all_possible_s_distributions
  -- for each distribution, for each level, the slowdown factors
  let all_possible_slowdown_factors_per_level =
        fmap (groupBy level_v_eq . sortBy level_v_cmp) all_possible_levels_and_s_int
  -- for each distribution, for each level, the level and the product of slowdown factors
  let all_possible_slowdowns_per_level_with_dups =
        fmap (fmap level_factor_vals_to_total_slowdown) all_possible_slowdown_factors_per_level
  --traceShowM all_possible_slowdowns_per_level_with_dups
  -- sending to set to remove duplicate distributions of factors
  S.toList $ S.fromList $
        fmap (sortBy (\x y -> compare (level_v x) (level_v y)))
        all_possible_slowdowns_per_level_with_dups

rewrite_all_AST_types' s seq_t = do
  let l = num_seq_layers seq_t
  let s_factors = S.toList $ ae_factorize s
  let all_possible_slowdowns_per_level_ints = S.toList $
        get_all_slowdowns_of_all_levels s_factors l
  map (\slowdowns_list ->
          map (\(slowdown, level_index) -> LFVP level_index slowdown)
          (zip slowdowns_list [0..])
      ) all_possible_slowdowns_per_level_ints
    
rewrite_all_AST_types :: Int -> SeqT.AST_Type -> [Out_Type_Rewrites]
rewrite_all_AST_types s seq_t = do
  let l = num_seq_layers seq_t
  let s_factors = S.toList $ ae_factorize s
  let all_possible_slowdowns_per_level_ints = S.toList $
        get_all_slowdowns_of_all_levels s_factors l
  let all_possible_slowdowns_per_level =
        map (\slowdowns_list ->
                map (\(slowdown, level_index) -> LFVP level_index slowdown)
                (zip slowdowns_list [0..])
            ) all_possible_slowdowns_per_level_ints
  --let all_possible_slowdowns_per_level = all_possible_slowdowns_per_level' s seq_t
  -- get all possible slowdowns for each factor distribution
  let unordered_results =
        concat $ fmap (\l_and_s_xs -> rewrite_AST_type_given_slowdowns l_and_s_xs 0 seq_t)
        all_possible_slowdowns_per_level
  --sortBy (\trs0 trs1 -> compare (rewrite_nesting_depth trs0) (rewrite_nesting_depth trs1))
  --  unordered_results
  unordered_results

rewrite_AST_type_given_slowdowns :: [Level_Factor_Val_Pair] -> Int ->
                                    SeqT.AST_Type -> [Out_Type_Rewrites]
-- first two cases handle where this layer is not being slowed
rewrite_AST_type_given_slowdowns [] cur_layer (SeqT.SeqT n _ t) = do
  let inner_rewrite_options = rewrite_AST_type_given_slowdowns [] (cur_layer + 1) t
  fmap (\trs -> SpaceR n : trs) inner_rewrite_options
rewrite_AST_type_given_slowdowns lfvps@(LFVP l _:other_s) cur_layer (SeqT.SeqT n _ t) |
  l /= cur_layer = do
  let inner_rewrite_options = rewrite_AST_type_given_slowdowns lfvps (cur_layer + 1) t
  fmap (\trs -> SpaceR n : trs) inner_rewrite_options
rewrite_AST_type_given_slowdowns (LFVP l 1:other_s) cur_layer (SeqT.SeqT n _ t) = do
  let inner_rewrite_options = rewrite_AST_type_given_slowdowns other_s (cur_layer + 1) t
  fmap (\trs -> SpaceR n : trs) inner_rewrite_options
rewrite_AST_type_given_slowdowns ((LFVP l s):other_s) cur_layer (SeqT.SeqT n _ t) = do
  let inner_rewrite_options = rewrite_AST_type_given_slowdowns other_s (cur_layer + 1) t
  let invalids = s-n
  let t_options =
        if s >= n
        then fmap (\trs -> TimeR n invalids : trs) inner_rewrite_options
        else []
  -- only exploring the tt options with 1 in bottom to allow repeating patterns
  let tt_options = concat $
        fmap (\trs ->
                -- s-n total invalids, divide them up between outer and
                -- and inner in all possible ways
                fmap (\io -> 
                         SplitNestedR (TimeR n io)
                         (SplitNestedR (TimeR 1 (fromJust $ ii_given_others n 1 io)) NonSeqR) : trs)
                [io | io <- [0..invalids], isJust (ii_given_others n 1 io)]
             )
        inner_rewrite_options
  let ttt_options = concat $
        fmap (\trs ->
                -- s-n total invalids, divide them up between outer and
                -- and inner in all possible ways
                fmap (\io -> 
                         SplitNestedR (TimeR n io)
                         (SplitNestedR (TimeR 1 (fromJust $ iii_given_others n io))
                         (SplitNestedR (TimeR 1 (fromJust $ iii_given_others n io)) NonSeqR)) : trs)
                [io | io <- [0..invalids], isJust (iii_given_others n io)]
             )
        inner_rewrite_options
  let possible_no = filter is_valid [1..n]
  let ts_options =
        if length possible_no == 0
        then []
        else do
          let max_no = maximum possible_no
          fmap (\trs -> SplitR max_no (s-max_no) (n `div` max_no) : trs) inner_rewrite_options
  ts_options ++ t_options ++ tt_options ++ ttt_options
  where
    is_valid no = (no <= s) && (no >= 0) && (n `mod` no == 0)
    ii_given_others no ni io =
      if (s `mod` (no + io) == 0) && ((s `div` (no + io)) >= ni)
      then Just ((s `div` (no + io)) - ni)
      else Nothing
    iii_given_others no io =
      if (s `mod` (no + io) == 0) && ((isSquare $ s `div` (no + io)))
      then Just $ integerSquareRoot $ (s `div` (no +io)) - 1
      else Nothing
rewrite_AST_type_given_slowdowns s_xs cur_layer (SeqT.STupleT n t) = do
  inner_rewrite <- rewrite_AST_type_given_slowdowns s_xs cur_layer t
  return $ NonSeqR : inner_rewrite
rewrite_AST_type_given_slowdowns _ _ _ = [[NonSeqR]]

rewrite_nesting_depth :: [Type_Rewrite] -> Int
rewrite_nesting_depth (SpaceR _ : tl) = 1 + rewrite_nesting_depth tl
rewrite_nesting_depth (TimeR _ _ : tl) = 1 + rewrite_nesting_depth tl
rewrite_nesting_depth (SplitR _ _ _ : tl) = 2 + rewrite_nesting_depth tl
rewrite_nesting_depth (SplitNestedR _ NonSeqR : tl) = 1 + rewrite_nesting_depth tl
rewrite_nesting_depth (SplitNestedR _ ntl : tl) = 1 + rewrite_nesting_depth (ntl : tl)
rewrite_nesting_depth (NonSeqR : tl) = 1 + rewrite_nesting_depth tl
rewrite_nesting_depth [] = 0

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
  let t_options = fmap (\trs -> TimeR n invalids : trs) inner_rewrite_options
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
  let possible_no = filter is_valid [1..n]
  let ts_options =
        if length possible_no == 0
        then []
        else do
          let max_no = maximum possible_no
          fmap (\trs -> SplitR max_no (s-max_no) (n `div` max_no) : trs) inner_rewrite_options
  ts_options ++ t_options ++ tt_options
  where
    is_valid no = (no <= s) && (no >= 0) && (n `mod` no == 0)
    ii_given_others no ni io =
      if (s `mod` (no + io) == 0) && ((s `div` (no + io)) >= ni)
      then Just ((s `div` (no + io)) - ni)
      else Nothing
rewrite_AST_type_given_slowdowns s_xs cur_layer (SeqT.STupleT n t) = do
  inner_rewrite <- rewrite_AST_type_given_slowdowns s_xs cur_layer t
  return $ NonSeqR : inner_rewrite
rewrite_AST_type_given_slowdowns _ _ _ = [[NonSeqR]]

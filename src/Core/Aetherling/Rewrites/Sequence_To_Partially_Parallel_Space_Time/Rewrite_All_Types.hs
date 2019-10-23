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

fst_eq :: Eq a => (a, b) -> (a, c) -> Bool
fst_eq (x, _) (y, _) = x == y

snd_eq :: Eq a => (b, a) -> (c, a) -> Bool
snd_eq (_, x) (_, y) = x == y

level_s_pairs_to_total_slowdown :: [(Int, Int)] -> (Int, Int)
level_s_pairs_to_total_slowdown [] = (-1, -1)
level_s_pairs_to_total_slowdown xs = (fst $ head xs, product $ fmap snd xs)

rewrite_all_AST_types_debug :: Int -> SeqT.AST_Type -> [Out_Type_Rewrites]
rewrite_all_AST_types_debug s seq_t = do
  let l = num_seq_layers seq_t
  let s_factors = S.toList $ ae_factorize s
  let s_for_each_level = groupBy snd_eq
        [ (x,y) | x <- [0..l-1], y <- s_factors]
  let all_possible_s_distributions = crossr s_for_each_level
  let all_possible_levels_and_s_int =
        fmap (fmap (\(level, factor) -> (level, factor_val factor))) all_possible_s_distributions
  let all_possible_slowdown_factors_per_level =
        fmap (groupBy fst_eq . sortBy (\x y -> compare (fst x) (fst y))) all_possible_levels_and_s_int
  let all_possible_slowdowns_per_level_with_levels =
        fmap (fmap level_s_pairs_to_total_slowdown) all_possible_slowdown_factors_per_level
  -- sending to set to remove duplicates
  let all_possible_slowdowns_per_level = S.toList $ S.fromList $
        fmap (sortBy (\x y -> compare (fst x) (fst y))) all_possible_slowdowns_per_level_with_levels
  let out_type_rewrites_with_maybes =
        fmap (\l_and_s_xs -> rewrite_AST_type_given_slowdowns l_and_s_xs 0 seq_t) all_possible_slowdowns_per_level
  fmap fromJust $ filter isJust out_type_rewrites_with_maybes

rewrite_AST_type_given_slowdowns :: [(Int, Int)] -> Int -> SeqT.AST_Type -> Maybe Out_Type_Rewrites
rewrite_AST_type_given_slowdowns ((l,_):other_s) cur_layer (SeqT.SeqT n _ t) |
  l /= cur_layer = do
  inner_rewrite <- rewrite_AST_type_given_slowdowns other_s (cur_layer + 1) t
  return $ SpaceR n : inner_rewrite
rewrite_AST_type_given_slowdowns ((l,1):other_s) cur_layer (SeqT.SeqT n _ t) = do
  inner_rewrite <- rewrite_AST_type_given_slowdowns other_s (cur_layer + 1) t
  return $ SpaceR n : inner_rewrite
rewrite_AST_type_given_slowdowns ((l,s):other_s) cur_layer (SeqT.SeqT n i t) |
  s >= n+i = do
  inner_rewrite <- rewrite_AST_type_given_slowdowns other_s (cur_layer + 1) t
  return $ TimeR n (s-n) : inner_rewrite
rewrite_AST_type_given_slowdowns ((l,s):other_s) cur_layer (SeqT.SeqT n _ t) = do
  inner_rewrite <- rewrite_AST_type_given_slowdowns other_s (cur_layer + 1) t
  let possible_no = filter is_valid [1..n]
  if length possible_no == 0
    then Nothing
    else do
    let max_no = maximum possible_no
    return $ SplitR max_no (s-max_no) (n `div` max_no) : inner_rewrite
  where
    is_valid no = (no <= s) && (no >= 0) && (n `mod` no == 0)
rewrite_AST_type_given_slowdowns s_xs cur_layer (SeqT.STupleT n t) = do
  inner_rewrite <- rewrite_AST_type_given_slowdowns s_xs cur_layer t
  return $ NonSeqR : inner_rewrite
rewrite_AST_type_given_slowdowns [] _ _ = Just [NonSeqR]
rewrite_AST_type_given_slowdowns _ _ _ = Nothing

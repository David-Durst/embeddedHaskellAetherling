module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Parallelism_Per_Layer where
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Sequence_Length_Per_Layer
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import Control.Monad.Except
import Data.Maybe
import Data.Either
import Text.Printf
{-
get_max_length_per_layer :: Lengths_Per_Layer -> [Int]
get_max_length_per_layer (Unary_Atom_Layer e_cur_layer) = get_max_length_per_layer e_cur_layer
get_max_length_per_layer (Binary_Atom_Layer e_left_cur_layer e_right_cur_layer) =
  fmap (uncurry max) $ zip
  (get_max_length_per_layer e_left_cur_layer)
  (get_max_length_per_layer e_right_cur_layer)
-}

data Layer_Slowdown = Layer_Slowdown {
  layer_s :: Int,
  layer_max_len :: Int,
  layer_split :: Bool
  } deriving (Show, Eq)

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

slowdown_less_than_min_and_mod_condition :: Int -> [Int] -> Bool
slowdown_less_than_min_and_mod_condition s cur_layer_lengths =
  s <= minimum cur_layer_lengths && (all (\n -> (n `mod` s) == 0) cur_layer_lengths)
  
slowdown_between_min_max_and_mod_condition :: Int -> [Int] -> Bool
slowdown_between_min_max_and_mod_condition s cur_layer_lengths =
  s >= minimum cur_layer_lengths &&
  s <= maximum cur_layer_lengths &&
  (all (\n -> (n `mod` s) == 0 || (s `mod` n) == 0) cur_layer_lengths)
  
slowdown_greater_than_max_and_mod_condition :: Int -> [Int] -> Bool
slowdown_greater_than_max_and_mod_condition s cur_layer_lengths =
  s >= maximum cur_layer_lengths &&
  (all (\n -> (s `mod` n) == 0) cur_layer_lengths) &&
  (all (\n -> n == (head cur_layer_lengths)) cur_layer_lengths)

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

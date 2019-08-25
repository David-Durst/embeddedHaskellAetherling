module Aetherling.Functional_Models.Flip_ts_to_st where
import Data.List
import qualified Data.Set as S
import Debug.Trace

data Banked_Value = Banked_Value {
  banked_elem :: Int,
  in_t_idx :: Int,
  in_s_idx :: Int,
  bank_idx :: Int,
  addr_idx :: Int
  } deriving (Show, Eq)

ts_to_st :: Int -> Int -> Either (String, [[Banked_Value]]) [[Int]]
ts_to_st t_len s_len = do
  let ts = [[ t*s_len + x | x <- [0 .. s_len - 1]] | t <- [0 .. t_len - 1]]
  let ts_banked_data = add_buffer_data_for_ts ts
  let banks = reshape_to_banks ts_banked_data
  -- this verifies that each bank is never written to on the same clock
  let bank_write_conflict = any id $
        map has_duplicates $ map (map in_t_idx) banks
  let st_banked_data = read_data_from_banks_for_st banks
  -- this ensures that parallel reads (same space index) don't share the same bank
  let bank_read_conflict = any id $
        map has_duplicates $ map (map bank_idx) $ transpose st_banked_data
  let st = map (map banked_elem) st_banked_data
  if bank_write_conflict
    then Left ("Write Conflict", banks) 
    else if bank_read_conflict then Left ("Read Conflict", st_banked_data)
    else if (concat ts /= concat st) then Left ("Element Order Not Preserved", st_banked_data)
    else return st

st_to_ts :: Int -> Int -> Either (String, [[Banked_Value]]) [[Int]]
st_to_ts s_len t_len = do
  let st = [[ x*t_len + t | t <- [0 .. t_len - 1]] | x <- [0 .. s_len - 1]]
  let st_banked_data = add_buffer_data_for_st st
  let banks = reshape_to_banks st_banked_data
  --traceM $ show $ fmap (fmap banked_elem) banks
  -- this verifies that each bank is never written to on the same clock
  let bank_write_conflict = any id $
        map has_duplicates $ map (map in_t_idx) banks
  let ts_banked_data = read_data_from_banks_for_ts banks
  -- this ensures that parallel reads (same space index) don't share the same bank
  let bank_read_conflict = any id $
        map has_duplicates $ map (map bank_idx) ts_banked_data
  let ts = map (map banked_elem) ts_banked_data
  if bank_write_conflict
    then Left ("Write Conflict", banks) 
    else if bank_read_conflict then Left ("Read Conflict", ts_banked_data)
    else if (concat ts /= concat st) then Left ("Element Order Not Preserved", ts_banked_data)
    else return ts

has_duplicates :: (Ord a) => [a] -> Bool
has_duplicates list = length list /= length set
  where set = S.fromList list
  
-- | given an [[Int]] represent an outer TSeq len and an inner SSeq len
-- return the same structure where bank and indexes are assigned to each value
add_buffer_data_for_ts :: [[Int]] -> [[Banked_Value]]
add_buffer_data_for_ts ts | (t_len `mod` s_len /= 0) && (s_len `mod` t_len /= 0) =
  [
    [ Banked_Value (ts !! t !! x) t x x t
    | x <- [0..(s_len - 1)]] | t <- [0..(t_len - 1)]]
  where
    t_len = length ts
    s_len = length (ts !! 0)
add_buffer_data_for_ts ts =
  [
    [ Banked_Value (ts !! t !! x) t x ((x + (flat_idx x t `div` max t_len s_len)) `mod` s_len) t
    | x <- [0..(s_len - 1)]] | t <- [0..(t_len - 1)]]
  where
    flat_idx x t = s_len * t + x
    t_len = length ts
    s_len = length (ts !! 0)

-- | given an [[Banked_Value]] representing a set of banks of memory
-- return the same structure in the order of the TSeq (SSeq) read from the bank
read_data_from_banks_for_ts :: [[Banked_Value]] -> [[Banked_Value]]
read_data_from_banks_for_ts banks | (t_len `mod` s_len /= 0) && (s_len `mod` t_len /= 0) =
  [
    [ banks !! x !! t
    | x <- [0..(s_len - 1)]] | t <- [0..(t_len - 1)]]
  where
    s_len = length banks
    t_len = length (banks !! 0)
read_data_from_banks_for_ts banks =
  [
    [ banks !! ((x + (flat_idx x t `div` max t_len s_len)) `mod` s_len) !! t
    | x <- [0..(s_len - 1)]] | t <- [0..(t_len - 1)]]
  where
    flat_idx x t = s_len * t + x
    s_len = length banks
    t_len = length (banks !! 0)

-- | given an [[Int]] represent an outer SSeq len and an inner TSeq len
-- return the same structure where bank and indexes are assigned to each value
add_buffer_data_for_st :: [[Int]] -> [[Banked_Value]]
add_buffer_data_for_st st | (t_len `mod` s_len /= 0) && (s_len `mod` t_len /= 0) =
  [
    [ Banked_Value (st !! x !! t) t x
      (flat_idx x t `mod` s_len) (flat_idx x t `div` s_len)
    | t <- [0..(t_len - 1)]] | x <- [0..(s_len - 1)]]
  where
    flat_idx x t = t_len * x + t
    s_len = length st
    t_len = length (st !! 0)
add_buffer_data_for_st st =
  [
    [ Banked_Value (st !! x !! t) t x
      (((flat_idx x t `mod` s_len) + (flat_idx x t `div` (max t_len s_len))) `mod` s_len)
      (flat_idx x t `div` s_len)
    | t <- [0..t_len - 1]] | x <- [0..s_len - 1]]
  where
    flat_idx x t = t_len * x + t
    s_len = length st
    t_len = length (st !! 0)

-- | given an [[Banked_Value]] representing a set of banks of memory
-- return the same structure in the order of the TSeq (SSeq) read from the bank
read_data_from_banks_for_st :: [[Banked_Value]] -> [[Banked_Value]]
read_data_from_banks_for_st banks | (t_len `mod` s_len /= 0) && (s_len `mod` t_len /= 0) =
  [
    [ banks !! (flat_idx x t `mod` s_len) !! (flat_idx x t `div` s_len)
    | t <- [0..(t_len - 1)]] | x <- [0..(s_len - 1)]]
  where
    flat_idx x t = t_len * x + t
    s_len = length banks
    t_len = length (banks !! 0)
read_data_from_banks_for_st banks =
  [
    [ banks !!
      (((flat_idx x t `mod` s_len) + (flat_idx x t `div` (max t_len s_len))) `mod` s_len) !!
      (flat_idx x t `div` s_len)
    | t <- [0..(t_len - 1)]] | x <- [0..(s_len - 1)]]
  where
    flat_idx x t = t_len * x + t
    s_len = length banks
    t_len = length (banks !! 0)
    
-- | given an [[Banked_Value]] where still organized by input TSeq (SSeq) or SSeq (TSeq) format
-- return a [[Input_Element_And_Clock]] where each outer array is a bank
-- and each inner element of the array is an address in the bank
reshape_to_banks :: [[Banked_Value]] -> [[Banked_Value]]
reshape_to_banks input_ordered_data = do
  let flattened_data = concat input_ordered_data
  -- groupBy only joins adjacent values, so need to sort first to merge all values
  -- that are same
  let sorted_by_bank = sortBy (\x y -> compare (bank_idx x) (bank_idx y)) flattened_data
  let grouped_by_bank = groupBy (\x y -> bank_idx x == bank_idx y) sorted_by_bank
  map (sortBy (\x y -> compare (addr_idx x) (addr_idx y))) grouped_by_bank

module Aetherling.Interpretations.Magma.Tester where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Aetherling.Monad_Helpers
import Data.List
import Debug.Trace

data Magma_Value_Element = Magma_Value_Element {
  magma_value :: String,
  mv_valid :: Bool,
  flat_s :: Int,
  flat_t :: Int
  } deriving (Show, Eq)

data Type_For_Magma =
  Int_For_Magma
  | Bit_For_Magma
  | ATuple_For_Magma AST_Type AST_Type
  deriving (Show, Eq)

type Flat_Idx_To_Magma_Val = Int -> Type_For_Magma -> String

generate_fault_inputs_for_st_type :: AST_Type -> Flat_Idx_To_Magma_Val -> String
generate_fault_inputs_for_st_type t conv_func = do
  let total_width = num_atoms_t t
  let total_time = clocks_t t
  let flat_results =
        generate_fault_inputs_for_st_type' t conv_func total_width total_time 0 0 True 0
  let sorted_results = sortBy (\x y -> compare (flat_t x) (flat_t y)) flat_results
  let grouped_by_t = groupBy (\x y -> flat_t x == flat_t y) sorted_results
  let grouped_and_sorted_by_s =
        map (sortBy (\x y -> compare (flat_s x) (flat_s y))) grouped_by_t
  let invs_filtered = filter (mv_valid . head) grouped_and_sorted_by_s
  let grouped_and_sorted_just_vals = map (map magma_value) invs_filtered
  -- need to filter out quotes from string printing
  filter (\x -> x /= '\"') $ show invs_filtered--grouped_and_sorted_just_vals

generate_fault_inputs_for_st_type' :: AST_Type -> Flat_Idx_To_Magma_Val ->
                                      Int -> Int -> Int -> Int -> Bool ->
                                      Int -> [Magma_Value_Element]
generate_fault_inputs_for_st_type' UnitT conv_func total_width
  total_time cur_space cur_time valid cur_idx = do
  [Magma_Value_Element "" valid cur_space cur_time]
generate_fault_inputs_for_st_type' BitT conv_func total_width
  total_time cur_space cur_time valid cur_idx = do
  [Magma_Value_Element (conv_func cur_idx Bit_For_Magma)
    valid cur_space cur_time]
generate_fault_inputs_for_st_type' IntT conv_func total_width
  total_time cur_space cur_time valid cur_idx = do
  [Magma_Value_Element (conv_func cur_idx Int_For_Magma)
    valid cur_space cur_time]
generate_fault_inputs_for_st_type' (ATupleT t0 t1) conv_func total_width
  total_time cur_space cur_time valid cur_idx = do
  [Magma_Value_Element (conv_func cur_idx (ATuple_For_Magma t0 t1))
    valid cur_space cur_time]
generate_fault_inputs_for_st_type' (STupleT n t) conv_func total_width
  total_time cur_space cur_time valid cur_idx = do
  let element_width = total_width `div` n
  let element_time = total_time
  let element_strs = [generate_fault_inputs_for_st_type' t conv_func
                      element_width element_time
                      (cur_space + j*element_width) cur_time
                      valid
                      (cur_idx + j*element_width)
                     | j <- [0..n-1]]
  concat element_strs
generate_fault_inputs_for_st_type' (SSeqT n t) conv_func total_width
  total_time cur_space cur_time valid cur_idx = do
  let element_width = total_width `div` n
  let element_time = total_time
  
  let element_strs = [generate_fault_inputs_for_st_type' t conv_func
                      element_width element_time
                      (cur_space + j*element_width) cur_time
                      valid
                      (cur_idx + j*element_width)
                     | j <- [0..n-1]]
  concat element_strs
generate_fault_inputs_for_st_type' (TSeqT n i t) conv_func total_width
  total_time cur_space cur_time valid cur_idx = do
  let element_width = total_width
  let element_time = total_time `div` n
  let element_strs = [generate_fault_inputs_for_st_type' t conv_func
                      element_width element_time
                      cur_space (cur_time + j * element_time)
                      (valid && j < n)
                      (cur_idx + i*element_time)
                     | j <- [0..(n+i)-1]]
  concat element_strs

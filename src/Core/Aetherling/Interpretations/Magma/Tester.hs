module Aetherling.Interpretations.Magma.Tester where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Aetherling.Monad_Helpers
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
  | ATuple_For_Magma Type_For_Magma Type_For_Magma
  deriving (Show, Eq)

type Flat_Idx_To_Magma_Val = Int -> Type_For_Magma -> String

generate_fault_inputs_for_st_type :: AST_Type -> Flat_Idx_To_Magma_Val -> String
generate_fault_inputs_for_st_type t conv_func = do
  let total_width = size_t t
  let total_valid_time = valid_clocks_t t
  generate_fault_inputs_for_st_type' t conv_func total_width total_valid_time 0 0 0
  undefined

generate_fault_inputs_for_st_type' :: AST_Type -> Flat_Idx_To_Magma_Val ->
                                      Int -> Int -> Int -> Int -> Int -> [Magma_Value_Element]
generate_fault_inputs_for_st_type' t@(ATupleT _ _) conv_func total_width
  total_valid_time cur_space cur_time
generate_fault_inputs_for_st_type' (STupleT n t) conv_func total_width
  total_valid_time cur_space cur_time cur_idx = do
  let element_width = total_width `div` n
  let element_valid_time = total_valid_time
  let element_strs = [generate_fault_inputs_for_st_type' t conv_func
                      element_width element_valid_time
                      (cur_space + i*element_width) cur_time
                      (cur_idx + i*element_valid_time)
                     | i <- [0..n-1]]
  concat element_strs
generate_fault_inputs_for_st_type' (SSeqT n t) conv_func total_width
  total_valid_time cur_space cur_time cur_idx = do
  let element_width = total_width `div` n
  let element_valid_time = total_valid_time
  let element_strs = [generate_fault_inputs_for_st_type' t conv_func
                      element_width element_valid_time
                      (cur_space + i*element_width) cur_time
                      (cur_idx + i*element_valid_time)
                     | i <- [0..n-1]]
  concat element_strs
generate_fault_inputs_for_st_type' (TSeqT n i t) conv_func total_width
  total_valid_time cur_space cur_time cur_idx = do
  let element_width = total_width
  let element_valid_time = total_valid_time `div` n
  let element_strs = [generate_fault_inputs_for_st_type' t conv_func
                      element_width element_valid_time
                      cur_space (cur_time + i * element_valid_time)
                      (cur_idx + i*element_valid_time)
                     | i <- [0..n-1]]
  concat element_strs

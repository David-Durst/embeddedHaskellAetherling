module Test_Big where
import Test.Tasty
import Test.Tasty.HUnit
import qualified Test_Slowdown as TS
import Aetherling.Monad_Helpers
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Isomorphisms
import Aetherling.Interpretations.Compute_Latency
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Aetherling.Rewrites.Sequence_Shallow_To_Deep
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Aetherling.Rewrites.Sequence_Assign_Indexes
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import Aetherling.Interpretations.Backend_Execute.Compile
import Control.Applicative
import Data.Proxy
import Data.Traversable
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Ratio



stencil_3_1dC_nested in_seq = do
  let shifted_once = shiftC (Proxy @1) in_seq
  let shifted_twice = shiftC (Proxy @1) shifted_once
  let window_tuple = map2C seq_tuple_appendC
                     (map2C seq_tupleC shifted_twice shifted_once)
                     in_seq
  let partitioned_tuple = partitionC Proxy (Proxy @1) window_tuple
  mapC seq_tuple_to_seqC partitioned_tuple
  
stencil_3x3_2dC_test in_col in_img = do
  let first_row = in_img
  let second_row = shiftC in_col in_img
  let third_row = shiftC in_col second_row
  let first_row_shifted = stencil_3_1dC_nested first_row
  let second_row_shifted = stencil_3_1dC_nested second_row
  let third_row_shifted = stencil_3_1dC_nested third_row
  let tuple = map2C seq_tupleC third_row_shifted second_row_shifted
  let triple = map2C seq_tuple_appendC tuple first_row_shifted
  let partitioned_triple = partitionC Proxy (Proxy @1) triple
  mapC seq_tuple_to_seqC partitioned_triple


stencil_2_1dC_nested in_seq = do
  let first_el = in_seq
  let second_el = shiftC (Proxy @1) first_el
  let tuple = map2C seq_tupleC second_el first_el
  let partitioned_tuple = partitionC Proxy (Proxy @1) tuple
  mapC seq_tuple_to_seqC partitioned_tuple
  
stencil_2x2_2dC_test in_col in_img = do
  let first_row = in_img
  let second_row = shiftC in_col in_img
  let third_row = shiftC in_col second_row
  let first_row_shifted = stencil_2_1dC_nested first_row
  let second_row_shifted = stencil_2_1dC_nested second_row
  let tuple = map2C seq_tupleC second_row_shifted first_row_shifted
  let partitioned_tuple = partitionC Proxy (Proxy @1) tuple
  mapC seq_tuple_to_seqC partitioned_tuple

tuple_2d_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @3) $
                    fmap (list_to_seq (Proxy @3)) $
                    fmap (fmap Atom_Int) hask_kernel
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel 
  let mul_result = mapC (mapC lslC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_Int 4]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC lsrC) sum_and_norm

hask_kernel_2x2 :: [[Int]] = [[0,2],[1,0]]
hask_kernel'_2x2 :: [Integer] = [1,4,2,1]
tuple_2d_2x2_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @2) $
                    fmap (list_to_seq (Proxy @2)) $
                    fmap (fmap Atom_Int) hask_kernel_2x2
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel
  let mul_result = mapC (mapC lslC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_Int 3]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC lsrC) sum_and_norm

conv_2d_shallow_no_input in_col in_seq = do
  let stencil = stencil_3x3_2dC_test in_col in_seq
  let conv_result = mapC tuple_2d_mul_shallow_no_input stencil
  unpartitionC (unpartitionC conv_result)


conv_2d_b2b_shallow_no_input in_col in_seq = do
  let first_stencil = stencil_3x3_2dC_test in_col in_seq
  let first_conv = unpartitionC $ unpartitionC $
        mapC tuple_2d_mul_shallow_no_input first_stencil
  let second_stencil = stencil_2x2_2dC_test in_col first_conv
  unpartitionC $ unpartitionC $
    mapC tuple_2d_2x2_mul_shallow_no_input second_stencil

row_size_big :: Integer = 1920
col_size_big :: Integer = 1080
img_size_big :: Int = fromInteger $ col_size_big*row_size_big
big_conv_2d = conv_2d_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_Int))
big_conv_2d_seq_idx = add_indexes $ seq_shallow_to_deep big_conv_2d
big_conv_2d_slowdowns = speed_to_slow [16, 8, 4, 2, 1, 1 % 3] (toInteger img_size_big)
big_conv_2d_ppar =
  fmap (\s -> compile_with_slowdown_to_expr big_conv_2d s) big_conv_2d_slowdowns
big_conv_2d_ppar_typechecked =
  fmap check_type big_conv_2d_ppar
big_conv_2d_ppar_typechecked' =
  fmap check_type_get_error big_conv_2d_ppar
big_conv_2d_inputs :: [[Integer]] = [[1..row_size_big*col_size_big]]
big_conv_2d_output :: [Integer] =
  conv_generator $ stencil_generator row_size_big [1.. row_size_big*col_size_big]
big_conv_2d_results = sequence $
  fmap (\s -> test_with_backend
              big_conv_2d (wrap_single_s s)
              Magma (Save_Gen_Verilog "big_conv2d")
              big_conv_2d_inputs big_conv_2d_output) big_conv_2d_slowdowns
big_conv_2d_results_chisel = sequence $
  fmap (\s -> test_with_backend
              big_conv_2d (wrap_single_s s)
              Chisel (Save_Gen_Verilog "big_conv2d")
              big_conv_2d_inputs big_conv_2d_output) big_conv_2d_slowdowns
big_conv_2d_results' = sequence $
  fmap (\s -> test_with_backend
              big_conv_2d (wrap_single_s s)
              Magma No_Verilog
              big_conv_2d_inputs big_conv_2d_output) [big_conv_2d_slowdowns !! 0]
big_conv_2d_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              big_conv_2d (wrap_single_s s)
              Chisel (Save_Gen_Verilog "big_conv2d")
              big_conv_2d_inputs big_conv_2d_output) [big_conv_2d_slowdowns !! 5]
big_conv_2d_st_prints = sequence $
  fmap (\s -> compile_to_file
              big_conv_2d (wrap_single_s s)
              text_backend "conv2d") big_conv_2d_slowdowns
big_conv_2d_verilog_prints = sequence $
  fmap (\s -> compile_to_file
              big_conv_2d (wrap_single_s s)
              Magma "conv2d") big_conv_2d_slowdowns

row_size_big_b2b = 1920
col_size_big_b2b = 1080
img_size_big_b2b :: Int = fromInteger $ col_size_big_b2b*row_size_big_b2b
big_conv_2d_b2b_slowdowns = speed_to_slow [16, 8, 4, 2, 1, 1 % 3] (toInteger img_size_big_b2b)
--big_conv_2d_b2b_slowdowns = speed_to_slow [1 % 3] (toInteger img_size_big_b2b)
big_conv_2d_b2b = conv_2d_b2b_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_Int))
big_conv_2d_b2b_seq_idx = add_indexes $ seq_shallow_to_deep big_conv_2d_b2b
big_conv_2d_b2b_ppar =
  fmap (\s -> compile_with_slowdown_to_expr big_conv_2d_b2b s) big_conv_2d_slowdowns
big_conv_2d_b2b_ppar_typechecked =
  fmap check_type big_conv_2d_b2b_ppar
big_conv_2d_b2b_ppar_typechecked' =
  fmap check_type_get_error big_conv_2d_b2b_ppar

conv_2x2_generator :: [[[Integer]]] -> [Integer]
conv_2x2_generator stencil_2d_output = [
  if window_valid
  then (sum $ zipWith (*) window_flat hask_kernel'_2x2) `mod` 255 `div` 8
  else int_to_ignore
  | window <- stencil_2d_output,
    let window_flat = concat window,
    let window_valid = not $ any (\x -> x == int_to_ignore) window_flat]

big_conv_2d_b2b_inputs :: [[Integer]] = [[1..row_size_big_b2b*col_size_big_b2b]]
big_conv_2d_b2b_output :: [Integer] =
  conv_2x2_generator $ stencil_2x2_generator row_size_big_b2b $
  conv_generator $ stencil_generator row_size_big_b2b [1..row_size_big_b2b*col_size_big_b2b]
big_conv_2d_b2b_results = sequence $
  fmap (\s -> test_with_backend
              big_conv_2d_b2b (wrap_single_s s)
              Magma (Save_Gen_Verilog "big_conv2d_b2b")
              big_conv_2d_b2b_inputs big_conv_2d_b2b_output) big_conv_2d_b2b_slowdowns
big_conv_2d_b2b_results_chisel = sequence $
  fmap (\s -> test_with_backend
              big_conv_2d_b2b (wrap_single_s s)
              Chisel (Save_Gen_Verilog "big_conv2d_b2b")
              big_conv_2d_b2b_inputs big_conv_2d_b2b_output) big_conv_2d_b2b_slowdowns


t_const :: Integer
t_const = 15
t_const' = 15
sharpen_one_pixel a_pixel b_pixel = do
  let b_sub_a = subC $ atom_tupleC b_pixel a_pixel
  let const_0 = (const_genC (Atom_Int 0) a_pixel)
  let abs_b_sub_a = absC b_sub_a
  let t_constC = const_genC (Atom_Int t_const') a_pixel
  let passed_threshold = ltC $ atom_tupleC t_constC abs_b_sub_a
  let h = ifC (atom_tupleC passed_threshold (atom_tupleC b_sub_a const_0))
  let alpha_h = lsrC $ atom_tupleC h (const_genC (Atom_Int 2) a_pixel)
  addC $ atom_tupleC b_pixel alpha_h
sharpen_one_pixel' :: Integer -> Integer -> Integer
sharpen_one_pixel' a b = do
  let h = if (abs $ b - a) > t_const then b - a else 0
  if a == int_to_ignore then a else b + (h `div` 4)

sharpen_shallow_no_input in_col in_seq = do
  let first_stencil = stencil_3x3_2dC_test in_col in_seq
  let branch_a = unpartitionC $ unpartitionC $
        mapC tuple_2d_mul_shallow_no_input first_stencil
  let branch_b = in_seq
  {-
  let b_sub_a = map2C (map2C $ map2C $ \x y -> (subC $ atom_tupleC x y)) branch_b branch_a
  let abs_b_sub_a = mapC (mapC $ mapC $ absC) b_sub_a
  let t_const = const_genC (Atom_Int 15) in_seq
  let passed_threshold = mapC (mapC $ mapC $ (\x -> ltC $ atom_tupleC t_const x)) abs_b_sub_a
   -}
  --let h = ifC (atom_tupleC passed_threshold (atom_tupleC b_sub_a (const_genC (Atom_Int 0) in_seq)))
  map2C sharpen_one_pixel branch_a branch_b

big_sharpen = sharpen_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_Int))
big_sharpen_seq_idx = add_indexes $ seq_shallow_to_deep big_sharpen
big_sharpen_ppar =
  fmap (\s -> compile_with_slowdown_to_expr big_sharpen s) [1,2,4,8,16,48,144]
big_sharpen_ppar_typechecked =
  fmap check_type big_sharpen_ppar
big_sharpen_ppar_typechecked' =
  fmap check_type_get_error big_sharpen_ppar
big_sharpen_inputs :: [[Integer]] = [[i * 5 | i <- [1..row_size_big * col_size_big]]]
big_sharpen_output :: [Integer] =
  zipWith sharpen_one_pixel' 
  (conv_generator $ stencil_generator row_size_big (big_sharpen_inputs !! 0))
  (big_sharpen_inputs !! 0)
big_sharpen_results = sequence $
  fmap (\s -> test_with_backend 
              big_sharpen (wrap_single_s s)
              Magma (Save_Gen_Verilog "big_sharpen")
              big_sharpen_inputs big_sharpen_output) big_conv_2d_slowdowns
big_sharpen_results_chisel = sequence $
  fmap (\s -> test_with_backend 
              big_sharpen (wrap_single_s s)
              Chisel (Save_Gen_Verilog "big_sharpen")
              big_sharpen_inputs big_sharpen_output) big_conv_2d_slowdowns

big_tests = testGroup "Big Tests"
  [
    --testCase "single big 3x3 convolution magma" $
    --(TS.all_success big_conv_2d_results') @? "single 3x3 convolution failed"
    testCase "single big 3x3 convolution chisel" $
    (TS.all_success big_conv_2d_results_chisel) @? "single 3x3 convolution chisel failed",
    testCase "big 3x3 conv to 2x2 conv chisel" $
    (TS.all_success big_conv_2d_b2b_results_chisel) @? "big 3x3 conv to 2x2 conv chisel failed",
    testCase "big sharpen chisel" $
    (TS.all_success big_sharpen_results_chisel) @? "big sharpen chisel failed"
  ]

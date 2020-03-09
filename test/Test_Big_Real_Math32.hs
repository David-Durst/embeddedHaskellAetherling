module Test_Big_Real_Math32 where
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
import Data.Word



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
                    fmap (fmap Atom_UInt32) hask_kernel_real32
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel 
  let mul_result = mapC (mapC mulC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_FixP1_7 (1/16)]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC divC) sum_and_norm

tuple_2d_2x2_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @2) $
                    fmap (list_to_seq (Proxy @2)) $
                    fmap (fmap Atom_UInt32) hask_kernel_2x2_real32
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel
  let mul_result = mapC (mapC mulC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_FixP1_7 (1/8)]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC divC) sum_and_norm

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

row_size_conv2d_big_real_32 :: Integer = 1920
col_size_conv2d_big_real_32 :: Integer = 1080
img_size_conv2d_big_real_32 :: Int = fromInteger $ col_size_conv2d_big_real_32*row_size_conv2d_big_real_32
big_real_32_conv_2d = conv_2d_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_UInt32))
big_real_32_conv_2d_seq_idx = add_indexes $ seq_shallow_to_deep big_real_32_conv_2d
big_real_32_conv_2d_throughputs = [16, 8, 4, 2, 1, 1 % 3]
--big_real_32_conv_2d_slowdowns = speed_to_slow [1] (toInteger img_size_conv2d_big_real_32)
big_real_32_conv_2d_ppar =
  fmap (\s -> compile_with_throughput_to_expr big_real_32_conv_2d s) big_real_32_conv_2d_throughputs
big_real_32_conv_2d_ppar_typechecked =
  fmap check_type big_real_32_conv_2d_ppar
big_real_32_conv_2d_ppar_typechecked' =
  fmap check_type_get_error big_real_32_conv_2d_ppar
big_real_32_conv_2d_inputs :: [[Word32]] = map (map fromIntegral) [[i*5 | i <- [1..row_size_conv2d_big_real_32*col_size_conv2d_big_real_32]]]
big_real_32_conv_2d_output :: [Word32] =
  conv_generator $ stencil_generator row_size_conv2d_big_real_32 (big_real_32_conv_2d_inputs !! 0)
big_real_32_conv_2d_results = sequence $
  fmap (\s -> test_with_backend
              big_real_32_conv_2d (wrap_single_t s)
              Magma (Save_Gen_Verilog "big_real_32_conv2d")
              big_real_32_conv_2d_inputs big_real_32_conv_2d_output) big_real_32_conv_2d_throughputs
big_real_32_conv_2d_results_chisel = sequence $
  fmap (\s -> test_with_backend
              big_real_32_conv_2d (wrap_single_t s)
              Chisel (Save_Gen_Verilog "big_real_32_conv2d")
              big_real_32_conv_2d_inputs big_real_32_conv_2d_output) big_real_32_conv_2d_throughputs
big_real_32_conv_2d_results' = sequence $
  fmap (\s -> test_with_backend
              big_real_32_conv_2d (wrap_single_t s)
              Magma No_Verilog
              big_real_32_conv_2d_inputs big_real_32_conv_2d_output) [big_real_32_conv_2d_throughputs !! 0]
big_real_32_conv_2d_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              big_real_32_conv_2d (wrap_single_t s)
              Chisel (Save_Gen_Verilog "big_real_32_conv2d")
              big_real_32_conv_2d_inputs big_real_32_conv_2d_output) [big_real_32_conv_2d_throughputs !! 5]
big_real_32_conv_2d_st_prints = sequence $
  fmap (\s -> compile_to_file
              big_real_32_conv_2d (wrap_single_t s)
              text_backend "conv2d") big_real_32_conv_2d_throughputs
big_real_32_conv_2d_verilog_prints = sequence $
  fmap (\s -> compile_to_file
              big_real_32_conv_2d (wrap_single_t s)
              Magma "conv2d") big_real_32_conv_2d_throughputs

row_size_big_real_32_b2b = 1920
col_size_big_real_32_b2b = 1080
img_size_big_real_32_b2b :: Int = fromInteger $ col_size_big_real_32_b2b*row_size_big_real_32_b2b
big_real_32_conv_2d_b2b_throughputs = [16, 8, 4, 2, 1, 1 % 3]
--big_real_32_conv_2d_b2b_slowdowns = speed_to_slow [1 % 3] (toInteger img_size_big_real_32_b2b)
big_real_32_conv_2d_b2b = conv_2d_b2b_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_UInt32))
big_real_32_conv_2d_b2b_seq_idx = add_indexes $ seq_shallow_to_deep big_real_32_conv_2d_b2b
big_real_32_conv_2d_b2b_ppar =
  fmap (\s -> compile_with_throughput_to_expr big_real_32_conv_2d_b2b s) big_real_32_conv_2d_b2b_throughputs
big_real_32_conv_2d_b2b_ppar_typechecked =
  fmap check_type big_real_32_conv_2d_b2b_ppar
big_real_32_conv_2d_b2b_ppar_typechecked' =
  fmap check_type_get_error big_real_32_conv_2d_b2b_ppar

big_real_32_conv_2d_b2b_inputs :: [[Word32]] = map (map fromIntegral) [[1..row_size_big_real_32_b2b*col_size_big_real_32_b2b]]
big_real_32_conv_2d_b2b_output :: [Word32] =
  conv_2x2_generator $ stencil_2x2_generator row_size_big_real_32_b2b $
  conv_generator $ stencil_generator row_size_big_real_32_b2b $
  head big_real_32_conv_2d_b2b_inputs
big_real_32_conv_2d_b2b_results = sequence $
  fmap (\s -> test_with_backend
              big_real_32_conv_2d_b2b (wrap_single_t s)
              Magma (Save_Gen_Verilog "big_real_32_conv2d_b2b")
              big_real_32_conv_2d_b2b_inputs big_real_32_conv_2d_b2b_output) big_real_32_conv_2d_b2b_throughputs
big_real_32_conv_2d_b2b_results_chisel = sequence $
  fmap (\s -> test_with_backend
              big_real_32_conv_2d_b2b (wrap_single_t s)
              Chisel (Save_Gen_Verilog "big_real_32_conv2d_b2b")
              big_real_32_conv_2d_b2b_inputs big_real_32_conv_2d_b2b_output) big_real_32_conv_2d_b2b_throughputs


t_const' = 15
sharpen_one_pixel a_pixel b_pixel = do
  let b_sub_a = subC $ atom_tupleC b_pixel a_pixel
  let a_sub_b = subC $ atom_tupleC a_pixel b_pixel
  let const_0 = (const_genC (Atom_UInt32 0) a_pixel)
  let t_constC = const_genC (Atom_UInt32 t_const') a_pixel
  let passed_threshold_b_sub_a = ltC $ atom_tupleC t_constC b_sub_a
  let passed_threshold_a_sub_b = ltC $ atom_tupleC t_constC a_sub_b
  let passed_thresholds = orC $ atom_tupleC passed_threshold_a_sub_b passed_threshold_b_sub_a
  let h = ifC (atom_tupleC passed_thresholds (atom_tupleC b_sub_a const_0))
  let alpha_h = divC $ atom_tupleC h (const_genC (Atom_FixP1_7 (1/4)) a_pixel)
  addC $ atom_tupleC b_pixel alpha_h

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

row_size_sharpen_big_real_32 :: Integer = 1920
col_size_sharpen_big_real_32 :: Integer = 1080
img_size_sharpen_big_real_32 :: Int = fromInteger $ col_size_sharpen_big_real_32*row_size_sharpen_big_real_32
big_real_32_sharpen = sharpen_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_UInt32))
big_real_32_sharpen_seq_idx = add_indexes $ seq_shallow_to_deep big_real_32_sharpen
big_real_32_sharpen_throughputs = [16, 8, 4, 2, 1, 1 % 3]
--big_real_32_sharpen_slowdowns = speed_to_slow [1] (toInteger img_size_sharpen_big_real_32)
big_real_32_sharpen_ppar =
  fmap (\s -> compile_with_throughput_to_expr big_real_32_sharpen s) big_real_32_sharpen_throughputs
big_real_32_sharpen_ppar_typechecked =
  fmap check_type big_real_32_sharpen_ppar
big_real_32_sharpen_ppar_typechecked' =
  fmap check_type_get_error big_real_32_sharpen_ppar
big_real_32_sharpen_inputs :: [[Word32]] = map (map fromIntegral) [[i * 5 | i <- [1..row_size_sharpen_big_real_32 * col_size_sharpen_big_real_32]]]
big_real_32_sharpen_output :: [Word32] =
  zipWith sharpen_one_pixel' 
  (conv_generator $ stencil_generator row_size_sharpen_big_real_32 (big_real_32_sharpen_inputs !! 0))
  (big_real_32_sharpen_inputs !! 0)
big_real_32_sharpen_results = sequence $
  fmap (\s -> test_with_backend 
              big_real_32_sharpen (wrap_single_t s)
              Magma (Save_Gen_Verilog "big_real_32_sharpen")
              big_real_32_sharpen_inputs big_real_32_sharpen_output) big_real_32_sharpen_throughputs
big_real_32_sharpen_results_chisel = sequence $
  fmap (\s -> test_with_backend 
              big_real_32_sharpen (wrap_single_t s)
              Chisel (Save_Gen_Verilog "big_real_32_sharpen")
              big_real_32_sharpen_inputs big_real_32_sharpen_output) big_real_32_sharpen_throughputs

big_real_32_tests = testGroup "Big Real 32 Tests"
  [
    --testCase "single big_real_32 3x3 convolution magma" $
    --(TS.all_success big_real_32_conv_2d_results') @? "single 3x3 convolution failed"
    testCase "single big_real_32 3x3 convolution chisel" $
    (TS.all_success big_real_32_conv_2d_results_chisel) @? "single 3x3 convolution chisel failed",
    testCase "big_real_32 3x3 conv to 2x2 conv chisel" $
    (TS.all_success big_real_32_conv_2d_b2b_results_chisel) @? "big_real_32 3x3 conv to 2x2 conv chisel failed",
    testCase "big_real_32 sharpen chisel" $
    (TS.all_success big_real_32_sharpen_results_chisel) @? "big_real_32 sharpen chisel failed"
  ]

big_real_32_tests' = testGroup "Big REal 32 Tests"
  [
    testCase "single big_real_32 3x3 convolution chisel" $
    (TS.all_success big_real_32_conv_2d_results_chisel') @? "single 3x3 convolution chisel failed"
  ]

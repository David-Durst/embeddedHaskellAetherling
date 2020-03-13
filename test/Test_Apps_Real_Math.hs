module Test_Apps_Real_Math where
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
import Data.Int

apps_tests_real_math_chisel = testGroup "Full Application Tests"
  [
    testCase "CONV with real math - single 3x3 convolution" $
    (TS.all_success conv_2d_real_results_chisel) @? "single 3x3 convolution failed",
    testCase "CONVB2B with real math - conv 3x3 to 2x2" $
    (TS.all_success conv_2d_real_b2b_results_chisel) @? "conv 3x3 to 2x2 failed",
    testCase "SHARPEN with real math" $
    (TS.all_success sharpen_real_results_chisel) @? "sharpen_real failed"
  ]

apps_paper_real_io = sequence [
  save_seq_test_io_as_json "paper_apps_8_real/conv2d" conv_2d_real_inputs conv_2d_real_output,
  save_seq_test_io_as_json "paper_apps_8_real/conv2d_b2b" conv_2d_real_b2b_inputs conv_2d_real_b2b_output,
  save_seq_test_io_as_json "paper_apps_8_real/sharpen" sharpen_real_inputs sharpen_real_output
  ]

stencil_3_1dC_nested in_seq = do
  let shifted_once = shiftC (Proxy @1) in_seq
  let shifted_twice = shiftC (Proxy @1) shifted_once
  let window_tuple = map2C seq_tuple_appendC
                     (map2C seq_tupleC shifted_twice shifted_once)
                     in_seq
  let partitioned_tuple = partitionC Proxy (Proxy @1) window_tuple
  mapC seq_tuple_to_seqC partitioned_tuple
  
stencil_3x3_2d_realC_test in_col in_img = do
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
stencil_2d_real_test = stencil_3x3_2d_realC_test (Proxy @4) $
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
stencil_2d_real_test_seq_idx = add_indexes $ seq_shallow_to_deep stencil_2d_real_test
stencil_2d_real_test_ppar = 
  fmap (\s -> compile_with_throughput_to_expr stencil_2d_real_test s) [16,8,4,2,1,1%3,1%9]
stencil_2d_real_test_ppar_typechecked =
  fmap check_type stencil_2d_real_test_ppar
stencil_2d_real_test_ppar_typechecked' =
  fmap check_type_get_error stencil_2d_real_test_ppar
row_size = 4
stencil_2d_real_inputs :: [[Word8]] = fmap (fmap fromIntegral) [[1..row_size*row_size]]
offset_if_valid offset i = if i > offset then i - offset else int_to_ignore
stencil_2d_real_output = stencil_generator row_size $ head stencil_2d_real_inputs
-- need to come back and check why slowest version uses a reduce_s
stencil_2d_real_results = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_real_test (wrap_single_t s)
              Magma No_Verilog
              stencil_2d_real_inputs stencil_2d_real_output)
  [16,8,4,2,1,1%3,1%9]
stencil_2d_real_results_chisel = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_real_test (wrap_single_t s)
              Chisel No_Verilog
              stencil_2d_real_inputs stencil_2d_real_output)
  [16,8,4,2,1,1%3,1%9]
stencil_2d_real_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_real_test (wrap_single_t s)
              Chisel (Save_Gen_Verilog "chisel_stencil_2d_real") 
              stencil_2d_real_inputs stencil_2d_real_output)
  [2]
stencil_2d_real_results' = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_real_test (wrap_single_t s)
              Magma (Save_Gen_Verilog "magma_stencil_2d_real")
              stencil_2d_real_inputs stencil_2d_real_output)
  [2]

tuple_2d_real_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @3) $
                    fmap (list_to_seq (Proxy @3)) $
                    fmap (fmap Atom_UInt8) hask_kernel_real
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel 
  let mul_result = mapC (mapC mulC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_FixP1_7 (1/16)]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC divC) sum_and_norm
tuple_2d_real_mul = tuple_2d_real_mul_shallow_no_input $
  com_input_seq "I" (Proxy :: Proxy (Seq 3 (Seq 3 Atom_UInt8)))
tuple_2d_real_mul_seq_idx = add_indexes $ seq_shallow_to_deep tuple_2d_real_mul
tuple_2d_real_mul_ppar =
  fmap (\s -> compile_with_throughput_to_expr tuple_2d_real_mul s) [1,1%3,1%9]
tuple_2d_real_mul_ppar_typechecked =
  fmap check_type tuple_2d_real_mul_ppar
tuple_2d_real_mul_ppar_typechecked' =
  fmap check_type_get_error tuple_2d_real_mul_ppar
tuple_2d_real_mul_inputs :: [[[Integer]]] = [[[1,2,3],[4,5,6],[7,8,9]]]
tuple_2d_real_mul_output :: [Integer] = [5]
tuple_2d_real_mul_results = sequence $
  fmap (\s -> test_with_backend
              tuple_2d_real_mul (wrap_single_t s)
              Magma No_Verilog
              tuple_2d_real_mul_inputs tuple_2d_real_mul_output) [1,3,9]
tuple_2d_real_mul_results_chisel = sequence $
  fmap (\s -> test_with_backend
              tuple_2d_real_mul (wrap_single_t s)
              Chisel No_Verilog
              tuple_2d_real_mul_inputs tuple_2d_real_mul_output) [1,3,9]

conv_2d_real_shallow_no_input in_col in_seq = do
  let stencil = stencil_3x3_2d_realC_test in_col in_seq
  let conv_result = mapC tuple_2d_real_mul_shallow_no_input stencil
  unpartitionC (unpartitionC conv_result)
conv_2d_real = conv_2d_real_shallow_no_input (Proxy @4) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
conv_2d_real_seq_idx = add_indexes $ seq_shallow_to_deep conv_2d_real
conv_2d_real_ppar =
  fmap (\s -> compile_with_throughput_to_expr conv_2d_real s) [16,8,4,2,1,1%3,1%9]
conv_2d_real_ppar' =
  fmap (\s -> compile_with_slowdown_to_expr conv_2d_real s) [1,2,4,8,16,48,144]
conv_2d_real_ppar_all_48 =
  compile_with_slowdown_to_all_possible_expr conv_2d_real 48
conv_2d_real_ppar_typechecked =
  fmap check_type conv_2d_real_ppar
conv_2d_real_ppar_typechecked' =
  fmap check_type_get_error conv_2d_real_ppar
conv_2d_real_inputs :: [[Word8]] = stencil_2d_real_inputs
conv_2d_real_output :: [Word8] = conv_generator $ stencil_generator row_size $ head stencil_2d_real_inputs
conv_2d_real_results = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real (wrap_single_t s)
              Magma (Save_Gen_Verilog "conv2d_real")
              conv_2d_real_inputs conv_2d_real_output) [16,8,4,2,1,1%3,1%9]
conv_2d_real_results_chisel = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d_real")
              conv_2d_real_inputs conv_2d_real_output) [16,8,4,2,1,1%3,1%9]
conv_2d_real_results_all_types = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "conv2d_real")
              conv_2d_real_inputs conv_2d_real_output) [1,2,4,8,16,48,144]
conv_2d_real_results' = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real (wrap_single_t s)
              Magma No_Verilog
              conv_2d_real_inputs conv_2d_real_output) [1%9]
conv_2d_real_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real (wrap_single_t s)
              Chisel No_Verilog
              conv_2d_real_inputs conv_2d_real_output) [1]
conv_2d_real_st_prints = sequence $
  fmap (\s -> compile_to_file
              conv_2d_real (wrap_single_t s)
              text_backend "conv2d_real") [16,8,4,2,1,1%3,1%9]
conv_2d_real_verilog_prints = sequence $
  fmap (\s -> compile_to_file
              conv_2d_real (wrap_single_t s)
              text_backend "conv2d_real") [16,8,4,2,1,1%3,1%9]


stencil_2_1dC_nested in_seq = do
  let first_el = in_seq
  let second_el = shiftC (Proxy @1) first_el
  let tuple = map2C seq_tupleC second_el first_el
  let partitioned_tuple = partitionC Proxy (Proxy @1) tuple
  mapC seq_tuple_to_seqC partitioned_tuple
  
stencil_2x2_2d_realC_test in_col in_img = do
  let first_row = in_img
  let second_row = shiftC in_col in_img
  let third_row = shiftC in_col second_row
  let first_row_shifted = stencil_2_1dC_nested first_row
  let second_row_shifted = stencil_2_1dC_nested second_row
  let tuple = map2C seq_tupleC second_row_shifted first_row_shifted
  let partitioned_tuple = partitionC Proxy (Proxy @1) tuple
  mapC seq_tuple_to_seqC partitioned_tuple

tuple_2d_real_2x2_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @2) $
                    fmap (list_to_seq (Proxy @2)) $
                    fmap (fmap Atom_UInt8) hask_kernel_2x2_real
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel
  let mul_result = mapC (mapC mulC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_FixP1_7 (1/8)]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC divC) sum_and_norm
  
conv_2d_real_b2b_shallow_no_input in_col in_seq = do
  let first_stencil = stencil_3x3_2d_realC_test in_col in_seq
  let first_conv = unpartitionC $ unpartitionC $
        mapC tuple_2d_real_mul_shallow_no_input first_stencil
  let second_stencil = stencil_2x2_2d_realC_test in_col first_conv
  unpartitionC $ unpartitionC $
    mapC tuple_2d_real_2x2_mul_shallow_no_input second_stencil
conv_2d_real_b2b = conv_2d_real_b2b_shallow_no_input (Proxy @4) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
conv_2d_real_b2b_seq_idx = add_indexes $ seq_shallow_to_deep conv_2d_real_b2b
conv_2d_real_b2b_ppar =
  fmap (\s -> compile_with_throughput_to_expr conv_2d_real_b2b s) [16,8,4,2,1,1%3,1%9]
conv_2d_real_b2b_ppar_typechecked =
  fmap check_type conv_2d_real_b2b_ppar
conv_2d_real_b2b_ppar_typechecked' =
  fmap check_type_get_error conv_2d_real_b2b_ppar

conv_2d_real_b2b_inputs :: [[Word8]] = stencil_2d_real_inputs
conv_2d_real_b2b_output :: [Word8] =
  conv_2x2_generator $ stencil_2x2_generator 4 $
  conv_generator $ stencil_generator 4 $ head stencil_2d_real_inputs
conv_2d_real_b2b_results = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real_b2b (wrap_single_t s)
              Magma (Save_Gen_Verilog "conv2d_real_b2b")
              conv_2d_real_b2b_inputs conv_2d_real_b2b_output) [16,8,4,2,1,1%3,1%9]
conv_2d_real_b2b_results_chisel = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real_b2b (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d_real_b2b")
              conv_2d_real_b2b_inputs conv_2d_real_b2b_output) [16,8,4,2,1,1%3,1%9]
conv_2d_real_b2b_results_all_types = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real_b2b (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "conv2d_real_b2b")
              conv_2d_real_b2b_inputs conv_2d_real_b2b_output) [1,2,4,8,16,48,144]

conv_2d_real_b2b_results' = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real_b2b (wrap_single_t s)
              Magma (Save_Gen_Verilog "conv2d_real_b2b")
              conv_2d_real_b2b_inputs conv_2d_real_b2b_output) [1%3]
conv_2d_real_b2b_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              conv_2d_real_b2b (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d_real_b2b")
              conv_2d_real_b2b_inputs conv_2d_real_b2b_output) [2]
conv_2d_real_b2b_print_st = sequence $ 
  fmap (\s -> compile_to_file
              conv_2d_real_b2b (wrap_single_t s)
              text_backend "conv2d_real_b2b") [16,8,4,2,1,1%3,1%9]
conv_2d_real_b2b_compile = sequence $ 
  fmap (\s -> compile_to_file
              conv_2d_real_b2b (wrap_single_t s)
              Magma "conv2d_real_b2b") [16,8,4,2,1,1%3,1%9]

t_const' = 15
sharpen_real_one_pixel a_pixel b_pixel = do
  let b_sub_a = subC $ atom_tupleC b_pixel a_pixel
  let a_sub_b = subC $ atom_tupleC a_pixel b_pixel
  let const_0 = (const_genC (Atom_UInt8 0) a_pixel)
  let t_constC = const_genC (Atom_UInt8 t_const') a_pixel
  let passed_threshold_b_sub_a = ltC $ atom_tupleC t_constC b_sub_a
  let passed_threshold_a_sub_b = ltC $ atom_tupleC t_constC a_sub_b
  let passed_thresholds = orC $ atom_tupleC passed_threshold_a_sub_b passed_threshold_b_sub_a
  let h = ifC (atom_tupleC passed_thresholds (atom_tupleC b_sub_a const_0))
  let alpha_h = divC $ atom_tupleC h (const_genC (Atom_FixP1_7 (1/4)) a_pixel)
  addC $ atom_tupleC b_pixel alpha_h
{-
sharpen_real_one_pixel a_pixel b_pixel = do
  let b_sub_a = subC $ atom_tupleC b_pixel a_pixel
  --let const_0 = (const_genC (Atom_Int 0) a_pixel)
  let const_t = (const_genC (Atom_Bit True) a_pixel)
  {-
  let abs_b_sub_a = absC b_sub_a
  let t_constC = const_genC (Atom_Int t_const') a_pixel
  let passed_threshold = ltC $ atom_tupleC t_constC abs_b_sub_a
  let h = ifC (atom_tupleC passed_threshold (atom_tupleC b_sub_a const_0))
-}
  let h = ifC (atom_tupleC const_t (atom_tupleC b_sub_a b_pixel))
  --let alpha_h = divC $ atom_tupleC h (const_genC (Atom_Int 5) a_pixel)
  --addC $ atom_tupleC b_pixel alpha_h
  --addC $ atom_tupleC h b_sub_a
  b_sub_a
-}
sharpen_real_one_pixel_map_no_input a_pixel b_pixel = do
  map2C sharpen_real_one_pixel a_pixel b_pixel 
sharpen_real_one_pixel_map = sharpen_real_one_pixel_map_no_input
  (com_input_seq "I0" (Proxy :: Proxy (Seq 2 Atom_UInt8)))
  (com_input_seq "I1" (Proxy :: Proxy (Seq 2 Atom_UInt8)))
sharpen_real_one_pixel_map_deep = seq_shallow_to_deep sharpen_real_one_pixel_map
sharpen_real_one_pixel_map_seq_idx = add_indexes $ seq_shallow_to_deep sharpen_real_one_pixel_map
sharpen_real_one_pixel_map_ppar =
  fmap (\s -> compile_with_throughput_to_expr sharpen_real_one_pixel_map s) [1,2]
sharpen_real_one_pixel_map_ppar_typechecked =
  fmap check_type sharpen_real_one_pixel_map_ppar
sharpen_real_one_pixel_map_ppar_typechecked' =
  fmap check_type_get_error sharpen_real_one_pixel_map_ppar
sharpen_real_one_pixel_map_inputs :: [[Word8]] = [[1,2],[2,30]]
sharpen_real_one_pixel_map_output :: [Word8] =
  zipWith sharpen_one_pixel'
  (sharpen_real_one_pixel_map_inputs !! 0) 
  (sharpen_real_one_pixel_map_inputs !! 1)
sharpen_real_one_pixel_map_results = sequence $
  fmap (\s -> test_with_backend
              sharpen_real_one_pixel_map (wrap_single_t s)
              Magma No_Verilog
              sharpen_real_one_pixel_map_inputs sharpen_real_one_pixel_map_output) [1,2]

sharpen_real_shallow_no_input in_col in_seq = do
  let first_stencil = stencil_3x3_2d_realC_test in_col in_seq
  let branch_a = unpartitionC $ unpartitionC $
        mapC tuple_2d_real_mul_shallow_no_input first_stencil
  let branch_b = in_seq
  {-
  let b_sub_a = map2C (map2C $ map2C $ \x y -> (subC $ atom_tupleC x y)) branch_b branch_a
  let abs_b_sub_a = mapC (mapC $ mapC $ absC) b_sub_a
  let t_const = const_genC (Atom_Int 15) in_seq
  let passed_threshold = mapC (mapC $ mapC $ (\x -> ltC $ atom_tupleC t_const x)) abs_b_sub_a
   -}
  --let h = ifC (atom_tupleC passed_threshold (atom_tupleC b_sub_a (const_genC (Atom_Int 0) in_seq)))
  map2C sharpen_real_one_pixel branch_a branch_b
-- haskell doesn't like it when both this and big sharpen_real are uncommented for unknown reason

sharpen_real = sharpen_real_shallow_no_input (Proxy @4) $
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
sharpen_real_seq_idx = add_indexes $ seq_shallow_to_deep sharpen_real
sharpen_real_ppar =
  fmap (\s -> compile_with_throughput_to_expr sharpen_real s) [16,8,4,2,1,1%3,1%9]
sharpen_real_ppar_typechecked =
  fmap check_type sharpen_real_ppar
sharpen_real_ppar_typechecked' =
  fmap check_type_get_error sharpen_real_ppar
sharpen_real_inputs :: [[Word8]] = fmap (fmap fromIntegral) [[i * 5 | i <- [1..row_size * row_size]]]
sharpen_real_output :: [Word8] =
  zipWith sharpen_one_pixel' 
  (conv_generator $ stencil_generator 4 (sharpen_real_inputs !! 0))
  (sharpen_real_inputs !! 0)
sharpen_real_results = sequence $
  fmap (\s -> test_with_backend 
              sharpen_real (wrap_single_t s)
              Magma (Save_Gen_Verilog "sharpen_real")
              sharpen_real_inputs sharpen_real_output) [16,8,4,2,1,1%3,1%9]
sharpen_real_results_chisel = sequence $
  fmap (\s -> test_with_backend 
              sharpen_real (wrap_single_t s)
              Chisel (Save_Gen_Verilog "sharpen_real")
              sharpen_real_inputs sharpen_real_output) [16,8,4,2,1,1%3,1%9]
sharpen_real_results_one = sequence $
  fmap (\s -> test_with_backend
              sharpen_real (wrap_single_t s)
              Magma (Save_Gen_Verilog "sharpen_real")
              sharpen_real_inputs sharpen_real_output) [48]
sharpen_real_results_all_types = sequence $
  fmap (\s -> test_with_backend 
              sharpen_real (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "sharpen_real")
              sharpen_real_inputs sharpen_real_output) [1,2,4,8,16,48,144]
sharpen_real_print_st = sequence $
  fmap (\s -> compile_to_file
              sharpen_real (wrap_single_t s)
              text_backend "sharpen_real") [16,8,4,2,1,1%3,1%9]

module Test_Apps where
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

apps_tests = testGroup "Full Application Tests"
  [
    testCase "MAP in paper" $
    (TS.all_success single_map_200_results) @? "map failed",
    testCase "CONV in paper - single 3x3 convolution" $
    (TS.all_success conv_2d_results) @? "single 3x3 convolution failed",
    testCase "pyramid" $
    (TS.all_success TS.pyramid_1d_results) @? "pyramid failed",
    testCase "CONVB2B in paper - conv 3x3 to 2x2" $
    (TS.all_success conv_2d_b2b_results) @? "conv 3x3 to 2x2 failed",
    testCase "conv 3x3 to 3x3" $
    (TS.all_success conv_2d_3x3_repeat_b2b_results) @? "conv 3x3 to 3x3 failed",
    testCase "SHARPEN in paper" $
    (TS.all_success sharpen_results) @? "sharpen failed"
  ]

apps_tests_chisel = testGroup "Full Application Tests"
  [
    --testCase "MAP in paper" $
    --(TS.all_success single_map_200_results_chisel) @? "map failed",
    --testCase "CONV in paper - single 3x3 convolution" $
    --(TS.all_success conv_2d_results_chisel) @? "single 3x3 convolution failed",
    testCase "CONVB2B in paper - conv 3x3 to 2x2" $
    (TS.all_success conv_2d_b2b_results_chisel) @? "conv 3x3 to 2x2 failed"--,
    --testCase "SHARPEN in paper" $
    --(TS.all_success sharpen_results_chisel) @? "sharpen failed"
  ]
all_types = sequence [single_map_200_results_all_types, conv_2d_results_all_types, conv_2d_results_all_types, --sharpen_results_all_types,
             TS.pyramid_1d_results_all_types]

add_5 atom_in = do
  let const = const_genC (Atom_UInt8 5) atom_in
  let tupled = atom_tupleC atom_in const
  addC tupled
single_map_200 = 
  mapC' (Proxy @200) add_5 $
  com_input_seq "I" (Proxy :: Proxy (Seq 200 Atom_UInt8))
single_map_200_seq_idx = add_indexes $ seq_shallow_to_deep single_map_200
single_map_200_ppar = fmap
  (\s -> compile_with_throughput_to_expr single_map_200 s)
  [1,2,4,5,8,10,20,40,200]
single_map_200_ppar_typechecked = fmap check_type single_map_200_ppar
single_map_200_inputs :: [[Word8]] = [[1..200]]
single_map_200_output :: [Word8] = [6..205]
-- sequence used to flip [] and IO so can print from command line
single_map_200_results = sequence $
  fmap (\s -> test_with_backend
              single_map_200 (wrap_single_t s)
              Magma (Save_Gen_Verilog "map")
              single_map_200_inputs single_map_200_output)
  [1,2,4,5,8,10,20,40,200]
single_map_200_results_chisel = sequence $
  fmap (\s -> test_with_backend
              single_map_200 (wrap_single_t s)
              Chisel (Save_Gen_Verilog "map")
              single_map_200_inputs single_map_200_output)
  [1,2,4,5,8,10,20,40,200]
single_map_200_results_all_types = sequence $
  fmap (\s -> test_with_backend
              single_map_200 (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "map")
              single_map_200_inputs single_map_200_output)
  [1,2,4,5,8,10,20,40,200]
single_map_200_st_prints = sequence $
  fmap (\s -> compile_to_file
              single_map_200 (wrap_single_t s)
              text_backend "map")
  [1,2,4,5,8,10,20,40,200]

single_map_200_results' = sequence $
  fmap (\s -> test_with_backend
              single_map_200 (wrap_single_t s)
              Magma (Save_Gen_Verilog "map")
              single_map_200_inputs single_map_200_output) [1]

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
stencil_2d_test = stencil_3x3_2dC_test (Proxy @4) $
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
stencil_2d_test_seq_idx = add_indexes $ seq_shallow_to_deep stencil_2d_test
stencil_2d_test_ppar = 
  fmap (\s -> compile_with_throughput_to_expr stencil_2d_test s) [16,8,4,2,1,1%3,1%9]
stencil_2d_test_ppar_typechecked =
  fmap check_type stencil_2d_test_ppar
stencil_2d_test_ppar_typechecked' =
  fmap check_type_get_error stencil_2d_test_ppar
row_size = 4
stencil_2d_inputs :: [[Word8]] = fmap (fmap fromIntegral) [[1..row_size*row_size]]
offset_if_valid offset i = if i > offset then i - offset else int_to_ignore
stencil_2d_output = stencil_generator row_size $ head stencil_2d_inputs
-- need to come back and check why slowest version uses a reduce_s
stencil_2d_results = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_test (wrap_single_t s)
              Magma No_Verilog
              stencil_2d_inputs stencil_2d_output)
  [16,8,4,2,1,1%3,1%9]
stencil_2d_results_chisel = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_test (wrap_single_t s)
              Chisel No_Verilog
              stencil_2d_inputs stencil_2d_output)
  [16,8,4,2,1,1%3,1%9]
stencil_2d_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_test (wrap_single_t s)
              Chisel (Save_Gen_Verilog "chisel_stencil_2d") 
              stencil_2d_inputs stencil_2d_output)
  [2]
stencil_2d_results' = sequence $
  fmap (\s -> test_with_backend
              stencil_2d_test (wrap_single_t s)
              Magma (Save_Gen_Verilog "magma_stencil_2d")
              stencil_2d_inputs stencil_2d_output)
  [2]

tuple_2d_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @3) $
                    fmap (list_to_seq (Proxy @3)) $
                    fmap (fmap Atom_UInt8) hask_kernel
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel 
  let mul_result = mapC (mapC lslC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_UInt8 4]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC lsrC) sum_and_norm
tuple_2d_mul = tuple_2d_mul_shallow_no_input $
  com_input_seq "I" (Proxy :: Proxy (Seq 3 (Seq 3 Atom_UInt8)))
tuple_2d_mul_seq_idx = add_indexes $ seq_shallow_to_deep tuple_2d_mul
tuple_2d_mul_ppar =
  fmap (\s -> compile_with_throughput_to_expr tuple_2d_mul s) [1,1%3,1%9]
tuple_2d_mul_ppar_typechecked =
  fmap check_type tuple_2d_mul_ppar
tuple_2d_mul_ppar_typechecked' =
  fmap check_type_get_error tuple_2d_mul_ppar
tuple_2d_mul_inputs :: [[[Integer]]] = [[[1,2,3],[4,5,6],[7,8,9]]]
tuple_2d_mul_output :: [Integer] = [5]
tuple_2d_mul_results = sequence $
  fmap (\s -> test_with_backend
              tuple_2d_mul (wrap_single_t s)
              Magma No_Verilog
              tuple_2d_mul_inputs tuple_2d_mul_output) [1,3,9]
tuple_2d_mul_results_chisel = sequence $
  fmap (\s -> test_with_backend
              tuple_2d_mul (wrap_single_t s)
              Chisel No_Verilog
              tuple_2d_mul_inputs tuple_2d_mul_output) [1,3,9]

conv_2d_shallow_no_input in_col in_seq = do
  let stencil = stencil_3x3_2dC_test in_col in_seq
  let conv_result = mapC tuple_2d_mul_shallow_no_input stencil
  unpartitionC (unpartitionC conv_result)
conv_2d = conv_2d_shallow_no_input (Proxy @4) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
conv_2d_seq_idx = add_indexes $ seq_shallow_to_deep conv_2d
conv_2d_ppar =
  fmap (\s -> compile_with_throughput_to_expr conv_2d s) [16,8,4,2,1,1%3,1%9]
conv_2d_ppar' =
  fmap (\s -> compile_with_slowdown_to_expr conv_2d s) [1,2,4,8,16,48,144]
conv_2d_ppar_all_48 =
  compile_with_slowdown_to_all_possible_expr conv_2d 48
conv_2d_ppar_typechecked =
  fmap check_type conv_2d_ppar
conv_2d_ppar_typechecked' =
  fmap check_type_get_error conv_2d_ppar
conv_2d_inputs :: [[Word8]] = stencil_2d_inputs
conv_2d_output :: [Word8] = conv_generator $ stencil_generator row_size $ head stencil_2d_inputs
conv_2d_results = sequence $
  fmap (\s -> test_with_backend
              conv_2d (wrap_single_t s)
              Magma (Save_Gen_Verilog "conv2d")
              conv_2d_inputs conv_2d_output) [16,8,4,2,1,1%3,1%9]
conv_2d_results_chisel = sequence $
  fmap (\s -> test_with_backend
              conv_2d (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d")
              conv_2d_inputs conv_2d_output) [16,8,4,2,1,1%3,1%9]
conv_2d_results_all_types = sequence $
  fmap (\s -> test_with_backend
              conv_2d (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "conv2d")
              conv_2d_inputs conv_2d_output) [1,2,4,8,16,48,144]
conv_2d_results' = sequence $
  fmap (\s -> test_with_backend
              conv_2d (wrap_single_t s)
              Magma No_Verilog
              conv_2d_inputs conv_2d_output) [1]
conv_2d_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              conv_2d (wrap_single_t s)
              Chisel No_Verilog
              conv_2d_inputs conv_2d_output) [1]
conv_2d_st_prints = sequence $
  fmap (\s -> compile_to_file
              conv_2d (wrap_single_t s)
              text_backend "conv2d") [16,8,4,2,1,1%3,1%9]
conv_2d_verilog_prints = sequence $
  fmap (\s -> compile_to_file
              conv_2d (wrap_single_t s)
              text_backend "conv2d") [16,8,4,2,1,1%3,1%9]


{-

down_from_pyramid_2d_no_input in_seq = do
  --let layer1_blurred = conv_2d_shallow_no_input (Proxy @8) in_seq
  let layer1_drop_cols = unpartitionC $ mapC (down_1dC 1) $
        partitionC (Proxy @32) (Proxy @2) Proxy (Proxy @0) in_seq  --layer1_blurred
  unpartitionC $ unpartitionC $
        mapC (down_1dC 1) $
        partitionC (Proxy @4) (Proxy @2) Proxy (Proxy @0) $
        partitionC (Proxy @8) (Proxy @4) Proxy (Proxy @0) layer1_drop_cols
  --layer1_blurred
down_from_pyramid_2d = down_from_pyramid_2d_no_input $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 64 (Seq 1 (Seq 1 Atom_Int))))
down_from_pyramid_2d_seq_idx = add_indexes $ seq_shallow_to_deep down_from_pyramid_2d
down_from_pyramid_2d_ppar =
  fmap (\s -> compile_with_slowdown_to_expr down_from_pyramid_2d s) [1,2,4,8,16,32,64]
down_and_upstream = STE.seq_in_st $ STE.seq_in_st $ down_from_pyramid_2d_ppar !! 5
just_down = down_and_upstream {
  STE.seq_in = STE.InputN (STT.TSeqT 4 0 (STT.TSeqT 2 0 (
                                     STT.TSeqT 4 0 (STT.SSeqT 1 (STT.SSeqT 1 STT.IntT)))))
           "I" (Index 37) }
just_down_latency = compute_latency just_down
big_reshape_and_upstream = STE.seq_in_st $ down_from_pyramid_2d_ppar !! 5
just_big_reshape = big_reshape_and_upstream {
  STE.seq_in = STE.InputN (STT.TSeqT 4 0 (STT.TSeqT 1 1 (
                                     STT.TSeqT 4 0 (STT.SSeqT 1 (STT.SSeqT 1 STT.IntT)))))
           "I" (Index 37) }
just_big_reshape_latency = compute_latency just_big_reshape
down_from_pyramid_2d_ppar_typechecked =
  fmap check_type down_from_pyramid_2d_ppar
down_from_pyramid_2d_ppar_typechecked' =
  fmap check_type_get_error down_from_pyramid_2d_ppar
down_from_pyramid_2d_inputs :: [[Integer]] = [[1..row_size_pyramid*row_size_pyramid]]
down_from_pyramid_2d_output :: [Integer] =
  down_generator [1..64]
  --conv_generator $ stencil_generator 8 [1..]
  --down_generator  $ conv_generator $ stencil_generator 8 [1..] 
down_from_pyramid_2d_results = sequence $
  fmap (\s -> test_with_backend
              down_from_pyramid_2d (wrap_single_s s)
              Magma No_Verilog
              down_from_pyramid_2d_inputs down_from_pyramid_2d_output) [192]


first_layer_pyr_shallow_no_input in_seq = do
  let layer1_blurred = conv_2d_shallow_no_input (Proxy @8) in_seq
  let layer1_drop_cols = unpartitionC $ mapC (down_1dC 1) $
        partitionC (Proxy @32) (Proxy @2) Proxy (Proxy @0) layer1_blurred
  unpartitionC $ unpartitionC $
        mapC (down_1dC 1) $
        partitionC (Proxy @4) (Proxy @2) Proxy (Proxy @0) $
        partitionC (Proxy @8) (Proxy @4) Proxy (Proxy @0) layer1_drop_cols
first_layer_pyr = first_layer_pyr_shallow_no_input $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 64 (Seq 1 (Seq 1 Atom_Int))))
first_layer_pyr_seq_idx = add_indexes $ seq_shallow_to_deep first_layer_pyr
first_layer_pyr_ppar =
  fmap (\s -> compile_with_slowdown_to_expr first_layer_pyr s) [1,2,4,8,16,32,64,192,576]
first_layer_pyr_ppar_typechecked =
  fmap check_type first_layer_pyr_ppar
first_layer_pyr_ppar_typechecked' =
  fmap check_type_get_error first_layer_pyr_ppar
first_layer_pyr_inputs :: [[Integer]] = [[1..row_size_pyramid*row_size_pyramid]]
first_layer_pyr_output :: [Integer] =
  down_generator  $ conv_generator $ stencil_generator 8 [1..] 
first_layer_pyr_results = sequence $
  fmap (\s -> test_with_backend
              first_layer_pyr (wrap_single_s s)
              Magma No_Verilog
              first_layer_pyr_inputs first_layer_pyr_output)
  [1,2,4,8,16,32,64,192,576]
first_layer_pyr_results' = sequence $
  fmap (\s -> test_with_backend 
              first_layer_pyr (wrap_single_s s)
              Magma No_Verilog
              first_layer_pyr_inputs first_layer_pyr_output)
  [2,4,8,16,32,64,192,576]
first_layer_pyr_results'' = sequence $
  fmap (\s -> test_with_backend
              first_layer_pyr (wrap_single_s s)
              Magma (Save_Gen_Verilog "pyramid")
              first_layer_pyr_inputs first_layer_pyr_output) [1]
first_layer_pyr_results''' = sequence $
  fmap (\s -> test_with_backend
              first_layer_pyr (wrap_single_s s)
              Magma (Save_Gen_Verilog "pyramid")
              first_layer_pyr_inputs first_layer_pyr_output) [576]


pyramid_2d_shallow_no_input in_seq = do
  let layer1_blurred = conv_2d_shallow_no_input (Proxy @8) in_seq
  let layer1_drop_cols = unpartitionC $ mapC (down_1dC 1) $
        partitionC (Proxy @32) (Proxy @2) Proxy (Proxy @0) layer1_blurred
  let layer2_input = unpartitionC $ unpartitionC $
        mapC (down_1dC 1) $
        partitionC (Proxy @4) (Proxy @2) Proxy (Proxy @0) $
        partitionC (Proxy @8) (Proxy @4) Proxy (Proxy @0) layer1_drop_cols
  let layer2_blurred = conv_2d_shallow_no_input (Proxy @4) layer2_input
  let layer2_drop_cols = unpartitionC $ mapC (down_1dC 1) $
        partitionC (Proxy @8) (Proxy @2) Proxy (Proxy @0) layer2_blurred
  unpartitionC $ unpartitionC $
        mapC (down_1dC 1) $
        partitionC (Proxy @2) (Proxy @2) Proxy (Proxy @0) $
        partitionC (Proxy @4) (Proxy @2) Proxy (Proxy @0) layer2_drop_cols
pyramid_2d = pyramid_2d_shallow_no_input $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 64 (Seq 1 (Seq 1 Atom_Int))))
pyramid_2d_seq_idx = add_indexes $ seq_shallow_to_deep pyramid_2d
pyramid_2d_ppar =
  fmap (\s -> compile_with_slowdown_to_expr pyramid_2d s) [1,2,4,8,16,32,64,192,576]
pyramid_2d_ppar_typechecked =
  fmap check_type pyramid_2d_ppar
pyramid_2d_ppar_typechecked' =
  fmap check_type_get_error pyramid_2d_ppar
row_size_pyramid = 8
down_generator :: [Integer] -> [Integer]
down_generator conv_output =
  [conv_output !! i
  | i <- [0..length conv_output-1],
    i `mod` 2 == 1 && (i `div` round (sqrt $ fromIntegral (length conv_output))) `mod` 2 == 1
   ]
pyramid_2d_inputs :: [[Integer]] = [[1..row_size_pyramid*row_size_pyramid]]
pyramid_2d_output :: [Integer] =
  down_generator $ conv_generator $ stencil_generator 4 $
  down_generator  $ conv_generator $ stencil_generator 8 [1..] 
pyramid_2d_results = sequence $
  fmap (\s -> test_with_backend 
              pyramid_2d (wrap_single_s s)
              Magma (Save_Gen_Verilog "pyramid")
              pyramid_2d_inputs pyramid_2d_output) [1,2,4,8,16,32,64,192,576]
pyramid_2d_results' = sequence $
  fmap (\s -> test_with_backend
              pyramid_2d (wrap_single_s s)
              Magma (Save_Gen_Verilog "pyramid")
              pyramid_2d_inputs pyramid_2d_output) [2,4,8,16,32,64,192,576]
pyramid_2d_results'' = sequence $
  fmap (\s -> test_with_backend
              pyramid_2d (wrap_single_s s)
              Magma (Save_Gen_Verilog "pyramid")
              pyramid_2d_inputs pyramid_2d_output) [1]
pyramid_2d_results''' = sequence $
  fmap (\s -> test_with_backend
              pyramid_2d (wrap_single_s s)
              Magma (Save_Gen_Verilog "pyramid")
              pyramid_2d_inputs pyramid_2d_output) [576]
pyramid_2d_prints = sequence $
  fmap (\s -> compile_to_file
              pyramid_2d (wrap_single_s s)
              text_backend "pyramid2dhueristic") [1,2,4,8,16,32,64,192,576]

-}
  
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

tuple_2d_2x2_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @2) $
                    fmap (list_to_seq (Proxy @2)) $
                    fmap (fmap Atom_UInt8) hask_kernel_2x2
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) in_seq kernel
  let mul_result = mapC (mapC lslC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_UInt8 3]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC lsrC) sum_and_norm
  
conv_2d_b2b_shallow_no_input in_col in_seq = do
  let first_stencil = stencil_3x3_2dC_test in_col in_seq
  let first_conv = unpartitionC $ unpartitionC $
        mapC tuple_2d_mul_shallow_no_input first_stencil
  let second_stencil = stencil_2x2_2dC_test in_col first_conv
  unpartitionC $ unpartitionC $
    mapC tuple_2d_2x2_mul_shallow_no_input second_stencil
conv_2d_b2b = conv_2d_b2b_shallow_no_input (Proxy @4) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
conv_2d_b2b_seq_idx = add_indexes $ seq_shallow_to_deep conv_2d_b2b
conv_2d_b2b_ppar =
  fmap (\s -> compile_with_throughput_to_expr conv_2d_b2b s) [16,8,4,2,1,1%3,1%9]
conv_2d_b2b_ppar_typechecked =
  fmap check_type conv_2d_b2b_ppar
conv_2d_b2b_ppar_typechecked' =
  fmap check_type_get_error conv_2d_b2b_ppar

conv_2d_b2b_inputs :: [[Word8]] = stencil_2d_inputs
conv_2d_b2b_output :: [Word8] =
  conv_2x2_generator $ stencil_2x2_generator 4 $
  conv_generator $ stencil_generator 4 $ head stencil_2d_inputs
conv_2d_b2b_results = sequence $
  fmap (\s -> test_with_backend
              conv_2d_b2b (wrap_single_t s)
              Magma (Save_Gen_Verilog "conv2d_b2b")
              conv_2d_b2b_inputs conv_2d_b2b_output) [16,8,4,2,1,1%3,1%9]
conv_2d_b2b_results_chisel = sequence $
  fmap (\s -> test_with_backend
              conv_2d_b2b (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d_b2b")
              conv_2d_b2b_inputs conv_2d_b2b_output) [16,8,4,2,1,1%3,1%9]
conv_2d_b2b_results_all_types = sequence $
  fmap (\s -> test_with_backend
              conv_2d_b2b (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "conv2d_b2b")
              conv_2d_b2b_inputs conv_2d_b2b_output) [1,2,4,8,16,48,144]

conv_2d_b2b_results' = sequence $
  fmap (\s -> test_with_backend
              conv_2d_b2b (wrap_single_t s)
              Magma (Save_Gen_Verilog "conv2d_b2b")
              conv_2d_b2b_inputs conv_2d_b2b_output) [2]
conv_2d_b2b_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              conv_2d_b2b (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d_b2b")
              conv_2d_b2b_inputs conv_2d_b2b_output) [2]
conv_2d_b2b_print_st = sequence $ 
  fmap (\s -> compile_to_file
              conv_2d_b2b (wrap_single_t s)
              text_backend "conv2d_b2b") [16,8,4,2,1,1%3,1%9]
conv_2d_b2b_compile = sequence $ 
  fmap (\s -> compile_to_file
              conv_2d_b2b (wrap_single_t s)
              Magma "conv2d_b2b") [16,8,4,2,1,1%3,1%9]


conv_2d_3x3_repeat_b2b_shallow_no_input in_col in_seq = do
  let first_stencil = stencil_3x3_2dC_test in_col in_seq
  let first_conv = unpartitionC $ unpartitionC $
        mapC tuple_2d_mul_shallow_no_input first_stencil
  let second_stencil = stencil_3x3_2dC_test in_col first_conv
  unpartitionC $ unpartitionC $
    mapC tuple_2d_mul_shallow_no_input second_stencil
conv_2d_3x3_repeat_b2b = conv_2d_3x3_repeat_b2b_shallow_no_input (Proxy @4) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
conv_2d_3x3_repeat_b2b_seq_idx = add_indexes $ seq_shallow_to_deep conv_2d_3x3_repeat_b2b
conv_2d_3x3_repeat_b2b_ppar =
  fmap (\s -> compile_with_throughput_to_expr conv_2d_3x3_repeat_b2b s) [16,8,4,2,1,1%3,1%9]
conv_2d_3x3_repeat_b2b_ppar_typechecked =
  fmap check_type conv_2d_3x3_repeat_b2b_ppar
conv_2d_3x3_repeat_b2b_ppar_typechecked' =
  fmap check_type_get_error conv_2d_3x3_repeat_b2b_ppar
conv_2d_3x3_repeat_b2b_inputs :: [[Word8]] = stencil_2d_inputs
conv_2d_3x3_repeat_b2b_output :: [Word8] =
  conv_generator $ stencil_generator 4 $
  conv_generator $ stencil_generator 4 $ head stencil_2d_inputs
conv_2d_3x3_repeat_b2b_results = sequence $
  fmap (\s -> test_with_backend
              conv_2d_3x3_repeat_b2b (wrap_single_t s)
              Magma (Save_Gen_Verilog "conv2d_b2b_3x3_repeat")
              conv_2d_3x3_repeat_b2b_inputs conv_2d_3x3_repeat_b2b_output)
  [16,8,4,2,1,1%3,1%9]
conv_2d_3x3_repeat_b2b_results_chisel = sequence $
  fmap (\s -> test_with_backend
              conv_2d_3x3_repeat_b2b (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d_b2b_3x3_repeat")
              conv_2d_3x3_repeat_b2b_inputs conv_2d_3x3_repeat_b2b_output)
  [16,8,4,2,1,1%3,1%9]
conv_2d_3x3_repeat_b2b_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              conv_2d_3x3_repeat_b2b (wrap_single_t s)
              Chisel (Save_Gen_Verilog "conv2d_b2b_3x3_repeat")
              conv_2d_3x3_repeat_b2b_inputs conv_2d_3x3_repeat_b2b_output)
  [2]

conv_2d_3x3_repeat_b2b_print_st = sequence $
  fmap (\s -> compile_to_file
              conv_2d_3x3_repeat_b2b (wrap_single_t s)
              Magma "conv2d_b2b_3x3_repeat") [1,2,4,8,16,48,144]

t_const' = 15
sharpen_one_pixel a_pixel b_pixel = do
  let b_sub_a = subC $ atom_tupleC b_pixel a_pixel
  let a_sub_b = subC $ atom_tupleC a_pixel b_pixel
  let const_0 = (const_genC (Atom_UInt8 0) a_pixel)
  let t_constC = const_genC (Atom_UInt8 t_const') a_pixel
  let passed_threshold_b_sub_a = ltC $ atom_tupleC t_constC b_sub_a
  let passed_threshold_a_sub_b = ltC $ atom_tupleC t_constC a_sub_b
  let passed_thresholds = orC $ atom_tupleC passed_threshold_a_sub_b passed_threshold_b_sub_a
  let h = ifC (atom_tupleC passed_thresholds (atom_tupleC b_sub_a const_0))
  let alpha_h = lsrC $ atom_tupleC h (const_genC (Atom_UInt8 2) a_pixel)
  addC $ atom_tupleC b_pixel alpha_h
{-
sharpen_one_pixel a_pixel b_pixel = do
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
sharpen_one_pixel_map_no_input a_pixel b_pixel = do
  map2C sharpen_one_pixel a_pixel b_pixel 
sharpen_one_pixel_map = sharpen_one_pixel_map_no_input
  (com_input_seq "I0" (Proxy :: Proxy (Seq 2 Atom_UInt8)))
  (com_input_seq "I1" (Proxy :: Proxy (Seq 2 Atom_UInt8)))
sharpen_one_pixel_map_deep = seq_shallow_to_deep sharpen_one_pixel_map
sharpen_one_pixel_map_seq_idx = add_indexes $ seq_shallow_to_deep sharpen_one_pixel_map
sharpen_one_pixel_map_ppar =
  fmap (\s -> compile_with_throughput_to_expr sharpen_one_pixel_map s) [1,2]
sharpen_one_pixel_map_ppar_typechecked =
  fmap check_type sharpen_one_pixel_map_ppar
sharpen_one_pixel_map_ppar_typechecked' =
  fmap check_type_get_error sharpen_one_pixel_map_ppar
sharpen_one_pixel_map_inputs :: [[Word8]] = [[1,2],[2,30]]
sharpen_one_pixel_map_output :: [Word8] =
  zipWith sharpen_one_pixel'
  (sharpen_one_pixel_map_inputs !! 0) 
  (sharpen_one_pixel_map_inputs !! 1)
sharpen_one_pixel_map_results = sequence $
  fmap (\s -> test_with_backend
              sharpen_one_pixel_map (wrap_single_t s)
              Magma No_Verilog
              sharpen_one_pixel_map_inputs sharpen_one_pixel_map_output) [1,2]

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
-- haskell doesn't like it when both this and big sharpen are uncommented for unknown reason

sharpen = sharpen_shallow_no_input (Proxy @4) $
  com_input_seq "I" (Proxy :: Proxy (Seq 16 Atom_UInt8))
sharpen_seq_idx = add_indexes $ seq_shallow_to_deep sharpen
sharpen_ppar =
  fmap (\s -> compile_with_throughput_to_expr sharpen s) [16,8,4,2,1,1%3,1%9]
sharpen_ppar_typechecked =
  fmap check_type sharpen_ppar
sharpen_ppar_typechecked' =
  fmap check_type_get_error sharpen_ppar
sharpen_inputs :: [[Word8]] = fmap (fmap fromIntegral) [[i * 5 | i <- [1..row_size * row_size]]]
sharpen_output :: [Word8] =
  zipWith sharpen_one_pixel' 
  (conv_generator $ stencil_generator 4 (sharpen_inputs !! 0))
  (sharpen_inputs !! 0)
sharpen_results = sequence $
  fmap (\s -> test_with_backend 
              sharpen (wrap_single_t s)
              Magma (Save_Gen_Verilog "sharpen")
              sharpen_inputs sharpen_output) [16,8,4,2,1,1%3,1%9]
sharpen_results_chisel = sequence $
  fmap (\s -> test_with_backend 
              sharpen (wrap_single_t s)
              Chisel (Save_Gen_Verilog "sharpen")
              sharpen_inputs sharpen_output) [16,8,4,2,1,1%3,1%9]
sharpen_results_one = sequence $
  fmap (\s -> test_with_backend
              sharpen (wrap_single_t s)
              Magma (Save_Gen_Verilog "sharpen")
              sharpen_inputs sharpen_output) [48]
sharpen_results_all_types = sequence $
  fmap (\s -> test_with_backend 
              sharpen (All_With_Slowdown_Factor s)
              Magma (Save_Gen_Verilog "sharpen")
              sharpen_inputs sharpen_output) [1,2,4,8,16,48,144]
sharpen_print_st = sequence $
  fmap (\s -> compile_to_file
              sharpen (wrap_single_t s)
              text_backend "sharpen") [16,8,4,2,1,1%3,1%9]

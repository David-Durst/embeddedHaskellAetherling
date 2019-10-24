module Test_Apps where
import Test.Tasty
import Test.Tasty.HUnit
import Aetherling.Monad_Helpers
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Isomorphisms
import Aetherling.Interpretations.Latency
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Aetherling.Rewrites.Sequence_Shallow_To_Deep
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
import Aetherling.Rewrites.Sequence_Assign_Indexes
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import Aetherling.Interpretations.Magma.Compile
import Aetherling.Interpretations.Magma.Tester
import Data.Proxy
import Data.Traversable
import GHC.TypeLits
import GHC.TypeLits.Extra

add_5 atom_in = do
  let const = const_genC (Atom_Int 5) atom_in
  let tupled = atom_tupleC atom_in const
  addC tupled
single_map_200 = 
  mapC' (Proxy @200) add_5 $
  com_input_seq "I" (Proxy :: Proxy (Seq 200 0 Atom_Int))
single_map_200_seq_idx = add_indexes $ seq_shallow_to_deep single_map_200
single_map_200_ppar = fmap (\s -> rewrite_to_partially_parallel s single_map_200_seq_idx) [1,5,10,20,25,40,50,100,200]
single_map_200_ppar_typechecked = fmap check_type single_map_200_ppar
single_map_200_inputs :: [[Integer]] = [[1..200]]
single_map_200_output :: [Integer] = [6..205]
-- sequence used to flip [] and IO so can print from command line
single_map_200_results = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                                single_map_200 s (Just "map")
                                                single_map_200_inputs single_map_200_output) [1,5,10,20,25,40,50,100,200]

stencil_3_1dC_nested in_seq = do
  let first_el = in_seq
  let second_el = shiftC (Proxy @1) first_el
  let third_el = shiftC (Proxy @1) second_el
  let tuple = map2C (map2C $ map2C seq_tupleC) third_el second_el 
  let triple = map2C (map2C $ map2C seq_tuple_appendC) tuple first_el 
  mapC (mapC seq_tuple_to_seqC) triple
  
stencil_3x3_2dC_test in_col in_img = do
  let first_row = in_img
  let second_row = shiftC in_col in_img
  let third_row = shiftC in_col second_row
  let first_row_shifted = stencil_3_1dC_nested first_row
  let second_row_shifted = stencil_3_1dC_nested second_row
  let third_row_shifted = stencil_3_1dC_nested third_row
  let tuple = map2C (map2C seq_tupleC) third_row_shifted second_row_shifted
  let triple = map2C (map2C seq_tuple_appendC) tuple first_row_shifted
  mapC seq_tuple_to_seqC triple
stencil_2d_test = stencil_3x3_2dC_test (Proxy @4) $
  com_input_seq "hi" (Proxy :: Proxy (Seq 16 0 (Seq 1 2 (Seq 1 2 Atom_Int))))
stencil_2d_test_seq_idx = add_indexes $ seq_shallow_to_deep stencil_2d_test
stencil_2d_test_ppar = 
  fmap (\s -> rewrite_to_partially_parallel s stencil_2d_test_seq_idx) [1,2,4,8,16,48,144]
stencil_2d_test_ppar_typechecked =
  fmap check_type stencil_2d_test_ppar
stencil_2d_test_ppar_typechecked' =
  fmap check_type_get_error stencil_2d_test_ppar
row_size = 4
stencil_2d_inputs :: [[Integer]] = [[1..row_size*row_size]]
offset_if_valid offset i = if i > offset then i - offset else int_to_ignore
stencil_generator :: Integer -> [Integer] -> [[[Integer]]]
stencil_generator row_size inputs = [
  [
    if r - k > 0
    then 
      [
        if c > 2 then inputs !! ((fromIntegral $ (r-k-1) * row_size + (c-2)) -1) else int_to_ignore,
        if (c > 1) && (c <= row_size + 1) then inputs !! ((fromIntegral $ (r-k-1) * row_size + (c-1)) -1) else int_to_ignore,
        if c <= row_size then inputs !! ((fromIntegral $ (r-k-1) * row_size + c) - 1) else int_to_ignore
      ]
    else [int_to_ignore, int_to_ignore, int_to_ignore]
  | k <- reverse $ [0..2]
  ] | r <- [1..row_size], c <- [1..row_size]]
stencil_2d_output :: [[[Integer]]] = [
  [
    if r - k > 0
    then 
      [
        if c > 2 then (r-k-1) * row_size + (c-2) else int_to_ignore,
        if (c > 1) && (c <= row_size + 1) then (r-k-1) * row_size + (c-1) else int_to_ignore,
        if c <= row_size then (r-k-1) * row_size + c else int_to_ignore
      ]
    else [int_to_ignore, int_to_ignore, int_to_ignore]
  | k <- reverse $ [0..2]
  ] | r <- [1..row_size], c <- [1..row_size]]
-- need to come back and check why slowest version uses a reduce_s
stencil_2d_results = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      stencil_2d_test s Nothing
                                      stencil_2d_inputs stencil_2d_output) [1,2,4,8,16,48,144]
stencil_2d_results' = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      stencil_2d_test s Nothing
                                      stencil_2d_inputs stencil_2d_output) [144]

                     
-- need thse for Integer and Int versions
hask_kernel :: [[Int]] = [[1,2,1],[2,4,2],[1,2,1]]
hask_kernel' :: [Integer] = [1,2,1,2,4,2,1,2,1]
tuple_2d_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @3) $
                    fmap (list_to_seq (Proxy @3)) $
                    fmap (fmap Atom_Int) hask_kernel
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) kernel in_seq
  let mul_result = mapC (mapC mulC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_Int 16]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC divC) sum_and_norm
tuple_2d_mul = tuple_2d_mul_shallow_no_input $
  com_input_seq "I" (Proxy :: Proxy (Seq 3 0 (Seq 3 0 Atom_Int)))
tuple_2d_mul_seq_idx = add_indexes $ seq_shallow_to_deep tuple_2d_mul
tuple_2d_mul_ppar =
  fmap (\s -> rewrite_to_partially_parallel s tuple_2d_mul_seq_idx) [1,3,9]
tuple_2d_mul_ppar_typechecked =
  fmap check_type tuple_2d_mul_ppar
tuple_2d_mul_ppar_typechecked' =
  fmap check_type_get_error tuple_2d_mul_ppar
tuple_2d_mul_inputs :: [[[Integer]]] = [[[1,2,3],[4,5,6],[7,8,9]]]
tuple_2d_mul_output :: [Integer] = [5]
tuple_2d_mul_results = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      tuple_2d_mul s Nothing
                                      tuple_2d_mul_inputs tuple_2d_mul_output) [1,3,9]

conv_2d_shallow_no_input in_col in_seq = do
  let stencil = stencil_3x3_2dC_test in_col in_seq
  mapC tuple_2d_mul_shallow_no_input stencil
conv_2d = conv_2d_shallow_no_input (Proxy @4) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 16 0 (Seq 1 2 (Seq 1 2 Atom_Int))))
conv_2d_seq_idx = add_indexes $ seq_shallow_to_deep conv_2d
conv_2d_ppar =
  fmap (\s -> rewrite_to_partially_parallel s conv_2d_seq_idx) [1,2,4,8,16,48,144]
conv_2d_ppar_typechecked =
  fmap check_type conv_2d_ppar
conv_2d_ppar_typechecked' =
  fmap check_type_get_error conv_2d_ppar
conv_2d_inputs :: [[Integer]] = stencil_2d_inputs
conv_generator :: [[[Integer]]] -> [Integer]
conv_generator stencil_2d_output = [
  if window_valid
  then (sum $ zipWith (*) window_flat hask_kernel') `mod` 255 `div` 16
  else int_to_ignore
  | window <- stencil_2d_output,
    let window_flat = concat window,
    let window_valid = not $ any (\x -> x == int_to_ignore) window_flat]
conv_2d_output :: [Integer] = [
  if window_valid
  then (sum $ zipWith (*) window_flat hask_kernel') `mod` 255 `div` 16
  else int_to_ignore
  | window <- stencil_2d_output,
    let window_flat = concat window,
    let window_valid = not $ any (\x -> x == int_to_ignore) window_flat]
conv_2d_results = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      conv_2d s (Just "conv2d")
                                      conv_2d_inputs conv_2d_output) [1,2,4,8,16,48,144]
conv_2d_results' = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      conv_2d s Nothing
                                      conv_2d_inputs conv_2d_output) [144]
conv_2d_st_prints = sequence $ fmap (\s -> compile_and_write_st_with_slowdown
                                      conv_2d s "conv2d") [1,2,4,8,16,48,144]
conv_2d_verilog_prints = sequence $ fmap (\s -> compile_with_slowdown
                                      conv_2d s "conv2d") [1,2,4,8,16,48,144]



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
  com_input_seq "hi" (Proxy :: Proxy (Seq 64 0 (Seq 1 2 (Seq 1 2 Atom_Int))))
down_from_pyramid_2d_seq_idx = add_indexes $ seq_shallow_to_deep down_from_pyramid_2d
down_from_pyramid_2d_ppar =
  fmap (\s -> rewrite_to_partially_parallel s down_from_pyramid_2d_seq_idx) [1,2,4,8,16,32,64]
down_and_upstream = STE.seq_in_st $ STE.seq_in_st $ down_from_pyramid_2d_ppar !! 5
just_down = down_and_upstream {
  STE.seq_in = STE.InputN (STT.TSeqT 4 0 (STT.TSeqT 2 0 (
                                     STT.TSeqT 4 0 (STT.SSeqT 1 (STT.SSeqT 1 STT.IntT)))))
           "I" (Index 37) }
just_down_latency = print_latency just_down
big_reshape_and_upstream = STE.seq_in_st $ down_from_pyramid_2d_ppar !! 5
just_big_reshape = big_reshape_and_upstream {
  STE.seq_in = STE.InputN (STT.TSeqT 4 0 (STT.TSeqT 1 1 (
                                     STT.TSeqT 4 0 (STT.SSeqT 1 (STT.SSeqT 1 STT.IntT)))))
           "I" (Index 37) }
just_big_reshape_latency = print_latency just_big_reshape
down_from_pyramid_2d_ppar_typechecked =
  fmap check_type down_from_pyramid_2d_ppar
down_from_pyramid_2d_ppar_typechecked' =
  fmap check_type_get_error down_from_pyramid_2d_ppar
down_from_pyramid_2d_inputs :: [[Integer]] = [[1..row_size_pyramid*row_size_pyramid]]
down_from_pyramid_2d_output :: [Integer] =
  down_generator [1..64]
  --conv_generator $ stencil_generator 8 [1..]
  --down_generator  $ conv_generator $ stencil_generator 8 [1..] 
down_from_pyramid_2d_results = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      down_from_pyramid_2d s Nothing 
                                      down_from_pyramid_2d_inputs down_from_pyramid_2d_output) [32]


  
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
  com_input_seq "hi" (Proxy :: Proxy (Seq 64 0 (Seq 1 2 (Seq 1 2 Atom_Int))))
pyramid_2d_seq_idx = add_indexes $ seq_shallow_to_deep pyramid_2d
pyramid_2d_ppar =
  fmap (\s -> rewrite_to_partially_parallel s pyramid_2d_seq_idx) [1,2,4,8,16,32,64,192,576]
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
pyramid_2d_results = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      pyramid_2d s (Just "pyramid")
                                      pyramid_2d_inputs pyramid_2d_output) [1,2,4,8,16,32,64,192,576]
pyramid_2d_results' = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      pyramid_2d s (Just "pyramid")
                                      pyramid_2d_inputs pyramid_2d_output) [2,4,8,16,32,64,192,576]
pyramid_2d_results'' = sequence $ fmap (\s -> compile_with_slowdown
                                      pyramid_2d s "pyramid") [1]


  
stencil_2_1dC_nested in_seq = do
  let first_el = in_seq
  let second_el = shiftC (Proxy @1) first_el
  let tuple = map2C (map2C $ map2C seq_tupleC) second_el first_el
  mapC (mapC seq_tuple_to_seqC) tuple
  
stencil_2x2_2dC_test in_col in_img = do
  let first_row = in_img
  let second_row = shiftC in_col in_img
  let third_row = shiftC in_col second_row
  let first_row_shifted = stencil_2_1dC_nested first_row
  let second_row_shifted = stencil_2_1dC_nested second_row
  let tuple = map2C (map2C $ seq_tupleC) second_row_shifted first_row_shifted
  mapC seq_tuple_to_seqC tuple
stencil_2x2_generator :: Integer -> [Integer] -> [[[Integer]]]
stencil_2x2_generator row_size inputs = [
  [
    if r - k > 0
    then 
      [
        if c > 1 then inputs !! ((fromIntegral $ (r-k-1) * row_size + (c-1)) -1) else int_to_ignore,
        if c <= row_size then inputs !! ((fromIntegral $ (r-k-1) * row_size + c) - 1) else int_to_ignore
      ]
    else [int_to_ignore, int_to_ignore]
  | k <- reverse $ [0..1]
  ] | r <- [1..row_size], c <- [1..row_size]]

-- need thse for Integer and Int versions
hask_kernel_2x2 :: [[Int]] = [[1,2],[2,1]]
hask_kernel'_2x2 :: [Integer] = [1,2,2,1]
tuple_2d_2x2_mul_shallow_no_input in_seq = do
  let kernel_list = list_to_seq (Proxy @2) $
                    fmap (list_to_seq (Proxy @2)) $
                    fmap (fmap Atom_Int) hask_kernel_2x2
  let kernel = const_genC kernel_list in_seq
  let kernel_and_values = map2C (map2C atom_tupleC) kernel in_seq
  let mul_result = mapC (mapC mulC) kernel_and_values
  let sum = reduceC'' (mapC addC) $ mapC (reduceC addC) mul_result
  let norm_list = list_to_seq (Proxy @1) [list_to_seq (Proxy @1) [Atom_Int 6]]
  let norm = const_genC norm_list in_seq
  let sum_and_norm = map2C (map2C atom_tupleC) sum norm
  mapC (mapC divC) sum_and_norm
  
conv_2d_b2b_shallow_no_input in_col in_seq = do
  let first_stencil = stencil_3x3_2dC_test in_col in_seq
  let first_conv = mapC tuple_2d_mul_shallow_no_input first_stencil
  let second_stencil = stencil_2x2_2dC_test in_col first_conv
  mapC tuple_2d_2x2_mul_shallow_no_input second_stencil
conv_2d_b2b = conv_2d_b2b_shallow_no_input (Proxy @4) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 16 0 (Seq 1 2 (Seq 1 2 Atom_Int))))
conv_2d_b2b_seq_idx = add_indexes $ seq_shallow_to_deep conv_2d_b2b
conv_2d_b2b_ppar =
  fmap (\s -> rewrite_to_partially_parallel s conv_2d_b2b_seq_idx) [1,2,4,8,16,48,144]
conv_2d_b2b_ppar_typechecked =
  fmap check_type conv_2d_b2b_ppar
conv_2d_b2b_ppar_typechecked' =
  fmap check_type_get_error conv_2d_b2b_ppar

conv_2x2_generator :: [[[Integer]]] -> [Integer]
conv_2x2_generator stencil_2d_output = [
  if window_valid
  then (sum $ zipWith (*) window_flat hask_kernel'_2x2) `mod` 255 `div` 6
  else int_to_ignore
  | window <- stencil_2d_output,
    let window_flat = concat window,
    let window_valid = not $ any (\x -> x == int_to_ignore) window_flat]
conv_2d_b2b_inputs :: [[Integer]] = stencil_2d_inputs
conv_2d_b2b_output :: [Integer] =
  conv_2x2_generator $ stencil_2x2_generator 4 $
  conv_generator $ stencil_generator 4 [1.. row_size*row_size]
conv_2d_b2b_results = sequence $ fmap (\s -> compile_and_test_with_slowdown
                                      conv_2d_b2b s (Just "conv2d_b2b")
                                      conv_2d_b2b_inputs conv_2d_b2b_output) [1,2,4,8,16,48,144]

conv_2d_b2b_print_st = sequence $ fmap (\s -> compile_and_write_st_with_slowdown
                                      conv_2d_b2b s "conv2d_b2b") [1,2,4,8,16,48,144]

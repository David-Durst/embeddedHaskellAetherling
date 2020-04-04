module Test_Demosaic where
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

demosaic_two_rows two_row_length row_length stencil = do
  let are_row_and_col_even = partitionC Proxy (Proxy @1) $
                             partitionC Proxy (Proxy @1) $
                             two_row_counter two_row_length stencil
  map2C demosaic_pixel stencil are_row_and_col_even

two_row_counter two_row_length in_img = do
  let index_counter = counterC two_row_length 1 in_img
  let is_row_even = mapC
        (\elem -> do
            let row_length_const =
                  const_genC
                  (Atom_UInt32 (fromInteger $ two_row_length_integer `div` 2))
                  elem
            notC $ ltC $ atom_tupleC elem row_length_const
        ) index_counter

  let is_col_even = mapC
        (\elem -> do
          let shifted_elem =
                lslC $ (\x -> atom_tupleC x (const_genC (Atom_UInt8 1) elem)) $
                lsrC (atom_tupleC elem (const_genC (Atom_UInt8 1) elem))
          notC $ eqC $ atom_tupleC elem shifted_elem
        ) index_counter
        
  map2C atom_tupleC is_row_even is_col_even
  where
    two_row_length_integer = natVal two_row_length

-- true if even row and col
-- this emits a value for the center pixel in the stencil
demosaic_pixel in_stencil are_row_and_col_even = do
  let row_bit = mapC (mapC fstC) are_row_and_col_even
  let col_bit = mapC (mapC sndC) are_row_and_col_even
  -- get the data per each pixel for each possible index
  let get_pixel row col = mapC (down_1dC (col + 1)) $ down_1dC (row + 1) in_stencil
  let div2 x y = do
        let sum2 = mapC (mapC addU32C) $ map2C (map2C atom_tupleC) x y
        let sum2_with_shift_amount =
              mapC (mapC (\x -> atom_tupleC x (const_genC (Atom_UInt8 1) in_stencil))) sum2
        mapC (mapC lsrC) $ sum2_with_shift_amount
  let div4 x0 x1 x2 x3 = do
        let seq_for_sum = (\x -> map2C (map2C seq_tuple_appendC) x x3) $
                          (\x -> map2C (map2C seq_tuple_appendC) x x2) $
                          map2C (map2C seq_tupleC) x0 x1
        let sum4 = mapC (reduceC addC) $ mapC seq_tuple_to_seqC seq_for_sum
        let sum4_with_shift_amount =
              mapC (mapC (\x -> atom_tupleC x (const_genC (Atom_UInt8 2) in_stencil))) sum4
        mapC (mapC lsrC) $ sum4_with_shift_amount
  -- re means row even, ce means column even
  let red_re_ce = do
        let l_pixel = get_pixel 0 (-1)
        let r_pixel = get_pixel 0 1
        div2 l_pixel r_pixel
  let red_re_co = get_pixel 0 0
  let red_ro_ce = do
        -- (0,0) is top left, with +1 offset by get_pixel
        let tl_pixel = get_pixel (-1) (-1) 
        let tr_pixel = get_pixel (-1) 1
        let bl_pixel = get_pixel 1 (-1)
        let br_pixel = get_pixel 1 1
        div4 tl_pixel tr_pixel bl_pixel br_pixel
  let red_ro_co = do
        let t_pixel = get_pixel (-1) 0
        let b_pixel = get_pixel 1 0
        div2 t_pixel b_pixel
  let green_re_ce = get_pixel 0 0
  let green_ro_co = get_pixel 0 0
  let green_other = do
        -- (0,0) is top left, with +1 offset by get_pixel
        let l_pixel = get_pixel 0 (-1)
        let t_pixel = get_pixel (-1) 0
        let r_pixel = get_pixel 0 1
        let b_pixel = get_pixel 1 0
        div4 l_pixel t_pixel r_pixel b_pixel
  -- re means row even, ce means column even
  let blue_ro_co = do
        let l_pixel = get_pixel 0 (-1)
        let r_pixel = get_pixel 0 1
        div2 l_pixel r_pixel
  let blue_ro_ce = get_pixel 0 0
  let blue_re_co = do
        -- (0,0) is top left, with +1 offset by get_pixel
        let tl_pixel = get_pixel (-1) (-1) 
        let tr_pixel = get_pixel (-1) 1
        let bl_pixel = get_pixel 1 (-1)
        let br_pixel = get_pixel 1 1
        div4 tl_pixel tr_pixel bl_pixel br_pixel
  let blue_re_ce = do
        let t_pixel = get_pixel (-1) 0
        let b_pixel = get_pixel 1 0
        div2 t_pixel b_pixel
  let top_left = get_pixel (-1) (-1)
  let bottom_right = get_pixel (1) (1)

  let tuple_colors r g b = map2C (map2C atom_tupleC) r $
                           map2C (map2C atom_tupleC) g b
  -- tuple up the above values into 3 color triple
  let colors_re_ce = tuple_colors red_re_ce green_re_ce blue_re_ce
  let colors_re_co = tuple_colors red_re_co green_other blue_re_co
  let colors_ro_ce = tuple_colors red_ro_ce green_other blue_ro_ce
  let colors_ro_co = tuple_colors red_ro_co green_ro_co blue_ro_co
  let this_color = tuple_colors top_left green_re_ce bottom_right--red_re_co green_re_ce blue_ro_ce

  -- select columns for each row
  let even_row_select_cols = mapC (mapC ifC) $
                             map2C (map2C atom_tupleC) col_bit $
                             --map2C (map2C atom_tupleC) colors_re_ce this_color
                             --map2C (map2C atom_tupleC) colors_re_ce colors_re_ce
                             map2C (map2C atom_tupleC) colors_re_ce colors_re_co
  let odd_row_select_cols = mapC (mapC ifC) $
                            map2C (map2C atom_tupleC) col_bit $
                            --map2C (map2C atom_tupleC) this_color this_color
                            --map2C (map2C atom_tupleC) colors_re_ce colors_re_ce
                            map2C (map2C atom_tupleC) colors_ro_ce colors_ro_co
  -- now selectrow
  mapC (mapC ifC) $
    map2C (map2C atom_tupleC) row_bit $
    map2C (map2C atom_tupleC) even_row_select_cols odd_row_select_cols

row_length_proxy = Proxy @1920
two_row_length_proxy = Proxy @3840
demosaic_test in_seq = do
  let first_stencil = stencil_3x3_2dC_test row_length_proxy in_seq
  unpartitionC $ unpartitionC $ unpartitionC $
    mapC (demosaic_two_rows two_row_length_proxy row_length_proxy) $
    partitionC Proxy two_row_length_proxy first_stencil

demosaic = demosaic_test $
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_UInt32))

row_size_demosaic :: Integer = 1920
col_size_demosaic :: Integer = 1080
img_size_demosaic :: Int = fromInteger $ col_size_demosaic*row_size_demosaic
demosaic_seq_idx = add_indexes $ seq_shallow_to_deep demosaic
demosaic_throughputs = [16, 8, 4, 2, 1, 1 % 4]
demosaic_tr = [[SplitNestedR (TimeR 2073600 0) (SplitNestedR (TimeR 1 3) NonSeqR), NonSeqR],
               [TimeR 2073600 (2073600 * 3) , NonSeqR],
               [TimeR 2073600 0 , NonSeqR]]
--demosaic_slowdowns = speed_to_slow [1] (toInteger img_size_conv2d_big_32)
demosaic_ppar =
  fmap (\s -> compile_with_throughput_to_expr demosaic s) demosaic_throughputs
demosaic_ppar_tr =
  fmap (\s -> compile_with_type_rewrite_to_expr demosaic s) demosaic_tr
demosaic_ppar_typechecked =
  fmap check_type demosaic_ppar
demosaic_ppar_typechecked' =
  fmap check_type_get_error demosaic_ppar
demosaic_ppar_typechecked_tr' =
  fmap check_type_get_error demosaic_ppar_tr
demosaic_inputs :: [[Word32]] = map (map fromIntegral) [[i*i | i <- [1..row_size_demosaic*col_size_demosaic]]]
demosaic_output :: [(Word32, (Word32, Word32))] =
  demosaic_generator row_size_demosaic (demosaic_inputs !! 0)
demosaic_results = sequence $
  fmap (\s -> test_with_backend
              demosaic (wrap_single_t s)
              Magma (Save_Gen_Verilog "demosaic")
              demosaic_inputs demosaic_output) demosaic_throughputs
demosaic_results_chisel = sequence $
  fmap (\s -> test_with_backend
              demosaic (wrap_single_t s)
              Chisel (Save_Gen_Verilog "demosaic")
              demosaic_inputs demosaic_output) demosaic_throughputs
demosaic_results' = sequence $
  fmap (\s -> test_with_backend
              demosaic (wrap_single_t s)
              Magma No_Verilog
              demosaic_inputs demosaic_output) [demosaic_throughputs !! 0]
demosaic_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              demosaic (wrap_single_t s)
              Chisel (Save_Gen_Verilog "demosaic")
              demosaic_inputs demosaic_output) [demosaic_throughputs !! 5]
demosaic_results_chisel_tr = sequence $
  fmap (\s -> test_with_backend
              demosaic (Type_Rewrites s)
              Chisel (Save_Gen_Verilog "demosaic")
              demosaic_inputs demosaic_output) [demosaic_tr !! 0]
demosaic_results_chisel_tr' = sequence $
  fmap (\s -> test_with_backend
              demosaic (Type_Rewrites s)
              Chisel (Save_Gen_Verilog "demosaic")
              demosaic_inputs demosaic_output) [demosaic_tr !! 2]
demosaic_st_prints = sequence $
  fmap (\s -> compile_to_file
              demosaic (Type_Rewrites s)
              text_backend "demosaic") demosaic_tr

demosaic_tests = testGroup "Demosaic Tests"
  [
    --testCase "single demosaic with tr 1/4" $
    --(TS.all_success demosaic_results_chisel_tr) @? "single demosaic with tr 1/4",
    testCase "demosaic" $
    (TS.all_success demosaic_results_chisel) @? "demosaic"--,
    --testCase "printing demosaics" $
    --((\x -> returnIO True) demosaic_st_prints) @? "printing demosaics"
  ]
  
demosaic_tests' = testGroup "Demosaic Tests"
  [
    testCase "single demosaic" $
    (TS.all_success demosaic_results_chisel') @? "single demosaic"--,
    --testCase "printing demosaics" $
    --((\x -> returnIO True) demosaic_st_prints) @? "printing demosaics"
  ]

demosaic_tests'' = testGroup "Demosaic Tests"
  [
    testCase "single demosaic with tr 1" $
    (TS.all_success demosaic_results_chisel_tr') @? "single demosaic with tr 1"
  ]
returnIO :: a -> IO a
returnIO = return

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

two_row_counter two_row_length in_img = do
  let index_counter = counterC two_row_length 1 in_img
  let is_row_even = mapC
        (\elem -> do
            let row_length_const =
                  const_genC
                  (Atom_UInt32 (fromInteger $ two_row_length_integer `div` 2))
                  elem
            ltC $ atom_tupleC elem row_length_const
        ) index_counter

  let is_col_even = mapC
        (\elem -> do
          let shifted_elem =
                lslC $ (\x -> atom_tupleC x (const_genC (Atom_UInt8 1) elem)) $
                lsrC (atom_tupleC elem (const_genC (Atom_UInt8 1) elem))
          eqC $ atom_tupleC elem shifted_elem
        ) index_counter
        
  (is_row_even, is_col_even)
  where
    two_row_length_integer = natVal two_row_length

demosaic_two_rows two_row_length in_img = do
  let (is_row_even, is_col_even) = two_row_counter two_row_length in_img
  undefined

-- true if even row and col
-- this emits a value for the center pixel in the stencil
demosaic_pixel in_stencil row_bit col_bit = do
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
        div4 l_pixel t_pixel l_pixel b_pixel
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

  let tuple_colors r g b = map2C (map2C atom_tupleC) r $
                           map2C (map2C atom_tupleC) g b
  -- tuple up the above values into 3 color triple
  let colors_re_ce = tuple_colors red_re_ce green_re_ce blue_re_ce
  let colors_re_co = tuple_colors red_re_co green_other blue_re_co
  let colors_ro_ce = tuple_colors red_ro_ce green_other blue_ro_ce
  let colors_ro_co = tuple_colors red_ro_co green_ro_co blue_ro_co

  -- select columns for each row
  let even_row_select_cols = mapC (mapC ifC) $
                             map2C (map2C atom_tupleC) col_bit $
                             map2C (map2C atom_tupleC) colors_re_ce colors_re_co
  let odd_row_select_cols = mapC (mapC ifC) $
                            map2C (map2C atom_tupleC) col_bit $
                            map2C (map2C atom_tupleC) colors_ro_ce colors_ro_co
  -- now selectrow
  mapC (mapC ifC) $
    map2C (map2C atom_tupleC) row_bit $
    map2C (map2C atom_tupleC) even_row_select_cols odd_row_select_cols

import Aetherling.Languages.Sequence.Shallow.Types
import Aetherling.Languages.Sequence.Shallow.Expr
import Aetherling.Interpretations.Sequence_Printer
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import Aetherling.Rewrites.Sequence_Shallow_To_Deep
import Aetherling.Rewrites.Sequence_Assign_Indexes
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import GHC.TypeLits
import GHC.TypeLits.Extra
import GHC.Exts (Constraint)
import Data.Proxy
import Data.List.Split
import Aetherling.Languages.Isomorphisms
import Text.Printf
import Control.Monad
import qualified Data.Vector.Sized as V
import System.Environment   
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import qualified Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import Data.List
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
import qualified Aetherling.Interpretations.Compute_Area as Comp_Area
import qualified Aetherling.Interpretations.Has_Error as Has_Error
import Aetherling.Rewrites.Sequence_Shallow_To_Deep
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Factors
import Aetherling.Rewrites.Sequence_Assign_Indexes
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import Aetherling.Interpretations.Backend_Execute.Compile
import Control.Applicative
import Data.Proxy
import Data.Traversable
import GHC.TypeLits
import GHC.TypeLits.Extra
import System.TimeIt
import Data.Ratio

main = do
  putStrLn $ show $ e_out_type $ expr_to_outer_types_st $ big_conv_2d_ppar !! 5
  --let possible_output_types = rewrite_all_AST_types 480  $
   --                           SeqT 480 0 (SeqT 1 2 (SeqT 1 2 seq_int))
  --Seq_Conv.e_out_type $ Seq_Conv.expr_to_outer_types $ big_conv_2d_seq_idx
  --putStrLn "output_types length"
  --timeIt $ putStrLn $ show $ length possible_output_types
  --
  --let possible_st_programs =
  --      map (\trs -> rewrite_to_partially_parallel_type_rewrite trs big_conv_2d_seq_idx)
  --      possible_output_types
  --putStrLn "possible st_programs length"
  --timeIt $ putStrLn $ show $ length possible_st_programs
  
  --let valid_possible_st_programs =
  --      filter (not . Has_Error.has_error) possible_st_programs
  --let possible_st_programs_and_areas = map (\p -> PA p (Comp_Area.get_area p)) valid_possible_st_programs
  --putStrLn "possible st_programs and areas length"
  --timeIt $ putStrLn $ show $ length possible_st_programs_and_areas
  --
  --let deep_st_program = get_expr_with_min_area (1920 * 1080 `div` 16) big_conv_2d_seq_idx
  --                      possible_st_programs_and_areas 
  --putStrLn "exactly 1 st_programs"
  --putStrLn $ show $ e_out_type $ expr_to_outer_types_st deep_st_program
  --
  --putStrLn "exactly 1 st_programs with registers"
  --putStrLn $ show $ e_out_type $ expr_to_outer_types_st $ add_registers deep_st_program
  return ()
  
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
hask_kernel :: [[Int]] = [[0,1,0],[1,2,1],[0,1,0]]
hask_kernel' :: [Integer] = [1,2,1,2,4,2,1,2,1]
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
  
conv_2d_shallow_no_input in_col in_seq = do
  let stencil = stencil_3x3_2dC_test in_col in_seq
  let conv_result = mapC tuple_2d_mul_shallow_no_input stencil
  unpartitionC (unpartitionC conv_result)

row_size_big :: Integer = 1920
col_size_big :: Integer = 1080
img_size_big :: Int = fromInteger $ col_size_big*row_size_big
big_conv_2d = conv_2d_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_Int))
big_conv_2d_seq_idx = add_indexes $ seq_shallow_to_deep big_conv_2d
big_conv_2d_slowdowns = speed_to_slow [16, 8, 4, 2, 1, 1 % 3] (toInteger img_size_big)-- --[1,2,4,8,16,32,64,img_size_big `div` 2, img_size_big, img_size_big *3]--, img_size_big*9]
big_conv_2d_ppar =
  fmap (\s -> compile_with_slowdown_to_expr big_conv_2d s) big_conv_2d_slowdowns

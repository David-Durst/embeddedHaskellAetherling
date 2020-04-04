module Test_Camera where
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
import qualified Test_Demosaic as TD
import qualified Test_Big_Real_Math32 as TBR

row_size_camera :: Integer = 1920
col_size_camera :: Integer = 1080
img_size_camera :: Int = fromInteger $ col_size_camera*row_size_camera
camera = TD.demosaic_test $
  TBR.sharpen_shallow_no_input (Proxy @1920) $ 
  com_input_seq "I" (Proxy :: Proxy (Seq 2073600 Atom_UInt32))
camera_seq_idx = add_indexes $ seq_shallow_to_deep camera
camera_throughputs = [16, 8, 4, 2, 1, 1 % 3]
camera_tr = [[SplitNestedR (TimeR 2073600 0) (SplitNestedR (TimeR 1 3) NonSeqR), NonSeqR],
               [TimeR 2073600 (2073600 * 3) , NonSeqR],
               [TimeR 2073600 0 , NonSeqR]]
--camera_slowdowns = speed_to_slow [1] (toInteger img_size_camera)
camera_ppar =
  fmap (\s -> compile_with_throughput_to_expr camera s) camera_throughputs
camera_ppar_typechecked =
  fmap check_type camera_ppar
camera_ppar_typechecked' =
  fmap check_type_get_error camera_ppar
camera_inputs :: [[Word32]] = map (map fromIntegral) [[i * i | i <- [1..row_size_camera * col_size_camera]]]
camera_output :: [(Word32, (Word32, Word32))] =
  demosaic_generator TD.row_size_demosaic $
  zipWith sharpen_one_pixel' 
  (conv_generator $ stencil_generator row_size_camera (camera_inputs !! 0))
  (camera_inputs !! 0)

camera_results = sequence $
  fmap (\s -> test_with_backend
              camera (wrap_single_t s)
              Magma (Save_Gen_Verilog "camera")
              camera_inputs camera_output) camera_throughputs
camera_results_chisel = sequence $
  fmap (\s -> test_with_backend
              camera (wrap_single_t s)
              Chisel (Save_Gen_Verilog "camera")
              camera_inputs camera_output) camera_throughputs
camera_results' = sequence $
  fmap (\s -> test_with_backend
              camera (wrap_single_t s)
              Magma No_Verilog
              camera_inputs camera_output) [camera_throughputs !! 0]
camera_results_chisel' = sequence $
  fmap (\s -> test_with_backend
              camera (wrap_single_t s)
              Chisel (Save_Gen_Verilog "camera")
              camera_inputs camera_output) [camera_throughputs !! 5]
camera_results_chisel_tr = sequence $
  fmap (\s -> test_with_backend
              camera (Type_Rewrites s)
              Chisel (Save_Gen_Verilog "camera")
              camera_inputs camera_output) [camera_tr !! 0]
camera_results_chisel_tr' = sequence $
  fmap (\s -> test_with_backend
              camera (Type_Rewrites s)
              Chisel (Save_Gen_Verilog "camera")
              camera_inputs camera_output) [camera_tr !! 2]
camera_st_prints = sequence $
  fmap (\s -> compile_to_file
              camera (Type_Rewrites s)
              text_backend "camera") camera_tr

camera_tests = testGroup "Camera Tests"
  [
    --testCase "single camera with tr 1/4" $
    --(TS.all_success camera_results_chisel_tr) @? "single camera with tr 1/4",
    testCase "camera" $
    (TS.all_success camera_results_chisel) @? "camera"--,
    --testCase "printing cameras" $
    --((\x -> returnIO True) camera_st_prints) @? "printing cameras"
  ]
  
camera_tests' = testGroup "Camera Tests"
  [
    testCase "single camera" $
    (TS.all_success camera_results_chisel') @? "single camera"--,
    --testCase "printing cameras" $
    --((\x -> returnIO True) camera_st_prints) @? "printing cameras"
  ]

camera_tests'' = testGroup "Camera Tests"
  [
    testCase "single camera with tr 1" $
    (TS.all_success camera_results_chisel_tr') @? "single camera with tr 1"
  ]

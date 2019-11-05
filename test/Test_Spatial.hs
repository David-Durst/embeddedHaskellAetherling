module Test_Spatial where
import Test_Apps
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


single_map_200_spatial_verilog = sequence $ fmap (\(s, d) -> compile_and_test_verilog single_map_200 s
                                                   single_map_200_inputs single_map_200_output
                                                   "test/verilog_examples/spatial/map/map_" d)
                                 [(50, 4), (100, 4), (200, 4)] 

conv_2d_spatial_verilog = sequence $ fmap (\(s, d) -> compile_and_test_verilog conv_2d s
                                      conv_2d_inputs conv_2d_output
                                                   "test/verilog_examples/spatial/conv_2d/conv_2d_" d)
                                 [(16,100), (8,100), (4,100), (2,100)]


conv_2d_b2b_spatial_verilog = sequence $ fmap (\(s, d) -> compile_and_test_verilog conv_2d_b2b s
                                      conv_2d_b2b_inputs conv_2d_b2b_output
                                                   "test/verilog_examples/spatial/conv_2d_b2b/conv_2d_b2b_" d)
                                 [(16,100), (8,100), (4,100), (2,100)]

sharpen_spatial_verilog = sequence $ fmap (\(s, d) -> compile_and_test_verilog sharpen s
                                      sharpen_inputs sharpen_output
                                                   "test/verilog_examples/spatial/sharpen/sharpen_" d)
                                 [(16,100), (8,100), (4,100), (2,100)]
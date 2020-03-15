module Aetherling.Interpretations.Backend_Execute.Chisel.Tester where
import Aetherling.Interpretations.Backend_Execute.Chisel.Expr_To_String
import Aetherling.Interpretations.Backend_Execute.Expr_To_String_Helpers
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Control.Applicative
import Aetherling.Monad_Helpers
import Data.List
import qualified Data.Map.Strict as M
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import System.Exit
import System.Directory
import Data.Maybe
import Debug.Trace

chisel_test_spec_wrapper :: String -> String -> String
chisel_test_spec_wrapper src_body test_body =
  src_body ++ "\n\n" ++
  "import aetherling.modules._\n" ++
  "import chisel3.iotesters.ChiselFlatSpec\n\n" ++
  "class TopTest(c: Top) extends NestedPeekPokeTester(c) {\n" ++
  test_body ++ "}\n\n" ++
  "class TopTester extends ChiselFlatSpec {\n" ++
  tab_str ++ "\"Top\" should \"behave correctly\" in {\n" ++ 
  tab_str ++ tab_str ++ "iotesters.Driver.execute(Array(\"--backend-name\"," ++
  " \"verilator\",\"--target-dir\",\"test_run_dir/top\",\"--generate-vcd-output\",\"off\"), () => new Top()) {\n" ++
  tab_str ++ tab_str ++ tab_str ++ "c => new TopTest(c)\n" ++
  tab_str ++ tab_str ++ "} should be(true)\n" ++
  tab_str ++ "}\n" ++
  "}"

array_of_bools_to_chisel_string :: [Bool] -> String
array_of_bools_to_chisel_string arr =
  make_array_string_for_backend chisel_conf $
  convert_to_flat_atom_list arr chisel_conf
  
add_test_harness_to_chisel_str :: (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr -> Backend_String_Results -> [a] -> b -> Int -> Bool -> Tester_Files -> String
add_test_harness_to_chisel_str p module_str_data inputs output output_latency
  is_verilog tester_io_paths = do
  let p_types = expr_to_outer_types p
  let num_ports = length $ in_ports $ module_outer_results $ module_str_data
  -- these are nested for both space and time
  -- issue: if 1 input per clock, then need to remove the space dimension
  let f_inputs = foldl (++) "" $
        map (\i -> tab_str ++ "val chisel_inputs" ++ show i ++
              " = JsonParser(Source.fromFile(\"" ++
              show_no_quotes (test_path $ tester_inputs_fp tester_io_paths !! i) ++
              "\").getLines.mkString).convertTo[IndexedSeq[" ++
              (if (nested_array $ tester_inputs_fp tester_io_paths !! i)
                then "IndexedSeq[Int]" else "Int") ++ "]]\n" ++
              tab_str ++ "val chisel_inputs" ++ show i ++ "_valid = " ++
              " JsonParser(Source.fromFile(\"" ++
              show_no_quotes (tester_valid_in_fp tester_io_paths !! i) ++
              "\").getLines.mkString).convertTo[IndexedSeq[Boolean]]\n"
            )
        [0..num_ports - 1]
  let f_output = tab_str ++ "val chisel_output = " ++
                 " JsonParser(Source.fromFile(\"" ++
                 show_no_quotes (test_path $ tester_output_fp tester_io_paths) ++
                 "\").getLines.mkString).convertTo[IndexedSeq[" ++
                 (if (nested_array $ tester_output_fp tester_io_paths)
                  then "IndexedSeq[Int]" else "Int") ++ "]]\n" ++
                 tab_str ++ "val chisel_output_valid = " ++
                 " JsonParser(Source.fromFile(\"" ++
                 show_no_quotes (tester_valid_out_fp tester_io_paths) ++
                 "\").getLines.mkString).convertTo[IndexedSeq[Boolean]]\n"

  let test_start =
        tab_str ++ "poke_nested(c.valid_up, 1.B)\n" ++
        tab_str ++ "var output_counter = 0\n" ++
        tab_str ++ "val run_clks = " ++ show (tester_clocks_files tester_io_paths) ++ "\n" ++
        tab_str ++ "val pipeline_clks = " ++ show output_latency ++ "\n" ++
        tab_str ++ "val total_clks = run_clks + pipeline_clks\n" ++
        tab_str ++ "for(f_clk <- 0 to (total_clks - 1)) {\n" ++
        tab_str ++ tab_str ++ "//println(s\"clk: $f_clk\")\n"
  let test_inputs = foldl (++) "" $
        map (\i -> do
                let i_port_name = (port_name $
                                   (in_ports $ module_outer_results module_str_data) !! i)
                tab_str ++ tab_str ++ "if (f_clk < run_clks " ++
                  " && chisel_inputs" ++ show i ++ "_valid(f_clk)) {\n" ++

                  tab_str ++ tab_str ++ tab_str ++
                  "poke_nested(c." ++ i_port_name ++
                  ", nest_indexed_seq(chisel_inputs" ++ show i ++ "(f_clk)," ++
                  "compute_num_atoms_per_sseq_layer(c." ++ i_port_name ++ ")))\n" ++

                  tab_str ++ tab_str ++ "}\n"
            ) [0..num_ports - 1]
  let test_print = tab_str ++ tab_str ++
        case num_ports of
          0 -> "//peek_nullary_module(c)\n"
          1 -> "//peek_unary_module(c)\n"
          _ -> "//peek_binary_module(c)\n"
  let output_port_name = port_name $ out_port $
                         module_outer_results module_str_data
  let test_output_counter_incr =
        tab_str ++ tab_str ++ "if(f_clk > " ++ show output_latency ++ "){\n" ++
        tab_str ++ tab_str ++ tab_str ++ "output_counter += 1\n" ++
        tab_str ++ tab_str ++ "}\n"
  let test_valid_down_check =
        tab_str ++ tab_str ++ "if(f_clk >= " ++ show output_latency ++ "){\n" ++
        -- circuit will always emit valid once started valid
        -- the valid/invalid clocks on types aren't refleceted by valid wire
        tab_str ++ tab_str ++ tab_str ++ "expect_nested(c.valid_down, 1)\n" ++
        tab_str ++ tab_str ++ "}\n" ++
        tab_str ++ tab_str ++ "if(f_clk < " ++ show output_latency ++ "){\n" ++
        -- circuit will always emit valid once started valid
        -- the valid/invalid clocks on types aren't refleceted by valid wire
        tab_str ++ tab_str ++ tab_str ++ "expect_nested(c.valid_down, 0)\n" ++
        tab_str ++ tab_str ++ "}\n"
  let test_output = tab_str ++ tab_str ++ "if(f_clk >= pipeline_clks && " ++
                    " chisel_output_valid(output_counter)){\n" ++
                    tab_str ++ tab_str ++ tab_str ++
                    "expect_nested(c." ++ output_port_name ++
                    ", nest_indexed_seq(chisel_output(output_counter)," ++
                    "compute_num_atoms_per_sseq_layer(c." ++
                    output_port_name ++ ")))\n" ++
                    tab_str ++ tab_str ++ "}\n"
  let test_step = tab_str ++ tab_str ++ "if (f_clk < (total_clks - 1)) step(1)\n"
  let test_end = tab_str ++ "}\n"
  let test_body =
        f_inputs ++ f_output ++
        test_start ++ test_inputs ++ test_print ++
        test_output_counter_incr ++ test_valid_down_check ++
        test_output ++ test_step ++ test_end
  chisel_test_spec_wrapper (module_str module_str_data) test_body

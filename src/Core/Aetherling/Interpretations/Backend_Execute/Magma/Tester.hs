module Aetherling.Interpretations.Backend_Execute.Magma.Tester where
import Aetherling.Interpretations.Backend_Execute.Magma.Expr_To_String
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

is_success_fault_result :: Test_Result -> Bool
is_success_fault_result Test_Success = True
is_success_fault_result _ = False

add_test_harness_to_fault_str :: (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Expr -> Backend_String_Results -> [a] -> b -> Int -> Bool -> String
add_test_harness_to_fault_str p module_str_data inputs output output_latency
  is_verilog = do
  let p_types = expr_to_outer_types p
  let num_ports = length $ in_ports $ module_outer_results $ module_str_data
  let fault_io = generate_tester_input_output_for_st_program p inputs output
  -- these are nested for both space and time
  -- issue: if 1 input per clock, then need to remove the space dimension
  let f_inputs = foldl (++) "" $
        map (\i -> "fault_inputs" ++ show i ++ " = " ++
              show_no_quotes (tester_inputs fault_io !! i) ++ "\n" ++
              "fault_inputs" ++ show i ++ "_valid = " ++
              show_no_quotes (tester_valid_in fault_io !! i) ++ "\n"
            )
        [0..num_ports - 1]
  let f_output = "fault_output = " ++ tester_output fault_io ++ "\n"
  let f_output_valid = "fault_output_valid = " ++
                       show_no_quotes (tester_valid_out fault_io) ++ "\n"
  let test_start =
        "if __name__ == '__main__':\n" ++
        tab_str ++ "mod = Main()\n" ++
        tab_str ++ "tester = fault.Tester(mod, clock(mod.CLK))\n" ++
        tab_str ++ "tester.circuit.valid_up = 1\n" ++
        tab_str ++ "output_counter = 0\n" ++
        tab_str ++ "for f_clk in range(" ++ show (tester_clocks fault_io) ++
        " + " ++ show output_latency ++ "):\n" ++
        tab_str ++ tab_str ++ "tester.print('clk: {}\\n'.format(f_clk))\n"
  let test_inputs = foldl (++) "" $
        map (\i -> do
                let i_port_name = (port_name $ (in_ports $ module_outer_results module_str_data) !! i)
                tab_str ++ tab_str ++ "if f_clk < " ++ show (tester_clocks fault_io) ++
                  " and fault_inputs" ++ show i ++ "_valid[f_clk]:\n" ++
                  tab_str ++ tab_str ++ tab_str ++
                  "fault_helpers.set_nested_port(tester, tester.circuit." ++
                  i_port_name ++ ", fault_inputs" ++ show i ++ "[f_clk], " ++
                  "num_nested_space_layers(" ++
                  (type_to_python $ e_in_types p_types !! i) ++ "), 0)\n" ++

                  tab_str ++ tab_str ++ tab_str ++
                  "tester.print(\"" ++  i_port_name ++ ": \")\n" ++

                  tab_str ++ tab_str ++ tab_str ++
                  "fault_helpers.print_nested_port(tester, tester.circuit." ++
                  i_port_name ++ ", num_nested_space_layers(" ++
                  (type_to_python $ e_in_types p_types !! i) ++ "))\n" ++

                  tab_str ++ tab_str ++ tab_str ++
                  "tester.print(\"\\n\")\n")
        [0..num_ports - 1]
  let test_eval = tab_str ++ tab_str ++ "tester.eval()\n"
  let output_port_name = (port_name $ out_port $ module_outer_results module_str_data)
  let test_output_counter_incr =
        tab_str ++ tab_str ++ "if f_clk > " ++ show output_latency ++ ":\n" ++
        tab_str ++ tab_str ++ tab_str ++ "output_counter += 1\n"
  let test_output_print =
        tab_str ++ tab_str ++
        "tester.print(\"" ++ output_port_name ++ ": \")\n" ++

        tab_str ++ tab_str ++
        "fault_helpers.print_nested_port(tester, tester.circuit." ++
        output_port_name ++ ", num_nested_space_layers(" ++
        (type_to_python $ e_out_type p_types) ++ "))\n" ++

        tab_str ++ tab_str ++
        "tester.print(\"\\n\")\n"
  let test_valid_down_check =
        tab_str ++ tab_str ++ "if f_clk >= " ++ show output_latency ++ ":\n" ++
        -- circuit will always emit valid once started valid
        -- the valid/invalid clocks on types aren't refleceted by valid wire
        tab_str ++ tab_str ++ tab_str ++ "tester.circuit.valid_down.expect(1)\n"
  let test_output_if_valid = tab_str ++ tab_str ++ "if f_clk >= " ++
                             show output_latency ++
                             " and fault_output_valid[output_counter]:\n"
  let test_output = tab_str ++ tab_str ++ tab_str ++
                    "fault_helpers.expect_nested_port(tester, tester.circuit." ++
                    output_port_name ++
                    ", fault_output[output_counter], num_nested_space_layers(" ++
                    (type_to_python $ e_out_type p_types)  ++ "), 0)\n"
  let test_step = tab_str ++ tab_str ++ "tester.step(2)\n"
  let test_run = if is_verilog
        then tab_str ++ "fault_helpers.compile_and_run_verilog(tester)\n"
        else tab_str ++ "fault_helpers.compile_and_run(tester)\n"
  (module_str module_str_data) ++ f_inputs ++ f_output ++
    f_output_valid ++ test_start ++ test_inputs ++ test_eval ++
    test_output_counter_incr ++ test_output_print ++ test_valid_down_check ++
    test_output_if_valid ++ test_output ++ test_step ++ test_run
  


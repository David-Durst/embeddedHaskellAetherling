module Aetherling.Interpretations.Compile where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Rewrites.Add_Pipeline_Registers as APR
import qualified Aetherling.Rewrites.Merge_Const_FIFOs as MCF
import qualified Aetherling.Monad_Helpers as MH
import qualified Aetherling.Rewrites.Sequence_Shallow_To_Deep as Seq_SToD
import qualified Aetherling.Rewrites.Match_Latencies as ML
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Type_To_Slowdown
import qualified Aetherling.Interpretations.Sequence_Printer as Seq_Print
import qualified Aetherling.Interpretations.Compute_Latency as CL
import qualified Aetherling.Interpretations.Has_Error as Has_Error
import qualified Aetherling.Interpretations.Compute_Area as Comp_Area
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types
import Aetherling.Rewrites.Sequence_Assign_Indexes
import qualified Aetherling.Languages.Sequence.Shallow.Types as Shallow_Types
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions as ST_Conv
import qualified Data.List as L
-- things this module needs to do:
-- 1. compile Seq to ST IR deep embedding to backend given a slowdown
-- 2. compile Seq to ST IR deep embedding to backend given a slowdown and verify an output matches an input
-- 3. compile Seq to ST IR deep embedding to backend given all possible types (or a random subset of all possible types) for a slowdown and verify an output matches an input for each possible output type
-- 4. compile Seq to ST IR deep embedding to backend given a type rewrite
-- 5. compile Seq to ST IR deep embedding to string for backend but not write to file
-- 6. compile Seq to ST IR to this version text representation and write with
-- 7. Run arbitrary verilog through my text bench

-- how to organize
-- 1. always need to compile seq to STIR
-- two options: (a) let algorithm pick best outpuot type rewrite given slowdown, (b) try all output type rewrites
-- note: I'd like to be able to also speak in terms of speedup, want helper function for that
-- 2. then either compile STIR to
--   (a) magma
--   (b) chisel
--   (c) text printing option
--   (d) kratos
-- 3. finally run testing for all but text printing option
--   (a) magma running tests on coreir
--   (b) magma running tests on unrelated verilog
--      (i) kratos will be run using this option as well as external systems like spatial
--   (c) chisel tests

data Target_Languages = Magma | Chisel | Text deriving (Show, Eq)

data Slowdown_Target =
  Slowdown_Factor Int
  | Slowdown_Factors [Int]
  | Type_Rewrites [Type_Rewrite]
  deriving (Show, Eq)

data Test_Args a b = Test_Args {test_inputs :: [a], test_output :: b}

compile :: (Shallow_Types.Aetherling_Value a) =>
           RH.Rewrite_StateM a -> Slowdown_Target -> IO String
compile shallow_seq_program s = undefined

data Compiler_Error = Type_Mismatch | Latency_Mismatch | Incorrect_Slowdown
  deriving (Show, Eq)

check_compiler_errors :: STE.Expr -> Int -> Maybe Compiler_Error
check_compiler_errors program s = do
  if check_type program
    then do
    if CL.check_latency program
      then do
      let outer_types = ST_Conv.expr_to_outer_types program
      let actual_s = type_to_slowdown $ ST_Conv.e_out_type outer_types
      if actual_s == s
        then Nothing
        else Just Incorrect_Slowdown
      else Just Latency_Mismatch
    else Just Type_Mismatch

-- Compile Seq Shallow to STIR helpers:
compile_with_type_rewrite_to_expr :: (Shallow_Types.Aetherling_Value a) =>
                                     RH.Rewrite_StateM a -> [Type_Rewrite] ->
                                     ML.Matched_Latency_Result
compile_with_type_rewrite_to_expr shallow_seq_program tr = do
  let deep_seq_program_with_indexes =
        lower_seq_shallow_to_deep_indexed shallow_seq_program
  let deep_st_program =
        rewrite_to_partially_parallel_type_rewrite tr deep_seq_program_with_indexes
  add_registers deep_st_program
  
compile_with_slowdown_to_expr :: (Shallow_Types.Aetherling_Value a) =>
                                     RH.Rewrite_StateM a -> Int ->
                                     ML.Matched_Latency_Result
compile_with_slowdown_to_expr shallow_seq_program s = do
  let deep_seq_program_with_indexes =
        lower_seq_shallow_to_deep_indexed shallow_seq_program
  let possible_st_programs_and_areas =
        rewrite_to_partially_parallel_slowdown s deep_seq_program_with_indexes
  let deep_st_program = if length possible_st_programs_and_areas == 0
        then STE.ErrorN ("No possible rewrites for slowdown " ++ show s ++
                         " of program \n" ++
                         Seq_Print.print_seq_str deep_seq_program_with_indexes)
             MH.No_Index
        else program $ L.minimumBy (\pa pb -> compare (area pa) (area pb))
             possible_st_programs_and_areas
  add_registers deep_st_program
  
compile_with_slowdown_to_all_possible_expr :: (Shallow_Types.Aetherling_Value a) =>
                                              RH.Rewrite_StateM a -> Int ->
                                              [ML.Matched_Latency_Result]
compile_with_slowdown_to_all_possible_expr shallow_seq_program s = do
  let deep_seq_program_with_indexes =
        lower_seq_shallow_to_deep_indexed shallow_seq_program
  let possible_st_programs_and_areas =
        rewrite_to_partially_parallel_slowdown s deep_seq_program_with_indexes
  map (add_registers . program) possible_st_programs_and_areas

-- helper functions for compile seq to stir
lower_seq_shallow_to_deep_indexed :: (Shallow_Types.Aetherling_Value a) =>
                                  RH.Rewrite_StateM a -> SeqE.Expr
lower_seq_shallow_to_deep_indexed shallow_seq_program = do
  let deep_seq_program_no_indexes =
        Seq_SToD.seq_shallow_to_deep shallow_seq_program
  add_indexes deep_seq_program_no_indexes
  
add_registers :: STE.Expr -> ML.Matched_Latency_Result
add_registers deep_st_program = do
  let pipelined_program = APR.add_pipeline_registers deep_st_program 3
  let matched_latencies = ML.match_latencies pipelined_program
  matched_latencies {
    ML.new_expr = MCF.merge_consts_and_fifos $ ML.new_expr matched_latencies
    }



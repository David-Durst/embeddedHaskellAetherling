module Aetherling.Interpretations.Compile where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Rewrites.Add_Pipeline_Registers as APR
import qualified Aetherling.Rewrites.Merge_Const_FIFOs as MCF
import qualified Aetherling.Monad_Helpers as MH
import qualified Aetherling.Rewrites.Sequence_Shallow_To_Deep as Seq_SToD
import qualified Aetherling.Rewrites.Match_Latencies as ML
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Type_To_Slowdown
import qualified Aetherling.Interpretations.Latency as CL
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
import Aetherling.Rewrites.Sequence_Assign_Indexes
import qualified Aetherling.Languages.Sequence.Shallow.Types as Shallow_Types
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions as ST_Conv
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

compile_with_slowdown_to_expr :: (Shallow_Types.Aetherling_Value a) =>
                                 RH.Rewrite_StateM a -> Either Int [Type_Rewrite] -> IO ML.Matched_Latency_Result
compile_with_slowdown_to_expr shallow_seq_program s_or_tr = do
  let deep_seq_program_no_indexes =
        Seq_SToD.seq_shallow_to_deep shallow_seq_program
  let deep_seq_program_with_indexes = add_indexes deep_seq_program_no_indexes
  let deep_st_program = case s_or_tr of
        Left s -> rewrite_to_partially_parallel s deep_seq_program_with_indexes
        Right tr -> rewrite_to_partially_parallel_type tr deep_seq_program_with_indexes
  let pipelined_program = APR.add_pipeline_registers deep_st_program 3
  matched_latencies <- ML.match_latencies pipelined_program
  return $ matched_latencies {
    ML.new_expr = MCF.merge_consts_and_fifos $ ML.new_expr matched_latencies
    }

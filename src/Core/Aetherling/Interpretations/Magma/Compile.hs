module Aetherling.Interpretations.Magma.Compile where
import Aetherling.Interpretations.Magma.Constants
import Aetherling.Interpretations.Magma.Tester
import Aetherling.Interpretations.Magma.Expr_To_String
import Aetherling.Interpretations.Magma.Value_To_String
import Aetherling.Interpretations.Space_Time_Printer
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Rewrites.Add_Pipeline_Registers as APR
import qualified Aetherling.Rewrites.Merge_Const_FIFOs as MCF
import qualified Aetherling.Monad_Helpers as MH
import qualified Aetherling.Rewrites.Sequence_Shallow_To_Deep as Seq_SToD
import qualified Aetherling.Rewrites.Match_Latencies as ML
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Type_To_Slowdown
import qualified Aetherling.Interpretations.Latency as CL
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Expr
import Aetherling.Rewrites.Sequence_Assign_Indexes
import qualified Aetherling.Languages.Sequence.Shallow.Types as Shallow_Types
import Aetherling.Languages.Space_Time.Deep.Type_Checker
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions as ST_Conv
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import System.Exit
import System.Directory
import System.FilePath
import Data.Maybe
import Debug.Trace

data Compile_Result = Compile_Success { verilog_file :: FilePath }
                    | Compile_Failure {
                        error_message :: String,
                        compile_stdout :: String,
                        compile_stderr :: String,
                        compile_exit_code :: Int
                      } deriving (Show, Eq)

compile_with_slowdown_to_file :: (Shallow_Types.Aetherling_Value a) =>
                         RH.Rewrite_StateM a -> Int -> String -> IO Compile_Result
compile_with_slowdown_to_file shallow_seq_program s output_name = do
  ML.Matched_Latency_Result deep_st_program _ <-
    compile_with_slowdown_to_expr shallow_seq_program s
  if check_type deep_st_program
    then do
    correct_latencies <- CL.check_latency deep_st_program
    if correct_latencies
      then do
      let outer_types = ST_Conv.expr_to_outer_types deep_st_program
      let actual_s = type_to_slowdown $ ST_Conv.e_out_type outer_types
      if actual_s == s
        then do
        p_str <- module_to_magma_string deep_st_program
        let output_name_with_s = output_name ++ show s
        let p_str_with_compile = module_str p_str ++ "\n" ++
                                "fault_helpers.compile(Main(), \"" ++ output_name_with_s ++ "\")"
        circuit_file <- emptySystemTempFile "ae_circuit.py"
        writeFile circuit_file p_str_with_compile
        stdout_name <- emptySystemTempFile "ae_circuit_verilog_stdout.txt"
        stdout_file <- openFile stdout_name WriteMode
        stderr_name <- emptySystemTempFile "ae_circuit_verilog_stderr.txt"
        stderr_file <- openFile stderr_name WriteMode
        let process = proc "python" [circuit_file]
        (_ , _, _, phandle) <- createProcess process { std_out = UseHandle stdout_file,
                                                      std_err = UseHandle stderr_file}
        exit_code <- waitForProcess phandle
        case exit_code of
          ExitSuccess -> do
            cwd <- getCurrentDirectory 
            return $ Compile_Success (cwd </> "vBuild" </> output_name_with_s <.> ".v")
          ExitFailure c -> do
            stdout_fault <- readFile stdout_name
            stderr_fault <- readFile stderr_name
            return $ Compile_Failure "magma to verilog failed" stdout_fault stderr_fault c
        else do
        print_st deep_st_program
        return $ Compile_Failure ("program not slowed correctly for target" ++
          " slowdown " ++ show s ++ " with actual slowdown " ++ show actual_s) "" "" 0
      else do
      print_st deep_st_program
      return $ Compile_Failure "invalid latencies for program" "" "" 0
    else do
    print_st deep_st_program
    return $ Compile_Failure "invalid types for program" "" "" 0

compile_and_test_with_slowdown :: (Shallow_Types.Aetherling_Value a,
                                   Convertible_To_Atom_Strings b,
                                   Convertible_To_Atom_Strings c) =>
                                  RH.Rewrite_StateM a -> Int -> Maybe String -> [b] ->
                                  c -> IO Fault_Result
compile_and_test_with_slowdown shallow_seq_program s base_name inputs output = do
  ML.Matched_Latency_Result deep_st_program output_latency <-
    compile_with_slowdown_to_expr shallow_seq_program s
  if check_type deep_st_program
    then do
    correct_latencies <- CL.check_latency deep_st_program
    if correct_latencies
      then do
      let outer_types = ST_Conv.expr_to_outer_types deep_st_program
      let actual_s = type_to_slowdown $ ST_Conv.e_out_type outer_types
      if actual_s == s
        then do
        result <- test_circuit_with_fault deep_st_program inputs output output_latency
        if isJust base_name
          then do
          let test_verilog_dir = root_dir ++
                "/test/verilog_examples/aetherling_copies/" ++
                fromJust base_name
          createDirectoryIfMissing True test_verilog_dir
          copyFile "vBuild/top.v"
            (test_verilog_dir ++ "/" ++ fromJust base_name ++ "_" ++ show s ++ ".v")
          else return ()
        return result
        else do
        return $ Fault_Failure ("program not slowed correctly for target" ++
          " slowdown " ++ show s ++ " with actual slowdown " ++ show actual_s) "" "" 0
      else do
      return $ Fault_Failure "invalid latencies for program" "" "" 0
    else do
    return $ Fault_Failure "invalid types for program" "" "" 0
    
compile_with_slowdown :: (Shallow_Types.Aetherling_Value a) =>
                         RH.Rewrite_StateM a -> Int -> String -> IO String
compile_with_slowdown shallow_seq_program s base_name = do
  ML.Matched_Latency_Result deep_st_program output_latency <-
    compile_with_slowdown_to_expr shallow_seq_program s
  if check_type deep_st_program
    then do
    correct_latencies <- CL.check_latency deep_st_program
    if correct_latencies
      then do
      let outer_types = ST_Conv.expr_to_outer_types deep_st_program
      let actual_s = type_to_slowdown $ ST_Conv.e_out_type outer_types
      if actual_s == s
        then do
        compile_no_test deep_st_program 
        -- do verilog
        let test_verilog_dir = root_dir ++
              "/test/verilog_examples/aetherling_copies/" ++
              base_name
        createDirectoryIfMissing True test_verilog_dir
        let file_path = (test_verilog_dir ++ "/" ++ base_name ++ "_" ++ show s ++ ".v")
        copyFile "vBuild/top.v" file_path

        -- copy coreir json to own directory
        let test_coreir_dir = root_dir ++
              "/test/coreir_examples/aetherling_copies/" ++
              base_name
        createDirectoryIfMissing True test_coreir_dir
        let json_path = (test_coreir_dir ++ "/" ++ base_name ++ "_" ++ show s ++ ".json")
        copyFile "vBuild/top.json" json_path
        return file_path
        else do
        return $ "program not slowed correctly for target" ++
          " slowdown " ++ show s ++ " with actual slowdown " ++ show actual_s
      else do
      return $ "invalid latencies for program"
    else do
    return $ "invalid types for program"

compile_no_test p = do
  p_module_str <- module_to_magma_string p
  let p_str = module_str p_module_str ++ "\ncompile(Main())"
  circuit_file <- emptySystemTempFile "ae_circuit.py"
  writeFile circuit_file p_str
  stdout_name <- emptySystemTempFile "ae_circuit_fault_stdout.txt"
  stdout_file <- openFile stdout_name WriteMode
  stderr_name <- emptySystemTempFile "ae_circuit_fault_stderr.txt"
  stderr_file <- openFile stderr_name WriteMode
  let process =
        proc "python" [circuit_file]
  (_ , _, _, phandle) <- createProcess process { std_out = UseHandle stdout_file,
                                                std_err = UseHandle stderr_file}
  exit_code <- waitForProcess phandle
  case exit_code of
    ExitSuccess -> return Fault_Success
    ExitFailure c -> do
      stdout_fault <- readFile stdout_name
      stderr_fault <- readFile stderr_name
      return $ Fault_Failure circuit_file stdout_fault stderr_fault c

compile_and_write_st_with_slowdown :: (Shallow_Types.Aetherling_Value a) =>
                                  RH.Rewrite_StateM a -> Int -> String -> IO String 
compile_and_write_st_with_slowdown shallow_seq_program s base_name = do
  ML.Matched_Latency_Result deep_st_program output_latency <-
    compile_with_slowdown_to_expr shallow_seq_program s
  if check_type deep_st_program
    then do
    correct_latencies <- CL.check_latency deep_st_program
    if correct_latencies
      then do
      let outer_types = ST_Conv.expr_to_outer_types deep_st_program
      let actual_s = type_to_slowdown $ ST_Conv.e_out_type outer_types
      if actual_s == s
        then do
        let st_dir = root_dir ++
              "/test/st_examples/aetherling_copies/" ++
              base_name
        createDirectoryIfMissing True st_dir
        let st_string = print_st_str deep_st_program
        let file_path = (st_dir ++ "/" ++ base_name ++ "_"
                         ++ show s ++ ".txt")
        writeFile file_path st_string
        return file_path 
        else do
        return $ "program not slowed correctly for target" ++
          " slowdown " ++ show s ++ " with actual slowdown " ++ show actual_s
      else do
      return $ "invalid latencies for program"
    else do
    return $ "invalid types for program"
    
compile_and_test_verilog :: (Shallow_Types.Aetherling_Value a,
                                   Convertible_To_Atom_Strings b,
                                   Convertible_To_Atom_Strings c) =>
                                  RH.Rewrite_StateM a -> Int -> [b] -> c ->
                                  String -> Int -> IO Fault_Result
compile_and_test_verilog shallow_seq_program s inputs output verilog_template
  output_latency = do
  ML.Matched_Latency_Result deep_st_program _ <-
    compile_with_slowdown_to_expr shallow_seq_program s
  if check_type deep_st_program
    then do
    correct_latencies <- CL.check_latency deep_st_program
    if correct_latencies
      then do
      let outer_types = ST_Conv.expr_to_outer_types deep_st_program
      let actual_s = type_to_slowdown $ ST_Conv.e_out_type outer_types
      if actual_s == s
        then do
        let verilog_path = verilog_template ++ show s ++ ".v"
        test_verilog_with_fault deep_st_program (root_dir ++ verilog_path) inputs output output_latency
        else do
        return $ Fault_Failure ("program not slowed correctly for target" ++
          " slowdown " ++ show s ++ " with actual slowdown " ++ show actual_s) "" "" 0
      else do
      return $ Fault_Failure "invalid latencies for program" "" "" 0
    else do
    return $ Fault_Failure "invalid types for program" "" "" 0

compile_with_slowdown_to_expr :: (Shallow_Types.Aetherling_Value a) =>
                                 RH.Rewrite_StateM a -> Int -> IO ML.Matched_Latency_Result
compile_with_slowdown_to_expr shallow_seq_program s = do
  let deep_seq_program_no_indexes =
        Seq_SToD.seq_shallow_to_deep shallow_seq_program
  let deep_seq_program_with_indexes = add_indexes deep_seq_program_no_indexes
  let deep_st_program =
        rewrite_to_partially_parallel s deep_seq_program_with_indexes
  let pipelined_program = APR.add_pipeline_registers deep_st_program 3
  matched_latencies <- ML.match_latencies pipelined_program
  return $ matched_latencies {
    ML.new_expr = MCF.merge_consts_and_fifos $ ML.new_expr matched_latencies
    }

tst_compile_with_slowdown_to_expr shallow_seq_program s = do
  let deep_seq_program_no_indexes =
        Seq_SToD.seq_shallow_to_deep shallow_seq_program
  let deep_seq_program_with_indexes = add_indexes deep_seq_program_no_indexes
  let deep_st_program =
        rewrite_to_partially_parallel s deep_seq_program_with_indexes
  let pipelined_program = APR.add_pipeline_registers deep_st_program 3
  putStr "pipelined: "
  print_st pipelined_program
  matched_latencies <- ML.match_latencies pipelined_program
  putStr "matched_latencies: "
  print_st $ ML.new_expr matched_latencies
  return $ matched_latencies {
    ML.new_expr = MCF.merge_consts_and_fifos $ ML.new_expr matched_latencies
    }

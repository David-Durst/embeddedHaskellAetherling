module Aetherling.Interpretations.Backend_Execute.Compile where
import Aetherling.Interpretations.Backend_Execute.Constants
import qualified Aetherling.Interpretations.Backend_Execute.Test_Helpers as Test_Helpers
import qualified Aetherling.Interpretations.Backend_Execute.Magma.Tester as M_Tester
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Rewrites.Add_Pipeline_Registers as APR
import qualified Aetherling.Rewrites.Merge_Const_FIFOs as MCF
import qualified Aetherling.Monad_Helpers as MH
import qualified Aetherling.Rewrites.Sequence_Shallow_To_Deep as Seq_SToD
import qualified Aetherling.Rewrites.Match_Latencies as ML
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Type_To_Slowdown
import qualified Aetherling.Interpretations.Sequence_Printer as Seq_Print
import qualified Aetherling.Interpretations.Space_Time_Printer as ST_Print
import qualified Aetherling.Interpretations.Compute_Latency as CL
import qualified Aetherling.Interpretations.Has_Error as Has_Error
import qualified Aetherling.Interpretations.Compute_Area as Comp_Area
import qualified Aetherling.Interpretations.Backend_Execute.Magma.Expr_To_String as M_Expr_To_Str
import qualified Aetherling.Interpretations.Backend_Execute.Chisel.Expr_To_String as C_Expr_To_Str
import qualified Aetherling.Interpretations.Backend_Execute.Expr_To_String_Helpers as H_Expr_To_Str
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
import Control.Monad.Except
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import System.Exit
import System.Directory
import System.FilePath
import Data.Maybe
import Debug.Trace

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

data Language_Target = Magma | Chisel | Text deriving (Show, Eq)
text_backend = Text

data Verilog_Test_Arg = Verilog_Sim_Source String
  | Save_Gen_Verilog String
  | No_Verilog
  deriving (Show, Eq)
verilog_sim_source str = Verilog_Sim_Source $ root_dir ++ str

data Slowdown_Target =
  -- this target is the minimum area circuit with a slowdown factor
  Min_Area_With_Slowdown_Factor Int
  -- this target is all circuits with a slowdown factor
  | All_With_Slowdown_Factor Int
  | Type_Rewrites [Type_Rewrite]
  deriving (Show, Eq)

data Test_Args a b = Test_Args {test_inputs :: [a], test_output :: b}

-- | Compile a shallowly embedded sequence language program to a backend
-- representation. Then, run that backend representation through a verilog
-- simulator with the specified input. Return if the output matches the input.
test_with_backend :: (Shallow_Types.Aetherling_Value a,
                     Convertible_To_Atom_Strings b,
                     Convertible_To_Atom_Strings c) =>
                     RH.Rewrite_StateM a -> 
                     Slowdown_Target -> Language_Target ->
                     Verilog_Test_Arg ->
                     [b] -> c ->
                     IO [Test_Helpers.Test_Result]
test_with_backend shallow_seq_program s_target l_target verilog_conf
  inputs output = do
  -- get STIR expr for each program
  let deep_st_programs =
        case (runExcept $ compile_to_expr shallow_seq_program s_target) of
          Left x -> error $ "Compiler Error: " ++ show x
          Right x -> x
  let expr_latencies = map CL.compute_latency deep_st_programs
  -- convert each STIR expr to a string for the backend with an added test hardness
  let test_strs =
        case l_target of
          Magma -> do
            let modules_str_data =
                  map (M_Expr_To_Str.module_to_magma_string) deep_st_programs
            let exprs_and_str_data_and_latencies =
                  zip3 deep_st_programs modules_str_data expr_latencies
            map (\(p_expr, p_str, p_latency) ->
                   M_Tester.add_test_harness_to_fault_str p_expr p_str
                   inputs output p_latency (use_verilog_sim_source verilog_conf))
              exprs_and_str_data_and_latencies
          Chisel -> error "Chisel compilation not yet supported"
          Text -> error "Can't run tests with Text backend."
  sequence $ map
    (\(test_str, idx) -> do
        circuit_file <- emptySystemTempFile "ae_circuit.py"
        case l_target of
          Magma -> do
            if use_verilog_sim_source verilog_conf
              then copyFile (get_verilog_sim_source verilog_conf)
                   ("vBuild/top.v")
              else return ()
            write_file_ae circuit_file test_str
            process_result <- run_process ("python " ++ circuit_file) Nothing
            if save_gen_verilog verilog_conf
              then copy_verilog_file "vBuild/top.v" test_verilog_dir
                   (get_verilog_save_name verilog_conf) s_target idx
              else return ()
            process_result_to_test_result process_result circuit_file
          Chisel -> error "Chisel compilation not yet supported"
          Text -> error "Can't run tests with Text backend."
    ) (zip test_strs [0..])

add_io_to_except :: Except a b -> ExceptT a IO b
add_io_to_except except = do
  let result = runExcept except
  case result of
    Left x -> throwError x
    Right x -> return x

use_verilog_sim_source (Verilog_Sim_Source _) = True
use_verilog_sim_source _ = False

get_verilog_sim_source (Verilog_Sim_Source name) = name
get_verilog_sim_source _ = ""

save_gen_verilog (Save_Gen_Verilog _) = True
save_gen_verilog _ = False

get_verilog_save_name (Save_Gen_Verilog name) = name
get_verilog_save_name _ = ""

wrap_single_s s = Min_Area_With_Slowdown_Factor s

-- a helper int for values that should be ignored by tester as they
-- indicate invalid in shift (and thus stencil)
int_to_ignore = 253

  -- need to make convertible_to_atom_strings language generic
  -- don't need to bring generate_fault_input_output_for_st_program in from Tester
  -- each language's tester will need to call that as the tester will take a convertible_to_atom_strings [b] input and convertible_to_atom_stirngs c output
  -- this will call compile_to_string and then add_test_harness depending on language target
  -- then it will check if a verilog file is needed and copy if necessary
  -- finally, it will call the normal run_python and convert the result to a Test_Success

-- | Compile a shallowly embedded sequence language program to a backend
-- representation. Then, run that backend to produce verilog if the backend
-- can produce verilog (ie isn't Text)
compile_to_file :: (Shallow_Types.Aetherling_Value a) =>
                     RH.Rewrite_StateM a -> Slowdown_Target -> Language_Target ->
                     String -> IO [Process_Result]
compile_to_file shallow_seq_program s_target l_target output_name_template = do
  result <- runExceptT $ compile_to_file' shallow_seq_program s_target
            l_target output_name_template
  case result of
    Left x -> error $ "Compiler Error: " ++ show x
    Right x -> return x
  
compile_to_file' :: (Shallow_Types.Aetherling_Value a) =>
                     RH.Rewrite_StateM a -> Slowdown_Target -> Language_Target ->
                     String -> ExceptT Compiler_Error IO [Process_Result]
compile_to_file' shallow_seq_program s_target l_target output_name_template = do
  -- get STIR expr for each program
  deep_st_programs <- add_io_to_except $
                      compile_to_expr shallow_seq_program s_target
  -- now append to each program the code to print out verilog
  let verilog_names = map (\i -> output_name_template ++ "_" ++ s_str ++ "_" ++
                            show i ++ ".v") [0..length deep_st_programs - 1]
  case l_target of
    Magma -> do
      compile_to_magma deep_st_programs
    Chisel -> do
      compile_to_chisel deep_st_programs
    Text -> compile_to_text deep_st_programs
    where
      -- | the next three are helpers for compile_to_file for each backend
      compile_to_magma :: [STE.Expr] ->
                          ExceptT Compiler_Error IO [Process_Result]
      compile_to_magma deep_st_programs  = do
        let program_strs = map (H_Expr_To_Str.module_str .
                                M_Expr_To_Str.module_to_magma_string)
                           deep_st_programs
        lift $ sequence $ map (\(p_str, idx) -> do
                let output_file_name = compute_output_file_name idx
                let p_str_with_verilog_out = p_str ++ "\n" ++
                      M_Expr_To_Str.magma_verilog_output_epilogue
                      (replaceExtension "v" output_file_name)
                write_file_ae output_file_name p_str_with_verilog_out
                run_process ("python " ++ output_file_name) Nothing
            ) (zip program_strs [0..])
      compile_to_chisel :: [STE.Expr] ->
                          ExceptT Compiler_Error IO [Process_Result]
      compile_to_chisel deep_st_programs  = do
        let program_strs = map (H_Expr_To_Str.module_str .
                                C_Expr_To_Str.module_to_chisel_string)
                           deep_st_programs
        lift $ sequence $
          map (\(p_str, idx) -> do
                  let output_file_name = compute_output_file_name idx
                  let verilog_file_name = replaceExtension output_file_name "v"
                  -- this puts the output_file in the chisel dir for sbt
                  let chisel_file_name = chisel_dir ++ "/" ++
                                         chisel_top_src_path ++ "/" ++
                                         "Top.scala"
                  let p_str_with_verilog_out = p_str ++ "\n" ++
                        C_Expr_To_Str.chisel_verilog_output_epilogue
                  write_file_ae output_file_name p_str_with_verilog_out
                  run_process
                    (root_dir ++
                      "/src/Core/Aetherling/Interpretations/" ++
                      "Backend_Execute/Chisel/compile_chisel.sh " ++
                      output_file_name ++ " " ++
                      chisel_dir ++ " " ++
                      verilog_file_name
                    ) Nothing
              ) (zip program_strs [0..])
      compile_to_text :: [STE.Expr] ->
                         ExceptT Compiler_Error IO [Process_Result]
      compile_to_text deep_st_programs =
        lift $ sequence $
        map (\(p_expr,idx) -> do
                let p_str = ST_Print.print_st_str p_expr
                let output_file_name = compute_output_file_name idx
                write_file_ae output_file_name p_str
                return $ Process_Result ExitSuccess "" ""
            ) (zip deep_st_programs [0..])
          
      s_str = slowdown_target_to_file_name_string s_target
      compute_output_file_name :: Int -> String
      compute_output_file_name i = do
        let (l_target_dir, l_file_ending) =
              case l_target of
                Magma -> ("magma_examples", ".py")
                Chisel -> ("chisel_examples", ".scala")
                Text -> ("st_examples", ".txt")
        root_dir ++ "/test/no_bench/" ++ l_target_dir ++ "/" ++
          output_name_template ++ "/" ++
          output_name_template ++ "_" ++ s_str ++ "_" ++ show i ++ l_file_ending
  

write_file_ae :: String -> String -> IO ()
write_file_ae file_name p_str = do
  createDirectoryIfMissing True $ takeDirectory file_name
  writeFile file_name p_str
  
test_verilog_dir = root_dir ++
                   "/test/verilog_examples/aetherling_copies/"
copy_verilog_file :: FilePath -> String -> String -> Slowdown_Target -> Int -> IO ()
copy_verilog_file source_file verilog_dir name s_target idx = do
  -- test verilog dir is the directory of all the verilog output
  -- each design indicated by name gets its own folder
  -- so the different throughputs can be in the same folder
  let file_dir = verilog_dir ++ "/" ++ name
  createDirectoryIfMissing True file_dir
  let s_str = slowdown_target_to_file_name_string s_target
  copyFile source_file
    (file_dir ++ "/" ++ name ++ "_" ++ s_str ++ "_" ++ show idx ++ ".v")

slowdown_target_to_file_name_string :: Slowdown_Target -> String
slowdown_target_to_file_name_string (Min_Area_With_Slowdown_Factor s) = show s
slowdown_target_to_file_name_string (All_With_Slowdown_Factor s) = show s
slowdown_target_to_file_name_string (Type_Rewrites trs) =
  show (product_tr_periods trs)
      
run_process :: String -> Maybe FilePath -> IO Process_Result
run_process process_str cwd = do
  stdout_name <- emptySystemTempFile "ae_stdout.txt"
  stdout_file <- openFile stdout_name WriteMode
  stderr_name <- emptySystemTempFile "ae_stderr.txt"
  stderr_file <- openFile stderr_name WriteMode
  let process =
        (shell process_str) {
        cwd = cwd,
        std_out = UseHandle stdout_file,
        std_err = UseHandle stderr_file
        }
  (_ , _, _, phandle) <- createProcess process
  exit_code <- waitForProcess phandle
  stdout_text <- readFile stdout_name
  stderr_text <- readFile stderr_name
  return $ Process_Result exit_code stdout_text stderr_text

data Process_Result = Process_Result {
  proc_exit_code :: ExitCode,
  proc_stdout :: String,
  proc_stderr :: String
  } deriving (Show, Eq)

process_result_to_test_result :: Process_Result -> FilePath ->
                                 IO Test_Helpers.Test_Result
process_result_to_test_result process_result test_file = do
  case proc_exit_code process_result of
    ExitSuccess -> return Test_Helpers.Test_Success
    ExitFailure exit_code -> do
      putStrLn $ "Failure with file " ++ test_file
      let stdout = proc_stdout process_result
      putStrLn $ "stdout: \n" ++ stdout
      let stderr = proc_stderr process_result
      putStrLn $ "stderr: \n" ++ stderr
      putStrLn $ "Exit Code: " ++ show exit_code
      return $ Test_Helpers.Test_Failure test_file stdout stderr exit_code

-- | Compile a shallowly embedding sequence language program to an STIR
-- program with a desired throughput with all passes applied.
-- This is a frontend for the three types of Seq Shallow to STIR compilers
-- that also does error checking.
compile_to_expr :: (Shallow_Types.Aetherling_Value a) =>
                     RH.Rewrite_StateM a -> Slowdown_Target -> 
                     Except Compiler_Error [STE.Expr]
compile_to_expr shallow_seq_program s_target = do
  case s_target of
        Min_Area_With_Slowdown_Factor s -> do
          let deep_st_to_be_checked =
                compile_with_slowdown_to_expr shallow_seq_program s
          case check_compiler_errors s deep_st_to_be_checked of
            Nothing -> return [deep_st_to_be_checked]
            Just err -> throwError err
        All_With_Slowdown_Factor s -> do
          let deep_sts_to_be_checked =
                compile_with_slowdown_to_all_possible_expr shallow_seq_program s
          case filter isJust $
               map (check_compiler_errors s) deep_sts_to_be_checked of
            [] -> return deep_sts_to_be_checked
            errs -> throwError $ Multiple_Errors $ map fromJust errs
        Type_Rewrites trs -> do
          let deep_st_to_be_checked =
                compile_with_type_rewrite_to_expr shallow_seq_program trs
          let s = product_tr_periods trs
          case check_compiler_errors s deep_st_to_be_checked of
            Nothing -> return [deep_st_to_be_checked]
            Just err -> throwError err

data Compiler_Error = Type_Mismatch
  | Latency_Mismatch
  | Incorrect_Slowdown
  | Multiple_Errors [Compiler_Error]
  deriving (Show, Eq)

check_compiler_errors :: Int -> STE.Expr -> Maybe Compiler_Error
check_compiler_errors s program = do
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
                                     STE.Expr
compile_with_type_rewrite_to_expr shallow_seq_program tr = do
  let deep_seq_program_with_indexes =
        lower_seq_shallow_to_deep_indexed shallow_seq_program
  let deep_st_program =
        rewrite_to_partially_parallel_type_rewrite tr deep_seq_program_with_indexes
  add_registers deep_st_program
  
compile_with_slowdown_to_expr :: (Shallow_Types.Aetherling_Value a) =>
                                     RH.Rewrite_StateM a -> Int ->
                                     STE.Expr
compile_with_slowdown_to_expr shallow_seq_program s = do
  let deep_seq_program_with_indexes =
        lower_seq_shallow_to_deep_indexed shallow_seq_program
  let possible_st_programs_and_areas =
        rewrite_to_partially_parallel_slowdown s deep_seq_program_with_indexes
  let deep_st_program = get_expr_with_min_area s deep_seq_program_with_indexes
                        possible_st_programs_and_areas 
  add_registers deep_st_program
  
compile_with_slowdown_to_all_possible_expr :: (Shallow_Types.Aetherling_Value a) =>
                                              RH.Rewrite_StateM a -> Int ->
                                              [STE.Expr]
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
  
add_registers :: STE.Expr -> STE.Expr
add_registers deep_st_program = do
  let pipelined_program = APR.add_pipeline_registers deep_st_program 3
  let matched_latencies = ML.match_latencies pipelined_program
  MCF.merge_consts_and_fifos $ ML.new_expr matched_latencies



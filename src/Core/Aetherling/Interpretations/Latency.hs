module Aetherling.Interpretations.Latency where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Builders
import System.IO.Temp
import System.IO
import System.Process
import System.Environment

compute_latency :: Expr -> IO Int
compute_latency (ReshapeN in_t out_t _ _) = do
  let in_t_py_str = type_to_python in_t
  let out_t_py_str = type_to_python out_t
  tmp_file <- emptySystemTempFile "latency.txt"
  stdout_name <- emptySystemTempFile "ignoredstdout_.txt"
  stdout_file <- openFile stdout_name WriteMode
  stderr_name <- emptySystemTempFile "ignoredstderr_.txt"
  stderr_file <- openFile stderr_name WriteMode
  --callProcess "python" ["-m", "aetherling", tmp_file, "reshape_latency", in_t_py_str, out_t_py_str]
  let process =
        proc "python" ["-m", "aetherling", tmp_file,
                       "reshape_latency", in_t_py_str, out_t_py_str]
  (_ , _, _,phandle) <- createProcess process { std_out = UseHandle stdout_file,
                                                std_err = UseHandle stderr_file}
  waitForProcess phandle
  latency_str <- readFile tmp_file
  return (read latency_str :: Int)


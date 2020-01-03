module Aetherling.Interpretations.Backend_Execute.Test_Helpers where


data Ex_Test_Result = Ex_Test_Success
                  | Ex_Test_Failure {
                      python_file :: FilePath,
                      fault_stdout :: String,
                      fault_stderr :: String,
                      fault_exit_code :: Int
                      } deriving (Show, Eq)

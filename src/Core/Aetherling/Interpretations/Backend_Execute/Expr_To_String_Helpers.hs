module Aetherling.Interpretations.Backend_Execute.Expr_To_String_Helpers where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Aetherling.Monad_Helpers

tab_str = "    "

data Module_Port = Module_Port {
  -- this is the port of the instance to wire
  -- to the module's output
  port_name :: String,
  -- this is the type of the port
  port_type :: AST_Type
  } deriving (Eq, Show)

data Backend_Module_Data = Backend_Module_Data {
  cur_module_output_lines :: [String],
  modules :: [String],
  cur_module_inputs :: [Module_Port],
  cur_module_output :: Module_Port,
  -- all modules other than reduce use valid
  cur_module_valid :: Bool,
  next_module_index :: Int,
  -- first module's name is top
  is_top_module :: Bool,
  -- don't create a separate module if only 1 operator before inputs
  cur_module_num_non_inputs :: Int,
  -- the string to use if this module is just 1 operator, has the string without
  -- operator assignment
  cur_module_last_op_no_assign :: String
  } deriving (Show, Eq)

empty_print_data = Backend_Module_Data [] [] [] (Module_Port "ERROR" IntT) True 0 True 0 ""

type Memo_Print_StateM v = DAG_MemoT v (ExceptT RH.Rewrite_Failure (State Backend_Module_Data))

add_to_cur_module :: String -> Memo_Print_StateM Backend_Module_Ref ()
add_to_cur_module new_string = do
  cur_data <- lift get
  let cur_output_lines = cur_module_output_lines cur_data
  lift $ put $ cur_data { cur_module_output_lines = cur_output_lines ++ [new_string] }
  return ()

incr_num_non_inputs_cur_module :: String -> Memo_Print_StateM Backend_Module_Ref ()
incr_num_non_inputs_cur_module new_string = do
  cur_data <- lift get
  let cur_num_non_inputs = cur_module_num_non_inputs cur_data
  lift $ put $ cur_data {
    cur_module_num_non_inputs = cur_num_non_inputs + 1,
    cur_module_last_op_no_assign = new_string
    }
  return ()

update_output :: Module_Port -> Memo_Print_StateM Backend_Module_Ref ()
update_output new_output = do
  cur_data <- lift get
  lift $ put $ cur_data { cur_module_output = new_output }
  return ()

use_valid_port :: Memo_Print_StateM Backend_Module_Ref Bool
use_valid_port = do
  cur_data <- lift get
  return $ cur_module_valid cur_data

enable_valid :: Memo_Print_StateM Backend_Module_Ref ()
enable_valid = do
  cur_data <- lift get
  lift $ put $ cur_data { cur_module_valid = True }
  
set_valid :: Bool -> Memo_Print_StateM Backend_Module_Ref ()
set_valid new_val = do
  cur_data <- lift get
  lift $ put $ cur_data { cur_module_valid = new_val }
  
disable_valid :: Memo_Print_StateM Backend_Module_Ref Bool
disable_valid = do
  cur_data <- lift get
  lift $ put $ cur_data { cur_module_valid = False }
  return $ cur_module_valid cur_data

data Magma_String_Results = Magma_String_Results {
  module_str :: String,
  module_outer_results :: Backend_Module_Ref
  } deriving (Show, Eq)

data Backend_Module_Ref = Backend_Module_Ref {
  var_name :: String,
  gen_call :: String,
  in_ports :: [Module_Port],
  out_port :: Module_Port
  } deriving (Show, Eq)

error_module_ref = Backend_Module_Ref "ERR_VAR_NAME" "ERR_GEN_CALL" []
                   (Module_Port "ERR_OUT" IntT)

print_index :: DAG_Index -> String
print_index No_Index = show No_Index
print_index (Index i) = show i

module Aetherling.Interpretations.Magma.Expr_To_String where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Aetherling.Monad_Helpers
import Data.Either
import Debug.Trace

data Module_Port = Module_Port {
  -- this is the port of the instance to wire
  -- to the module's output
  port_name :: String,
  -- this is the type of the port
  port_type :: AST_Type
  } deriving Eq

instance Show Module_Port where
  show (Module_Port name t) = "\'" ++ name ++ "\', In(" ++ type_to_python t ++ ".magma_repr())"

data Magma_Data = Magma_Data {
  cur_module_output_lines :: [String],
  modules :: [String],
  cur_module_inputs :: [Module_Port],
  cur_module_output :: Module_Port,
  -- all modules other than reduce use valid
  cur_module_valid :: Bool,
  next_module_index :: Int
  } deriving (Show, Eq)

empty_print_data = Magma_Data [] [] [] (Module_Port "ERROR" IntT) True 0

type Memo_Print_StateM v = DAG_MemoT v (ExceptT RH.Rewrite_Failure (State Magma_Data))

add_to_cur_module :: String -> Memo_Print_StateM Magma_Module_Ref ()
add_to_cur_module new_string = do
  cur_data <- lift get
  let cur_output_lines = cur_module_output_lines cur_data
  lift $ put $ cur_data { cur_module_output_lines = cur_output_lines ++ [new_string] }
  return ()

use_valid_port :: Memo_Print_StateM Magma_Module_Ref Bool
use_valid_port = do
  cur_data <- lift get
  return $ cur_module_valid cur_data

enable_valid :: Memo_Print_StateM Magma_Module_Ref ()
enable_valid = do
  cur_data <- lift get
  lift $ put $ cur_data { cur_module_valid = True }
  
disable_valid :: Memo_Print_StateM Magma_Module_Ref ()
disable_valid = do
  cur_data <- lift get
  lift $ put $ cur_data { cur_module_valid = False }

magma_prelude :: IO String
magma_prelude = return $
  "import fault\n" ++
  "import aetherling.helpers.fault_helpers as fault_helpers\n" ++
  "from aetherling.space_time import *\n" ++
  "\n"

magma_epilogue :: IO String
magma_epilogue = return $
  "fault_helpers.compile(Main)\n"

print_magma :: Expr -> IO ()
print_magma e = do
  prelude <- magma_prelude
  putStrLn prelude
  let lines = execState (runExceptT $ startEvalMemoT $ print_module e) empty_print_data
  putStrLn $ foldl (++) "" $ fmap (\line -> line ++ "\n") $ modules lines
  putStrLn $ "Main = Module_" ++ (show $ next_module_index lines - 1) ++ "()"
  --epilogue <- magma_epilogue
  --putStrLn epilogue

data Magma_String_Results = Magma_String_Results {
  module_str :: String,
  module_outer_results :: Magma_Module_Ref
  } deriving (Show, Eq)

error_module_ref = Magma_Module_Ref "ERR_VAR_NAME" "ERR_GEN_CALL" []
                   (Module_Port "ERR_OUT" IntT)
                   
module_to_magma_string :: Expr -> IO Magma_String_Results
module_to_magma_string e = do
  prelude <- magma_prelude
  let (outer_module_ref, lines) = runState (runExceptT $ startEvalMemoT $ print_module e) empty_print_data
  if isLeft outer_module_ref
    then return $ Magma_String_Results
         (RH.rw_msg $ fromLeft undefined outer_module_ref)
         error_module_ref
    else do
    let mod_body = foldl (++) "" $ fmap (\line -> line ++ "\n") $ modules lines
    let mod_def = "Main = Module_" ++ (show $ next_module_index lines - 1) ++ "\n"
   -- epilogue <- magma_epilogue
    return $ Magma_String_Results
      (prelude ++ "\n" ++ mod_body ++ mod_def)
      (fromRight undefined outer_module_ref)

tab_str = "    "
-- this handles creating a module
print_module :: Expr -> Memo_Print_StateM Magma_Module_Ref Magma_Module_Ref
print_module new_module = do
  -- get state at start of module
  start_data <- lift get

  -- setup state for inside module
  let inner_data = start_data {
        cur_module_output_lines = [],
        cur_module_inputs = []
        }
  lift $ put inner_data
  
  cur_module_result_ref <- module_to_string_inner new_module

  -- get state after executing inside module
  end_data <- lift get
  let cur_module_index = next_module_index end_data
  let cur_module_name = "Module_" ++ show cur_module_index
  let cur_inputs = cur_module_inputs end_data
  let cur_inputs_str = foldl (\x y -> x ++ ", " ++ show y)
                       (show $ head $ cur_inputs) (tail $ cur_inputs)
  let cur_output_str = ", 'O', " ++ "Out(" ++
                       ((type_to_python $ port_type $
                         out_port cur_module_result_ref) ++ ".magma_repr()") ++ ")"
  let module_func_string = "@cache_definition \ndef " ++ cur_module_name ++ "() -> DefineCircuitKind:\n"
  let module_st_types =
        if length cur_inputs == 1 then
          tab_str ++ tab_str ++ "st_in_t = " ++
          (type_to_python $ port_type $ head cur_inputs) ++ "\n" ++
          tab_str ++ tab_str ++ "st_out_t = " ++
          (type_to_python $ port_type $ cur_module_output end_data) ++ "\n" ++
          tab_str ++ tab_str ++ "binary_op = False\n"
        else
          tab_str ++ tab_str ++ "st_in_t = [" ++
          (type_to_python $ port_type $ head cur_inputs) ++ ", " ++
          (type_to_python $ port_type $ head $ tail cur_inputs) ++ "]\n" ++
          tab_str ++ tab_str ++ "st_out_t = " ++
          (type_to_python $ port_type $ cur_module_output end_data) ++ "\n" ++
          tab_str ++ tab_str ++ "binary_op = True\n"
          
  let module_class_decl_string =
        tab_str ++ "class _" ++ cur_module_name ++ "(Circuit):\n" ++
        tab_str ++ tab_str ++ "name = \"" ++ cur_module_name ++ "\"\n" ++
        tab_str ++ tab_str ++ "IO = [" ++ cur_inputs_str ++ cur_output_str ++ "]" ++
        " + ClockInterface(has_ce=False,has_reset=False) + valid_ports\n" ++
        module_st_types ++
        tab_str ++ tab_str ++ "@classmethod\n" ++
        tab_str ++ tab_str ++ "def definition(cls):\n"
  let module_body = foldl (++) "" $ fmap (\b -> tab_str ++ tab_str ++ tab_str ++ b ++ "\n") $
                    cur_module_output_lines end_data
  let cur_module_result_str = var_name cur_module_result_ref ++ "." ++
                              (port_name $ out_port cur_module_result_ref)
  let module_wire_output = tab_str ++ tab_str ++ tab_str ++
                           "wire(" ++ cur_module_result_str ++ ", cls.O)\n"
  let cur_module_valid_str = var_name cur_module_result_ref ++ ".valid_down"
  let module_valid_output = tab_str ++ tab_str ++ tab_str ++
                           "wire(" ++ cur_module_valid_str ++ ", cls.valid_down)\n"
  let module_end = tab_str ++ "return _" ++ cur_module_name ++ "\n"
  let module_str = module_func_string ++ module_class_decl_string ++
                   module_body ++ module_wire_output ++ module_valid_output ++
                   module_end

  -- setup for outer module
  lift $ put $ start_data {
    next_module_index = cur_module_index + 1,
    modules = modules end_data ++ [module_str]
    }
  --traceShowM $ "module " ++ cur_module_name
  --traceShowM $ show end_data
  --traceShowM $ show cur_module_result_ref
  return $ Magma_Module_Ref (cur_module_name ++ "()") "" cur_inputs (out_port cur_module_result_ref)

data Magma_Module_Ref = Magma_Module_Ref {
  var_name :: String,
  gen_call :: String,
  in_ports :: [Module_Port],
  out_port :: Module_Port
  } deriving (Show, Eq)

int_width = "8"
-- this handles the strings inside a module
module_to_string_inner :: Expr -> Memo_Print_StateM Magma_Module_Ref Magma_Module_Ref
module_to_string_inner (IdN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
module_to_string_inner consumer_e@(AbsN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let cur_ref = Magma_Module_Ref cur_ref_name "DefineAbs_Atom(True)"
                [Module_Port "I" IntT] (Module_Port "O" IntT)
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(NotN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let cur_ref = Magma_Module_Ref cur_ref_name "DefineNot_Atom(True)"
                [Module_Port "I" BitT] (Module_Port "O" BitT)
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(AddN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let cur_ref = Magma_Module_Ref cur_ref_name "DefineAdd_Atom(True)"
                [Module_Port "I" (ATupleT IntT IntT)] (Module_Port "O" IntT)
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(SubN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let cur_ref = Magma_Module_Ref cur_ref_name "DefineSub_Atom(True)"
                [Module_Port "I" (ATupleT IntT IntT)] (Module_Port "O" IntT)
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(MulN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let cur_ref = Magma_Module_Ref cur_ref_name "DefineMul_Atom(True)"
                [Module_Port "I" (ATupleT IntT IntT)] (Module_Port "O" IntT)
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(DivN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let cur_ref = Magma_Module_Ref cur_ref_name "DefineDiv_Atom(True)"
                [Module_Port "I" (ATupleT IntT IntT)] (Module_Port "O" IntT)
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(EqN t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let cur_ref = Magma_Module_Ref cur_ref_name
                ("DefineEq_Atom(" ++ type_to_python t ++ ", True)")
                [Module_Port "I" (port_type $ out_port producer_ref)]
                (Module_Port "O" BitT)
  print_unary_operator cur_ref producer_ref
  return cur_ref

-- need to fix from here until map
-- generators
module_to_string_inner consumer_e@(Lut_GenN lut_table lut_type producer_e cur_idx) = do
  throwError $ RH.Print_Failure "Lut_GenN not printable"
{-
module_to_string_inner consumer_e@(Const_GenN constant constant_type cur_idx) = do
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Const_GenN " ++ show constant ++ " " ++
    show constant_type
  return cur_ref_name
-}

-- sequence operators
module_to_string_inner consumer_e@(Shift_sN n shift_amount elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineShift_S(" ++ show n ++ ", " ++ show shift_amount ++
                ", " ++ type_to_python elem_t ++ ", has_valid=True)"
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str
                [Module_Port "I" (SSeqT n elem_t)] (Module_Port "O" (SSeqT n elem_t))
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(Shift_tN n i shift_amount elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineShift_T(" ++ show n ++ ", " ++ show i ++ ", " ++
                show shift_amount ++ ", " ++ type_to_python elem_t ++
                ", has_valid=True)"
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str
                [Module_Port "I" (TSeqT n i elem_t)] (Module_Port "O" (TSeqT n i elem_t))
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(Up_1d_sN n elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineUp_S(" ++ show n ++ ", " ++ type_to_python elem_t ++
                ", has_valid=True)"
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str
                [Module_Port "I" (SSeqT 1 elem_t)] (Module_Port "O" (SSeqT n elem_t))
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(Up_1d_tN n i elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineUp_T(" ++ show n ++ ", " ++ show i ++ ", " ++
                type_to_python elem_t ++ ", has_valid=True)"
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str
                [Module_Port "I" (TSeqT 1 (i+n-1) elem_t)] (Module_Port "O" (TSeqT n i elem_t))
  print_unary_operator cur_ref producer_ref
  return cur_ref
-- no need for downsample module. This doesn't do anything with current clock approach
module_to_string_inner consumer_e@(Down_1d_sN n sel_idx elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
module_to_string_inner consumer_e@(Down_1d_tN n i sel_idx elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
module_to_string_inner consumer_e@(Partition_s_ssN no ni elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
module_to_string_inner consumer_e@(Partition_t_ttN no ni io 0 elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
module_to_string_inner consumer_e@(Partition_t_ttN no ni io ii elem_t producer_e cur_idx) = do
  module_to_string_inner (ReshapeN (TSeqT (no*ni) (io*ii) elem_t)
               (TSeqT no io (TSeqT ni ii elem_t)) producer_e cur_idx)
module_to_string_inner consumer_e@(Unpartition_s_ssN no ni elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
module_to_string_inner consumer_e@(Unpartition_t_ttN no ni io ii elem_t producer_e cur_idx) = do
  module_to_string_inner (ReshapeN (TSeqT no io (TSeqT ni ii elem_t))
               (TSeqT (no*ni) (io*ii) elem_t) producer_e cur_idx)
module_to_string_inner consumer_e@(SerializeN n i elem_t producer_e cur_idx) = do
  throwError $ RH.Print_Failure "Serialize not printable"
module_to_string_inner consumer_e@(DeserializeN n i elem_t producer_e cur_idx) = do
  throwError $ RH.Print_Failure "Deserialize not printable"
module_to_string_inner consumer_e@(Add_1_sN elem_t producer_e cur_idx) = do
  throwError $ RH.Print_Failure "Add_1_s not printable"
module_to_string_inner consumer_e@(Add_1_0_tN elem_t producer_e cur_idx) = do
  throwError $ RH.Print_Failure "Add_1_0_t not printable"
module_to_string_inner consumer_e@(Remove_1_sN elem_t producer_e cur_idx) = do
  throwError $ RH.Print_Failure "Remove_1_s not printable"
module_to_string_inner consumer_e@(Remove_1_0_tN elem_t producer_e cur_idx) = do
  throwError $ RH.Print_Failure "Remove_1_0_t not printable"

-- higher order operators
module_to_string_inner consumer_e@(Map_sN n f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  Magma_Module_Ref f_name f_gen_call f_in_ports f_out_port <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineMap_S(" ++ show n ++ ", " ++ f_name ++ ")"
  let map_in_ports =
        map (\port -> port {port_type = SSeqT n (port_type port)}) f_in_ports
  let map_out_port = f_out_port {port_type = SSeqT n (port_type f_out_port)}
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str map_in_ports map_out_port
  print_unary_operator cur_ref producer_ref
  return cur_ref

module_to_string_inner consumer_e@(Map_tN n i f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  Magma_Module_Ref f_name f_gen_call f_in_ports f_out_port <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineMap_T(" ++ show n ++ ", " ++ show i ++ ", " ++ f_name ++ ")"
  let map_in_ports =
        map (\port -> port {port_type = TSeqT n i (port_type port)}) f_in_ports
  let map_out_port = f_out_port {port_type = TSeqT n i (port_type f_out_port)}
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str map_in_ports map_out_port
  print_unary_operator cur_ref producer_ref
  return cur_ref

module_to_string_inner consumer_e@(Map2_sN n f producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ module_to_string_inner producer0_e
  producer1_ref <- memo producer1_e $ module_to_string_inner producer1_e
  Magma_Module_Ref f_name f_gen_call f_in_ports f_out_port <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineMap2_S(" ++ show n ++ ", " ++ f_name ++ ")"
  let map_in_ports =
        map (\port -> port {port_type = SSeqT n (port_type port)}) f_in_ports
  let map_out_port = f_out_port {port_type = SSeqT n (port_type f_out_port)}
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str map_in_ports map_out_port
  print_binary_operator cur_ref producer0_ref producer1_ref
  return cur_ref

module_to_string_inner consumer_e@(Map2_tN n i f producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ module_to_string_inner producer0_e
  producer1_ref <- memo producer1_e $ module_to_string_inner producer1_e
  Magma_Module_Ref f_name f_gen_call f_in_ports f_out_port <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineMap2_T(" ++ show n ++ ", " ++ show i ++ ", " ++ f_name ++ ")"
  let map_in_ports =
        map (\port -> port {port_type = TSeqT n i (port_type port)}) f_in_ports
  let map_out_port = f_out_port {port_type = TSeqT n i (port_type f_out_port)}
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str map_in_ports map_out_port
  print_binary_operator cur_ref producer0_ref producer1_ref
  return cur_ref

module_to_string_inner consumer_e@(Reduce_sN n f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  disable_valid
  Magma_Module_Ref f_name f_gen_call f_in_ports f_out_port <- memo f $ print_module f
  enable_valid
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineReduce_S(" ++ show n ++ ", " ++ f_name ++ ")"
  let red_in_ports = [Module_Port "I"
                      (SSeqT n $ extract_tuple_element $ port_type $
                       head f_in_ports)]
  let red_out_port = f_out_port {port_type = SSeqT n (port_type f_out_port)}
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str red_in_ports red_out_port
  print_unary_operator cur_ref producer_ref
  return cur_ref
  where
    extract_tuple_element :: AST_Type -> AST_Type
    extract_tuple_element (ATupleT t0 _) = t0
    extract_tuple_element _ = undefined

module_to_string_inner consumer_e@(Reduce_tN n i f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  disable_valid
  Magma_Module_Ref f_name f_gen_call f_in_ports f_out_port <- memo f $ print_module f
  enable_valid
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineReduce_T(" ++ show n ++ ", " ++ show i ++ ", " ++ f_name ++ ")"
  let red_in_ports = [Module_Port "I"
                      (TSeqT n i $ extract_tuple_element $ port_type $
                       head f_in_ports)]
  let red_out_port = f_out_port {port_type = TSeqT n i (port_type f_out_port)}
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str red_in_ports red_out_port
  print_unary_operator cur_ref producer_ref
  return cur_ref
  where
    extract_tuple_element :: AST_Type -> AST_Type
    extract_tuple_element (ATupleT t0 _) = t0
    extract_tuple_element _ = undefined
    
-- tuple operators
module_to_string_inner consumer_e@(FstN t0 t1 producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let producer_out_str = var_name producer_ref ++ "." ++
                         (port_name $ out_port producer_ref) 
  add_to_cur_module $ cur_ref_name ++ " = " ++ producer_out_str
  let cur_ref = Magma_Module_Ref cur_ref_name ""
                [Module_Port "I" (ATupleT t0 t1)] (Module_Port "O" t0)
  return cur_ref
  
module_to_string_inner consumer_e@(SndN t0 t1 producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let producer_out_str = var_name producer_ref ++ "." ++
                         (port_name $ out_port producer_ref) 
  add_to_cur_module $ cur_ref_name ++ " = " ++ producer_out_str
  let cur_ref = Magma_Module_Ref cur_ref_name ""
                [Module_Port "I" (ATupleT t0 t1)] (Module_Port "O" t1)
  return cur_ref
  
module_to_string_inner consumer_e@(ATupleN t0 t1 producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ module_to_string_inner producer0_e
  producer1_ref <- memo producer1_e $ module_to_string_inner producer1_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineAtomTupleCreator(" ++ type_to_python t0 ++ ", " ++
                type_to_python t1 ++ ", has_valid=True)"
  let tup_in_ports = [Module_Port "I0" t0, Module_Port "I1" t1]
  let tup_out_port = Module_Port "O" (ATupleT t0 t1)
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str tup_in_ports tup_out_port
  print_binary_operator cur_ref producer0_ref producer1_ref
  return cur_ref
  
module_to_string_inner consumer_e@(STupleN elem_t producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ module_to_string_inner producer0_e
  producer1_ref <- memo producer1_e $ module_to_string_inner producer1_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineSSeqTupleCreator(" ++ type_to_python elem_t ++
                ", has_valid=True)"
  let tup_in_ports = [Module_Port "I0" elem_t, Module_Port "I1" elem_t]
  let tup_out_port = Module_Port "O" (STupleT 2 elem_t)
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str tup_in_ports tup_out_port
  print_binary_operator cur_ref producer0_ref producer1_ref
  return cur_ref
 
module_to_string_inner consumer_e@(STupleAppendN out_len elem_t producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ module_to_string_inner producer0_e
  producer1_ref <- memo producer1_e $ module_to_string_inner producer1_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineSSeqTupleAppender(" ++ type_to_python elem_t ++ ", " ++
                (show $ out_len - 1) ++ ", has_valid=True)"
  let tup_in_ports = [Module_Port "I0" (SSeqT (out_len - 1) elem_t), Module_Port "I1" elem_t]
  let tup_out_port = Module_Port "O" (STupleT 2 elem_t)
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str tup_in_ports tup_out_port
  print_binary_operator cur_ref producer0_ref producer1_ref
  return cur_ref
  
module_to_string_inner consumer_e@(STupleToSSeqN tuple_len elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
module_to_string_inner consumer_e@(SSeqToSTupleN tuple_len elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  return producer_ref
  
module_to_string_inner (InputN t name cur_idx) = do
  cur_data <- lift get
  lift $ put $ cur_data {
    cur_module_inputs = cur_module_inputs cur_data ++ [Module_Port name t]
    }
  return $ Magma_Module_Ref "cls" "" [] (Module_Port name t)
module_to_string_inner e@(ErrorN msg cur_idx) = do
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ "ERROR " ++ msg
  return $ Magma_Module_Ref cur_ref_name "" [Module_Port "error" BitT]
    (Module_Port "error" BitT)
module_to_string_inner consumer_e@(FIFON t delay_clks producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineFIFO(" ++ type_to_python t ++
                ", " ++ show delay_clks ++ ", has_valid=True)"
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str
                [Module_Port "I" t] (Module_Port "O" t)
  print_unary_operator cur_ref producer_ref
  return cur_ref
module_to_string_inner consumer_e@(ReshapeN in_t out_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ module_to_string_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  let gen_str = "DefineReshape_st(" ++ type_to_python in_t ++
                ", " ++ type_to_python out_t ++ ")"
  let cur_ref = Magma_Module_Ref cur_ref_name gen_str
                [Module_Port "I" in_t] (Module_Port "O" out_t)
  print_unary_operator cur_ref producer_ref
  return cur_ref

print_index :: DAG_Index -> String
print_index No_Index = show No_Index
print_index (Index i) = show i

print_unary_operator :: Magma_Module_Ref -> Magma_Module_Ref -> Memo_Print_StateM Magma_Module_Ref ()
print_unary_operator cur_ref producer_ref = do
  add_to_cur_module $ var_name cur_ref ++ " = " ++ gen_call cur_ref ++ "()"
  let producer_out_str = var_name producer_ref ++ "." ++
                         (port_name $ out_port producer_ref) 
  let cur_ref_in_str = var_name cur_ref ++ "." ++
                       (port_name $ in_ports cur_ref !! 0) 
  add_to_cur_module $ "wire(" ++ producer_out_str ++ ", " ++ cur_ref_in_str ++ ")"
  valid_bool <- use_valid_port
  if valid_bool
    then do
    let producer_valid_str =
          if var_name producer_ref == "cls"
          then "cls.valid_up"
          else var_name producer_ref ++ ".valid_down"
    let cur_ref_valid_str = var_name cur_ref ++ ".valid_up"
    add_to_cur_module $ "wire(" ++ producer_valid_str ++ ", " ++ cur_ref_valid_str ++ ")"
    else return ()

print_binary_operator :: Magma_Module_Ref -> Magma_Module_Ref -> Magma_Module_Ref -> Memo_Print_StateM Magma_Module_Ref ()
print_binary_operator cur_ref producer_ref_left producer_ref_right = do
  add_to_cur_module $ var_name cur_ref ++ " = " ++ gen_call cur_ref ++ "()"
  let producer_out_str_left = var_name producer_ref_left ++ "." ++
                              (port_name $ out_port producer_ref_left) 
  let producer_out_str_right = var_name producer_ref_right ++ "." ++
                              (port_name $ out_port producer_ref_right) 
  let cur_ref_in_str_left = var_name cur_ref ++ "." ++
                            (port_name $ in_ports cur_ref !! 0) 
  let cur_ref_in_str_right = var_name cur_ref ++ "." ++
                             (port_name $ in_ports cur_ref !! 1) 
  add_to_cur_module $ "wire(" ++ producer_out_str_left ++ ", " ++ cur_ref_in_str_left ++ ")"
  add_to_cur_module $ "wire(" ++ producer_out_str_right ++ ", " ++ cur_ref_in_str_right ++ ")"
  valid_bool <- use_valid_port
  if valid_bool
    then do
    let producer_valid_str_left =
          if var_name producer_ref_left == "cls"
          then "cls.valid_up"
          else var_name producer_ref_left ++ ".valid_down"
    let producer_valid_str_right =
          if var_name producer_ref_right == "cls"
          then "cls.valid_up"
          else var_name producer_ref_right ++ ".valid_down"
    let producer_valid_str = producer_valid_str_left ++ " & " ++ producer_valid_str_right
    let cur_ref_valid_str = var_name cur_ref ++ ".valid_up"
    add_to_cur_module $ "wire(" ++ producer_valid_str ++ ", " ++ cur_ref_valid_str ++ ")"
    else return ()

get_output_port cur_ref_name = return $ cur_ref_name ++ ".O"

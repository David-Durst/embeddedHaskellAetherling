module Aetherling.Rewrites.Space_Time_To_Magma.Module_Rewrites where
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Rewrites.Space_Time_To_Magma.State
import Aetherling.Rewrites.Space_Time_To_Magma.Node_Rewrites
import Control.Monad.State
import Control.Monad.Memo
import Control.Monad.Except
import qualified Data.Map as M
import qualified Data.Set as S


-- | Take an expression and convert all it's components to strings
-- stored in a MagmaState. Then compile all the strings into a single module
-- string.
-- The return DAG_Index is the Module_Index of the module created
-- This function will add one module to the module_instances in MagmaM, increment
-- next_module, and not touch the rest of the state
-- Note: this function just pops all the non-module state off the stack and then
-- calls expr_to_magma_node
expr_to_magma_module :: Expr -> MagmaM DAG_Index
expr_to_magma_module e = do
  cur_module_idx <- increment_next_module_index
  outer_state <- lift get
  -- get a fresh state ready for the new module
  lift $ put $ outer_state {
    next_node = (Node_Index 0),
    cur_module = cur_module_idx,
    node_definitions = [],
    ready_down_map = M.empty,
    valid_down_map = M.empty,
    unwired_ready_valid_down = S.empty,
    wires = [],
    cur_module_inputs = []
    }
  -- build up the state object starting with the last expression in the cur module
  let output_node_idx = (memo expr_to_magma_node) e

  -- build the string for the cur module
  cur_module_state <- lift get
  let module_prelude = gen_magma_module_prelude
                       (cur_module_inputs cur_module_state)
                       (e_out_type $ expr_to_types e)
                       cur_module_idx
  let ce_wires = fmap (\idx -> wire_ports (idx, "CE") (cur_module_idx, "CE"))
                 (ce_to_wire cur_module_state)
  let last_ready_wires = S.map (\idx -> wire_ports (idx, "ready_down")
                                        (cur_module_idx, "ready_down"))
                         (unwired_ready_valid_down cur_module_state)
  let last_valid_wires = S.map (\idx -> "wire(" ++ get_port idx "valid_down" ++ " , "
                              ++ get_port cur_module_idx "valid_down" ++ ")\n")
                         (unwired_ready_valid_down cur_module_state)
  let module_body = node_definitions cur_module_state ++
                    wires cur_module_state ++
                    S.toList last_ready_wires ++
                    S.toList last_valid_wires ++
                    ce_wires ++
                    gen_magma_module_epilogue cur_module_idx
  -- no need to set cur_module as outer_state has preserved that
  let updated_outer_state = outer_state {
        -- the next module index is the next after all the modules that
        -- depend on this one
        next_module = next_module cur_module_state,
        module_definitions = module_definitions outer_state ++ ["\n\n\n"] ++ module_body
        }
  lift $ put updated_outer_state
  return cur_module_idx

-- | Convert a module's inputs and the module's name to the beginning of a
-- module definition
gen_magma_module_prelude :: [Module_Input] -> AST_Type -> DAG_Index -> MagmaM String
gen_magma_module_prelude inputs output_type (Module_Index d_idx) = do
  let append_module_input prior_inputs (Module_Input input_name input_type) =
        prior_inputs ++
        "'" ++ input_name ++ "', " ++
        ast_type_to_magma True input_type ++ ", " 
  let args_str = "args" ++ show d_idx ++ " = [" ++
                 foldl append_module_input [] inputs ++
                 "out, " ++ ast_type_to_magma False output_type ++
                 "] + ClockInterface(has_ce=True)\n" ++
                 "+ ready_valid_interface"
  let module_declaration_str = "module" ++ show d_idx ++
                               " DefineCircuit('module" ++ show d_idx ++
                               "'), *args" ++ show d_idx ++ ")\n"
  return $ args_str ++ module_declaration_str
gen_magma_module_prelude _ _ _ = lift $ throwError $
  Module_Failure "node index passed in for get_magma_module_prelude"

-- | Get the strings to finish a module. This includes the terms for the
-- module's CE in case nothing in the circuit uses it
gen_magma_module_epilogue :: DAG_Index -> [String]
gen_magma_module_epilogue cur_module_idx = do
  let ce_term = "ceTerm = TermAnyType(Enable)"
  let ce_wire = "wire(ceTerm.I, " ++ get_port cur_module_idx "CE" ++ ")"
  let circuit_end = "EndCircuit()"
  [ce_term, ce_wire, circuit_end]


-- | Convert an AST type to a magma string that can be used in a module interface
-- First arg is true if input, False if output
-- this relies on ast_type_to_magma' to do the recursive parts of the conversion
ast_type_to_magma :: Bool -> AST_Type -> String
ast_type_to_magma dir_bool t =
  dir_string ++ ast_type_to_magma' t ++ ".magma_repr())"
  where dir_string = if dir_bool then "In(" else "Out("

-- | The recursive helper for ast_type_to_magma
ast_type_to_magma' :: AST_Type -> String
ast_type_to_magma' UnitT = undefined
ast_type_to_magma' (SeqT _ _ _) = undefined
ast_type_to_magma' BitT = "ST_Bit()"
ast_type_to_magma' IntT = "ST_Int()"
ast_type_to_magma' (ATupleT x y) =
  "ST_Atom_Tuple(" ++ ast_type_to_magma' x ++ ", " ++ ast_type_to_magma' y ++ ")"
ast_type_to_magma' (STupleT n t) =
  "ST_SSeq_Tuple(" ++ show n ++ ", " ++ ast_type_to_magma' t ++ ")"
ast_type_to_magma' (SSeqT n t) =
  "ST_SSeq(" ++ show n ++ ", " ++ ast_type_to_magma' t ++ ")"
ast_type_to_magma' (TSeqT n i t) =
  "ST_TSeq(" ++ show n ++ ", " ++ show i ++ ", " ++ ast_type_to_magma' t ++ ")"


magma_prelude = "\from aetherling.modules import * \\ from aetherling.space_time_modules import * \
                \from magma import * \
                \from magma.bitutils import * \
                \from mantle.coreir import DefineCoreirConst "

module Aetherling.Rewrites.Space_Time_To_Magma.State where
import Aetherling.Types.Declarations
import Aetherling.Rewrites.Rewrite_Helpers
import Control.Monad.Identity
import Control.Monad.Memo
import Control.Monad.State
import Control.Monad.Except
import qualified Data.Map as M
import qualified Data.Set as S

-- | The monad that does memoization, error handling, and state management
-- for the Space_Time_To_Magma compiler
type MagmaM = MemoT Expr DAG_Index (StateT MagmaState (Except Rewrite_Failure))

data DAG_Index = Node_Index { d_idx :: Int }
               | Module_Index { d_idx :: Int }
               deriving (Eq, Ord)

instance Show DAG_Index where
  show (Node_Index i) = "node" ++ show i
  show (Module_Index i) = "module" ++ show i

increment_DAG_index :: DAG_Index -> DAG_Index
increment_DAG_index (Node_Index i) = Node_Index (i+1)
increment_DAG_index (Module_Index i) = Module_Index (i+1)

decrement_DAG_index :: DAG_Index -> DAG_Index
decrement_DAG_index (Node_Index i) = Node_Index (i-1)
decrement_DAG_index (Module_Index i) = Module_Index (i-1)

get_port :: DAG_Index -> String -> String
get_port idx str = show idx ++ "." ++ str

wire_ports :: (DAG_Index, String) -> (DAG_Index, String) -> String
wire_ports (idx0, port_name0) (idx1, port_name1) =
  "wire(" ++ get_port idx0 port_name0 ++ " , " ++ get_port idx1 port_name1 ++ ")\n"

and_ports :: [(DAG_Index, String)] -> String
and_ports ports_data = do
  let ports_strs = fmap (uncurry get_port) ports_data
  foldl (\anded_ports next_port -> anded_ports ++ " & " ++ next_port)
    (head ports_strs) (tail ports_strs)

data MagmaState = MagmaState {
  -- next node's index
  next_node :: DAG_Index,
  -- cur_module is current module
  -- exiting expr_to_magma_module decrements it so it's always current
  cur_module :: DAG_Index,
  -- next_module is the next module's index. It is never decremented
  -- as the next module always needs a fresh index
  next_module :: DAG_Index,
  node_definitions :: [String],
  module_definitions :: [String],
  -- maps of DAG_indices to ready_down and valid_down 
  -- when wiring to a node's output, use these maps to find
  -- the downstream ready and valids
  -- Nothing is the ready_down and the valid_down are taken from the
  -- module's input ports
  -- need to wire all ready_down at end. Each ready_down may need many inputs
  -- anded together
  ready_down_map :: M.Map DAG_Index (Maybe String),
  valid_down_map :: M.Map DAG_Index (Maybe String),
  -- nodes in current module who haven't had their ready and valid down's wired up yet
  -- at the end, these nodes will be wired to the module's ready/valid down
  unwired_ready_valid_down :: S.Set DAG_Index,
  -- nodes in current module who haven't had their ready and valid up's wired up yet
  -- at the end, these nodes will be wired to the module's ready/valid up
  unwired_ready_valid_up :: S.Set DAG_Index,
  -- nodes in current module that need their CE wired up
  ce_to_wire :: [DAG_Index],
  wires :: [String],
  
  cur_module_inputs :: [Module_Input]
  } deriving (Show, Eq)

empty_magma_state = MagmaState (Node_Index 0) (Module_Index 0) (Module_Index 0) [] [] M.empty M.empty S.empty S.empty [] [] []

-- | increment the next_node index in the magma state and return the old one
increment_node_index :: MagmaM DAG_Index
increment_node_index = do
  cur_state <- lift get
  let cur_node_index = next_node cur_state
  lift $ put $ cur_state { next_node = increment_DAG_index $ cur_node_index }
  return $ cur_node_index

-- | increment the next_module index in the magma state and return the old one
increment_next_module_index :: MagmaM DAG_Index
increment_next_module_index = do
  cur_state <- lift get
  let cur_module_index = next_module cur_state
  lift $ put $ cur_state { next_module = increment_DAG_index $ cur_module_index }
  return $ cur_module_index
 
data Module_Input = Module_Input {
  input_name :: String,
  input_type :: AST_Type
  } deriving (Show, Eq)

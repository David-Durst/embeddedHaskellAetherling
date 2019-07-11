module Aetherling.Rewrites.Space_Time_To_Magma.Node_Rewrites where
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Rewrites.Space_Time_To_Magma.State
import Control.Monad.State
import Control.Monad.Memo
import Control.Monad.Except
import qualified Data.Map as M
import qualified Data.Set as S


-- | Take an expression and convert it into a Magma node that can be called
-- stored in a MagmaState. Then compile all the strings necessary to use this
-- wire in later parts of a Magma module
-- The return DAG_Index is the Node_Index of the node create
expr_to_magma_node :: Expr -> MagmaM DAG_Index
expr_to_magma_node = undefined
  

wire_ready_valid_node :: DAG_Index -> [DAG_Index] -> MagmaM ()
wire_ready_valid_node cur_node_idx upstream_node_idxs = do
  cur_state <- lift get
  let cur_module_idx = cur_module cur_state
  undefined

wire_ce_node :: DAG_Index -> MagmaM ()
wire_ce_node cur_node_idx = do
  cur_state <- lift get
  let cur_module_idx = cur_module cur_state
  let new_ce_to_wire = ce_to_wire cur_state ++ [cur_node_idx]
  lift $ put $ cur_state { ce_to_wire = new_ce_to_wire }

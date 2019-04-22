module Aetherling.Interpretations.Sequence_To_Space_Time where
import qualified Aetherling.ASTs.Space_Time as ST
import qualified Aetherling.ASTs.Sequence as S
import Aetherling.Types.Declarations
import qualified Data.Map as M
import Data.Maybe
import Control.Monad.Except
import Data.Foldable

sequence_to_space_time :: Int -> S.Seq_DAG -> Except String ST.ST_DAG
sequence_to_space_time slowdown_factor seq_dag@(DAG nodes edges) = do
  let nodes_with_index = zip [0..] nodes
  let starting_builder = empty_builder seq_dag
  let st_builder_result =
        foldlM (seq_node_to_st_node slowdown_factor) starting_builder nodes_with_index
  fmap st_dag st_builder_result

-- stores the information needed during the Seq To ST convertion
data Seq_To_ST_Builder = Seq_To_ST_Builder {
  index_mapping :: Seq_To_ST_Index_Mapping,
  st_dag :: ST.ST_DAG,
  seq_dag :: S.Seq_DAG,
  next_dag_index :: DAG_Index}
  deriving (Show, Eq)

empty_builder seq_dag = Seq_To_ST_Builder M.empty (DAG [] []) seq_dag 0

-- when rewriting the Seq_DAG to ST_DAG, this maps each Seq_DAG's node to the
-- corresponding nodes in the ST_DAG. Since one Seq_DAG may corresponding to
-- multiple ST_DAG, this tracks the inputs and outputs of the collection of
-- nodes in the ST_DAG
type Seq_To_ST_Index_Mapping = M.Map DAG_Index ST_Nodes_For_Seq_Node
data ST_Nodes_For_Seq_Node = ST_Nodes_For_Seq_Node {
  st_in_index :: DAG_Index,
  st_out_index :: DAG_Index}
  deriving (Show, Eq)

-- first argument is the old builder to update.
-- second argument is the list of nodes to add to st dag
-- third argument is list of edges to add to new st dag
-- fourth argument is the corresponding index in the seq dag
add_to_DAG :: Seq_To_ST_Builder -> [ST.Space_Time_Language_AST] -> [DAG_Edge] ->
              DAG_Index -> Seq_To_ST_Builder
add_to_DAG (Seq_To_ST_Builder s_to_st_map prior_st_dag seq_dag first_cur_index)
  added_nodes added_edges seq_index =
  Seq_To_ST_Builder new_s_to_st_map (DAG new_nodes new_edges) seq_dag next_index
  where
    new_nodes = nodes prior_st_dag ++ added_nodes
    new_edges = edges prior_st_dag ++ added_edges
    next_index = first_cur_index + length added_nodes
    st_indices_for_seq_node =
      ST_Nodes_For_Seq_Node first_cur_index (next_index - 1)
    new_s_to_st_map = M.insert seq_index st_indices_for_seq_node s_to_st_map


-- get all edges that point to seq_target_index. Rename edges from sequence DAG
-- to ST DAG. It is assumed that the next nodes to be created in the st_dag are
-- the ones that correspond to seq_target_index.
get_input_indices :: Seq_To_ST_Builder -> DAG_Index -> [DAG_Edge]
get_input_indices builder seq_target_index = st_edges
  where
    seq_edges = edges $ seq_dag builder
    st_target_index = next_dag_index builder
    -- these are the edges seq_target_index as the sink
    relevant_seq_edges =
      filter (\(DAG_Edge _ sink) -> sink == seq_target_index) seq_edges
    -- take the output index corresponding to the seq_source as the output
    -- generate's the source's value
    seq_edge_to_st_edge (DAG_Edge seq_source _) = DAG_Edge
      (st_out_index $ fromJust $ M.lookup seq_source (index_mapping builder))
      st_target_index
    st_edges = fmap seq_edge_to_st_edge relevant_seq_edges

seq_node_to_st_node :: Int -> Seq_To_ST_Builder ->
  (Int, S.Sequence_Language_AST) -> Except String Seq_To_ST_Builder
  -- unary operators
seq_node_to_st_node _ builder (seq_index, S.IdN) = return $
  add_to_DAG builder [ST.IdN] (get_input_indices builder seq_index) seq_index
seq_node_to_st_node _ builder (seq_index, S.AbsN) = return $
  add_to_DAG builder [ST.AbsN] (get_input_indices builder seq_index) seq_index
seq_node_to_st_node _ builder (seq_index, S.NotN) = return $
  add_to_DAG builder [ST.NotN] (get_input_indices builder seq_index) seq_index

-- binary operators
seq_node_to_st_node _ builder (seq_index, S.AddN) = return $
  add_to_DAG builder [ST.AddN] (get_input_indices builder seq_index) seq_index
seq_node_to_st_node _ builder (seq_index, S.EqN t) = return $
  add_to_DAG builder [ST.EqN t] (get_input_indices builder seq_index) seq_index

-- generators
seq_node_to_st_node _ builder (seq_index, S.Lut_GenN tbl) = return $
  add_to_DAG builder [ST.Lut_GenN tbl] (get_input_indices builder seq_index) seq_index
seq_node_to_st_node _ builder (seq_index, S.Const_GenN v) = return $
  add_to_DAG builder [ST.Const_GenN v] (get_input_indices builder seq_index) seq_index

-- sequence operators
seq_node_to_st_node 1 builder (seq_index, S.Up_1dN n t) = return $
  add_to_DAG builder [ST.Up_1d_sN n t] (get_input_indices builder seq_index) seq_index

-- if slowdown is less than n, then no underutilization
seq_node_to_st_node slowdown builder (seq_index, S.Up_1dN n t) |
  slowdown > 1 && slowdown < n =
  return $ add_to_DAG builder [ST.Up_1d_sN n t] new_edges seq_index
  where
    ni = n `div` slowdown
    no = slowdown
    parallel_up = ST.Map_tN no 0 (DAG [ST.Up_1d_sN ni t] [])
    new_nodes = [ST.Up_1d_tN no 0 (SSeqT 1 t), parallel_up]
    input_edges_from_seq = get_input_indices builder seq_index
    starting_st_index = next_dag_index builder
    new_edges = input_edges_from_seq ++
      -- this new edge connects the up_1d_t and the map
      [DAG_Edge starting_st_index (starting_st_index + 1)]

-- if slowdown is less than n, then no underutilization
seq_node_to_st_node slowdown builder (seq_index, S.Up_1dN n t) | slowdown > n =
  return $ add_to_DAG builder [ST.Up_1d_sN n t] new_edges seq_index
  where
    new_nodes = [ST.Up_1d_tN n (slowdown `div` n) (SSeqT 1 t), parallel_up]
    input_edges_from_seq = get_input_indices builder seq_index
    starting_st_index = next_dag_index builder
    new_edges = input_edges_from_seq ++
      -- this new edge connects the up_1d_t and the map
      [DAG_Edge starting_st_index (starting_st_index + 1)]


seq_node_to_st_node slowdown builder (index, n@(S.Up_1dN _ _)) = throwError $
  show n ++ " can't be slowed down with slowdown " ++ show slowdown ++ ". The"++
  "builder is " ++ show builder ++ " and index in sequence DAG is "++ show index

seq_node_to_st_node 1 builder (seq_index, S.Down_1dN n t) = return $
  add_to_DAG builder [ST.Down_1d_sN n t] (get_input_indices builder seq_index) seq_index

-- if slowdown is less than n, then no underutilization
seq_node_to_st_node slowdown builder (seq_index, S.Down_1dN n t) |
  slowdown > 1 && slowdown < n =
  return $ add_to_DAG builder [ST.Down_1d_sN n t] new_edges seq_index
  where
    ni = n `div` slowdown
    no = slowdown
    parallel_up = ST.Map_tN 1 (no-1) (DAG [ST.Down_1d_sN ni t] [])
    new_nodes = [ST.Down_1d_tN no 0 (SSeqT ni t), parallel_up]
    input_edges_from_seq = get_input_indices builder seq_index
    starting_st_index = next_dag_index builder
    new_edges = input_edges_from_seq ++
      -- this new edge connects the up_1d_t and the map
      [DAG_Edge starting_st_index (starting_st_index + 1)]

-- if slowdown is less than n, then no underutilization
seq_node_to_st_node slowdown builder (seq_index, S.Down_1dN n t) | slowdown > n =
  return $ add_to_DAG builder [ST.Down_1d_sN n t] new_edges seq_index
  where
    parallel_up = ST.Map_tN n (slowdown `div` n) (DAG [ST.Down_1d_sN 1 t] [])
    new_nodes = [ST.Down_1d_tN n (slowdown `div` n) (SSeqT 1 t), parallel_up]
    input_edges_from_seq = get_input_indices builder seq_index
    starting_st_index = next_dag_index builder
    new_edges = input_edges_from_seq ++
      -- this new edge connects the up_1d_t and the map
      [DAG_Edge starting_st_index (starting_st_index + 1)]


seq_node_to_st_node slowdown builder (index, n@(S.Down_1dN _ _)) = throwError $
  show n ++ " can't be slowed down with slowdown " ++ show slowdown ++ ". The"++
  "builder is " ++ show builder ++ " and index in sequence DAG is "++ show index
--seq_node_to_st_node n (S.Up_1dN n t) = ST.Up_1d_sN n t
--seq_node_to_st_node 1 (S.Down_1dN n t) = ST.Down_1d_sN n t
{-

seq_node_to_st_node (S.PartitionN no ni t) = ST.Partition_ssN no ni t
seq_node_to_st_node (S.UnpartitionN no ni t) = ST.Unpartition_ssN no ni t

seq_node_to_st_node (S.MapN n inner_dag) =
  ST.Map_sN n (sequence_to_space_time inner_dag)
seq_node_to_st_node (S.Map2N n inner_dag) =
  ST.Map2_sN n (sequence_to_space_time inner_dag)
-}

-- tuple operations
seq_node_to_st_node _ builder (seq_index, S.FstN t0 t1) = return $
  add_to_DAG builder [ST.FstN t0 t1] (get_input_indices builder seq_index) seq_index
seq_node_to_st_node _ builder (seq_index, S.SndN t0 t1) = return $
  add_to_DAG builder [ST.SndN t0 t1] (get_input_indices builder seq_index) seq_index
seq_node_to_st_node _ builder (seq_index, S.ZipN t0 t1) = return $
  add_to_DAG builder [ST.ZipN t0 t1] (get_input_indices builder seq_index) seq_index

seq_node_to_st_node _ builder (seq_index, S.InputN t) = return $
  add_to_DAG builder [ST.InputN t] (get_input_indices builder seq_index) seq_index

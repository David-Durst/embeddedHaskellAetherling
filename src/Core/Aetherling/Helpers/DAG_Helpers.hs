module Aetherling.Helpers.DAG_Helpers where
import Aetherling.Types.Declarations
import qualified Data.List as L
import qualified Data.Graph as G
import qualified Data.Map as M
import qualified Data.Tuple as P

get_all_DAG_node_indices :: DAG a -> [DAG_Index]
get_all_DAG_node_indices dag = concat $
  L.map (\iter -> L.map (\idx -> DAG_Index iter idx) iter_range) iter_range
  where
    iter_range = [0 .. (L.length $ nodes dag)]
    idx_range iter = [0 .. (L.length $ (nodes dag) !! iter)]

-- | DAG index to an int, for converting my DAGs to Data.Graph dags that
-- can be sorted
index_to_int_map :: DAG a -> M.Map DAG_Index Int
index_to_int_map dag = do
  let indices = get_all_DAG_node_indices dag
  let nodes_with_indices = L.map P.swap $ L.zip [0..] indices
  M.fromList nodes_with_indices

-- | DAG index to an int, for converting Data.Graph dags to my DAGs
int_to_index_map :: DAG a -> M.Map Int DAG_Index
int_to_index_map dag = do
  let reversed_map = index_to_int_map dag
  M.fromList $ L.map P.swap $ M.toList reversed_map

convert_DAG_to_Graph :: DAG a -> G.Graph
convert_DAG_to_Graph dag = do
  let index_to_ints = index_to_int_map dag
  let max_int = P.fst $ M.findMax $ int_to_index_map dag
  -- edges without negatives, as those aren't between two real nodes
  let edges_as_ints = L.map
                      (\edge ->
                         (index_to_ints M.! source edge,
                          index_to_ints M.! sink edge))
                      (edges dag)
  -- edges without negatives, as those aren't between two real nodes
  let non_neg_edges_as_ints = filter (\edge -> (fst edge >= 0) && (snd edge >= 0)) edges_as_ints
  G.buildG (0, max_int) non_neg_edges_as_ints

get_sorted_DAG_indices :: DAG a -> [DAG_Index]
get_sorted_DAG_indices dag = do
  let graph = convert_DAG_to_Graph dag
  let sorted_graph_indices = G.topSort graph
  let ints_to_index = int_to_index_map dag
  L.map (\graph_int -> ints_to_index M.! graph_int) sorted_graph_indices

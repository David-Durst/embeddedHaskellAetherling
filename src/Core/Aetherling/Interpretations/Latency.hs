module Aetherling.Interpretations.Latency where
import Aetherling.ASTs.Space_Time
import Aetherling.Types.Declarations

get_latency :: ST_DAG -> Int
-- since each node must take same total time, just take head
get_latency (DAG (hd_node : _) _) = get_node_latency $ head hd_node
get_latency _ = 0

get_node_latency :: Space_Time_Language_AST -> Int
get_node_latency IdN = 1
get_node_latency AbsN = 1
get_node_latency NotN = 1
get_node_latency AddN = 1
get_node_latency (EqN _) = 1

  -- generators
get_node_latency (Lut_GenN _ _) = 1
get_node_latency (Const_GenN v _) = 1

  -- sequence operators
get_node_latency (Up_1d_sN n _) = 1
get_node_latency (Up_1d_tN n v _) = n+v
get_node_latency (Down_1d_sN n _) = 1
get_node_latency (Down_1d_tN n v _) = n+v
get_node_latency (Partition_s_ssN _ _ _) = 1
get_node_latency (Unpartition_s_ssN _ _ _) = 1
get_node_latency (Partition_t_ttN no vo ni vi _) = vo + no*(ni + vi)
get_node_latency (Unpartition_t_ttN no vo ni vi _) = vo + no*(ni + vi)
get_node_latency (Map_sN n f) = n * get_latency f
get_node_latency (Map_tN n v f) = v + n * get_latency f
get_node_latency (Map2_sN n f) = n * get_latency f
get_node_latency (Map2_tN n v f) = v + n * get_latency f
get_node_latency (FstN _ _) = 1
get_node_latency (SndN _ _) = 1
get_node_latency (InputN _) = 1

module Aetherling.Interpretations.Timing where
import Aetherling.ASTs.Space_Time
import Aetherling.Types.Declarations

get_latency :: ST_DAG -> Int
-- since each node must take same total time except combinational with 0,
-- get max. It will be 0 if everything is combinational. Otherwise, will
-- be clock cycles in all non-combinational nodes.
get_latency (DAG nodes _) = foldl max 0 $ fmap get_node_latency nodes

get_node_latency :: Space_Time_Language_AST -> Int
get_node_latency IdN = 0
get_node_latency AbsN = 0
get_node_latency NotN = 0
get_node_latency AddN = 0
get_node_latency (EqN _) = 0

  -- generators
get_node_latency (Lut_GenN _) = 0
get_node_latency (Const_GenN v) = 0

  -- sequence operators
get_node_latency (Up_1d_sN n _) = 0
get_node_latency (Up_1d_tN n v _) = n+v
get_node_latency (Down_1d_sN n _) = 0
get_node_latency (Down_1d_tN n v _) = n+v
get_node_latency (Partition_ssN _ _ _) = 0
get_node_latency (Unpartition_ssN _ _ _) = 0
get_node_latency (Partition_ttN no vo_in ni vi_in _) = vo_in + no*(ni + vi_in)
get_node_latency (Unpartition_ttN no vo_out ni vi_out _) = vo_out + no*(ni + vi_out)
get_node_latency (Partition_tsN no ni v_in _) = v_in + ni
get_node_latency (Unpartition_tsN no ni v_out _) = v_out + ni
get_node_latency (Map_sN n f) = n * get_latency f
get_node_latency (Map_tN n v f) = v + n * get_latency f
get_node_latency (Map2_sN n f) = n * get_latency f
get_node_latency (Map2_tN n v f) = v + n * get_latency f
get_node_latency (FstN _ _) = 0
get_node_latency (SndN _ _) = 0
get_node_latency (ZipN _ _) = 0
get_node_latency (InputN _) = 0

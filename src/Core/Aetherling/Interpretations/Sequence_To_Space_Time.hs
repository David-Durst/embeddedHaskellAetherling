module Aetherling.Interpretations.Sequence_To_Space_Time where
import qualified Aetherling.Declarations.Space_Time as ST
import qualified Aetherling.Declarations.Sequence as S
import Aetherling.Types.Declarations

sequence_to_space_time :: S.Seq_DAG -> ST.ST_DAG
sequence_to_space_time (DAG nodes edges) = DAG (fmap seq_node_to_st_node nodes) edges

seq_node_to_st_node :: S.Sequence_Language_AST -> ST.Space_Time_Language_AST
  -- unary operators
seq_node_to_st_node S.IdN = ST.IdN
seq_node_to_st_node S.AbsN = ST.AbsN
seq_node_to_st_node S.NotN = ST.NotN

-- binary operators
seq_node_to_st_node S.AddN = ST.AddN
seq_node_to_st_node (S.EqN t) = ST.EqN t

-- generators
seq_node_to_st_node (S.Lut_GenN tbl) = ST.Lut_GenN tbl
seq_node_to_st_node (S.Const_GenN v) = ST.Const_GenN v

-- sequence operators
seq_node_to_st_node (S.Up_1dN n t) = ST.Up_1d_sN n t
seq_node_to_st_node (S.Down_1dN n t) = ST.Down_1d_sN n t

seq_node_to_st_node (S.PartitionN no ni t) = ST.Partition_ssN no ni t
seq_node_to_st_node (S.UnpartitionN no ni t) = ST.Unpartition_ssN no ni t

seq_node_to_st_node (S.MapN n inner_dag) =
  ST.Map_sN n (sequence_to_space_time inner_dag)
seq_node_to_st_node (S.Map2N n inner_dag) =
  ST.Map2_sN n (sequence_to_space_time inner_dag)

-- tuple operations
-- these require no size as they are just for connecting other nodes
seq_node_to_st_node (S.FstN t0 t1) = ST.FstN t0 t1
seq_node_to_st_node (S.SndN t0 t1) = ST.SndN t0 t1
seq_node_to_st_node (S.ZipN t0 t1) = ST.ZipN t0 t1

seq_node_to_st_node (S.InputN t) = ST.InputN t

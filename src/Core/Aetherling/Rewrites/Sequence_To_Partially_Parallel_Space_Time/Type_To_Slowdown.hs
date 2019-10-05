module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Type_To_Slowdown where
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT

type_to_slowdown :: STT.AST_Type -> Int
type_to_slowdown (STT.SSeqT n t) = type_to_slowdown t
type_to_slowdown (STT.STupleT n t) = type_to_slowdown t
type_to_slowdown (STT.TSeqT n i t) = (n + i) * type_to_slowdown t
type_to_slowdown _ = 1

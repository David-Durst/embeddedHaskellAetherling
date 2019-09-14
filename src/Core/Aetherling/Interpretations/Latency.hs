module Aetherling.Interpretations.Latency where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Builders

compute_latency :: Expr -> IO Int
compute_latency (ReshapeN in_t out_t _ _) = undefined


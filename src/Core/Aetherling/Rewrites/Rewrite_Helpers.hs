module Aetherling.Rewrites.Rewrite_Helpers where
import Control.Monad.Except
import Control.Monad.Identity

data Rewrite_Failure = Expr_Failure {rw_msg :: String}
                     | Type_Failure {rw_msg :: String}
                     | Value_Failure {rw_msg :: String}
                     | Input_Failure {rw_msg :: String}
                     | Module_Failure {rw_msg :: String}
  deriving (Eq, Show)

module Aetherling.Rewrites.Rewrite_Helpers where
import Control.Monad.Except
import Control.Monad.Identity
import Aetherling.Types.Declarations

data Rewrite_Failure = Expr_Failure {rw_msg :: String, rw_expr :: Expr}
                     | Type_Failure {rw_msg :: String, rw_t :: AST_Type}
                     | Value_Failure {rw_msg :: String, rw_v :: AST_Value}
                     | Input_Failure {rw_msg :: String}
                     | Module_Failure {rw_msg :: String}
  deriving (Eq, Show)

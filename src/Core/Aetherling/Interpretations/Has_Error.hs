module Aetherling.Interpretations.Has_Error where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Builders
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions as ST_Conv
import Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions as Seq_Conv
import Aetherling.Interpretations.Space_Time_Printer
import Aetherling.Rewrites.Rewrite_Helpers
import Aetherling.Monad_Helpers
import Control.Monad.State as S
import Control.Monad.Identity
import Control.Monad.Except
import Data.Either
import Data.Maybe
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import Debug.Trace

has_error :: Expr -> Bool
has_error st_expr_in = do
  let error_result = evalState (runExceptT $ startEvalMemoT $ has_error' st_expr_in)
                     empty_rewrite_data
  if isLeft error_result
    then True
    else fromRight True error_result
    
      
    
has_error' :: Expr -> Memo_Rewrite_StateM Bool Bool
has_error' (ErrorN _ _) = return True
has_error' consumer_e = do
  let f_e_maybe = get_f consumer_e
  f_error_maybe <- mapM (\f_e -> memo f_e $ has_error' f_e) f_e_maybe
  let f_error = fromMaybe False f_error_maybe
  let producers_e = get_producers consumer_e
  producer_error <- mapM (\producer_e -> memo producer_e $ has_error' producer_e)
                    producers_e
  return $ f_error || any (== True) producer_error

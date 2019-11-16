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
has_error' consumer_e = do
  let f_e_maybe = get_f consumer_e
  f_error_maybe <- mapM (\f_e -> memo f_e $ has_error' f_e) f_e_maybe
  let f_error = fromMaybe False f_error_maybe
  {-
  let f_errorM =
        if isJust f_e_maybe
        then do
          let f_e = fromJust f_e_maybe
          memo f_e $ has_error' f_e
        else return False
  f_error <- f_errorM
-}
  let producers_e = get_producers consumer_e
  producer_error <- mapM (\producer_e -> memo producer_e $ has_error' producer_e)
                    producers_e
  return $ f_error || any (== True) producer_error
  {-
  --return $ consumer_e { seq_in = merged_producer }
  let consumer_e_producers_replaced =
        if length producers_e == 0
        then consumer_e
        else if length producers_e == 1
        then consumer_e { seq_in = merged_producers !! 0}
        else consumer_e {
          seq_in_left = merged_producers !! 0,
          seq_in_right = merged_producers !! 1
          }
  if isJust merged_f
    then return $ consumer_e_producers_replaced { f = fromJust merged_f }
    else return consumer_e_producers_replaced
-}

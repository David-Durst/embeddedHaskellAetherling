module Aetherling.Rewrites.Add_Pipeline_Registers where
import Aetherling.Interpretations.Compute_Max_Idx
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
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import Debug.Trace

add_pipeline_registers :: Expr -> Int -> Expr
-- | Add 1 register to each input port, num_end_registers to output port
add_pipeline_registers e num_end_registers = do
  let pre_pipelined_max_idx = compute_max_idx e
  let pipelined_e = evalState
                 (runExceptT $ startEvalMemoT $
                  add_pipeline_registers' e $ Just num_end_registers)
                 (Rewrite_Data $ incr_DAG_index pre_pipelined_max_idx)
  if isLeft pipelined_e
    then (ErrorN (rw_msg $ fromLeft undefined pipelined_e) No_Index)
    else fromRight undefined pipelined_e

-- maybe int is number of end registers if expr is output or nothing otherwise
add_pipeline_registers' :: Expr -> Maybe Int -> Memo_Rewrite_StateM Expr Expr
-- ok to assume this input is a top level input as map/reduce never calls inner
-- function for this rewrite
add_pipeline_registers' e@(InputN t _ _) maybe_num_end_registers = do
  reg1_idx <- get_cur_index
  reg2_idx <- get_cur_index
  add_pipeline_registers_if_last maybe_num_end_registers $
    FIFON t 1 (FIFON t 1 e reg1_idx) reg2_idx
add_pipeline_registers' e@(Const_GenN _ t _ _) maybe_num_end_registers = do
  reg_idx <- get_cur_index
  add_pipeline_registers_if_last maybe_num_end_registers e
add_pipeline_registers' e@(Map2_sN _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_left_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(Map2_tN _ _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_left_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(ATupleN _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_left_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(STupleN _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_left_pipelined, seq_in_right = producer_right_pipelined }
add_pipeline_registers' e@(STupleAppendN _ _ producer_left producer_right _)
  maybe_num_end_registers = do
  producer_left_pipelined <- memo producer_left $
                             add_pipeline_registers' producer_left Nothing
  producer_right_pipelined <- memo producer_right $
                             add_pipeline_registers' producer_right Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in_left = producer_left_pipelined, seq_in_right = producer_right_pipelined }
-- all other expressions are unary
add_pipeline_registers' e maybe_num_end_registers = do
  let producer = seq_in e
  producer_pipelined <- memo producer $
                             add_pipeline_registers' producer Nothing
  add_pipeline_registers_if_last maybe_num_end_registers $
    e { seq_in = producer_pipelined }

add_pipeline_registers_if_last :: Maybe Int -> Expr -> Memo_Rewrite_StateM Expr Expr
  -- | if e is the last expression and 1 or more pipeline reigsters to add,
  -- add 1 and recur
  -- otherwise return immediately as no registers to add
add_pipeline_registers_if_last Nothing e = return e
add_pipeline_registers_if_last (Just 0) e = return e
add_pipeline_registers_if_last (Just n) e = do
  reg_idx <- get_cur_index
  pipelined_n_minus_1_e <- add_pipeline_registers_if_last (Just $ n-1) e
  let t = ST_Conv.e_out_type $ ST_Conv.expr_to_types e
  return $ FIFON t 1 pipelined_n_minus_1_e reg_idx

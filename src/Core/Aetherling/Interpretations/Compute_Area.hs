module Aetherling.Interpretations.Compute_Area where
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
import Data.Map as M

get_area :: Expr -> Int
get_area e = do
  let computed_area = evalState
                        (runExceptT $ startEvalMemoT $ get_area' e)
                        empty_rewrite_data
  fromRight undefined computed_area

get_area' :: Expr -> Memo_Rewrite_StateM Int Int
get_area' e@(IdN producer _) = memo producer $ get_area' producer
get_area' e@(AbsN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 1
get_area' e@(NotN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 1
get_area' e@(AndN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 1
get_area' e@(OrN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 1
get_area' e@(AddN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 1
get_area' e@(SubN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 1
get_area' e@(MulN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 8
get_area' e@(DivN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 8
get_area' e@(LSRN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 8
get_area' e@(LSLN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 8
get_area' e@(LtN producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 4
get_area' e@(EqN t producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 1
get_area' e@(IfN t producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + 2

-- generators
get_area' e@(Lut_GenN _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Const_GenN _ const_t _ _) = do
  return $ area_t const_t
  

-- sequence operators
get_area' e@(Shift_sN _ _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Shift_tN _ _ shift_amount elem_t producer _) = do
  producer_area <- memo producer $ get_area' producer
  return $ producer_area + shift_amount * area_t elem_t
get_area' e@(Shift_tsN _ _ _ shift_amount elem_t producer _) = do
  producer_area <- memo producer $ get_area' producer
  return $ producer_area + shift_amount * area_t elem_t
get_area' e@(Shift_ttN _ _ _ _ shift_amount elem_t producer _) = do
  producer_area <- memo producer $ get_area' producer
  return $ producer_area + shift_amount * area_t elem_t
get_area' e@(Shift_tnN _ _ _ _ shift_amount elem_t producer _) = do
  producer_area <- memo producer $ get_area' producer
  return $ producer_area + shift_amount * area_t elem_t
get_area' e@(Up_1d_sN _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Up_1d_tN _ _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Down_1d_sN _ _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Down_1d_tN _ _ _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Partition_s_ssN _ _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Partition_t_ttN _ _ _ _ _ producer _) = do
  let input_output_types = ST_Conv.expr_to_types e
  let reshape =
        ReshapeN
        (head $ ST_Conv.e_in_types input_output_types)
        (ST_Conv.e_out_type input_output_types)
        producer No_Index
  get_area' reshape
get_area' e@(Unpartition_s_ssN _ _ _ producer _) = memo producer $ get_area' producer
get_area' e@(Unpartition_t_ttN _ _ _ _ _ producer _) = do
  let input_output_types = ST_Conv.expr_to_types e
  let reshape =
        ReshapeN
        (head $ ST_Conv.e_in_types input_output_types)
        (ST_Conv.e_out_type input_output_types)
        producer No_Index
  get_area' reshape
  get_area' reshape
  
-- these helpers shouldn't exist now that i've written reshape
get_area' e@(SerializeN n _ elem_t producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + n * area_t elem_t
get_area' e@(DeserializeN _ _ _ _ _) = undefined
get_area' e@(Add_1_sN f producer _) = get_area'_map 1 e f producer
get_area' e@(Add_1_0_tN f producer _) = get_area'_map 1 e f producer
get_area' e@(Remove_1_sN f producer _) = get_area'_map 1 e f producer
get_area' e@(Remove_1_0_tN f producer _) = get_area'_map 1 e f producer

-- higher order operators
get_area' e@(Map_sN n f producer _) = get_area'_map n e f producer
get_area' e@(Map_tN _ _ f producer _) = get_area'_map 1 e f producer 
get_area' e@(Map2_sN n f producer_left producer_right _) = do
  producer_left_area <- memo producer_left $ get_area' producer_left
  producer_right_area <- memo producer_right $ get_area' producer_right
  inner_area <- memo f $ get_area' f
  return $ producer_left_area + producer_right_area + n * inner_area
get_area' e@(Map2_tN _ _ f producer_left producer_right _) = do
  producer_left_area <- memo producer_left $ get_area' producer_left
  producer_right_area <- memo producer_right $ get_area' producer_right
  inner_area <- memo f $ get_area' f
  return $ producer_left_area + producer_right_area + inner_area
get_area' e@(Reduce_sN n f producer _) = do
  producer_area <- memo producer $ get_area' producer
  inner_area <- memo f $ get_area' f
  return $ producer_area + ((n-1) * inner_area)
get_area' e@(Reduce_tN _ _ f producer _) = do
  producer_area <- memo producer $ get_area' producer
  inner_area <- memo f $ get_area' f
  let out_t = ST_Conv.e_out_type $ ST_Conv.expr_to_types f
  return $ producer_area + inner_area + area_t out_t

-- tuple operators
get_area' e@(FstN _ _ producer _) =
  memo producer $ get_area' producer
get_area' e@(SndN _ _ producer _) =
  memo producer $ get_area' producer
get_area' e@(ATupleN _ _ producer_left producer_right _) = do
  producer_left_area <- memo producer_left $ get_area' producer_left
  producer_right_area <- memo producer_right $ get_area' producer_right
  return $ producer_left_area + producer_right_area
get_area' e@(STupleN _ producer_left producer_right _) = do
  producer_left_area <- memo producer_left $ get_area' producer_left
  producer_right_area <- memo producer_right $ get_area' producer_right
  return $ producer_left_area + producer_right_area
get_area' e@(STupleAppendN _ _ producer_left producer_right _) = do
  producer_left_area <- memo producer_left $ get_area' producer_left
  producer_right_area <- memo producer_right $ get_area' producer_right
  return $ producer_left_area + producer_right_area
get_area' e@(STupleToSSeqN _ _ producer _) = memo producer $ get_area' producer
get_area' e@(SSeqToSTupleN _ _ producer _) = memo producer $ get_area' producer

-- other operators
get_area' e@(InputN _ _ _) = return 0
get_area' e@(ErrorN error_msg _) = return (-1000000000)
get_area' e@(FIFON t delay_clks producer _) = do
  producer_latency <- memo producer $ get_area' producer
  return $ producer_latency + delay_clks * area_t t
get_area' e@(ReshapeN in_t out_t producer _) = do
  producer_area <- memo producer $ get_area' producer
  let in_t_norm = normalize_type in_t
  let out_t_norm = normalize_type out_t
  let in_out_diff = diff_types in_t_norm out_t_norm
  let type_area =
        if isJust in_out_diff
        then area_t $ fromJust in_out_diff
        else 0
  return $ producer_area + (2 * type_area)
get_area'_map n e f producer = do
  producer_area <- memo producer $ get_area' producer
  inner_area <- get_area' f
  return $ producer_area + n * inner_area

-- | The size in bits of types
area_t :: AST_Type -> Int
area_t UnitT = 0
area_t BitT = 1
area_t IntT = 1
area_t (ATupleT t0 t1) = area_t t0 + area_t t1
area_t (STupleT n t) = n * area_t t
area_t (SSeqT n t) = n * area_t t
area_t (TSeqT n _ t) = n * area_t t

module Aetherling.Languages.Sequence.Deep.Type_Checker where
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Sequence.Deep.Expr
import Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions
import Aetherling.Monad_Helpers
import Control.Monad.Except
import Control.Monad.Identity
import Control.Monad.State
import Data.Either

type Type_Checker_Error = DAG_MemoT AST_Type (Except (Either String Type_Error))

data Type_Error = Type_Error {
  consumer_input_type :: AST_Type,
  producer_output_type :: AST_Type,
  consumer :: Expr
  } deriving (Show, Eq)

check_type :: Expr -> Bool
check_type e = do
  let checked_result = runIdentity $ runExceptT $ startEvalMemoT $ check_type' e
  isRight checked_result

check_type' :: Expr -> Type_Checker_Error AST_Type
check_type' (IdN producer_e _) = check_type' producer_e
check_type' consumer_e@(AbsN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(NotN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(AddN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(SubN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(MulN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(DivN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(LSRN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(LSLN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(LtN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(EqN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(IfN _ producer_e _) =
  check_unary_operator consumer_e producer_e

-- generators
check_type' consumer_e@(Lut_GenN _ _ producer_e _) = 
  check_unary_operator consumer_e producer_e
check_type' (Const_GenN _ t _) = return t

-- sequence operators
check_type' consumer_e@(ShiftN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Up_1dN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Down_1dN _ _ _ producer_e _) = 
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(PartitionN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(UnpartitionN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e

-- higher order operators
check_type' consumer_e@(MapN _ f producer_e _) = do
  memo f $ check_type' f
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Map2N _ f producer0_e producer1_e _) = do
  memo f $ check_type' f
  check_binary_operator consumer_e producer0_e producer1_e
check_type' consumer_e@(ReduceN _ f producer_e _) = do
  memo f $ check_type' f
  check_unary_operator consumer_e producer_e

-- tuple operators
check_type' consumer_e@(FstN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(SndN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(ATupleN _ _ producer0_e producer1_e _) = do
  check_binary_operator consumer_e producer0_e producer1_e
check_type' consumer_e@(STupleN _ producer0_e producer1_e _) = do
  check_binary_operator consumer_e producer0_e producer1_e
 
check_type' consumer_e@(STupleAppendN _ _ producer0_e producer1_e _) = do
  check_binary_operator consumer_e producer0_e producer1_e
  
check_type' consumer_e@(STupleToSeqN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(SeqToSTupleN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
  
check_type' (InputN t _ _) = return t
check_type' e@(ErrorN _ _) = throwError $ Left $ show e

check_unary_operator :: Expr -> Expr -> Type_Checker_Error AST_Type
check_unary_operator consumer_op producer_op = do
  producer_output_type <- memo producer_op $ check_type' producer_op
  let consumer_input_types = e_in_types $ expr_to_types consumer_op
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  if (length consumer_input_types == 1) &&
    (head consumer_input_types == producer_output_type)
    then return consumer_output_type
    else throwError $ Right $
         Type_Error (head consumer_input_types) producer_output_type consumer_op

check_binary_operator :: Expr -> Expr -> Expr -> Type_Checker_Error AST_Type
check_binary_operator consumer_op producer_op0 producer_op1 = do
  producer0_output_type <- memo producer_op0 $ check_type' producer_op0
  producer1_output_type <- memo producer_op1 $ check_type' producer_op1
  let consumer_input_types = e_in_types $ expr_to_types consumer_op
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  if (length consumer_input_types /= 2)
    then throwError $ Left ("no two inputs for " ++ show consumer_op)
    else if (consumer_input_types !! 0 /= producer0_output_type)
    then throwError $ Right $
         Type_Error (head consumer_input_types) producer0_output_type consumer_op
    else if (consumer_input_types !! 1 /= producer1_output_type)
    then throwError $ Right $
         Type_Error (consumer_input_types !! 1) producer0_output_type consumer_op
    else return consumer_output_type

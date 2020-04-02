module Aetherling.Languages.Space_Time.Deep.Type_Checker where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Monad_Helpers
import Control.Monad.Except
import Data.Either

type Type_Checker_Error = DAG_MemoT AST_Type (Except Type_Error)

data Type_Error = Producer_Consumer_Type_Error {
  consumer_input_type :: AST_Type,
  producer_output_type :: AST_Type,
  consumer :: Expr
  }
  | Reshape_Type_Error {
      reshape_input_type :: AST_Type,
      reshape_output_type :: AST_Type,
      reshape_op :: Expr
      }
  | Propagating_Error String
  | Binary_Op_Type_Error String
  deriving (Show, Eq)

check_type :: Expr -> Bool
check_type e = do
  let checked_result = runExcept $ startEvalMemoT $ check_type' e
  isRight checked_result
  
check_type_get_error :: Expr -> Maybe Type_Error
check_type_get_error e = do
  let checked_result = runExcept $ startEvalMemoT $ check_type' e
  if isLeft checked_result
    then return $ fromLeft undefined checked_result
    else Nothing

check_type' :: Expr -> Type_Checker_Error AST_Type
check_type' (IdN producer_e _) = check_type' producer_e
check_type' consumer_e@(AbsN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(NotN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(AndN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(OrN producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(AddN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(SubN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(MulN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(DivN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(LtN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(LSRN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(LSLN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(EqN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(IfN _ producer_e _) =
  check_unary_operator consumer_e producer_e

-- generators
check_type' consumer_e@(Lut_GenN _ _ producer_e _) = 
  check_unary_operator consumer_e producer_e
check_type' (Const_GenN _ t _ _) = return t
check_type' (Counter_sN n _ int_type _ _) = return $ SSeqT n int_type
check_type' (Counter_tN n i _ int_type _ _) = return $ TSeqT n i int_type
check_type' (Counter_tsN no io ni _ int_type _ _) =
  return $ TSeqT no io (SSeqT ni int_type)
check_type' (Counter_tnN ns is _ int_type _ _) =
  return $ nested_tseq_gen ns is int_type

-- sequence operators
check_type' consumer_e@(Shift_sN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Shift_tN _ _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Shift_tsN _ _ _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Shift_ttN _ _ _ _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Shift_tnN _ _ _ _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Up_1d_sN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Up_1d_tN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Down_1d_sN _ _ _ producer_e _) = 
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Down_1d_tN _ _ _ _ producer_e _) = 
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Partition_s_ssN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Partition_t_ttN _ _ _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Unpartition_s_ssN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Unpartition_t_ttN _ _ _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(SerializeN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(DeserializeN _ _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Add_1_sN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Add_1_0_tN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Remove_1_sN _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Remove_1_0_tN _ producer_e _) =
  check_unary_operator consumer_e producer_e

-- higher order operators
check_type' consumer_e@(Map_sN _ f producer_e _) = do
  memo f $ check_type' f
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Map_tN _ _ f producer_e _) = do
  memo f $ check_type' f
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Map2_sN _ f producer0_e producer1_e _) = do
  memo f $ check_type' f
  check_binary_operator consumer_e producer0_e producer1_e
check_type' consumer_e@(Map2_tN _ _ f producer0_e producer1_e _) = do
  memo f $ check_type' f
  check_binary_operator consumer_e producer0_e producer1_e
check_type' consumer_e@(Reduce_sN _ f producer_e _) = do
  memo f $ check_type' f
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(Reduce_tN _ _ f producer_e _) = do
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
  
check_type' consumer_e@(STupleToSSeqN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(SSeqToSTupleN _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
  
check_type' (InputN t _ _) = return t
check_type' e@(ErrorN _ _) = throwError $ Propagating_Error $ show e
check_type' consumer_e@(FIFON _ _ producer_e _) =
  check_unary_operator consumer_e producer_e
check_type' consumer_e@(ReshapeN in_t out_t producer_e _) =
  if (clocks_t in_t == clocks_t out_t) &&
     (num_atoms_stuple_total_t in_t == num_atoms_stuple_total_t out_t)
  then check_unary_operator consumer_e producer_e
  else throwError $ Reshape_Type_Error in_t out_t consumer_e
  
check_unary_operator :: Expr -> Expr -> Type_Checker_Error AST_Type
check_unary_operator consumer_op producer_op = do
  producer_output_type <- memo producer_op $ check_type' producer_op
  let consumer_input_types = e_in_types $ expr_to_types consumer_op
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  if (length consumer_input_types == 1) &&
    (head consumer_input_types == producer_output_type)
    then return consumer_output_type
    else throwError $ 
         Producer_Consumer_Type_Error (head consumer_input_types)
         producer_output_type consumer_op

check_binary_operator :: Expr -> Expr -> Expr -> Type_Checker_Error AST_Type
check_binary_operator consumer_op producer_op0 producer_op1 = do
  producer0_output_type <- memo producer_op0 $ check_type' producer_op0
  producer1_output_type <- memo producer_op1 $ check_type' producer_op1
  let consumer_input_types = e_in_types $ expr_to_types consumer_op
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  if (length consumer_input_types /= 2)
    then throwError $ Binary_Op_Type_Error ("no two inputs for " ++ show consumer_op)
    else if (consumer_input_types !! 0 /= producer0_output_type)
    then throwError $
         Producer_Consumer_Type_Error (head consumer_input_types)
         producer0_output_type consumer_op
    else if (consumer_input_types !! 1 /= producer1_output_type)
    then throwError $
         Producer_Consumer_Type_Error (consumer_input_types !! 1)
         producer0_output_type consumer_op
    else return consumer_output_type

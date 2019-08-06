module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Feed_Forward_Rewrite where
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Control.Monad.Except
import Data.Maybe
import Data.Either

data Type_Conversion_Guide =
  Split { outer_t :: Type_Conversion_Guide, inner_t :: Type_Conversion_Guide }
  | Whole_Space { ws_len :: Int }
  | Whole_Time { wt_len :: Int, wt_invalid :: Int }
  | Atom
  deriving (Show, Eq)

data Slowdown_Amount = First_Node_Amount { remaining_slowdown :: Int }
  | Mid_Pipeline_Amount { conversion_guides :: [Type_Conversion_Guide] }
-- int parameter will be extra slowdown needed to propagate from above
{-
sequence_to_partially_parallel' :: Slowdown_Amount -> SeqE.Expr -> Rewrite_StateM STE.Expr
sequence_to_partially_parallel' s_layers s_extra consumer@(SeqE.IdN producer) =
  partially_parallelize_atom_operator s_layers s_extra consumer STE.IdN producer
sequence_to_partially_parallel' s_layers s_extra consumer@(SeqE.AbsN producer) =
  partially_parallelize_atom_operator s_layers s_extra consumer STE.AbsN producer
sequence_to_partially_parallel' s_layers s_extra consumer@(SeqE.NotN producer) =
  partially_parallelize_atom_operator s_layers s_extra consumer STE.NotN producer
sequence_to_partially_parallel' s_layers s_extra consumer@(SeqE.AddN producer) =
  partially_parallelize_atom_operator s_layers s_extra consumer STE.AddN producer
sequence_to_partially_parallel' s_layers s_extra consumer@(SeqE.SubN producer) =
  partially_parallelize_atom_operator s_layers s_extra consumer STE.SubN producer
sequence_to_partially_parallel' s_layers s_extra consumer@(SeqE.MulN producer) =
  partially_parallelize_atom_operator s_layers s_extra consumer STE.MulN producer
sequence_to_partially_parallel' s_layers s_extra consumer@(SeqE.DivN producer) =
  partially_parallelize_atom_operator s_layers s_extra consumer STE.DivN producer
-}
{-
partially_parallelize_AST_type :: Slowdown_Amount -> SeqT.AST_Type -> Rewrite_StateM STT.AST_Type
partially_parallelize_AST_type _ SeqT.UnitT = return STT.UnitT
partially_parallelize_AST_type _ SeqT.BitT = return STT.BitT
partially_parallelize_AST_type _ SeqT.IntT = return STT.IntT
partially_parallelize_AST_type s (SeqT.ATupleT x y) = do
  x_stt <- partially_parallelize_AST_type s x
  y_stt <- partially_parallelize_AST_type s y
  return $ (STT.ATupleT x_stt y_stt) 
partially_parallelize_AST_type (First_Node_Amount rs) (SeqT.SeqT n i t) = do
  if rs >= n
    then do
    let new_n = n
    let new_i = min i (rs - n)
    inner_type <- partially_parallelize_AST_type (First_Node_Amount) t
  --return $ STT.SSeqT n inner_type
    undefined
    else
    undefined
partially_parallelize_AST_type _ (SeqT.STupleT n t) = do
  inner_type <- parallelize_AST_type t
  return $ STT.STupleT n inner_type

parallelize_AST_value :: SeqT.AST_Value -> Rewrite_StateM STT.AST_Value
parallelize_AST_value SeqT.UnitV = return STT.UnitV
parallelize_AST_value (SeqT.BitV b) = return (STT.BitV b)
parallelize_AST_value (SeqT.IntV i) = return (STT.IntV i)
parallelize_AST_value (SeqT.ATupleV x y) = do
  x_stv <- parallelize_AST_value x
  y_stv <- parallelize_AST_value y
  return $ (STT.ATupleV x_stv y_stv) 
parallelize_AST_value (SeqT.SeqV xs _) = do
  xs_par <- mapM parallelize_AST_value xs
  return $ STT.SSeqV xs_par
parallelize_AST_value (SeqT.STupleV xs) = do
  xs_par <- mapM parallelize_AST_value xs
  return $ STT.STupleV xs_par
-}
{-
parallelize_atom_operator :: (STE.Expr -> STE.Expr) -> SeqE.Expr -> Rewrite_StateM STE.Expr
parallelize_atom_operator atom_op_gen producer = do
  producer_par <- sequence_to_fully_parallel producer
  return $ atom_op_gen producer_par
  
parallelize_unary_seq_operator :: (STT.AST_Type -> STE.Expr -> STE.Expr) -> SeqT.AST_Type ->
                                  SeqE.Expr -> Rewrite_StateM STE.Expr
parallelize_unary_seq_operator unary_seq_op_gen t producer = do
  producer_par <- sequence_to_fully_parallel producer
  t_par <- parallelize_AST_type t
  return $ unary_seq_op_gen t_par producer_par
-}

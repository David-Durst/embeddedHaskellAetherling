module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Partially_Parallel_Rewrite where
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Sequence_Length_Per_Layer
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Slowdown_Per_Layer
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Control.Monad.Except
import Data.Maybe
import Data.Either

{-
-- int parameter will be extra slowdown needed to propagate from above
sequence_to_partially_parallel' :: [Layer_Slowdown] -> Int -> SeqE.Expr ->
                                   Rewrite_StateM (STE.Expr, Int)
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

-- generators
sequence_to_partially_parallel node@(SeqE.Lut_GenN _ _ producer) =
  throwError $ Expr_Failure $ "Can't parallelize LUTs: " ++ show node

partially_parallelize_AST_type :: SeqE.Expr -> SeqT.AST_Type ->
                                  Partially_Parallel_StateM STT.AST_Type
partially_parallelize_AST_type e SeqT.UnitT = do
  slowdown_factor <- get_remaining_slowdown
  if slowdown_factor /= 1
    then throw_partially_parallel_error e
    else return STT.UnitT
partially_parallelize_AST_type e SeqT.BitT = do
  slowdown_factor <- get_remaining_slowdown
  if slowdown_factor /= 1
    then throw_partially_parallel_error e
    else return STT.BitT
partially_parallelize_AST_type e SeqT.IntT = do
  slowdown_factor <- get_remaining_slowdown
  if slowdown_factor /= 1
    then throw_partially_parallel_error e
    else return STT.IntT
partially_parallelize_AST_type e (SeqT.ATupleT x y) = do
  x_stt <- partially_parallelize_AST_type e x
  y_stt <- partially_parallelize_AST_type e y
  return $ (STT.ATupleT x_stt y_stt) 
partially_parallelize_AST_type e (SeqT.SeqT n _ t) = do
  slowdown_factor <- get_remaining_slowdown
  -- fully sequential as factor is only part of length of seq
  -- what about i? Need to consider divisibility of i as well
  if n `mod` slowdown_factor == 0
    then do
    let par_amount = n `div` slowdown_factor
    set_remaining_slowdown n slowdown_factor
    inner_type <- partially_parallelize_AST_type t
    return $ STT.TSeqT n inner_type
    else undefined
partially_parallelize_AST_type e (SeqT.STupleT n t) = do
  inner_type <- partially_parallelize_AST_type e t
  return $ STT.STupleT n inner_type

partially_parallelize_AST_value :: [Layer_Slowdown] -> Int -> SeqT.AST_Value ->
  Rewrite_StateM (STT.AST_Value, Int)
partially_parallelize_AST_value (cur_layer : _) down_extra_s (SeqT.BitV b) =
  return (STT.BitV b, layer_s cur_layer * down_extra_s)
partially_parallelize_AST_value (cur_layer : _) down_extra_s (SeqT.IntV i) =
  return (STT.IntV i, layer_s cur_layer * down_extra_s)
partially_parallelize_AST_value (cur_layer : lower_layers) down_extra_s (SeqT.ATupleV x y) = do
  x_stv <- partially_parallelize_AST_value lower_layers 1 x
  y_stv <- partially_parallelize_AST_value lower_layers 1 y
  return $ (STT.ATupleV x_stv y_stv, layer_s cur_layer * down_extra_s) 
partially_parallelize_AST_value (SeqT.SeqV xs _) = do
  xs_par <- mapM partially_parallelize_AST_value xs
  return $ STT.SSeqV xs_par
partially_parallelize_AST_value (SeqT.STupleV xs) = do
  xs_par <- mapM partially_parallelize_AST_value xs
  return $ STT.STupleV xs_par
partially_parallelize_AST_value [] _ _ = 
  throwError $ Slowdown_Failure "ran out of slowdown layers when doing AST value rewrite"

partially_parallelize_atom_operator :: [Layer_Slowdown] -> Int -> SeqE.Expr -> (STE.Expr -> STE.Expr) -> SeqE.Expr
  -> Rewrite_StateM (STE.Expr, Int)
partially_parallelize_atom_operator ls@(cur_layer : _) down_extra_s consumer atom_op_gen producer = do
  (producer_par, producer_upwards_s) <- sequence_to_partially_parallel' ls 1 producer
  if producer_upwards_s /= layer_s cur_layer
    then throwError $ Slowdown_Failure "adding an extra slowdown in chained atom operators"
    else return $ (atom_op_gen producer_par, layer_s cur_layer * down_extra_s)
partially_parallelize_atom_operator [] _ _ _ _ =
  throwError $ Slowdown_Failure "ran out of slowdown layers when doing atom rewrite"

-}

module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time where
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Space_Time.Deep.Expr as STE
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Aetherling.Languages.Sequence.Shallow.Expr_Type_Conversions
import Control.Monad.Except
import Control.Monad.Identity
import Control.Monad.State
import Data.Maybe
import Data.Either

data Partially_Parallel_Data = Partially_Parallel_Data {
  remaining_slowdown :: Int,
  -- the below data may have fewer entries than
  -- depth of returned type as it is according to pre-split types
  -- this is lengths of seqs before rewrites
  lengths_per_seq_nesting :: [Int],
  -- this is slowdown of each seq
  slowdown_per_seq_nesting :: [Int]
  } deriving (Show, Eq)

type Partially_Parallel_StateM = StateT Partially_Parallel_Data Rewrite_StateM

throw_partially_parallel_error :: SeqE.Expr -> Partially_Parallel_StateM STE.Expr
throw_partially_parallel_error e = do
  pp_data <- get
  throwError $ Slowdown_Failure $ "Can't slow down: " ++ show pp_data ++
    "\nwith expression: " ++ show e

get_remaining_slowdown :: Partially_Parallel_StateM Int
get_remaining_slowdown = do
  cur_state <- get
  return $ remaining_slowdown cur_state
  
set_remaining_slowdown :: Int -> Int -> Partially_Parallel_StateM ()
set_remaining_slowdown updated_seq_length amount_seq_slowed = do
  cur_state <- get
  put $ cur_state {
    remaining_slowdown = remaining_slowdown cur_state `div` amount_seq_slowed,
    lengths_per_seq_nesting = lengths_per_seq_nesting cur_state ++
                              [updated_seq_length],
    slowdown_per_seq_nesting = slowdown_per_seq_nesting cur_state ++
                               [amount_seq_slowed]
    }

{-
rewrite_to_partially_parallel :: Int -> SeqE.Expr -> STE.Expr
rewrite_to_partially_parallel slowdown_factor seq_expr = do
  let expr_par = runExcept $ sequence_to_partially_parallel slowdown_factor seq_expr
  if isLeft expr_par
    then STE.ErrorN (rw_msg $ fromLeft undefined expr_par)
    else fromRight undefined expr_par
-}


sequence_to_partially_parallel :: SeqE.Expr -> Partially_Parallel_StateM STE.Expr
sequence_to_partially_parallel consumer@(SeqE.IdN producer) =
  partially_parallelize_atom_operator consumer STE.IdN producer
sequence_to_partially_parallel consumer@(SeqE.AbsN producer) =
  partially_parallelize_atom_operator consumer STE.AbsN producer
sequence_to_partially_parallel consumer@(SeqE.NotN producer) =
  partially_parallelize_atom_operator consumer STE.NotN producer
sequence_to_partially_parallel consumer@(SeqE.AddN producer) =
  partially_parallelize_atom_operator consumer STE.AddN producer
sequence_to_partially_parallel consumer@(SeqE.SubN producer) =
  partially_parallelize_atom_operator consumer STE.SubN producer
sequence_to_partially_parallel consumer@(SeqE.MulN producer) =
  partially_parallelize_atom_operator consumer STE.MulN producer
sequence_to_partially_parallel consumer@(SeqE.DivN producer) =
  partially_parallelize_atom_operator consumer STE.DivN producer

-- generators
{-
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
-}

partially_parallelize_AST_value :: SeqT.AST_Value -> Rewrite_StateM STT.AST_Value
partially_parallelize_AST_value SeqT.UnitV = return STT.UnitV
partially_parallelize_AST_value (SeqT.BitV b) = return (STT.BitV b)
partially_parallelize_AST_value (SeqT.IntV i) = return (STT.IntV i)
partially_parallelize_AST_value (SeqT.ATupleV x y) = do
  x_stv <- partially_parallelize_AST_value x
  y_stv <- partially_parallelize_AST_value y
  return $ (STT.ATupleV x_stv y_stv) 
partially_parallelize_AST_value (SeqT.SeqV xs _) = do
  xs_par <- mapM partially_parallelize_AST_value xs
  return $ STT.SSeqV xs_par
partially_parallelize_AST_value (SeqT.STupleV xs) = do
  xs_par <- mapM partially_parallelize_AST_value xs
  return $ STT.STupleV xs_par
  
partially_parallelize_atom_operator :: SeqE.Expr -> (STE.Expr -> STE.Expr) -> SeqE.Expr
  -> Partially_Parallel_StateM STE.Expr
partially_parallelize_atom_operator consumer atom_op_gen producer = do
  slowdown_factor <- get_remaining_slowdown
  if slowdown_factor /= 1
    then throw_partially_parallel_error consumer
    else do
    producer_par <- sequence_to_partially_parallel producer
    return $ atom_op_gen producer_par

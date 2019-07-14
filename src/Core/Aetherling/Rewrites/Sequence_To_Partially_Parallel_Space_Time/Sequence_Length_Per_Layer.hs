module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Sequence_Length_Per_Layer where
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import Data.Maybe
import Data.Either

-- once I get to an empty layer, everything at that layer or below is empty
data Lengths_Per_Layer =
  Unary_Atom_Layer { next_element_cur_layer :: Lengths_Per_Layer}
  | Binary_Atom_Layer {
      next_left_element_cur_layer :: Lengths_Per_Layer,
      next_right_element_cur_layer :: Lengths_Per_Layer
      }
  | Unary_Seq_Layer {
      next_element_cur_layer :: Lengths_Per_Layer,
      next_layer :: Lengths_Per_Layer,
      length_cur_node :: Int
      }
  | Binary_Seq_Layer {
      next_left_element_cur_layer :: Lengths_Per_Layer,
      next_right_element_cur_layer :: Lengths_Per_Layer,
      next_layer :: Lengths_Per_Layer,
      length_cur_node :: Int
      }
  | Start_Atom_Layer
  | Start_Seq_Layer {
      next_layer :: Lengths_Per_Layer,
      length_cur_node :: Int
      }
  | Start_Empty_Layer { next_layer :: Lengths_Per_Layer }
  | Unary_Empty_Layer {
      next_element_cur_layer :: Lengths_Per_Layer,
      next_layer :: Lengths_Per_Layer
      }
  | Binary_Empty_Layer {
      next_left_element_cur_layer :: Lengths_Per_Layer,
      next_right_element_cur_layer :: Lengths_Per_Layer,
      next_layer :: Lengths_Per_Layer
      }
    deriving (Eq, Show)
  
get_lengths_per_layer :: SeqE.Expr -> Lengths_Per_Layer
get_lengths_per_layer (SeqE.IdN producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer
get_lengths_per_layer (SeqE.AbsN producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer
get_lengths_per_layer (SeqE.NotN producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer
get_lengths_per_layer (SeqE.AddN producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer
get_lengths_per_layer (SeqE.SubN producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer
get_lengths_per_layer (SeqE.MulN producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer
get_lengths_per_layer (SeqE.DivN producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer
get_lengths_per_layer (SeqE.EqN _ producer) =
  Unary_Atom_Layer $ get_lengths_per_layer producer

-- generators
get_lengths_per_layer (SeqE.Lut_GenN _ _ producer) = undefined
get_lengths_per_layer (SeqE.Const_GenN _ t) =
  get_lengths_per_layer_AST_type t

-- sequence operators
get_lengths_per_layer (SeqE.ShiftN n _ _ elem_t producer) = Unary_Seq_Layer
  (get_lengths_per_layer producer)
  (get_lengths_per_layer_AST_type elem_t)
  n
get_lengths_per_layer (SeqE.Up_1dN n _ elem_t producer) = Unary_Seq_Layer
  (get_lengths_per_layer producer)
  (get_lengths_per_layer_AST_type elem_t)
  n
get_lengths_per_layer (SeqE.Down_1dN n _ _ elem_t producer) = Unary_Seq_Layer
  (get_lengths_per_layer producer)
  (get_lengths_per_layer_AST_type elem_t)
  n
get_lengths_per_layer (SeqE.PartitionN no ni _ _ elem_t producer) = Unary_Seq_Layer
  (get_lengths_per_layer producer)
  (Start_Seq_Layer (get_lengths_per_layer_AST_type elem_t) ni)
  no
get_lengths_per_layer (SeqE.UnpartitionN no ni _ _ elem_t producer) = Unary_Seq_Layer
  (get_lengths_per_layer producer)
  (Start_Seq_Layer (get_lengths_per_layer_AST_type elem_t) ni)
  no

-- higher order operators
get_lengths_per_layer (SeqE.MapN n _ f producer) = Unary_Seq_Layer
  (get_lengths_per_layer producer)
  (get_lengths_per_layer f)
  n
get_lengths_per_layer (SeqE.Map2N n _ f producer_left producer_right) = Binary_Seq_Layer
  (get_lengths_per_layer producer_left)
  (get_lengths_per_layer producer_right)
  (get_lengths_per_layer f)
  n
get_lengths_per_layer (SeqE.ReduceN n _ f producer) = Unary_Seq_Layer
  (get_lengths_per_layer producer)
  (get_lengths_per_layer f)
  n

-- tuple operations
get_lengths_per_layer (SeqE.FstN _ _ producer) = Unary_Atom_Layer
  (get_lengths_per_layer producer)

get_lengths_per_layer (SeqE.SndN _ _ producer) = Unary_Atom_Layer
  (get_lengths_per_layer producer)

get_lengths_per_layer (SeqE.ATupleN _ _ producer_left producer_right) = Binary_Atom_Layer
  (get_lengths_per_layer producer_left)
  (get_lengths_per_layer producer_right)
  
get_lengths_per_layer (SeqE.STupleN elem_t producer_left producer_right) = Binary_Empty_Layer 
  (get_lengths_per_layer producer_left)
  (get_lengths_per_layer producer_right)
  (get_lengths_per_layer_AST_type elem_t)

get_lengths_per_layer (SeqE.STupleAppendN _ elem_t producer_left producer_right) = Binary_Empty_Layer 
  (get_lengths_per_layer producer_left)
  (get_lengths_per_layer producer_right)
  (get_lengths_per_layer_AST_type elem_t)
  
get_lengths_per_layer (SeqE.STupleToSeqN _ _ _ _ elem_t producer) = Unary_Empty_Layer
  (get_lengths_per_layer producer)
  (get_lengths_per_layer_AST_type elem_t)
  
get_lengths_per_layer (SeqE.SeqToSTupleN no ni io ii elem_t producer) = Unary_Empty_Layer
  (get_lengths_per_layer producer)
  (get_lengths_per_layer_AST_type elem_t)

get_lengths_per_layer (SeqE.InputN t _) = do
  get_lengths_per_layer_AST_type t

get_lengths_per_layer (SeqE.ErrorN s) = Start_Seq_Layer Start_Atom_Layer (-1)


get_lengths_per_layer_AST_type :: SeqT.AST_Type -> Lengths_Per_Layer
get_lengths_per_layer_AST_type SeqT.UnitT = Start_Atom_Layer 
get_lengths_per_layer_AST_type SeqT.BitT = Start_Atom_Layer
get_lengths_per_layer_AST_type SeqT.IntT = Start_Atom_Layer 
get_lengths_per_layer_AST_type (SeqT.ATupleT x y) = Start_Atom_Layer 
get_lengths_per_layer_AST_type (SeqT.SeqT n _ t) =
  Start_Seq_Layer (get_lengths_per_layer_AST_type t) n
get_lengths_per_layer_AST_type (SeqT.STupleT n t) =
  Start_Empty_Layer (get_lengths_per_layer_AST_type t)
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

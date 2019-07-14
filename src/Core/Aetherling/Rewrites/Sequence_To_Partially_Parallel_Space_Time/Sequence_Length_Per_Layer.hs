module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Sequence_Length_Per_Layer where
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Expr as SeqE
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import Data.Maybe
import Data.Either
import Control.Applicative

-- once I get to an empty layer, everything at that layer or below is empty
data Lengths_Per_Layer = Lengths_Per_Layer { lengths :: [[Maybe Int]]}
    deriving (Eq, Show)

merge_lengths_per_layer :: Lengths_Per_Layer -> Lengths_Per_Layer -> Lengths_Per_Layer
merge_lengths_per_layer (Lengths_Per_Layer lengths0) (Lengths_Per_Layer lengths1) =
  Lengths_Per_Layer $ getZipList $ (++) <$>
  ZipList deep_layer_list <*> ZipList extended_list 
  where
    -- need to extended the shallower list so that don't truncate longer one
    -- when merging
    deep_layer_list = max lengths0 lengths1
    shallower_layer_list = min lengths0 lengths1
    extended_list = shallower_layer_list ++ (repeat [])

prepend_lengths_per_layer :: Maybe Int -> Lengths_Per_Layer -> Lengths_Per_Layer
prepend_lengths_per_layer prefix (Lengths_Per_Layer body) =
  Lengths_Per_Layer ([prefix] : body)
  
get_lengths_per_layer :: SeqE.Expr -> Lengths_Per_Layer
get_lengths_per_layer (SeqE.IdN producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer
get_lengths_per_layer (SeqE.AbsN producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer
get_lengths_per_layer (SeqE.NotN producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer
get_lengths_per_layer (SeqE.AddN producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer
get_lengths_per_layer (SeqE.SubN producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer
get_lengths_per_layer (SeqE.MulN producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer
get_lengths_per_layer (SeqE.DivN producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer
get_lengths_per_layer (SeqE.EqN _ producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer

-- generators
get_lengths_per_layer (SeqE.Lut_GenN _ _ producer) = undefined
get_lengths_per_layer (SeqE.Const_GenN _ t) =
  get_lengths_per_layer_AST_type t

-- sequence operators
get_lengths_per_layer (SeqE.ShiftN n _ _ elem_t producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just n)
                       (get_lengths_per_layer_AST_type elem_t)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)
get_lengths_per_layer (SeqE.Up_1dN n _ elem_t producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just n)
                       (get_lengths_per_layer_AST_type elem_t)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)
get_lengths_per_layer (SeqE.Down_1dN n _ _ elem_t producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just n)
                       (get_lengths_per_layer_AST_type elem_t)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)
get_lengths_per_layer (SeqE.PartitionN no ni _ _ elem_t producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just no) $
                       prepend_lengths_per_layer (Just ni)
                       (get_lengths_per_layer_AST_type elem_t)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)
get_lengths_per_layer (SeqE.UnpartitionN no ni _ _ elem_t producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just no) $
                       prepend_lengths_per_layer (Just ni)
                       (get_lengths_per_layer_AST_type elem_t)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)

-- higher order operators
get_lengths_per_layer (SeqE.MapN n _ f producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just n)
                       (get_lengths_per_layer f)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)
get_lengths_per_layer (SeqE.Map2N n _ f producer_left producer_right) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just n)
                       (get_lengths_per_layer f)
  merge_lengths_per_layer cur_op_lengths $
    merge_lengths_per_layer (get_lengths_per_layer producer_left)
    (get_lengths_per_layer producer_right)
get_lengths_per_layer (SeqE.ReduceN n _ f producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just n)
                       (get_lengths_per_layer f)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)

-- tuple operations
get_lengths_per_layer (SeqE.FstN _ _ producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer

get_lengths_per_layer (SeqE.SndN _ _ producer) =
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
  get_lengths_per_layer producer

get_lengths_per_layer (SeqE.ATupleN _ _ producer_left producer_right) = do
  merge_lengths_per_layer (Lengths_Per_Layer [[Nothing]]) $
    merge_lengths_per_layer (get_lengths_per_layer producer_left)
    (get_lengths_per_layer producer_left)
  
get_lengths_per_layer (SeqE.STupleN elem_t producer_left producer_right) = do
  merge_lengths_per_layer (get_lengths_per_layer_AST_type elem_t) $
    merge_lengths_per_layer (get_lengths_per_layer producer_left)
    (get_lengths_per_layer producer_left)

get_lengths_per_layer (SeqE.STupleAppendN _ elem_t producer_left producer_right) = do
  merge_lengths_per_layer cur_op_lengths $
    merge_lengths_per_layer (get_lengths_per_layer producer_left)
    (get_lengths_per_layer producer_left)
  where
    elem_lengths = get_lengths_per_layer_AST_type elem_t
    cur_op_lengths = prepend_lengths_per_layer Nothing elem_lengths
  
get_lengths_per_layer (SeqE.STupleToSeqN no ni _ _ elem_t producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just no) $
                       prepend_lengths_per_layer (Just ni)
                       (get_lengths_per_layer_AST_type elem_t)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)
  
get_lengths_per_layer (SeqE.SeqToSTupleN no ni _ _ elem_t producer) = do
  let cur_op_lengths = prepend_lengths_per_layer (Just no) $
                       prepend_lengths_per_layer (Just ni)
                       (get_lengths_per_layer_AST_type elem_t)
  merge_lengths_per_layer cur_op_lengths (get_lengths_per_layer producer)

get_lengths_per_layer (SeqE.InputN t _) = do
  get_lengths_per_layer_AST_type t

get_lengths_per_layer (SeqE.ErrorN s) = Lengths_Per_Layer []


get_lengths_per_layer_AST_type :: SeqT.AST_Type -> Lengths_Per_Layer
get_lengths_per_layer_AST_type SeqT.UnitT = Lengths_Per_Layer [[Nothing]]
get_lengths_per_layer_AST_type SeqT.BitT = Lengths_Per_Layer [[Nothing]]
get_lengths_per_layer_AST_type SeqT.IntT = Lengths_Per_Layer [[Nothing]]
get_lengths_per_layer_AST_type (SeqT.ATupleT x y) = Lengths_Per_Layer [[Nothing]]
get_lengths_per_layer_AST_type (SeqT.SeqT n _ t) =
  prepend_lengths_per_layer (Just n) $ get_lengths_per_layer_AST_type t
get_lengths_per_layer_AST_type (SeqT.STupleT n t) =
  prepend_lengths_per_layer Nothing $ get_lengths_per_layer_AST_type t
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

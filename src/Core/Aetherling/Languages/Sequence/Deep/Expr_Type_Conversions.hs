module Aetherling.Languages.Sequence.Deep.Expr_Type_Conversions where
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Languages.Sequence.Deep.Expr
import Control.Monad.State
import qualified Data.Set as S

size_int :: Int
size_int = 8
size_bit :: Int
size_bit = 1

-- | The size in bits of types
size_t :: AST_Type -> Int
size_t UnitT = 0
size_t BitT = size_bit
size_t IntT = size_int
size_t (ATupleT t0 t1) = size_t t0 + size_t t1
size_t (STupleT n t) = n * size_t t
size_t (SeqT _ _ _) = 0

-- | input and outputs for an expression when not considering the
-- input expressions to it
data Expr_Types = Expr_Types { e_in_types :: [AST_Type], e_out_type :: AST_Type}
  deriving (Show, Eq, Ord)

-- | Convert an Expr to it's input and output tpyes not considering the input
-- expressions to it
expr_to_types :: Expr -> Expr_Types
expr_to_types (IdN in_e) = Expr_Types [input_type] input_type
  where input_type = e_out_type $ expr_to_types in_e
expr_to_types (AbsN _) = Expr_Types [IntT] IntT
expr_to_types (NotN _) = Expr_Types [BitT] BitT
expr_to_types (AddN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (SubN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (MulN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (DivN _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (EqN t _) = Expr_Types [ATupleT t t] BitT

-- generators
expr_to_types (Lut_GenN _ t _) = Expr_Types [IntT] t
expr_to_types (Const_GenN _ t) = Expr_Types [] t

-- sequence operators
expr_to_types (ShiftN n i _ elem_t _) = Expr_Types [seq_type] seq_type
  where seq_type = SeqT n i elem_t
expr_to_types (Up_1dN n i elem_t _) = Expr_Types in_types out_type
  where
    in_types = [SeqT 1 (n - 1 + i) elem_t]
    out_type = SeqT n i elem_t
expr_to_types (Down_1dN n i _ elem_t _) = Expr_Types in_types out_type
  where
    in_types = [SeqT n i elem_t]
    out_type = SeqT 1 (n - 1 + i) elem_t
expr_to_types (PartitionN no ni io ii elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [SeqT (no * ni) (invalid_clocks_from_nested no ni io ii) elem_t]
    out_type = SeqT no io (SeqT ni ii elem_t)
expr_to_types (UnpartitionN no ni io ii elem_t _) =
  Expr_Types in_types out_type
  where
    in_types = [SeqT no io (SeqT ni ii elem_t)]
    out_type = SeqT (no * ni) (invalid_clocks_from_nested no ni io ii) elem_t

-- higher order operators
expr_to_types (MapN n i f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    in_types = fmap (SeqT n i) $ e_in_types inner_types
    out_type = SeqT n i $ e_out_type inner_types
expr_to_types (Map2N n i f _ _) = Expr_Types in_types out_type
  where
    -- this only looks at last node (f's) type, need to get input
    -- type to whole inner expression ending with f
    inner_types = expr_to_outer_types f
    in_types = fmap (SeqT n i) $ e_in_types inner_types
    out_type = SeqT n i $ e_out_type inner_types
expr_to_types (ReduceN n i f _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    -- the reducer f must accept a tuple of the same type as it's output
    -- and the whole reduce must use Seqs of that type on input and output
    in_types = [SeqT n i $ e_out_type inner_types]
    out_type = SeqT 1 (n - 1 + i) $ e_out_type inner_types

-- tuple operators
expr_to_types (FstN t0 t1 _) = Expr_Types [ATupleT t0 t1] t0
expr_to_types (SndN t0 t1 _) = Expr_Types [ATupleT t0 t1] t1
expr_to_types (ATupleN t0 t1 _ _) = Expr_Types [t0, t1] (ATupleT t0 t1)
expr_to_types (STupleN elem_t _ _) =
  Expr_Types [elem_t, elem_t] (STupleT 2 elem_t)
  
expr_to_types (STupleAppendN out_len elem_t _ _) =
  Expr_Types [STupleT (out_len - 1) elem_t, elem_t] (STupleT out_len elem_t)
  
expr_to_types (STupleToSeqN no ni io ii tuple_elem_t _) =
  Expr_Types [SeqT no ((no * ((ni - 1) + ii)) + (io * (ni + ii))) (STupleT ni tuple_elem_t)]
  (SeqT no io (SeqT ni ii tuple_elem_t))
expr_to_types (SeqToSTupleN no ni io ii tuple_elem_t _) =
  Expr_Types [SeqT no io (SeqT ni ii tuple_elem_t)]
  (SeqT no ((no * ((ni - 1) + ii)) + (io * (ni + ii))) (STupleT ni tuple_elem_t))
  
expr_to_types (InputN t _) = Expr_Types [] t
expr_to_types (ErrorN _) = Expr_Types [] UnitT

-- | get the input and output types of the entire expression,
-- not just those of the last expression like expr_to_types

type Input_TrackerM = State (S.Set String)

expr_to_outer_types :: Expr -> Expr_Types
expr_to_outer_types e = evalState (expr_to_outer_types' e) S.empty

expr_to_outer_types' :: Expr -> Input_TrackerM Expr_Types
expr_to_outer_types' (IdN producer_e) = expr_to_outer_types' producer_e
expr_to_outer_types' consumer_e@(AbsN producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(NotN producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(AddN producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(SubN producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(MulN producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(DivN producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(EqN _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e

-- generators
expr_to_outer_types' consumer_e@(Lut_GenN _ _ producer_e) = 
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' (Const_GenN _ t) = return $ Expr_Types [] t

-- sequence operators
expr_to_outer_types' consumer_e@(ShiftN _ _ _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Up_1dN _ _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Down_1dN _ _ _ _ producer_e) = 
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(PartitionN _ _ _ _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(UnpartitionN _ _ _ _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e

-- higher order operators
expr_to_outer_types' consumer_e@(MapN _ _ _ producer_e) = do
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Map2N _ _ _ producer0_e producer1_e) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
expr_to_outer_types' consumer_e@(ReduceN _ _ _ producer_e) = do
  expr_to_outer_types_atom_operator consumer_e producer_e

-- tuple operators
expr_to_outer_types' consumer_e@(FstN _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(SndN _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(ATupleN _ _ producer0_e producer1_e) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
expr_to_outer_types' consumer_e@(STupleN _ producer0_e producer1_e) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
 
expr_to_outer_types' consumer_e@(STupleAppendN _ _ producer0_e producer1_e) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
  
expr_to_outer_types' consumer_e@(STupleToSeqN _ _ _ _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(SeqToSTupleN _ _ _ _ _ producer_e) =
  expr_to_outer_types_atom_operator consumer_e producer_e
  
expr_to_outer_types' (InputN t name) = do
  previous_names <- get
  if S.member name previous_names
    then return $ Expr_Types [] t
    else do
    let updated_names = S.insert name previous_names
    put updated_names 
    return $ Expr_Types [t] t
expr_to_outer_types' (ErrorN _) = return $ Expr_Types [] UnitT

expr_to_outer_types_atom_operator :: Expr -> Expr -> Input_TrackerM Expr_Types 
expr_to_outer_types_atom_operator consumer_op producer_op = do
  producer_outer_types <- expr_to_outer_types' producer_op
  let producer_input_types = e_in_types producer_outer_types
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  return $ Expr_Types producer_input_types consumer_output_type

expr_to_outer_types_binary_operator :: Expr -> Expr -> Expr -> Input_TrackerM Expr_Types
expr_to_outer_types_binary_operator consumer_op producer_op0 producer_op1 = do
  producer0_outer_types <- expr_to_outer_types' producer_op0
  let producer0_input_types = e_in_types producer0_outer_types
  producer1_outer_types <- expr_to_outer_types' producer_op1
  let producer1_input_types = e_in_types producer1_outer_types
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  return $ Expr_Types (producer0_input_types ++ producer1_input_types) consumer_output_type

invalid_clocks_from_nested :: Int -> Int -> Int -> Int -> Int
invalid_clocks_from_nested no ni io ii = (no * ii) + (io * (ni + ii))

total_clocks_from_nested :: Int -> Int -> Int -> Int -> Int
total_clocks_from_nested no ni io ii = (no * (ni + ii)) + (io * (ni + ii))

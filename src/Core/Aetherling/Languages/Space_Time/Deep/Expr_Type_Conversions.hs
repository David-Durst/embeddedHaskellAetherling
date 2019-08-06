module Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Control.Monad.State
import Aetherling.Monad_Helpers
import qualified Data.Set as S
import Debug.Trace

-- | input and outputs for an expression when not considering the
-- input expressions to it
data Expr_Types = Expr_Types { e_in_types :: [AST_Type], e_out_type :: AST_Type}
  deriving (Show, Eq, Ord)

-- | Convert an Expr to it's input and output tpyes not considering the input
-- expressions to it
expr_to_types :: Expr -> Expr_Types
expr_to_types (IdN in_e _) = Expr_Types [input_type] input_type
  where input_type = e_out_type $ expr_to_types in_e
expr_to_types (AbsN _ _) = Expr_Types [IntT] IntT
expr_to_types (NotN _ _) = Expr_Types [BitT] BitT
expr_to_types (AddN _ _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (SubN _ _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (MulN _ _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (DivN _ _) = Expr_Types [ATupleT IntT IntT] IntT
expr_to_types (EqN t _ _) = Expr_Types [ATupleT t t] BitT

-- generators
expr_to_types (Lut_GenN _ t _ _) = Expr_Types [IntT] t
expr_to_types (Const_GenN _ t _) = Expr_Types [] t

-- sequence operators
expr_to_types (Shift_sN n _ elem_t _ _) = Expr_Types [seq_type] seq_type
  where seq_type = SSeqT n elem_t
expr_to_types (Shift_tN n i _ elem_t _ _) = Expr_Types [seq_type] seq_type
  where seq_type = TSeqT n i elem_t
expr_to_types (Up_1d_sN n elem_t _ _) = Expr_Types in_types out_type
  where
    in_types = [SSeqT 1 elem_t]
    out_type = SSeqT n elem_t
expr_to_types (Up_1d_tN n i elem_t _ _) = Expr_Types in_types out_type
  where
    in_types = [TSeqT 1 (n - 1 + i) elem_t]
    out_type = TSeqT n i elem_t
expr_to_types (Down_1d_sN n _ elem_t _ _) = Expr_Types in_types out_type
  where
    in_types = [SSeqT n elem_t]
    out_type = SSeqT 1 elem_t
expr_to_types (Down_1d_tN n i _ elem_t _ _) = Expr_Types in_types out_type
  where
    in_types = [TSeqT n i elem_t]
    out_type = TSeqT 1 (n - 1 + i) elem_t
expr_to_types (Partition_s_ssN no ni elem_t _ _) =
  Expr_Types in_types out_type
  where
    in_types = [SSeqT (no * ni) elem_t]
    out_type = SSeqT no (SSeqT ni elem_t)
expr_to_types (Partition_t_ttN no ni io ii elem_t _ _) =
  Expr_Types in_types out_type
  where
    in_types = [TSeqT (no * ni) ((no * ii) + (io * (ni + ii))) elem_t]
    out_type = TSeqT no io (TSeqT ni ii elem_t)
expr_to_types (Unpartition_s_ssN no ni elem_t _ _) =
  Expr_Types in_types out_type
  where
    in_types = [SSeqT no (SSeqT ni elem_t)]
    out_type = SSeqT (no * ni) elem_t
expr_to_types (Unpartition_t_ttN no ni io ii elem_t _ _) =
  Expr_Types in_types out_type
  where
    in_types = [TSeqT no io (TSeqT ni ii elem_t)]
    out_type = TSeqT (no * ni) ((no * ii) + (io * (ni + ii))) elem_t

expr_to_types (SerializeN n i tuple_elem_t _ _) =
  Expr_Types [TSeqT 1 ((n - 1) + i) (SSeqT n tuple_elem_t)]
  (TSeqT n i tuple_elem_t)
expr_to_types (DeserializeN n i tuple_elem_t _ _) =
  Expr_Types [(TSeqT n i tuple_elem_t)]
  (TSeqT 1 ((n - 1) + i) (SSeqT n tuple_elem_t))

expr_to_types (Add_1_sN elem_t _ _) =
  Expr_Types [elem_t] (SSeqT 1 elem_t)
expr_to_types (Add_1_0_tN elem_t _ _) =
  Expr_Types [elem_t] (TSeqT 1 0 elem_t)
expr_to_types (Remove_1_sN elem_t _ _) =
  Expr_Types [SSeqT 1 elem_t] elem_t
expr_to_types (Remove_1_0_tN elem_t _ _) =
  Expr_Types [TSeqT 1 0 elem_t] elem_t

-- higher order operators
expr_to_types (Map_sN n f _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    in_types = fmap (SSeqT n) $ e_in_types inner_types
    out_type = SSeqT n $ e_out_type inner_types
expr_to_types (Map_tN n i f _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    in_types = fmap (TSeqT n i) $ e_in_types inner_types
    out_type = TSeqT n i $ e_out_type inner_types
expr_to_types (Map2_sN n f _ _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    in_types = fmap (SSeqT n) $ e_in_types inner_types
    out_type = SSeqT n $ e_out_type inner_types
expr_to_types (Map2_tN n i f _ _ _) = do
  trace ("f" ++ show f ++ "\n") $ trace ("inner_types: " ++ show inner_types) $
    Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    in_types = fmap (TSeqT n i) $ e_in_types inner_types
    out_type = TSeqT n i $ e_out_type inner_types
expr_to_types (Reduce_sN n f _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    -- the reducer f must accept a tuple of the same type as it's output
    -- and the whole reduce must use Seqs of that type on input and output
    in_types = [SSeqT n $ e_out_type inner_types]
    out_type = SSeqT 1 $ e_out_type inner_types
expr_to_types (Reduce_tN n i f _ _) = Expr_Types in_types out_type
  where
    inner_types = expr_to_outer_types f
    -- the reducer f must accept a tuple of the same type as it's output
    -- and the whole reduce must use Seqs of that type on input and output
    in_types = [TSeqT n i $ e_out_type inner_types]
    out_type = TSeqT 1 (n - 1 + i) $ e_out_type inner_types

-- tuple operators
expr_to_types (FstN t0 t1 _ _) = Expr_Types [ATupleT t0 t1] t0
expr_to_types (SndN t0 t1 _ _) = Expr_Types [ATupleT t0 t1] t1
expr_to_types (ATupleN t0 t1 _ _ _) = Expr_Types [t0, t1] (ATupleT t0 t1)
expr_to_types (STupleN elem_t _ _ _) =
  Expr_Types [elem_t, elem_t] (STupleT 2 elem_t)
  
expr_to_types (STupleAppendN out_len elem_t _ _ _) =
  Expr_Types [STupleT (out_len - 1) elem_t, elem_t] (STupleT out_len elem_t)
  
expr_to_types (STupleToSSeqN tuple_len tuple_elem_t _ _) =
  Expr_Types [STupleT tuple_len tuple_elem_t] (SSeqT tuple_len tuple_elem_t)
expr_to_types (SSeqToSTupleN tuple_len tuple_elem_t _ _) =
  Expr_Types [SSeqT tuple_len tuple_elem_t] (STupleT tuple_len tuple_elem_t)
  
expr_to_types (InputN t _ _) = Expr_Types [] t
expr_to_types (ErrorN _ _) = Expr_Types [] UnitT

expr_to_types (FIFON n i _ elem_t _ _) =
  Expr_Types [TSeqT n i elem_t] (TSeqT n i elem_t)

-- | get the input and output types of the entire expression,
-- not just those of the last expression like expr_to_types

type Input_TrackerM = DAG_MemoT Expr_Types (State (S.Set String))

expr_to_outer_types :: Expr -> Expr_Types
expr_to_outer_types e = evalState (startEvalMemoT $ expr_to_outer_types' e) S.empty

expr_to_outer_types' :: Expr -> Input_TrackerM Expr_Types
expr_to_outer_types' (IdN producer_e _) = expr_to_outer_types' producer_e
expr_to_outer_types' consumer_e@(AbsN producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(NotN producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(AddN producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(SubN producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(MulN producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(DivN producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(EqN _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e

-- generators
expr_to_outer_types' consumer_e@(Lut_GenN _ _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' (Const_GenN _ t _) = return $ Expr_Types [] t

-- sequence operators
expr_to_outer_types' consumer_e@(Shift_sN _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Shift_tN _ _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Up_1d_sN _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Up_1d_tN _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Down_1d_sN _ _ _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Down_1d_tN _ _ _ _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Partition_s_ssN _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Partition_t_ttN _ _ _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Unpartition_s_ssN _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Unpartition_t_ttN _ _ _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(SerializeN _ _ _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(DeserializeN _ _ _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Add_1_sN _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Add_1_0_tN _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Remove_1_sN _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Remove_1_0_tN _ producer_e _) = 
  expr_to_outer_types_unary_operator consumer_e producer_e

-- higher order operators
expr_to_outer_types' consumer_e@(Map_sN _ _ producer_e _) = do
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Map_tN _ _ _ producer_e _) = do
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Map2_sN _ _ producer0_e producer1_e _) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
expr_to_outer_types' consumer_e@(Map2_tN _ _ _ producer0_e producer1_e _) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
expr_to_outer_types' consumer_e@(Reduce_sN _ _ producer_e _) = do
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(Reduce_tN _ _ _ producer_e _) = do
  expr_to_outer_types_unary_operator consumer_e producer_e

-- tuple operators
expr_to_outer_types' consumer_e@(FstN _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(SndN _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(ATupleN _ _ producer0_e producer1_e _) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
expr_to_outer_types' consumer_e@(STupleN _ producer0_e producer1_e _) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
 
expr_to_outer_types' consumer_e@(STupleAppendN _ _ producer0_e producer1_e _) = do
  expr_to_outer_types_binary_operator consumer_e producer0_e producer1_e
  
expr_to_outer_types' consumer_e@(STupleToSSeqN _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
expr_to_outer_types' consumer_e@(SSeqToSTupleN _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
  
expr_to_outer_types' (InputN t name _) = do
  previous_names <- lift get
  if S.member name previous_names
    then return $ Expr_Types [] t
    else do
    let updated_names = S.insert name previous_names
    lift $ put updated_names 
    return $ Expr_Types [t] t
expr_to_outer_types' (ErrorN _ _) = return $ Expr_Types [] UnitT

expr_to_outer_types' consumer_e@(FIFON _ _ _ _ producer_e _) =
  expr_to_outer_types_unary_operator consumer_e producer_e
  
expr_to_outer_types_unary_operator :: Expr -> Expr -> Input_TrackerM Expr_Types 
expr_to_outer_types_unary_operator consumer_op producer_op = do
  producer_outer_types <- memo consumer_op $ expr_to_outer_types' producer_op
  let producer_input_types = e_in_types producer_outer_types
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  return $ Expr_Types producer_input_types consumer_output_type

expr_to_outer_types_binary_operator :: Expr -> Expr -> Expr -> Input_TrackerM Expr_Types
expr_to_outer_types_binary_operator consumer_op producer_op0 producer_op1 = do
  producer0_outer_types <- memo producer_op0 $ expr_to_outer_types' producer_op0
  let producer0_input_types = e_in_types producer0_outer_types
  producer1_outer_types <- memo producer_op1 $ expr_to_outer_types' producer_op1
  let producer1_input_types = e_in_types producer1_outer_types
  let consumer_output_type = e_out_type $ expr_to_types consumer_op
  return $ Expr_Types (producer0_input_types ++ producer1_input_types) consumer_output_type

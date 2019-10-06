module Aetherling.Interpretations.Space_Time_Printer where
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Aetherling.Monad_Helpers
import Debug.Trace

data Print_Data = Print_Data {
  cur_module_output_lines :: [String],
  modules :: [String],
  cur_module_inputs :: [String],
  next_module_index :: Int
  } deriving (Show, Eq)

empty_print_data = Print_Data [] [] [] 0

type Memo_Print_StateM v = DAG_MemoT v (ExceptT RH.Rewrite_Failure (State Print_Data))

add_to_cur_module :: String -> Memo_Print_StateM String ()
add_to_cur_module new_string = do
  cur_data <- lift get
  let cur_output_lines = cur_module_output_lines cur_data
  lift $ put $ cur_data { cur_module_output_lines = cur_output_lines ++ [new_string] }
  return ()

print_st :: Expr -> IO ()
print_st e = do
  let lines = execState (runExceptT $ startEvalMemoT $ print_module e) empty_print_data
  putStrLn $ foldl (++) "" $ fmap (\line -> line ++ "\n") $ modules lines

-- this handles creating a module
print_module :: Expr -> Memo_Print_StateM String String
print_module new_module = do
  -- get state at start of module
  start_data <- lift get

  -- setup state for inside module
  let inner_data = start_data {
        cur_module_output_lines = [],
        cur_module_inputs = []
        }
  lift $ put inner_data
  
  cur_module_result <- print_inner new_module

  -- get state after executing inside module
  end_data <- lift get
  let cur_module_index = next_module_index end_data
  let cur_module_ref = "module" ++ show cur_module_index
  let cur_inputs = cur_module_inputs end_data
  let cur_inputs_str = foldl (\x y -> x ++ " " ++ y)
                       (head $ cur_inputs) (tail $ cur_inputs)
  let module_start_string = cur_module_ref ++ " " ++ cur_inputs_str ++ " =\n"
  let module_body = foldl (++) "" $ fmap (\b -> "    " ++ b ++ "\n") $
                    cur_module_output_lines end_data
  let module_str = module_start_string ++ module_body

  -- setup for outer module
  lift $ put $ start_data {
    next_module_index = cur_module_index + 1,
    modules = modules end_data ++ [module_str]
    }
  return cur_module_ref

-- this handles the strings inside a module
-- the strings here are the variables in the SSA that the producer's
-- outputs were assigned to
print_inner :: Expr -> Memo_Print_StateM String String
print_inner (IdN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = IdN " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(AbsN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = AbsN " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(NotN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = NotN " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(AddN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = AddN " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(SubN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = SubN " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(MulN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = MulN " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(DivN producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = DivN " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(EqN t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = EqN " ++ show t ++ " " ++ producer_ref
  return cur_ref_name

-- generators
print_inner consumer_e@(Lut_GenN lut_table lut_type producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Lut_GenN " ++ show lut_table ++ " " ++
    show lut_type ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Const_GenN constant constant_type cur_idx) = do
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Const_GenN " ++ show constant ++ " " ++
    show constant_type
  return cur_ref_name

-- sequence operators
print_inner consumer_e@(Shift_sN n shift_amount elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Shift_sN " ++ show n ++
    " " ++ show shift_amount ++ " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Shift_tN n i shift_amount elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Shift_tN " ++ show n ++ " " ++ show i ++
    " " ++ show shift_amount ++ " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Shift_tsN no io ni shift_amount elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Shift_tsN " ++ show no ++ " " ++ show io ++
    " " ++ show ni ++ " " ++ show shift_amount ++ " " ++
    show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Up_1d_sN n elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Up_1d_sN " ++ show n ++
    " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Up_1d_tN n i elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Up_1d_tN " ++ show n ++ " " ++ show i ++
    " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Down_1d_sN n sel_idx elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Down_1d_sN " ++ show n ++ 
    " " ++ show sel_idx ++ " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Down_1d_tN n i sel_idx elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Down_1d_tN " ++ show n ++ " " ++ show i ++
    " " ++ show sel_idx ++ " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Partition_s_ssN no ni elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Partition_s_ssN " ++
    show no ++ " " ++ show ni ++ " " ++
    show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Partition_t_ttN no ni io ii elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Partition_t_ttN " ++
    show no ++ " " ++ show ni ++ " " ++ show io ++ " " ++ show ii ++ " " ++
    show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Unpartition_s_ssN no ni elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Unpartition_s_ssN " ++
    show no ++ " " ++ show ni ++ " " ++ 
    show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Unpartition_t_ttN no ni io ii elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Unpartition_t_ttN " ++
    show no ++ " " ++ show ni ++ " " ++ show io ++ " " ++ show ii ++ " " ++
    show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(SerializeN n i elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = SerializeN " ++ show n ++ " " ++ show i ++
    " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(DeserializeN n i elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = DeserializeN " ++ show n ++ " " ++ show i ++
    " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Add_1_sN elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Add_1_sN " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Add_1_0_tN elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Add_1_0_tN " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Remove_1_sN elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Remove_1_sN " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Remove_1_0_tN elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Remove_1_0_tN " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name

-- higher order operators
print_inner consumer_e@(Map_sN n f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  f_ref <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Map_sN " ++
    show n ++ " " ++ f_ref ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Map_tN n i f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  f_ref <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Map_tN " ++
    show n ++ " " ++ show i ++ " " ++ f_ref ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Map2_sN n f producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ print_inner producer0_e
  producer1_ref <- memo producer1_e $ print_inner producer1_e
  f_ref <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Map2_sN " ++
    show n ++ " " ++ f_ref ++ " " ++ producer0_ref ++
    " " ++ producer1_ref
  return cur_ref_name
print_inner consumer_e@(Map2_tN n i f producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ print_inner producer0_e
  producer1_ref <- memo producer1_e $ print_inner producer1_e
  f_ref <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Map2_tN " ++
    show n ++ " " ++ show i ++ " " ++ f_ref ++ " " ++ producer0_ref ++
    " " ++ producer1_ref
  return cur_ref_name
print_inner consumer_e@(Reduce_sN n f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  f_ref <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Reduce_sN " ++
    show n ++ " " ++ f_ref ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(Reduce_tN n i f producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  f_ref <- memo f $ print_module f
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = Reduce_tN " ++
    show n ++ " " ++ show i ++ " " ++ f_ref ++ " " ++ producer_ref
  return cur_ref_name

-- tuple operators
print_inner consumer_e@(FstN t0 t1 producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = FstN " ++
    show t0 ++ " " ++ show t1 ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(SndN t0 t1 producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = SndN " ++
    show t0 ++ " " ++ show t1 ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(ATupleN t0 t1 producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ print_inner producer0_e
  producer1_ref <- memo producer1_e $ print_inner producer1_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = ATupleN " ++
    show t0 ++ " " ++ show t1 ++ " " ++ producer0_ref ++ " " ++ producer1_ref
  return cur_ref_name
print_inner consumer_e@(STupleN elem_t producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ print_inner producer0_e
  producer1_ref <- memo producer1_e $ print_inner producer1_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = STupleN " ++
    show elem_t ++ " " ++ producer0_ref ++ " " ++ producer1_ref
  return cur_ref_name
 
print_inner consumer_e@(STupleAppendN out_len elem_t producer0_e producer1_e cur_idx) = do
  producer0_ref <- memo producer0_e $ print_inner producer0_e
  producer1_ref <- memo producer1_e $ print_inner producer1_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = STupleAppendN " ++ show out_len ++ " " ++
    show elem_t ++ " " ++ producer0_ref ++ " " ++ producer1_ref
  return cur_ref_name
  
print_inner consumer_e@(STupleToSSeqN tuple_len elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = STupleToSSeqN " ++
    show tuple_len ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
print_inner consumer_e@(SSeqToSTupleN tuple_len elem_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = SSeqToSTupleN " ++
    show tuple_len ++ " " ++ show elem_t ++ " " ++ producer_ref
  return cur_ref_name
  
print_inner (InputN t name cur_idx) = do
  cur_data <- lift get
  let input_str = "(" ++ name ++ " :: " ++ show t ++ ")"
  lift $ put $ cur_data {
    cur_module_inputs = cur_module_inputs cur_data ++ [input_str]
    }
  return name
print_inner e@(ErrorN msg cur_idx) = do
  let cur_ref_name = "n" ++ print_index cur_idx
  cur_data <- lift get
  lift $ put $ cur_data {
    cur_module_inputs = cur_module_inputs cur_data ++
                        ["ERROR for node" ++ show cur_idx]
    }
  add_to_cur_module $ cur_ref_name ++ " = ErrorN " ++ msg
  return cur_ref_name
print_inner consumer_e@(FIFON t delay_clks producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = FIFON " ++ show t ++
    " " ++ show delay_clks ++ " " ++ show producer_ref
  return cur_ref_name
print_inner consumer_e@(ReshapeN in_t out_t producer_e cur_idx) = do
  producer_ref <- memo producer_e $ print_inner producer_e
  let cur_ref_name = "n" ++ print_index cur_idx
  add_to_cur_module $ cur_ref_name ++ " = ReshapeN (" ++ show in_t ++ ") (" ++ show out_t ++
    ") " ++ producer_ref
  return cur_ref_name

print_index :: DAG_Index -> String
print_index No_Index = show No_Index
print_index (Index i) = show i

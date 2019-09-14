module Aetherling.Interpretations.Space_Time_Types_Printer where
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.State

start_tseq :: Int -> Int -> String
start_tseq n i =
  "\\begin{array}{ |" ++ (concat $ replicate n " c | ") ++
  (concat $ replicate i " >{\\columncolor{red!100}}c | ") ++
  "}\\hline"
end_tseq = "\\hline \\end{array}"

start_sseq = "\\left( \\, \\begin{array}{c} "
end_sseq = " \\end{array} \\, \\right)"

nesting_str :: Int -> String
nesting_str n = concat $ replicate n "\t"

data Bank_Index = Bank_Index {
  bank :: Int,
  addr :: Int
  } deriving (Show, Eq)

data Print_State = Print_State {
  cur_int :: Int,
  cur_bit :: Bool,
  cur_invalid :: Bool,
  tseq_is_outer :: Bool,
  flattened_banks :: [Int]
  } deriving (Show, Eq)

empty_print_state t = Print_State 0 False False (outer_tseq t) []

get_cur_invalid :: State Print_State Bool
get_cur_invalid = do
  cur_state <- get
  return $ cur_invalid cur_state 

set_cur_invalid :: Bool -> State Print_State ()
set_cur_invalid new_invalid = do
  cur_state <- get
  put $ cur_state { cur_invalid = new_invalid }

cur_print_int :: State Print_State Int
cur_print_int = do
  cur_state <- get
  put $ cur_state { cur_int = cur_int cur_state +
                    (if cur_invalid cur_state then 0 else 1) }
  if flattened_banks cur_state == []
    then return $ cur_int cur_state
    else return (flattened_banks cur_state !! cur_int cur_state)

cur_print_bit :: State Print_State Bool
cur_print_bit = do
  cur_state <- get
  if cur_invalid cur_state
    then put $ cur_state { cur_bit = cur_bit cur_state `xor` True }
    else return ()
  return $ cur_bit cur_state

print_st_type_io :: AST_Type -> IO ()
print_st_type_io t =
  putStrLn $
  show t ++ "\n" ++ "\\[ \n " ++
  evalState (print_st_type t 0) (empty_print_state t) ++ "\n\\]\n"

outer_tseq :: AST_Type -> Bool
outer_tseq (TSeqT _ _ _) = True
outer_tseq _ = False
  
-- | Given a space_time_type and a nested level, produce a string
-- with the right indentation
print_st_type :: AST_Type -> Int -> State Print_State String
print_st_type (TSeqT n i t) nesting = do
  valid_t_strs <- mapM (\_ -> print_st_type t (nesting + 1)) [1..n]
  -- end valids with newline only if no invalid clocks
  let valid_t_str = merge_with_vertical_lines (i == 0) valid_t_strs
  out_invalid <- get_cur_invalid
  set_cur_invalid True
  invalid_t_strs <- mapM (\_ -> print_st_type t (nesting + 1)) [1..i]
  let invalid_t_str = merge_with_vertical_lines True $ map (\s -> "\\color{red} " ++ s) invalid_t_strs
  set_cur_invalid out_invalid
  return $
    nesting_str nesting ++ start_tseq n i ++ "\n" ++
    valid_t_str ++ invalid_t_str ++
    nesting_str nesting ++ end_tseq 
print_st_type (SSeqT n t) nesting = do
  t_strs <- mapM (\_ -> print_st_type t (nesting + 1)) [1..n]
  let t_str = merge_with_newlines t_strs
  return $
    nesting_str nesting ++ start_sseq ++ "\n" ++
     t_str ++
    nesting_str nesting ++ end_sseq
print_st_type (STupleT n t) nesting = do
  t_strs <- mapM (\_ -> print_st_type t (nesting + 1)) [1..n]
  let t_str = merge_with_newlines t_strs
  return $
    nesting_str nesting ++ start_sseq ++ "\n" ++
    t_str ++ "\n" ++
    nesting_str nesting ++ end_sseq
print_st_type (ATupleT l r) nesting = do
  l_t_str <- print_st_type l 0
  r_t_str <- print_st_type r 0
  return $ nesting_str nesting ++ "(" ++ l_t_str ++ ", " ++ r_t_str ++ ")"
print_st_type IntT nesting = do
  cur_int <- cur_print_int
  return $ nesting_str nesting ++ show cur_int
print_st_type BitT nesting = do
  cur_bit <- cur_print_bit
  return $ nesting_str nesting ++ show cur_bit
print_st_type UnitT nesting = do
  return $ nesting_str nesting ++ "()"

merge_with_newlines :: [String] -> String
merge_with_newlines s_xs = do
  let s_xs_idxs = zip [1..] s_xs
  concat $ fmap (\(idx,s) -> s ++ " \\\\ \\\\\n") s_xs_idxs
  --concat $ fmap (\(idx,s) -> if (idx == length s_xs) then s else s ++ "\\\\\n") s_xs_idxs
  
merge_with_vertical_lines :: Bool -> [String] -> String
merge_with_vertical_lines end_with_newline s_xs = do
  let s_xs_idxs = zip [1..] s_xs
  --concat $ fmap (\(idx,s) -> s ++ " & \n ") s_xs_idxs
  concat $ fmap (\(idx,s) -> if (idx == length s_xs && end_with_newline) then s ++ " \\\\ \n " else s ++ " & \n ") s_xs_idxs

xor :: Bool -> Bool -> Bool
xor x y = (x /= y) && (x || y)


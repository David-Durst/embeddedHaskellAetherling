module Aetherling.Interpretations.Backend_Execute.Value_To_String where
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import qualified Data.Map.Strict as M
import Data.List
import Debug.Trace
import Data.Char
import qualified Control.Monad.ST.Strict as STS
import Data.Array.ST
import qualified Data.Array as Arr

data ST_Val_String = ST_Val_String {
  st_values :: String,
  st_valids :: [Bool]
  } deriving (Show, Eq)

int_width = "8"
data ST_Val_To_String_Config = ST_Val_To_String_Config {
  make_integer_string_for_backend :: Integer -> String,
  make_bool_string_for_backend :: Bool -> String,
  make_tuple_string_for_backend :: String -> String -> String,
  make_array_string_for_backend :: [String] -> String
  }

json_conf = ST_Val_To_String_Config show (map toLower . show) (\x y -> show_no_quotes (x,y))
             show_no_quotes
magma_conf = ST_Val_To_String_Config show show (\x y -> show_no_quotes (x,y))
             show_no_quotes
chisel_conf = ST_Val_To_String_Config show (map toLower . show)
  (\x y -> "Array(" ++ x ++ ", " ++ y ++ ")")
  (\x -> "Array(" ++
    (foldl (\result_s new_s -> result_s ++ "," ++ new_s) (head x) (tail x)) ++
    ")")
chisel_hardware_conf = ST_Val_To_String_Config
  (\x -> show x ++ ".U(" ++ int_width ++ ".W)")
  (\x -> (map toLower . show) x ++ ".B")
  (\x y -> "Const.make_vec(" ++ x ++ ", " ++ y ++ ")")
  (\x -> "Const.make_vec(" ++
    (foldl (\result_s new_s -> result_s ++ "," ++ new_s) (head x) (tail x)) ++
    ")")

convert_seq_val_to_st_val_string ::
  Convertible_To_Atom_Strings a => a -> AST_Type ->
  ST_Val_To_String_Config -> ST_Val_String
convert_seq_val_to_st_val_string seq_val st_type conf = do
  -- get the mapping from flat_idx to value as a string
  let flat_val_strs = convert_to_flat_atom_list seq_val conf
  let flat_val_idx_to_str :: M.Map Int String =
        M.fromList $ zip [0..] flat_val_strs

  -- get the mapping from flat st to flat_idx
  let st_idxs = generate_st_val_idxs_for_st_type st_type
  let valid_clks = map mv_valid $ map head st_idxs

  -- convert the st_idx double nested arrays to st double arrays with values
  let st_vals = convert_st_val_idxs_to_vals flat_val_idx_to_str st_idxs
  -- these are nested for both space and time
  -- issue: if 1 input per clock, then need to remove the space dimension
  -- as each input port is not vectorized
  let st_val_string = make_array_string_for_backend conf $
                      remove_sseq_length_one conf st_vals
  ST_Val_String st_val_string valid_clks
  
class Convertible_To_Atom_Strings a where
  convert_to_flat_atom_list :: a -> ST_Val_To_String_Config -> [String]

instance Convertible_To_Atom_Strings Integer where
  convert_to_flat_atom_list x conf = [make_integer_string_for_backend conf x]

instance Convertible_To_Atom_Strings Bool where
  convert_to_flat_atom_list x conf = [make_bool_string_for_backend conf x]
  
instance (Convertible_To_Atom_Strings a, Convertible_To_Atom_Strings b) =>
  Convertible_To_Atom_Strings (a, b) where
  convert_to_flat_atom_list (x, y) conf =
    [make_tuple_string_for_backend conf
      (head $ convert_to_flat_atom_list x conf)
      (head $ convert_to_flat_atom_list y conf)]

instance (Convertible_To_Atom_Strings a) => Convertible_To_Atom_Strings [a] where
  convert_to_flat_atom_list xs conf = concat $
    map (\x -> convert_to_flat_atom_list x conf) xs

instance Convertible_To_Atom_Strings AST_Atoms where
  convert_to_flat_atom_list (BitA b) conf =
    [make_bool_string_for_backend conf $ b]
  convert_to_flat_atom_list (IntA i) conf =
    [make_integer_string_for_backend conf i]
  convert_to_flat_atom_list (ATupleA x y) conf =
    [make_tuple_string_for_backend conf
      (head $ convert_to_flat_atom_list x conf)
      (head $ convert_to_flat_atom_list y conf)]

-- these atoms are just used to convert between
-- the atoms in AST_Value and the string representations from Convertible_To_Atom_Strings
-- when printing an AST_Value to magma
data AST_Atoms = BitA Bool | IntA Integer | ATupleA AST_Atoms AST_Atoms
               deriving (Show, Eq)

flatten_ast_value :: AST_Value -> [AST_Atoms]
flatten_ast_value UnitV = undefined
flatten_ast_value (BitV b) = [BitA b]
flatten_ast_value (IntV i) = [IntA $ toInteger i]
flatten_ast_value (ATupleV l r) = [ATupleA
                                   (head $ flatten_ast_value l)
                                   (head $ flatten_ast_value r)]
flatten_ast_value (STupleV vals) = concatMap flatten_ast_value vals
flatten_ast_value (SSeqV vals) = concatMap flatten_ast_value vals
flatten_ast_value (TSeqV vals _) = concatMap flatten_ast_value vals

data ST_Val_Index = ST_Val_Index {
  flat_idx :: !Int,
  mv_valid :: !Bool,
  flat_s :: !Int,
  flat_t :: !Int
  } deriving (Show, Eq)

remove_sseq_length_one :: ST_Val_To_String_Config -> [[String]] -> [String]
remove_sseq_length_one _ ts_vals | length ts_vals == 0 = []
remove_sseq_length_one _ ts_vals |
  length (ts_vals !! 0) == 1 =
  map (\sseq -> sseq !! 0) ts_vals
remove_sseq_length_one conf ts_vals =
  map (make_array_string_for_backend conf) ts_vals

show_no_quotes :: Show a => a -> String
show_no_quotes = filter (\x -> x /= '\"') . show

convert_st_val_idxs_to_vals :: M.Map Int String -> [[ST_Val_Index]] -> [[String]]
convert_st_val_idxs_to_vals idx_to_str st_val_idxs =
  map (map (\st_val_idx -> M.findWithDefault "0" (flat_idx st_val_idx) idx_to_str)) st_val_idxs

generate_st_val_idxs_for_st_type :: AST_Type -> [[ST_Val_Index]]
generate_st_val_idxs_for_st_type t = do
  let total_width = num_atoms_per_valid_t t
  let total_time = clocks_t t
  let valid_time = valid_clocks_t t
  --let initial_idxs = newArray ((0,0),(total_time-1,total_width-1)) (ST_Val_Index 0 False 0 0)
  --set_val_index t total_width total_time valid_time 0 0 True 0 initial_idxs
  let arr = runSTArray $ initialize_and_set_val_indexes t total_width total_time
            valid_time
  [[ arr Arr.! (t, s) | s <- [0..total_width - 1]] | t <- [0..total_time-1]]

initialize_and_set_val_indexes :: AST_Type -> Int -> Int ->
  Int -> STS.ST s (STArray s (Int, Int) ST_Val_Index)
initialize_and_set_val_indexes t total_width total_time valid_time = do
  idxs <- newArray ((0,0),(total_time-1,total_width-1)) (ST_Val_Index 0 False 0 0)
  set_val_index t total_width total_time valid_time 0 0 True 0 idxs
  return idxs
  
generate_st_val_idxs_for_st_type_old :: AST_Type -> [[ST_Val_Index]]
generate_st_val_idxs_for_st_type_old t = do
  let total_width = num_atoms_per_valid_t t
  let total_time = clocks_t t
  let valid_time = valid_clocks_t t
  let flat_results =
        generate_st_val_idxs_for_st_type' t total_width total_time
        valid_time 0 0 True 0
  let sorted_results = sortBy (\x y -> compare (flat_t x) (flat_t y)) flat_results
  let grouped_by_t = groupBy (\x y -> flat_t x == flat_t y) sorted_results
  let grouped_and_sorted_by_s =
        map (sortBy (\x y -> compare (flat_s x) (flat_s y))) grouped_by_t
  grouped_and_sorted_by_s
  -- let invs_filtered = filter (mv_valid . head) grouped_and_sorted_by_s
  --let grouped_and_sorted_just_vals = map (map magma_value) grouped_and_sorted_by_s
  -- need to filter out quotes from string printing
  --filter (\x -> x /= '\"') $ show grouped_and_sorted_just_vals
{-
data Parallel_Index = Parallel_Index {
  start_index :: !Int,
  incr_index :: !Int
  } deriving (Show, Eq)
-}
-- | Given a space-time type, get the parallel elements per clock
-- and how the indexes increment per clock
set_val_index :: AST_Type -> Int -> Int -> Int ->
                 Int -> Int -> Bool ->
                 Int -> STArray s (Int,Int) ST_Val_Index -> STS.ST s ()
set_val_index (STupleT n t) total_width
  total_time valid_time cur_space cur_time valid cur_idx st_val_idxs = do
  let element_width = total_width `div` n
  let element_time = total_time
  let element_valid_time = valid_time
  mapM
    (\j -> set_val_index t
           element_width element_time element_valid_time
           (cur_space + j*element_width) cur_time
           valid
           (cur_idx + j*element_width*element_valid_time)
           st_val_idxs
    )
    [0..n-1]
  return ()
set_val_index (SSeqT n t) total_width
  total_time valid_time cur_space cur_time valid cur_idx st_val_idxs = do
  let element_width = total_width `div` n
  let element_time = total_time
  let element_valid_time = valid_time
  mapM
    (\j -> set_val_index t
           element_width element_time element_valid_time
           (cur_space + j*element_width) cur_time
           valid
           (cur_idx + j*element_width*element_valid_time)
           st_val_idxs
    )
    [0..n-1]
  return ()
set_val_index (TSeqT n i t) total_width
  total_time valid_time cur_space cur_time valid cur_idx st_val_idxs = do
  let element_width = total_width
  let element_time = total_time `div` (n+i)
  let element_valid_time = valid_time `div` n
  mapM
    (\j -> set_val_index t
           element_width element_time element_valid_time
           cur_space (cur_time + j * element_time)
           (valid && j < n)
           (cur_idx + j*element_width*element_valid_time)
           st_val_idxs
    )
    [0..(n+i)-1]
  return ()
set_val_index _ _ _ _ cur_space cur_time valid cur_idx st_val_idxs = do
  writeArray st_val_idxs (cur_time, cur_space)
    (ST_Val_Index cur_idx valid cur_space cur_time)

concatMap' :: Foldable t => (a -> [b]) -> t a -> [b]
concatMap' f = reverse . foldl' (\acc x -> f x ++ acc) []

generate_st_val_idxs_for_st_type' :: AST_Type -> Int -> Int -> Int ->
                                      Int -> Int -> Bool ->
                                      Int -> [ST_Val_Index]
generate_st_val_idxs_for_st_type' UnitT _ _ _ cur_space cur_time
  valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' BitT _ _ _ cur_space cur_time
  valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' IntT _ _ _ cur_space cur_time
  valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' (ATupleT t0 t1) _ _ _ cur_space
  cur_time valid cur_idx = do
  [ST_Val_Index cur_idx valid cur_space cur_time]
generate_st_val_idxs_for_st_type' (STupleT n t) total_width
  total_time valid_time cur_space cur_time valid cur_idx = do
  let element_width = total_width `div` n
  let element_time = total_time
  let element_valid_time = valid_time
  concatMap' 
    (\j -> generate_st_val_idxs_for_st_type' t
           element_width element_time element_valid_time
           (cur_space + j*element_width) cur_time
           valid
           (cur_idx + j*element_width*element_valid_time))
    [0..n-1]
generate_st_val_idxs_for_st_type' (SSeqT n t) total_width
  total_time valid_time cur_space cur_time valid cur_idx = do
  let element_width = total_width `div` n
  let element_time = total_time
  let element_valid_time = valid_time
  concatMap'
    (\j -> generate_st_val_idxs_for_st_type' t
           element_width element_time element_valid_time
           (cur_space + j*element_width) cur_time
           valid
           (cur_idx + j*element_width*element_valid_time))
    [0..n-1]
generate_st_val_idxs_for_st_type' (TSeqT n i t) total_width
  total_time valid_time cur_space cur_time valid cur_idx = do
  let element_width = total_width
  let element_time = total_time `div` (n+i)
  let element_valid_time = valid_time `div` n
  concatMap' 
    (\j -> generate_st_val_idxs_for_st_type' t
           element_width element_time element_valid_time
           cur_space (cur_time + j * element_time)
           (valid && j < n)
           (cur_idx + j*element_width*element_valid_time))
    [0..(n+i)-1]

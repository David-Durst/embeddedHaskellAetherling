module Aetherling.Languages.Space_Time.Deep.Expr_Builders where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Monad_Helpers
import Aetherling.Rewrites.Rewrite_Helpers

-- | STuple multiple expressions of the same type together
-- Corresponds to  foldl (\accum next -> Map2_t no Tuple accum next)
-- the function argument is the map2 generator either in space or time.
-- the map2 should already have n (and i if applicable) applied to it
-- to indicate the lengths of the outer sequence containing the tupled items
-- The list of expression argument is the list of expressions to tuple
-- The AST_Type is the type of each element in the outputed STuple
repeated_stuple :: (Monad m) =>
                   (Expr -> Expr -> Expr -> DAG_Index -> Expr) ->
                   [Memo_Rewrite_StateTM Expr m Expr] -> AST_Type ->
                   Memo_Rewrite_StateTM Expr m Expr
repeated_stuple map_gen input_exprs elem_t = do
  let map_stuple_append out_len in_left in_right = do
        map2_idx <- get_cur_index
        stuple_append_idx <- get_cur_index
        input1_idx <- get_cur_index
        input2_idx <- get_cur_index
        return $ 
          map_gen 
          (STupleAppendN out_len
            elem_t
            (InputN (STupleT (out_len - 1) elem_t) "I0" input1_idx)
            (InputN elem_t "I1" input2_idx)
            stuple_append_idx)
          in_left in_right map2_idx
  -- the initial step in the fold
  let map_stuple_initial = do
        map2_idx <- get_cur_index
        stuple_idx <- get_cur_index
        input1 <- input_exprs !! 0
        input2 <- input_exprs !! 1
        input1_idx <- get_cur_index
        input2_idx <- get_cur_index
        return $
          map_gen
          (STupleN elem_t 
           (InputN elem_t "I0" input1_idx)
           (InputN elem_t "I1" input2_idx)
           stuple_idx)
          input1 input2 map2_idx
  
  foldl (\prior_tuplesM cur_len -> do
            prior_tuples <- prior_tuplesM
            next_input <- (input_exprs !! (cur_len - 1))
            map_stuple_append
              cur_len
              prior_tuples
              next_input)
    -- start at 3 to set
    map_stuple_initial [3 .. length input_exprs]

add_input_test :: (Expr -> DAG_Index -> Expr) -> Expr
add_input_test expr_gen = do
  let input_idx = Index 1000
  let outer_idx = Index 1001
  let expr_types = expr_to_types
                   (expr_gen (ErrorN "not an error" input_idx) outer_idx)
  let expr_in_type = head $ e_in_types expr_types
  expr_gen (InputN expr_in_type "I" input_idx) outer_idx

add_input_to_expr_for_map :: Monad m => (Expr -> DAG_Index -> Expr) ->
                             Memo_Rewrite_StateTM Expr m Expr
add_input_to_expr_for_map expr_gen = do
  input_idx <- get_cur_index
  map_idx <- get_cur_index
  let expr_types = expr_to_types
                   (expr_gen (ErrorN "not an error" input_idx) map_idx)
  let expr_in_type = head $ e_in_types expr_types
  return $ expr_gen (InputN expr_in_type "I" input_idx) map_idx

add_input_to_expr_for_map2 :: Monad m => (Expr -> Expr -> DAG_Index -> Expr) ->
                              Memo_Rewrite_StateTM Expr m Expr
add_input_to_expr_for_map2 expr_gen = do
  input1_idx <- get_cur_index
  input2_idx <- get_cur_index
  map2_idx <- get_cur_index
  let expr_types = expr_to_types
                   (expr_gen (ErrorN "not an error" input1_idx)
                     (ErrorN "not an error" input2_idx) map2_idx)
  let expr_in_type0 = head $ e_in_types expr_types
  let expr_in_type1 = (e_in_types expr_types) !! 1
  return $
    expr_gen (InputN expr_in_type0 "I0" input1_idx)
    (InputN expr_in_type1 "I1" input2_idx) map2_idx
  
make_map_t :: Monad m => Int -> Int -> (Expr -> DAG_Index -> Expr) ->
             Expr -> Memo_Rewrite_StateTM Expr m Expr
make_map_t n i inner_expr_gen producer = do
  inner_expr <- add_input_to_expr_for_map inner_expr_gen
  (add_index $ Map_tN n i inner_expr) producer

make_map_t_nested :: Monad m => Int -> Int -> (Expr -> Memo_Rewrite_StateTM Expr m Expr) ->
                     Expr -> Memo_Rewrite_StateTM Expr m Expr
make_map_t_nested n i expr_gen producer = do
  input_idx <- get_cur_index
  map_idx <- get_cur_index
  expr_with_error <- expr_gen (ErrorN "not an error" input_idx)
  let expr_types = expr_to_types expr_with_error
  let expr_in_type = head $ e_in_types expr_types
  expr_with_input <- expr_gen (InputN expr_in_type "I" input_idx)
  return $ Map_tN n i expr_with_input producer map_idx
  
make_map_s :: Monad m => Int -> (Expr -> DAG_Index -> Expr) ->
             Expr -> Memo_Rewrite_StateTM Expr m Expr
make_map_s n inner_expr_gen producer = do
  inner_expr <- add_input_to_expr_for_map inner_expr_gen
  (add_index $ Map_sN n inner_expr) producer
  
make_map_s_nested :: Monad m => Int -> (Expr -> Memo_Rewrite_StateTM Expr m Expr) ->
                     Expr -> Memo_Rewrite_StateTM Expr m Expr
make_map_s_nested n expr_gen producer = do
  input_idx <- get_cur_index
  map_idx <- get_cur_index
  expr_with_error <- expr_gen (ErrorN "not an error" input_idx)
  let expr_types = expr_to_types expr_with_error
  let expr_in_type = head $ e_in_types expr_types
  expr_with_input <- expr_gen (InputN expr_in_type "I" input_idx)
  return $ Map_sN n expr_with_input producer map_idx

make_map_ts :: Monad m => Int -> Int -> Int -> (Expr -> DAG_Index -> Expr) ->
             Expr -> Memo_Rewrite_StateTM Expr m Expr
make_map_ts no io ni inner_expr_gen producer = do
  inner_expr <- add_input_to_expr_for_map inner_expr_gen
  map_s_expr <- add_input_to_expr_for_map $ Map_sN ni inner_expr
  (add_index $ Map_tN no io map_s_expr) producer
  
make_reduce_s :: Monad m => Int -> (Expr -> DAG_Index -> Expr) ->
                 Expr -> Memo_Rewrite_StateTM Expr m Expr
make_reduce_s n inner_expr_gen producer = do
  inner_expr <- add_input_to_expr_for_map inner_expr_gen
  (add_index $ Reduce_sN n inner_expr) producer

make_reduce_t :: Monad m => Int -> Int -> (Expr -> DAG_Index -> Expr) ->
                 Expr -> Memo_Rewrite_StateTM Expr m Expr
make_reduce_t n i inner_expr_gen producer = do
  inner_expr <- add_input_to_expr_for_map inner_expr_gen
  (add_index $ Reduce_tN n i inner_expr) producer

make_remove_1_s :: Monad m => (Expr -> DAG_Index -> Expr) ->
                   Expr -> Memo_Rewrite_StateTM Expr m Expr
make_remove_1_s inner_expr_gen producer = do
  inner_expr <- add_input_to_expr_for_map inner_expr_gen
  (add_index $ Remove_1_sN inner_expr) producer
  
make_add_1_s :: Monad m => (Expr -> DAG_Index -> Expr) ->
                   Expr -> Memo_Rewrite_StateTM Expr m Expr
make_add_1_s inner_expr_gen producer = do
  inner_expr <- add_input_to_expr_for_map inner_expr_gen
  (add_index $ Add_1_sN inner_expr) producer

get_producers :: Expr -> [Expr]
get_producers (Const_GenN _ _ _ _) = []
get_producers (Counter_sN _ _ _ _ _) = []
get_producers (Counter_tN _ _ _ _ _ _) = []
get_producers (Counter_tsN _ _ _ _ _ _ _) = []
get_producers (Counter_tnN _ _ _ _ _ _) = []
get_producers (InputN _ _ _) = []
get_producers (ErrorN _ _) = []
get_producers (Map2_sN _ _ producer0 producer1 _) = [producer0, producer1]
get_producers (Map2_tN _ _ _ producer0 producer1 _) = [producer0, producer1]
get_producers (ATupleN _ _ producer0 producer1 _) = [producer0, producer1]
get_producers (STupleN _ producer0 producer1 _) = [producer0, producer1]
get_producers (STupleAppendN _ _ producer0 producer1 _) = [producer0, producer1]
-- every other operator is unary
get_producers op = [seq_in op]

get_f :: Expr -> Maybe Expr
get_f (Add_1_sN f _ _) = Just f
get_f (Add_1_0_tN f _ _) = Just f
get_f (Remove_1_sN f _ _) = Just f
get_f (Remove_1_0_tN f _ _) = Just f
get_f (Map_sN _ f _ _) = Just f
get_f (Map_tN _ _ f _ _) = Just f
get_f (Map2_sN _ f _ _ _) = Just f
get_f (Map2_tN _ _ f _ _ _) = Just f
get_f (Reduce_sN _ f _ _) = Just f
get_f (Reduce_tN _ _ f _ _) = Just f
get_f _ = Nothing

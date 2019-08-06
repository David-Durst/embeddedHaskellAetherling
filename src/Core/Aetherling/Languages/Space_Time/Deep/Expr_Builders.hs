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
repeated_stuple :: (Monad m) => (Expr -> Expr -> Expr -> DAG_Index -> Expr) ->
                   [Expr] -> AST_Type -> Memo_Rewrite_StateM Expr Expr
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
            (InputN (STupleT (out_len - 1) elem_t) "tuple_in_1" input1_idx)
            (InputN elem_t "tuple_in_2" input2_idx)
            stuple_append_idx)
          in_left in_right map2_idx
  -- the initial step in the fold
  let map_stuple_initial = do
        map2_idx <- get_cur_index
        stuple_idx <- get_cur_index
        input1_idx <- get_cur_index
        input2_idx <- get_cur_index
        return $
          map_gen
          (STupleN elem_t 
           (InputN elem_t "tuple_in_1" input1_idx)
           (InputN elem_t "tuple_in_2" input2_idx)
          stuple_idx)
          (input_exprs !! 0) (input_exprs !! 1) map2_idx

  foldl (\prior_tuplesM cur_len -> do
            prior_tuples <- prior_tuplesM
            map_stuple_append
              cur_len
              prior_tuples
              (input_exprs !! (cur_len - 1)))
    -- start at 3 to set
    map_stuple_initial [3 .. length input_exprs]

add_input_to_expr_for_map :: (Expr -> Expr) -> Memo_Rewrite_StateM Expr Expr
add_input_to_expr_for_map expr_gen = do
  input_idx <- get_cur_index
  let expr_types = expr_to_types (expr_gen $ ErrorN "not an error" input_idx)
  let expr_in_type = head $ e_in_types expr_types
  return $ expr_gen $ InputN expr_in_type "f_in" input_idx
  
add_input_to_expr_for_map2 :: (Expr -> Expr -> Expr) -> Memo_Rewrite_StateM Expr Expr
add_input_to_expr_for_map2 expr_gen = do
  input1_idx <- get_cur_index
  input2_idx <- get_cur_index
  let expr_types = expr_to_types
                   (expr_gen (ErrorN "not an error" input1_idx)
                     (ErrorN "not an error" input2_idx))
  let expr_in_type0 = head $ e_in_types expr_types
  let expr_in_type1 = (e_in_types expr_types) !! 1
  return $
    expr_gen (InputN expr_in_type0 "f_in1" input1_idx)
    (InputN expr_in_type1 "f_in2" input2_idx)
  

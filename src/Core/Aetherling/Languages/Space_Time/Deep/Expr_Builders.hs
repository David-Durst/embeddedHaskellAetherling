module Aetherling.Languages.Space_Time.Deep.Expr_Builders where
import Aetherling.Languages.Space_Time.Deep.Types
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions

-- | STuple multiple expressions of the same type together
-- Corresponds to  foldl (\accum next -> Map2_t no Tuple accum next)
-- the function argument is the map2 generator either in space or time.
-- the map2 should already have n (and i if applicable) applied to it
-- to indicate the lengths of the outer sequence containing the tupled items
-- The list of expression argument is the list of expressions to tuple
-- The AST_Type is the type of each element in the outputed STuple
repeated_stuple :: (Expr -> Expr -> Expr -> Expr) -> [Expr] -> AST_Type -> Expr
repeated_stuple map_gen input_exprs elem_t = do
  let map_stuple_append out_len in_left in_right = map_gen 
                                                   (STupleAppendN out_len
                                                    elem_t
                                                    (InputN (STupleT (out_len - 1) elem_t) "tuple_in_1")
                                                     (InputN elem_t "tuple_in_2"))
        in_left in_right
  -- the initial step in the fold
  let map_stuple_initial = map_gen
                           (STupleN elem_t 
                             (InputN elem_t "tuple_in_1")
                             (InputN elem_t "tuple_in_2")
                           )
                           (input_exprs !! 0) (input_exprs !! 1)

  foldl (\prior_tuples cur_len ->
            map_stuple_append
            cur_len
            prior_tuples
            (input_exprs !! (cur_len - 1)))
    -- start at 3 to set
    map_stuple_initial [3 .. length input_exprs]

add_input_to_expr_for_map :: (Expr -> Expr) -> Expr
add_input_to_expr_for_map expr_gen = do
  let expr_types = expr_to_types (expr_gen $ ErrorN "not an error")
  let expr_in_type = head $ e_in_types expr_types
  expr_gen $ InputN expr_in_type "f_in"
  
add_input_to_expr_for_map2 :: (Expr -> Expr -> Expr) -> Expr
add_input_to_expr_for_map2 expr_gen = do
  let expr_types = expr_to_types (expr_gen (ErrorN "not an error") (ErrorN "not an error"))
  let expr_in_type0 = head $ e_in_types expr_types
  let expr_in_type1 = (e_in_types expr_types) !! 1
  expr_gen (InputN expr_in_type0 "f_in0") (InputN expr_in_type1 "f_in0")
  

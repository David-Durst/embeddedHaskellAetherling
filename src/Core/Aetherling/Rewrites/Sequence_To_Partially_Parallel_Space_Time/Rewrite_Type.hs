module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type where
import Aetherling.Rewrites.Rewrite_Helpers
import qualified Aetherling.Languages.Sequence.Deep.Types as SeqT
import qualified Aetherling.Languages.Space_Time.Deep.Types as STT
import Control.Monad.Except
import Data.List
import Data.Maybe
import Data.Either
import qualified Data.Set as S
import Text.Printf
import Math.NumberTheory.Primes.Factorisation
import Debug.Trace
{-
get_max_length_per_layer :: Lengths_Per_Layer -> [Int]
get_max_length_per_layer (Unary_Atom_Layer e_cur_layer) = get_max_length_per_layer e_cur_layer
get_max_length_per_layer (Binary_Atom_Layer e_left_cur_layer e_right_cur_layer) =
  fmap (uncurry max) $ zip
  (get_max_length_per_layer e_left_cur_layer)
  (get_max_length_per_layer e_right_cur_layer)
-}

data Type_Rewrite =
  SpaceR { tr_n :: Int}
  | TimeR { tr_n :: Int, tr_i :: Int}
  | SplitR { tr_n_outer :: Int, tr_i_outer :: Int, tr_n_inner :: Int }
  | NonSeqR
  deriving (Show, Eq)

get_type_rewrite_periods :: Type_Rewrite -> Int
get_type_rewrite_periods (SpaceR _) = 1
get_type_rewrite_periods (TimeR tr_n tr_i) = tr_n + tr_i
get_type_rewrite_periods (SplitR tr_no tr_io _) = tr_no + tr_io
get_type_rewrite_periods NonSeqR = -1

data Layer_Rewrite_Info = Layer { l_tr :: Type_Rewrite, l_i_max :: Int, n_divisors :: S.Set Int }
  deriving (Show, Eq)

rewrite_AST_type_debug :: Int -> SeqT.AST_Type -> [Type_Rewrite]
rewrite_AST_type_debug s seq_t = do
  let s_factors = ae_factors_to_int_list $ ae_factorize s
  --traceM $ show s_factors
  let all_space_rw = seq_to_sseq_tr seq_t
  let (t_rewrites_no_underutil, s_remaining_no_underutil) =
        foldl (\(cur_rw,not_used_s_factors) s_factor -> do
                  let (new_rw, success) = rewrite_no_underutil s_factor cur_rw
                  if success
                    then trace (show new_rw) $ (new_rw, not_used_s_factors)
                    else (new_rw, insert s_factor not_used_s_factors)
                  ) (all_space_rw, []) s_factors
  traceM "finished with no underutil calls"
  traceM $ show t_rewrites_no_underutil
  traceM $ show s_remaining_no_underutil
  let maybe_t_rewrites_with_underutil =
        foldM (\cur_rw_maybe s_factor -> rewrite_with_underutil s_factor cur_rw_maybe)
        t_rewrites_no_underutil s_remaining_no_underutil
  fmap l_tr $ fromJust maybe_t_rewrites_with_underutil
rewrite_AST_type :: (Monad m) => Int -> SeqT.AST_Type -> Rewrite_StateTM m [Type_Rewrite]
rewrite_AST_type s seq_t = do
  let s_factors = ae_factors_to_int_list $ ae_factorize s
  let all_space_rw = seq_to_sseq_tr seq_t
  let (t_rewrites_no_underutil, s_remaining_no_underutil) =
        foldl (\(cur_rw,not_used_s_factors) s_factor -> do
                  let (new_rw, success) = rewrite_no_underutil s_factor cur_rw
                  if success
                    then (new_rw, not_used_s_factors)
                    else (new_rw, insert s_factor not_used_s_factors)
                  ) (all_space_rw, []) s_factors
  let maybe_t_rewrites_with_underutil =
        foldM (\cur_rw_maybe s_factor -> rewrite_with_underutil s_factor cur_rw_maybe)
        t_rewrites_no_underutil s_remaining_no_underutil
  if isJust maybe_t_rewrites_with_underutil
    then return $ fmap l_tr $ fromJust maybe_t_rewrites_with_underutil
    else throwError $ Slowdown_Failure $ show s_remaining_no_underutil ++ " slowdown not 1 " ++
         "with t_rewrites " ++ show t_rewrites_no_underutil ++ " for initial type " ++ show seq_t ++
         " and initial slowdown factor " ++ show s

        {-
        rewrite_AST_type_no_underutil s_factors seq_t
  let (t_rewrites, s_remaining) =
        rewrite_AST_type_add_underutil s_remaining_no_underutil t_rewrites_no_underutil seq_t
  if ae_all_non_one_factors_used s_remaining
    then return t_rewrites
    else throwError $ Slowdown_Failure $ show s_remaining ++ " slowdown not 1 " ++
         "with t_rewrites " ++ show t_rewrites ++ " for initial type " ++ show seq_t
-}

seq_to_sseq_tr :: SeqT.AST_Type -> [Layer_Rewrite_Info]
seq_to_sseq_tr (SeqT.SeqT n i t) =
  Layer (SpaceR n) i (ae_divisors n) : seq_to_sseq_tr t
seq_to_sseq_tr (SeqT.STupleT n t) =
  Layer NonSeqR 0 (S.empty) : seq_to_sseq_tr t
seq_to_sseq_tr _ = [Layer NonSeqR 0 (S.empty)]

rewrite_one_space_layer_no_underutil :: Int -> Layer_Rewrite_Info -> Maybe Layer_Rewrite_Info
rewrite_one_space_layer_no_underutil s_p (Layer (SpaceR n) i_max divisors) |
  (n+i_max) == s_p = do
    return $ Layer (TimeR n i_max) i_max divisors 
rewrite_one_space_layer_no_underutil s_p (Layer (SpaceR n) i_max divisors) |
  n `mod` s_p == 0 = do
    let no = s_p
    let ni = n `div` no
    return $ Layer (SplitR no 0 ni) i_max divisors
rewrite_one_space_layer_no_underutil _ _ = Nothing

-- bool for whether was able to rewrite by this factor
rewrite_no_underutil :: Int -> [Layer_Rewrite_Info] -> ([Layer_Rewrite_Info], Bool)
rewrite_no_underutil s_p (cur_layer@(Layer (SpaceR n) _ _) : tl) = do
  let rw_result = rewrite_one_space_layer_no_underutil s_p cur_layer
  if (isNothing rw_result)
    then do
    let (inner_l, inner_success) = rewrite_no_underutil s_p tl
    (cur_layer : inner_l, inner_success)
    else ((fromJust rw_result) : tl, True)
rewrite_no_underutil s_p (cur_layer@(Layer (SplitR no 0 ni) i_max divisors) : tl) = do
  let rw_result = rewrite_one_space_layer_no_underutil (s_p*no)
                  (Layer (SpaceR (no*ni)) i_max divisors)
  if (isNothing rw_result)
    then do
    let (inner_l, inner_success) = rewrite_no_underutil s_p tl
    (cur_layer : inner_l, inner_success)
    else ((fromJust rw_result) : tl, True)
-- can't slow down a fully spatial dimension any more without underutil
-- nor any other types of dimensions without underutil
rewrite_no_underutil s_p (l : tl) = do
  let (inner_l, inner_success) = rewrite_no_underutil s_p tl
  (l : inner_l, inner_success)
rewrite_no_underutil _ [] = ([], False)

rewrite_one_space_layer_with_underutil :: Int -> Layer_Rewrite_Info -> Maybe Layer_Rewrite_Info
rewrite_one_space_layer_with_underutil s_p (Layer (SpaceR n) i_max n_divisors) |
  (n+i_max) >= s_p = do
    -- get smallest valid ni
    let ni_options = filter io_and_no_valid $ S.toAscList n_divisors
    if length ni_options == 0
      then Nothing
      else do
      let ni = head ni_options
      let io = s_p - (n `div` ni)
      let no = n `div` ni
      return $ Layer (SplitR no io ni) i_max n_divisors
    where
      io_and_no_valid ni =
        -- no is a positive integer
        ((n `mod` ni) == 0) &&
        -- io is a non-negative integer
        (s_p - (n `div` ni) >= 0) &&
        -- io less than or equal to i_max
        (s_p - (n `div` ni) <= i_max)
rewrite_one_space_layer_with_underutil _ _ = Nothing

-- this fails if can't incorporate all factors
rewrite_with_underutil :: Int -> [Layer_Rewrite_Info] -> Maybe [Layer_Rewrite_Info]
rewrite_with_underutil s_p (cur_layer@(Layer (SpaceR n) _ _) : tl) = do
  let rw_result = rewrite_one_space_layer_with_underutil s_p cur_layer
  if (isNothing rw_result)
    then do
    inner_l <- rewrite_with_underutil s_p tl
    return $ cur_layer : inner_l
    else return $ (fromJust rw_result) : tl
rewrite_with_underutil s_p (cur_layer@(Layer (SplitR no io ni) i_max divisors) : tl) = do
  let rw_result = rewrite_one_space_layer_with_underutil ((no+io)*s_p)
                  (Layer (SpaceR (no*ni)) i_max divisors)
  if (isNothing rw_result)
    then do
    inner_l <- rewrite_with_underutil s_p tl
    return $ cur_layer : inner_l
    else return $ (fromJust rw_result) : tl
-- can't slow down a fully spatial dimension any more without underutil
-- nor any other types of dimensions without underutil
rewrite_with_underutil s_p (l : tl) = do
  inner_l <- rewrite_with_underutil s_p tl
  return $ l : inner_l
rewrite_with_underutil _ [] = Nothing
{-
rewrite_for_underutil :: Int -> [Layer_Rewrite_Info] -> [Layer_Rewrite_Info]
rewrite_for_underutil s_p (Layer (SpaceR n) i_max factors : tl) |
  (n+i_max) `mod` s_p == 0 = do
    let no_new = no
-}
rewrite_AST_type_no_underutil :: Factors -> SeqT.AST_Type -> ([Type_Rewrite], Factors)
rewrite_AST_type_no_underutil s_remaining_factors (SeqT.SeqT n i t) = do
  let n_factors = ae_factorize n
  if ae_factors_intersect n_factors s_remaining_factors /= S.empty
    then do
    let slowdown_factors = ae_factors_intersect n_factors s_remaining_factors
    let slowdown = ae_factors_product slowdown_factors
    let no = slowdown
    let ni = n `div` no
    let io = 0
    let result_s_remaining_factors = ae_renumber_factors $
          ae_factors_diff s_remaining_factors slowdown_factors
    let (inner_rewrites, final_factors) = rewrite_AST_type_no_underutil result_s_remaining_factors t
    if i == 0 && no == n
      -- special case of doing a full slowdown, can only happen
      -- if i is 0. Need to produce time
      -- Ok that add_invalid_clocks will can't handle timer's
      -- produced by this function as won't be able to slow
      -- this down any further
      then (TimeR no 0 : inner_rewrites, final_factors)
      else (SplitR no io ni : inner_rewrites, final_factors)

    else do
    let (inner_rewrites, final_factors) = rewrite_AST_type_no_underutil s_remaining_factors t
    (SpaceR n : inner_rewrites, final_factors)
rewrite_AST_type_no_underutil s_remaining_factors (SeqT.STupleT n t) = do
  let (inner_rewrites, final_factors) = rewrite_AST_type_no_underutil s_remaining_factors t
  (NonSeqR : inner_rewrites, final_factors)
rewrite_AST_type_no_underutil s_remaining_factors _ = ([NonSeqR], s_remaining_factors)

rewrite_AST_type_add_underutil :: Factors -> [Type_Rewrite] -> SeqT.AST_Type -> ([Type_Rewrite], Factors)
rewrite_AST_type_add_underutil s_remaining_factors (cur_tr_no_under : no_under_tl)
  (SeqT.SeqT n i t) = do
  -- problem: n+i may not be divisible by n, so this max slowdown is invalid
  -- 
  let max_slowdown = (n + i) `div` get_type_rewrite_periods cur_tr_no_under
  let max_slowdown_factors = ae_factorize max_slowdown
  if ae_factors_intersect max_slowdown_factors s_remaining_factors /= S.empty
    then do
    let slowdown_factors = ae_factors_intersect max_slowdown_factors s_remaining_factors
    let slowdown = ae_factors_product slowdown_factors
    let result_s_remaining_factors = ae_renumber_factors $
          ae_factors_diff s_remaining_factors slowdown_factors
    let (inner_rewrites, final_factors) = rewrite_AST_type_add_underutil
                                          result_s_remaining_factors no_under_tl t
    (add_invalid_clocks cur_tr_no_under slowdown : inner_rewrites, final_factors)

    else do
    let (inner_rewrites, final_factors) = rewrite_AST_type_add_underutil
                                          s_remaining_factors no_under_tl t
    (cur_tr_no_under : inner_rewrites, final_factors)
    where
      add_invalid_clocks :: Type_Rewrite -> Int -> Type_Rewrite
      -- if going to emit at most 1 valid per clock and using all possible clocks
      -- then fully sequential so only a time
      add_invalid_clocks (SpaceR 1) slowdown |
        slowdown == (n+i) =
        TimeR 1 (slowdown - 1)
      add_invalid_clocks (SplitR no io ni) slowdown |
        slowdown*(no+io) == (n+i) && (no*ni) <= slowdown*(no+io) =
        -- need to subtract no from invalids as total time should be (no+io) * slowdown
        TimeR (no*ni) (slowdown*(no+io) - (no*ni))
      add_invalid_clocks (SpaceR n) slowdown |
        n <= slowdown =
        TimeR n (slowdown - n)
      -- otherwise, just make it a splitr and slow down by requested amount
      add_invalid_clocks (SpaceR n) slowdown =
        SplitR 1 (slowdown - 1) n
      add_invalid_clocks (SplitR no io ni) slowdown =
        SplitR no (slowdown*(no+io) - no) ni
      add_invalid_clocks _ _ = traceShow "calling add_invalid_wrong" undefined
rewrite_AST_type_add_underutil s_remaining_factors (_ : no_under_tl) (SeqT.STupleT n t) = do
  let (inner_rewrites, final_factors) =
        rewrite_AST_type_add_underutil s_remaining_factors no_under_tl t
  (NonSeqR : inner_rewrites, final_factors)
rewrite_AST_type_add_underutil s_remaining_factors _ _ = ([NonSeqR], s_remaining_factors)

data Factor = Factor { factor_val :: Int, factor_num :: Int }
  deriving (Show, Eq, Ord)

type Factors = S.Set Factor

factor_num_pair_to_factor_list :: (Integer, Int) -> Factors
factor_num_pair_to_factor_list (factor, copies) = do
  let factor_int = fromInteger factor
  S.fromList $ [Factor factor_int i | i <- [0 .. copies - 1]]
  
ae_factorize :: Int -> Factors
ae_factorize n = do
  let factors = factorise $ fromIntegral n
  let nested_factors = S.fromList $ fmap factor_num_pair_to_factor_list factors
  S.foldl S.union S.empty nested_factors

ae_all_non_one_factors_used :: Factors -> Bool
ae_all_non_one_factors_used fs = fs == S.empty

ae_factors_to_int_list :: Factors -> [Int]
ae_factors_to_int_list factors = do
  let factors_list = S.toList factors
  fmap factor_val factors_list

ae_renumber_factors :: Factors -> Factors
ae_renumber_factors input_factors = do
  let input_factors_list = ae_factors_to_int_list input_factors
  -- note: group only combines adjacent elements
  -- which is fine since ae_factors_to_int_list puts all equivalent ints adjacent
  let grouped_factors_list = group input_factors_list
  let indices :: [Int] = [0..]
  let factors_with_indices = fmap (\x -> zip x indices) grouped_factors_list
  let flattened_factors_with_indices = foldl (++) [] factors_with_indices
  let typed_factors = fmap
        (\(factor, idx) -> Factor factor idx)
        flattened_factors_with_indices
  S.fromList typed_factors

ae_factors_product :: Factors -> Int
ae_factors_product = product . ae_factors_to_int_list

ae_factors_subset :: Factors -> Factors -> Bool
ae_factors_subset = S.isSubsetOf

ae_factors_diff :: Factors -> Factors -> Factors
ae_factors_diff = S.difference

ae_factors_intersect :: Factors -> Factors -> Factors
ae_factors_intersect = S.intersection

ae_factors_union :: Factors -> Factors -> Factors
ae_factors_union = S.union

ae_divisors :: Int -> S.Set Int
ae_divisors n = do
  let factors = ae_factorize n
  ae_divisors_from_factors factors

ae_divisors_from_factors :: Factors -> S.Set Int
ae_divisors_from_factors factors = do
  let factors_with_indices_powerset = ae_factors_powerset factors
  S.map ae_factors_product factors_with_indices_powerset

ae_factors_powerset :: Factors -> S.Set Factors
ae_factors_powerset xs_set = do
  let xs = S.toList xs_set
  S.fromList $ fmap S.fromList $ filterM (const [True, False]) xs

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

-- | given a set of type rewrites, get the parallel factors
-- this is so can compute flattened number of atoms in or out per clock
-- as reshaping between types requires holding that constant
-- the Int is par factors to ignore as they've been used by new STuples
-- on the other side of reshape type
get_par_factors :: [Type_Rewrite] -> Int -> Factors
get_par_factors tr_xs par_to_ignore = do 
  let total_par = foldl (\prior_par_product tr -> get_par tr * prior_par_product) 1 tr_xs
  let par_without_stuple = total_par `div` par_to_ignore
  ae_factorize par_without_stuple
  where
    get_par :: Type_Rewrite -> Int
    get_par (SpaceR n) = n
    get_par (SplitR _ _ ni) = ni
    get_par _ = 1

data Layer_Rewrite_Info = Layer {
  l_tr :: Type_Rewrite,
  l_i_max :: Int,
  n_divisors :: S.Set Int,
  l_par_factors :: Factors
  }
  deriving (Show, Eq)

rewrite_AST_type_debug :: Int -> Factors -> SeqT.AST_Type -> [Type_Rewrite]
rewrite_AST_type_debug s par_factors seq_t = do
  -- sort factors from largest to smallest as want to slow down by biggest first
  let s_factors = reverse $ sort $ ae_factors_to_int_list $ ae_factorize s
  --traceM $ show s_factors
  let all_space_rw = seq_to_sseq_tr seq_t
  let (t_rewrites_no_underutil, s_remaining_no_underutil, par_factors_remaining_no_underutil) =
        foldl (\(cur_rw,not_used_s_factors, cur_available_par_factors) s_factor -> do
                  let (new_rw, success, new_available_par_factors) =
                        rewrite_no_underutil s_factor cur_available_par_factors cur_rw
                  if success
                    then (new_rw, not_used_s_factors, new_available_par_factors)
                    else (new_rw, not_used_s_factors ++ [s_factor], cur_available_par_factors)
                  ) (all_space_rw, [], par_factors) s_factors
  traceM "finished with no underutil calls"
  traceM $ show t_rewrites_no_underutil
  traceM $ show s_remaining_no_underutil
  -- sort factors from largest to smallest as want to slow down by biggest first
  let maybe_t_rewrites_with_underutil =
        foldM (\(cur_rw, cur_available_par_factors) s_factor ->
                 rewrite_with_underutil s_factor cur_available_par_factors cur_rw)
        (t_rewrites_no_underutil, par_factors_remaining_no_underutil) s_remaining_no_underutil
  fmap l_tr $ fst $ fromJust maybe_t_rewrites_with_underutil
-- | s is amount to slowdown.
-- par_factors the factors that must appear in the SSeqs. This is used by reshape to
-- ensure the same number of input and output atoms per value clock
-- seq_t is the sequential type
rewrite_AST_type :: (Monad m) => Int -> Factors -> SeqT.AST_Type -> Rewrite_StateTM m [Type_Rewrite]
rewrite_AST_type s par_factors seq_t = do
  let s_factors = ae_factors_to_int_list $ ae_factorize s
  let all_space_rw = seq_to_sseq_tr seq_t
  let (t_rewrites_no_underutil, s_remaining_no_underutil, par_factors_remaining_no_underutil) =
        foldl (\(cur_rw,not_used_s_factors, cur_available_par_factors) s_factor -> do
                  let (new_rw, success, new_available_par_factors) =
                        rewrite_no_underutil s_factor cur_available_par_factors cur_rw
                  if success
                    then (new_rw, not_used_s_factors, new_available_par_factors)
                    else (new_rw, not_used_s_factors ++ [s_factor], cur_available_par_factors)
                  ) (all_space_rw, [], par_factors) s_factors
  let maybe_t_rewrites_with_underutil =
        foldM (\(cur_rw, cur_available_par_factors) s_factor ->
                 rewrite_with_underutil s_factor cur_available_par_factors cur_rw)
        (t_rewrites_no_underutil, par_factors_remaining_no_underutil) s_remaining_no_underutil
  if isJust maybe_t_rewrites_with_underutil
    then return $ fmap l_tr $ fst $ fromJust maybe_t_rewrites_with_underutil
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
  -- first time you make everything SSeq, haven't assigned any factors
  -- just making it sseq for rewriting, so nothing here
  Layer (SpaceR n) i (ae_divisors n) S.empty : seq_to_sseq_tr t
seq_to_sseq_tr (SeqT.STupleT n t) =
  Layer NonSeqR 0 (S.empty) S.empty : seq_to_sseq_tr t
seq_to_sseq_tr _ = [Layer NonSeqR 0 (S.empty) S.empty]

rewrite_one_space_layer_no_underutil :: Int -> Factors ->
  Layer_Rewrite_Info -> Maybe (Layer_Rewrite_Info, Factors)
rewrite_one_space_layer_no_underutil s_p par_factors (Layer (SpaceR n) i_max divisors _) |
  ((n+i_max) == s_p) && (ae_factors_subset (ae_factorize n) par_factors) = do
    return $ (Layer (TimeR n i_max) i_max divisors (ae_factorize n), ae_remove_int_from_factors n par_factors)
rewrite_one_space_layer_no_underutil s_p par_factors (Layer (SpaceR n) i_max divisors _) |
  (n `mod` s_p == 0) && (ae_factors_subset (ae_factorize ni) par_factors) = do
    return $ (Layer (SplitR no 0 ni) i_max divisors (ae_factorize ni), ae_remove_int_from_factors n par_factors)
    where
      no = s_p
      ni = n `div` no
rewrite_one_space_layer_no_underutil _ _ _ = Nothing

-- bool for whether was able to rewrite by this factor
rewrite_no_underutil :: Int -> Factors -> [Layer_Rewrite_Info] ->
                        ([Layer_Rewrite_Info], Bool, Factors)
rewrite_no_underutil s_p par_factors (cur_layer@(Layer (SpaceR n) _ _ cur_layer_par_factors) : tl) = do
  let rw_result = rewrite_one_space_layer_no_underutil s_p cur_layer_par_factors cur_layer
  if (trace (show rw_result) $ isNothing rw_result)
    then do
    let (inner_l, inner_success, new_par_factors) = rewrite_no_underutil s_p par_factors tl
    (cur_layer : inner_l, inner_success, new_par_factors)
    else do 
    let (rw_layer, new_par_factors) = fromJust rw_result
    (rw_layer : tl, True, new_par_factors)
rewrite_no_underutil s_p par_factors (cur_layer@(Layer (SplitR no 0 ni) i_max divisors cur_layer_par_factors) : tl) = do
  -- need to add factors used for current par component of SplitR
  -- to par_factors when doing rewrite as they can be used in current layer
  let factors_can_used_current_layer = ae_add_int_to_factors
                                       (ae_factors_product cur_layer_par_factors)
                                       par_factors
  let rw_result = rewrite_one_space_layer_no_underutil (s_p*no)
                  factors_can_used_current_layer
                  (Layer (SpaceR (no*ni)) i_max divisors S.empty)
  if (isNothing rw_result)
    then do
    let (inner_l, inner_success, new_par_factors) = rewrite_no_underutil s_p par_factors tl
    (cur_layer : inner_l, inner_success, new_par_factors)
    else do 
    let (rw_layer, new_par_factors) = fromJust rw_result
    (rw_layer : tl, True, new_par_factors)
-- can't slow down a fully spatial dimension any more without underutil
-- nor any other types of dimensions without underutil
rewrite_no_underutil s_p par_factors (l : tl) = do
  let (inner_l, inner_success, new_par_factors) = rewrite_no_underutil s_p par_factors tl
  (l : inner_l, inner_success, new_par_factors)
rewrite_no_underutil _ par_factors [] = ([], False, par_factors)

rewrite_one_space_layer_with_underutil :: Int -> Factors ->
  Layer_Rewrite_Info -> Maybe (Layer_Rewrite_Info, Factors)
rewrite_one_space_layer_with_underutil s_p par_factors (Layer (SpaceR n) i_max n_divisors _) |
  (n+i_max) >= s_p = do
    -- get smallest valid ni
    let ni_options = filter io_and_no_valid $ S.toAscList n_divisors
    if length ni_options == 0
      then Nothing
      else do
      let ni = head ni_options
      let io = s_p - (n `div` ni)
      let no = n `div` ni
      return $ (Layer (SplitR no io ni) i_max n_divisors (ae_factorize ni),
                ae_remove_int_from_factors ni par_factors)
    where
      io_and_no_valid ni =
        -- no is a positive integer
        ((n `mod` ni) == 0) &&
        -- io is a non-negative integer
        (s_p - (n `div` ni) >= 0) &&
        -- io less than or equal to i_max
        (s_p - (n `div` ni) <= i_max) &&
        -- ni contains only factors in par_factors
        (ae_factors_subset (ae_factorize ni) par_factors)
rewrite_one_space_layer_with_underutil _ _ _ = Nothing

-- this fails if can't incorporate all factors
rewrite_with_underutil :: Int -> Factors -> [Layer_Rewrite_Info] -> Maybe ([Layer_Rewrite_Info], Factors)
rewrite_with_underutil s_p par_factors (cur_layer@(Layer (SpaceR n) _ _ cur_layer_par_factors) : tl) = do
  -- need to add factors used for current SpaceR to par_factors when doing rewrite
  -- as they can be used in current layer
  let factors_can_used_current_layer = ae_add_int_to_factors
                                       (ae_factors_product cur_layer_par_factors)
                                       par_factors
  let rw_result = rewrite_one_space_layer_with_underutil s_p factors_can_used_current_layer cur_layer
  if (isNothing rw_result)
    then do
    (inner_l, new_par_factors) <- rewrite_with_underutil s_p par_factors tl
    return $ (cur_layer : inner_l, new_par_factors)
    else do
    let (rw_layer, new_par_factors) = fromJust rw_result
    return $ (rw_layer : tl, new_par_factors)
rewrite_with_underutil s_p par_factors (cur_layer@(Layer (SplitR no io ni) i_max divisors cur_layer_par_factors) : tl) = do
  -- need to add factors used for current par component of SplitR
  -- to par_factors when doing rewrite as they can be used in current layer
  let factors_can_used_current_layer = ae_add_int_to_factors
                                       (ae_factors_product cur_layer_par_factors)
                                       par_factors
  let rw_result = rewrite_one_space_layer_with_underutil ((no+io)*s_p)
                  factors_can_used_current_layer
                  (Layer (SpaceR (no*ni)) i_max divisors S.empty)
  if (isNothing rw_result)
    then do
    (inner_l, new_par_factors) <- rewrite_with_underutil s_p par_factors tl
    return $ (cur_layer : inner_l, new_par_factors)
    else do
    let (rw_layer, new_par_factors) = fromJust rw_result
    return $ (rw_layer : tl, new_par_factors)
-- can't slow down a fully spatial dimension any more without underutil
-- nor any other types of dimensions without underutil
rewrite_with_underutil s_p par_factors (l : tl) = do
  (inner_l, new_par_factors) <- rewrite_with_underutil s_p par_factors tl
  return $ (l : inner_l, new_par_factors)
rewrite_with_underutil _ _ [] = Nothing
{-
rewrite_for_underutil :: Int -> [Layer_Rewrite_Info] -> [Layer_Rewrite_Info]
rewrite_for_underutil s_p (Layer (SpaceR n) i_max factors : tl) |
  (n+i_max) `mod` s_p == 0 = do
    let no_new = no
-}

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

ae_add_int_to_factors :: Int -> Factors -> Factors
ae_add_int_to_factors new_int old_factors = do
  let product = ae_factors_product old_factors * new_int
  ae_factorize product
  
ae_remove_int_from_factors :: Int -> Factors -> Factors
ae_remove_int_from_factors old_int old_factors = do
  ae_factors_diff old_factors $ ae_factorize old_int

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

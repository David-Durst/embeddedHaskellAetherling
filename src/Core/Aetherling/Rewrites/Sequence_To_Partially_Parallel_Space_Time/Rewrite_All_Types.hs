module Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_All_Types where
import Aetherling.Rewrites.Sequence_To_Partially_Parallel_Space_Time.Rewrite_Type
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

num_seq_layers :: SeqT.AST_Type -> Int
num_seq_layers (SeqT.SeqT n i t) = 1 + num_seq_layers t
num_seq_layers (SeqT.STupleT n t) = num_seq_layers t
num_seq_layers _ = 0

crossr [] = [[]]
crossr (x:xs) = [ a:as |  a <- x,  as <- crossr xs ]

type Out_Type_Rewrites = [Type_Rewrite]

rewrite_all_AST_types_debug :: Int -> SeqT.AST_Type -> [Out_Type_Rewrites]
rewrite_all_AST_types_debug s seq_t = do
  let l = num_seq_layers seq_t
  let s_factors = S.toList $ ae_factorize s
  let s_for_each_level = groupBy (\x y -> fst x == fst y)
        [ (x,y) | x <- s_factors, y <- [1..l]]
  let all_possible_s_distributions = crossr s_for_each_level
  undefined

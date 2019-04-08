module Aetherling.Interpretations.Sequence_Shallow_To_Deep where
import Aetherling.Declarations.Sequence
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Types.Isomorphisms
import Aetherling.Interpretations.Monad_Helpers
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Identity
import Data.Typeable
import Data.Maybe
import GHC.TypeLits
import Unsafe.Coerce
import qualified Data.Vector.Sized as V
import Util

get_deep_dag :: Seq_Shallow_To_Deep_Env a -> Either String Seq_DAG
get_deep_dag shallow_embedding =
  runIdentity $ runExceptT $ execStateT shallow_embedding empty_seq_dag

empty_seq_dag = Seq_DAG [] [] 0

data Seq_DAG = Seq_DAG {
  nodes :: [Sequence_Language_AST],
  edges :: [DAG_Edge],
  next_DAG_index :: DAG_Index
  } deriving (Show, Eq)

type Seq_Shallow_To_Deep_Env = StateT Seq_DAG (ExceptT String Identity)

add_to_DAG :: (Convertible_To_DAG_Data a) =>
  Sequence_Language_AST -> Maybe [DAG_Index] -> String -> String ->
  Seq_Shallow_To_Deep_Env a
add_to_DAG new_node input_indices_maybe node_name args_name = do
  prior_DAG <- get
  let cur_node_index = next_DAG_index prior_DAG
  if isJust input_indices_maybe
    then do
    let input_indices = fromJust input_indices_maybe
    let new_edges = fmap (\idx -> DAG_Edge idx cur_node_index) input_indices
    let new_DAG = Seq_DAG
          (nodes prior_DAG ++ [new_node])
          (edges prior_DAG ++ new_edges)
          (next_DAG_index prior_DAG + 1)
    put new_DAG
    return (convert_index_to_value cur_node_index)
    else do
    fail $ fail_message node_name args_name

input_to_maybe_indices :: (Convertible_To_DAG_Data a) =>
  [a] -> Maybe [DAG_Index]
input_to_maybe_indices inputs = traverse convert_to_index inputs

instance Sequence_Language Seq_Shallow_To_Deep_Env where
  -- unary operators
  idC x = add_to_DAG IdN (input_to_maybe_indices [x]) "idC" "any_input_edge"
  absC x = add_to_DAG AbsN (input_to_maybe_indices [x]) "absC" "Atom_Int_Edge"
  notC x = add_to_DAG NotN (input_to_maybe_indices [x]) "absC" "Atom_Bit_Edge"
  
  -- binary operators
  addC x = add_to_DAG AddN (input_to_maybe_indices [x]) "addC" "Atom_Tuple_Edge"
  eqC x = add_to_DAG EqN (input_to_maybe_indices [x]) "eqC" "Atom_Tuple_Edge"
  
  
  -- generators
  lut_genC table x = do
    let lut_table_maybe = traverse convert_atom_to_AST_Value table
    if isJust lut_table_maybe
      then do
      add_to_DAG (Lut_GenN $ fromJust lut_table_maybe) (input_to_maybe_indices [x])
        "lut_genC" "Atom_Int_edge"
      else do
      fail $ fail_message "lut_genC" "[a_Edge]"

  const_genC const x = do
    let const_maybe = convert_atom_to_AST_Value const
    if isJust const_maybe
      then do
      add_to_DAG (Const_GenN $ fromJust const_maybe) (input_to_maybe_indices [x])
        "const_genC" "Atom_Unit_Edge"
      else do
      fail $ fail_message "const_genC" "a_Edge"

  -- sequence operators
  up_1dC proxyN x = add_to_DAG (Up_1dN valN (get_AST_type get_proxy))
    (input_to_maybe_indices [x]) "up_1dC" "Seq_Edge"
    where
      valN = fromInteger $ natVal proxyN
{-
  lut_genC xs (Atom_Int i) | i < length xs = return $ xs !! i 
  lut_genC xs (Atom_Int i) = fail "lut lookup index out of bounds"
  lut_genC _ _ = fail $ fail_message "lut_genC" "Atom_Int"

  const_genC x _ = return x

  -- sequence operators
  up_1dC proxyN (Seq elem) = return $ Seq $
    V.replicate' proxyN $ V.head elem
  up_1dC _ _ = fail $ fail_message "up_1dC" "Seq"

  down_1dC proxyN (Seq vec) = return $ Seq $
    V.replicate' (Proxy @1) $ V.head vec
  down_1dC _ _ = fail $ fail_message "down_1dC" "Seq"

  partitionC _ proxy_ni unnested_seq =
    return $ seqToSeqOfSeq proxy_ni unnested_seq 

  unpartitionC _ _ unflattened_seq =
    return $ seqOfSeqToSeq unflattened_seq

  mapC _ f input = mapM f input
  map2C _ f input = traverse2 f input

  -- tuple operations
  fstC (Atom_Tuple (x, _)) = return x
  fstC _ = fail $ fail_message "fstC" "Atom_Tuple"

  sndC (Atom_Tuple (_, y)) = return y
  sndC _ = fail $ fail_message "sndC" "Atom_Tuple"

  zipC x y = return $ Atom_Tuple (x,y) 

  -- composition operators
  (>>>) f g x = f x >>= g
-}

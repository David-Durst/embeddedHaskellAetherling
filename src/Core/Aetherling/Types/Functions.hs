module Aetherling.Types.Functions where
import Aetherling.Types.Declarations
import Aetherling.Types.Isomorphisms
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Proxy
import GHC.Exts (Constraint)
import Data.Typeable
import Data.List.Split
import qualified Data.List as L

{-
Below are type families for computing types depending on other types
These are mainly used in function declarations
-}
size_int :: Int
size_int = 8
size_bit :: Int
size_bit = 1

size_t :: AST_Type -> Int
size_t UnitT = 0
size_t BitT = size_bit
size_t IntT = size_int
size_t (ATupleT t0 t1) = size_t t0 + size_t t1
size_t (STupleT n t) = n * size_t t
size_t (SeqT _ _ _) = 0
size_t (SSeqT n t) = n * size_t t
size_t (TSeqT n _ t) = size_t t

type family Check_Type_Is_Atom (x :: *) :: Constraint where
  Check_Type_Is_Atom Atom_Unit = True ~ True
  Check_Type_Is_Atom (Atom_Int) = True ~ True
  Check_Type_Is_Atom (Atom_Bit) = True ~ True
  Check_Type_Is_Atom (Atom_Tuple a b) = True ~ True
  Check_Type_Is_Atom x =
    TypeError (ShowType x :<>: Text " is not an atom.")

type family Check_Type_Is_Atom_Or_Nested (x :: *) :: Constraint where
  Check_Type_Is_Atom_Or_Nested Atom_Unit = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Int) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Bit) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Atom_Tuple a b) = True ~ True
  Check_Type_Is_Atom_Or_Nested (Seq _ _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested (SSeq _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested (TSeq _ _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested x =
    TypeError (ShowType x :<>: Text " is not an atom, a Seq containing atoms,"
              :<>: Text " an SSeq containing atoms, or a TSeq containing atoms.")

-- A typeclass that indicates all the valid Aetherling values
-- For each Aetherling value, when converting from shallow to deep representation,
-- must be able to convert between edges' types and the index of the node they
-- are produced by
class Aetherling_Value a where
  convert_ae_value_to_index :: a -> Maybe DAG_Index
  convert_index_to_ae_value :: DAG_Index -> a
  get_AST_type :: Proxy a -> AST_Type
  get_AST_value :: a -> Maybe AST_Value

instance Aetherling_Value Atom_Unit where
  convert_ae_value_to_index (Atom_Unit_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = Atom_Unit_Edge idx
  get_AST_type _ = UnitT
  get_AST_value Atom_Unit = Just $ UnitV
  get_AST_value _ = Nothing

instance Aetherling_Value Atom_Bit where
  convert_ae_value_to_index (Atom_Bit_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = Atom_Bit_Edge idx
  get_AST_type _ = BitT
  get_AST_value (Atom_Bit b) = Just $ BitV b
  get_AST_value _ = Nothing

instance Aetherling_Value Atom_Int where
  convert_ae_value_to_index (Atom_Int_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = Atom_Int_Edge idx
  get_AST_type _ = IntT
  get_AST_value (Atom_Int i) = Just $ IntV i
  get_AST_value _ = Nothing

instance (Aetherling_Value a, Aetherling_Value b) =>
  Aetherling_Value (Atom_Tuple a b) where
  convert_ae_value_to_index (Atom_Tuple_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = Atom_Tuple_Edge idx
  get_AST_type _ =
    ATupleT (get_AST_type (Proxy :: Proxy a)) (get_AST_type (Proxy :: Proxy b))
  get_AST_value (Atom_Tuple x y) = do
    x_val <- get_AST_value x
    y_val <- get_AST_value y
    Just $ ATupleV x_val y_val
  get_AST_value _ = Nothing

instance (KnownNat n, Aetherling_Value a) =>
  Aetherling_Value (Seq_Tuple n a)  where
  convert_ae_value_to_index (Seq_Tuple_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = Seq_Tuple_Edge idx
  get_AST_type _ = STupleT nVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
  get_AST_value (Seq_Tuple vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    Just $ STupleV elements_as_AST_values
  get_AST_value _ = Nothing

instance (KnownNat n, KnownNat i, Aetherling_Value a) =>
  Aetherling_Value (Seq n i a) where
  convert_ae_value_to_index (Seq_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = Seq_Edge idx
  get_AST_type _ = SeqT nVal iVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
      iVal = fromInteger $ natVal (Proxy :: Proxy i)
  get_AST_value (Seq vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    let iVal = fromInteger $ natVal (Proxy :: Proxy i)
    Just $ SeqV elements_as_AST_values iVal
  get_AST_value _ = Nothing

instance (KnownNat n, Aetherling_Value a) =>
  Aetherling_Value (SSeq n a) where
  convert_ae_value_to_index (SSeq_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = SSeq_Edge idx
  get_AST_type _ = SSeqT nVal (get_AST_type (Proxy :: Proxy a))
    where nVal = fromInteger $ natVal (Proxy :: Proxy n)
  get_AST_value (SSeq vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    Just $ SSeqV elements_as_AST_values
  get_AST_value _ = Nothing

instance (KnownNat n, KnownNat i, Aetherling_Value a) =>
  Aetherling_Value (TSeq n i a) where
  convert_ae_value_to_index (TSeq_Edge idx) = Just idx
  convert_ae_value_to_index _ = Nothing
  convert_index_to_ae_value idx = TSeq_Edge idx
  get_AST_type _ = TSeqT nVal vVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
      vVal = fromInteger $ natVal (Proxy :: Proxy i)
  get_AST_value (TSeq vec) = do
    let elements = V.toList vec
    elements_as_AST_values <- traverse get_AST_value elements
    let iVal = fromInteger $ natVal (Proxy :: Proxy i)
    Just $ TSeqV elements_as_AST_values iVal
  get_AST_value _ = Nothing

{-
Below functions are for converting a type representation to a string
for compilation to Magma
-}

-- if true, then input string, if false then output string
directionalString :: Bool -> String
directionalString True = "In"
directionalString False = "Out"
  
intTypeString isInput = "Array(" L.++ show size_int L.++ ", " L.++
  directionalString isInput L.++ "(Bit))"
bitTypeString isInput = "Array(" L.++ show size_bit L.++ ", " L.++
  directionalString isInput L.++ "(Bit))"

-- first one is string to replace
-- second one is string to replace it with
-- third string is string to operate on
replaceAString :: String -> String -> String -> String
replaceAString toReplace subtitute input = replaced 
  where
    (hdSplit:tlSplit) = splitOn toReplace input
    replaced = L.foldl (\x -> \y -> x L.++ subtitute L.++ y)
      hdSplit tlSplit

typeToMagmaString :: Bool -> TypeRep -> String
typeToMagmaString isInput typeRep
  | typeRep == typeOf (Proxy :: Proxy Atom_Unit) = ""
  | typeRep == typeOf (Proxy :: Proxy Atom_Int) = 
    intTypeString isInput
  | typeRep == typeOf (Proxy :: Proxy Atom_Bit) = 
    bitTypeString isInput
  -- assume otherwise this is a tuple
  | otherwise = do
      let lastBraceRemoved = L.reverse . L.tail . L.reverse $ show typeRep
          proxyRemoved = L.foldl (L.++) "" $ splitOn "Proxy * (" $ lastBraceRemoved
          -- need to replace all commas with ints to get tuple indexing
          splitOnCommas = splitOn "," proxyRemoved
          joinStrWithIdx idx str = ",_" L.++ show idx L.++ "=" L.++ str
          withIndices = L.zipWith joinStrWithIdx [0..(L.length splitOnCommas)] splitOnCommas
          -- will handle first element in tuples at end as it is different,
          -- so need to remove first from prior step
          withIndicesExcept0 = L.foldl (L.++) "" $ [L.head splitOnCommas] L.++ (L.tail withIndices)
          intsReplaced = replaceAString "(Atom Int)" (intTypeString isInput) withIndicesExcept0
          bitsReplaced = replaceAString "(Atom Bool)" (bitTypeString isInput) intsReplaced
          tuplesReplaced = replaceAString "Atom (" "Tuple(_0=" bitsReplaced
      tuplesReplaced

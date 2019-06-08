module Aetherling.Types.Functions where
import Aetherling.Types.Declarations
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
type family Type_Size (x :: *) :: Nat where
  Type_Size (Atom_Unit) = 0
  Type_Size (Atom_Int) = 8
  Type_Size (Atom_Bit) = 1
  Type_Size (Atom_Tuple a b) = (Type_Size a) + (Type_Size b)

size_p :: forall a . (KnownNat (Type_Size a)) => Proxy a -> Int
size_p _ = fromInteger $ natVal $ (Proxy :: Proxy (Type_Size a) )

size_t :: AST_Type -> Int
size_t UnitT = 0
size_t BitT = size_bit
size_t IntT = size_int
size_t (ATupleT t0 t1) = size_t t0 + size_t t1
size_t (STupleT n t) = n * size_t t
size_t (SeqT _ _ _) = 0
size_t (SSeqT n t) = n * size_t t
size_t (TSeqT n _ t) = size_t t

size_v :: AST_Value -> Int
size_v UnitV = 0
size_v (BitV _) = size_bit
size_v (IntV _) = size_int
size_v (TupleV t0 t1) = size_v t0 + size_v t1

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

-- Convert atoms to AST_Values for converting LUT and const_gen
-- from functions to AST nodes
class Convertible_To_AST_Value a where
  convert_atom_to_AST_Value :: a -> Maybe AST_Value

instance Convertible_To_AST_Value Atom_Unit where
  convert_atom_to_AST_Value _ = Just UnitV

instance Convertible_To_AST_Value Atom_Bit where
  convert_atom_to_AST_Value (Atom_Bit x) = Just $ BitV x
  convert_atom_to_AST_Value _ = Nothing

instance Convertible_To_AST_Value Atom_Int where
  convert_atom_to_AST_Value (Atom_Int x) = Just $ IntV x
  convert_atom_to_AST_Value _ = Nothing

instance (Convertible_To_AST_Value a, Convertible_To_AST_Value b) =>
  Convertible_To_AST_Value (Atom_Tuple a b) where
  convert_atom_to_AST_Value (Atom_Tuple x y) = do
    x_val <- convert_atom_to_AST_Value x
    y_val <- convert_atom_to_AST_Value y
    return $ TupleV x_val y_val
  convert_atom_to_AST_Value _ = Nothing


-- Convert outputs of Seq shallow representation to index in DAG
-- for wiring up deep representation
class Convertible_To_DAG_Data a where
  convert_to_index :: a -> Maybe DAG_Index
  convert_index_to_value :: DAG_Index -> a
  get_AST_type :: Proxy a -> AST_Type

instance Convertible_To_DAG_Data Atom_Unit where
  convert_to_index (Atom_Unit_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = Atom_Unit_Edge idx
  get_AST_type _ = UnitT

instance Convertible_To_DAG_Data Atom_Bit where
  convert_to_index (Atom_Bit_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = Atom_Bit_Edge idx
  get_AST_type _ = BitT

instance Convertible_To_DAG_Data Atom_Int where
  convert_to_index (Atom_Int_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = Atom_Int_Edge idx
  get_AST_type _ = IntT

instance (Convertible_To_DAG_Data a, Convertible_To_DAG_Data b) =>
  Convertible_To_DAG_Data (Atom_Tuple a b) where
  convert_to_index (Atom_Tuple_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = Atom_Tuple_Edge idx
  get_AST_type _ =
    ATupleT (get_AST_type (Proxy :: Proxy a)) (get_AST_type (Proxy :: Proxy b))

instance (KnownNat n, Convertible_To_DAG_Data a) =>
  Convertible_To_DAG_Data (Seq_Tuple n a) where
  convert_to_index (Seq_Tuple_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = Seq_Tuple_Edge idx
  get_AST_type _ = STupleT nVal (get_AST_type (Proxy :: Proxy a))
    where nVal = fromInteger $ natVal (Proxy :: Proxy n)

instance (KnownNat n, KnownNat i, Convertible_To_DAG_Data a) =>
  Convertible_To_DAG_Data (Seq n i a) where
  convert_to_index (Seq_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = Seq_Edge idx
  get_AST_type _ = SeqT nVal iVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
      iVal = fromInteger $ natVal (Proxy :: Proxy i)

instance (KnownNat n, Convertible_To_DAG_Data a) =>
  Convertible_To_DAG_Data (SSeq n a) where
  convert_to_index (SSeq_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = SSeq_Edge idx
  get_AST_type _ = SSeqT nVal (get_AST_type (Proxy :: Proxy a))
    where nVal = fromInteger $ natVal (Proxy :: Proxy n)

instance (KnownNat n, KnownNat v, Convertible_To_DAG_Data a) =>
  Convertible_To_DAG_Data (TSeq n v a) where
  convert_to_index (TSeq_Edge idx) = Just idx
  convert_to_index _ = Nothing
  convert_index_to_value idx = TSeq_Edge idx
  get_AST_type _ = TSeqT nVal vVal (get_AST_type (Proxy :: Proxy a))
    where
      nVal = fromInteger $ natVal (Proxy :: Proxy n)
      vVal = fromInteger $ natVal (Proxy :: Proxy v)

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

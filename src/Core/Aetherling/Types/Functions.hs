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
intSizeInBits :: Int
intSizeInBits = 8
bitSizeInBits :: Int
bitSizeInBits = 1
type family Type_Size (x :: *) :: Nat where
  Type_Size (Atom_Unit) = 0
  Type_Size (Atom_Int) = 8
  Type_Size (Atom_Bit) = 1
  Type_Size (Atom_Tuple a b) = (Type_Size a) + (Type_Size b)

size :: forall a . (KnownNat (Type_Size a)) => Proxy a -> Int
size _ = fromInteger $ natVal $ (Proxy :: Proxy (Type_Size a) )


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
  Check_Type_Is_Atom_Or_Nested (Seq _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested (SSeq _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested (TSeq _ _ a) = Check_Type_Is_Atom_Or_Nested a
  Check_Type_Is_Atom_Or_Nested x =
    TypeError (ShowType x :<>: Text " is not an atom, a Seq containing atoms,"
              :<>: Text " an SSeq containing atoms, or a TSeq containing atoms.")
{-
Below functions are for converting a type representation to a string
for compilation to Magma
-}

-- if true, then input string, if false then output string
directionalString :: Bool -> String
directionalString True = "In"
directionalString False = "Out"
  
intTypeString isInput = "Array(" L.++ show intSizeInBits L.++ ", " L.++
  directionalString isInput L.++ "(Bit))"
bitTypeString isInput = "Array(" L.++ show bitSizeInBits L.++ ", " L.++
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

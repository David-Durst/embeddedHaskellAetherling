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

size :: forall a . (KnownNat (Type_Size a)) => Proxy a -> Int
size _ = fromInteger $ natVal $ (Proxy :: Proxy (Type_Size a) )


{-
Keeps track of original types when doing recursion. Prints out top level types
in error message.
-}
type family Check_Types_Conform (lType :: *) (rType :: *) :: Constraint where
  Check_Types_Conform l l = True ~ True
  Check_Types_Conform l r = Check_Types_Conform_Inner l l r r

type family Check_Types_Conform_Inner (lType :: *) (lTypeOrig :: *)
  (rType :: *) (rTypeOrig :: *) :: Constraint where
  Check_Types_Conform_Inner a _ a _ = True ~ True
  Check_Types_Conform_Inner (Seq n lInner) lOrig (Seq n rInner) rOrig =
    Check_Types_Conform_Inner lInner lOrig rInner rOrig
  Check_Types_Conform_Inner _ lOrig _ rOrig =
    TypeError (Text "The types " :<>: ShowType lOrig :<>: Text " and " :<>:
               Text " do not conform.")

type family Check_Type_Is_Atom (x :: *) :: Constraint where
  Check_Type_Is_Atom Atom_Unit = True ~ True
  Check_Type_Is_Atom (Atom_Int) = True ~ True
  Check_Type_Is_Atom (Atom_Bit) = True ~ True
  Check_Type_Is_Atom x =
    TypeError (ShowType x :<>: Text " is not an atom.")

{-
Below functions are for lifting types onto seqs, sseqs, and tseqs
-}
type family Type_Lifted_To_Seq (n :: Nat) (x :: *) :: * where
  Type_Lifted_To_Seq n (a -> b) = Seq n a -> Type_Lifted_To_Seq n b
  Type_Lifted_To_Seq n a = Seq n a 

type family Type_Lifted_To_SSeq (n :: Nat) (x :: *) :: * where
  Type_Lifted_To_SSeq n (a -> b) = SSeq n a -> Type_Lifted_To_SSeq n b
  Type_Lifted_To_SSeq n a = SSeq n a 

type family Type_Lifted_To_TSeq (n :: Nat) (e :: Nat) (x :: *) :: * where
  Type_Lifted_To_TSeq n e (a -> b) = TSeq n e a -> Type_Lifted_To_TSeq n e b
  Type_Lifted_To_TSeq n e a = TSeq n e a 
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

module DataTypes where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Control.Applicative
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import Data.List.Split
import qualified Data.List as L

{-
class SizeOf a where
  size :: a -> Int
data Atom =
  Int Int
  | Bit Bool
  | CompilerResult String
  deriving (Eq, Show)
-}

data Atom a where
  Unit :: Atom ()
  Int :: Int -> Atom Int
  Bit :: Bool -> Atom Bool
  Tuple :: Atom a -> Atom b -> Atom (Atom a, Atom b)
  -- example of how I'm going to restrict to sseqs of atoms or sseqs
  NTuple :: V.Vector n a -> Atom (V.Vector n (Atom a))

atomInt :: Int -> Atom Int
atomInt x = Int x
atomInt2 = Int 3
instance Eq (Atom a) where
  (Unit) == (Unit) = True
  (Int x) == (Int y) = x == y
  (Bit x) == (Bit y) = x == y
  (Tuple x y) == (Tuple x' y') = (x == x') && (y == y')

instance Show (Atom a) where
  show Unit = show ()
  show (Int x) = show x
  show (Bit x) = show x
  show (Tuple x y) = "(" L.++ show x L.++ ", " L.++ show y L.++ ")"

intSizeInBits :: Int
intSizeInBits = 8
bitSizeInBits :: Int
bitSizeInBits = 1
type family TypeSize (x :: *) :: Nat where
  TypeSize (Atom Int) = 8
  TypeSize (Atom Bool) = 1
  TypeSize (Atom (x, y)) = (TypeSize x) + (TypeSize y)
  TypeSize (Atom (V.Vector n (Atom a))) =  n * (TypeSize (Atom a))
  TypeSize (SSeq n a) = n * (TypeSize a)
 -- TypeSize (TSeq n _ a) = (TypeSize a)
  TypeSize a = 0

size :: forall a . (KnownNat (TypeSize a)) => Proxy a -> Int
size _ = fromInteger $ natVal $ (Proxy :: Proxy (TypeSize a) )

-- first one is string to replace
-- second one is string to replace it with
-- third string is string to operate on
replaceAString :: String -> String -> String -> String
replaceAString toReplace subtitute input = replaced 
  where
    (hdSplit:tlSplit) = splitOn toReplace input
    replaced = L.foldl (\x -> \y -> x L.++ subtitute L.++ y)
      hdSplit tlSplit

typeToMagmaString :: forall (a :: *) (b :: *) . Bool -> (TypeRep, Int) -> String
typeToMagmaString isInput (typeRep, 1) = oneTypeToMagmaString isInput typeRep
typeToMagmaString isInput (typeRep, n) | n > 1 = "Array(" L.++
                                 oneTypeToMagmaString isInput typeRep L.++ ")"
typeToMagmaString _ (_, n) =
  "parallelism for typeToMagmaString must be greater than 0, got" L.++ show n

-- if true, then input string, if false then output string
directionalString :: Bool -> String
directionalString True = "In"
directionalString False = "Out"


intTypeString isInput = "Array(" L.++ show intSizeInBits L.++ ", " L.++
  directionalString isInput L.++ "(Bit))"
bitTypeString isInput = "Array(" L.++ show bitSizeInBits L.++ ", " L.++
  directionalString isInput L.++ "(Bit))"

oneTypeToMagmaString :: forall (a :: *) (b :: *) . Bool -> TypeRep -> String
oneTypeToMagmaString isInput typeRep
  | typeRep == typeOf (Proxy :: Proxy (Atom ())) = ""
  | typeRep == typeOf (Proxy :: Proxy (Atom Int)) = 
    intTypeString isInput
  | typeRep == typeOf (Proxy :: Proxy (Atom Bool)) = 
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
{-
      (hdSplitOnInts:tlSplitOnInts) = splitOn "(Atom Int)" $ proxyRemoved
      intsReplaced = foldl (\x -> \y -> x ++ "Array(8,In(BitIn))" ++ y)
        hdSplitOnInts tlSplitOnInts
      (hdSplitOnBits:tlSplitOnBits) = splitOn "(Atom Bit)" $ proxyRemoved
      bitsReplaced = foldl (\x -> \y -> x ++ "Array(1,In(BitIn))" ++ y)
        hdSplitOnBits tlSplitOnBits
      (hdSplitOnTuples:tlSplitOnTuples) = splitOn "Atom (" $ proxyRemoved
      tuplesReplaced = foldl (\x -> \y -> x ++ "Tuple(" ++ y)
        hdSplitOnTuples tlSplitOnTuples
-}
{-
instance SizeOf Atom where
  size (Int _) = intSizeInBits
  size (Bit _) = bitSizeInBits
  size _ = -1

instance (SizeOf a, KnownNat n, KnownNat m, n ~ (m + 1)) => SizeOf (SSeq n a) where
  size (SSeq s) = V.length s * (size $ V.head s)

instance (SizeOf a, KnownNat n, KnownNat m, n ~ (m + 1)) => SizeOf (TSeq n v a) where
  size (TSeq s) = (size $ V.head s)

-}
newtype Seq n a = Seq {stVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (Seq n) where
  fmap f (Seq vec) = Seq (fmap f vec)

instance (KnownNat n) => Applicative (Seq n) where
  pure a = (Seq ((pure :: a -> Vector n a) a))
  (Seq f) <*> (Seq a) = Seq (f <*> a)

newtype SSeq n a = SSeq {aVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (SSeq n) where
  fmap f (SSeq vec) = SSeq (fmap f vec)

instance (KnownNat n) => Applicative (SSeq n) where
  pure a = (SSeq ((pure :: a -> Vector n a) a))
  (SSeq f) <*> (SSeq a) = SSeq (f <*> a)
  
-- n is number of elements, v is number of clocks of delay
-- v is always 0 for now. Please ignore it for the time being
newtype TSeq n v a = TSeq {seqVec :: Vector n a}
  deriving (Foldable, Traversable, Show)

instance (KnownNat n) => Functor (TSeq n v) where
  fmap f (TSeq vec) = TSeq (fmap f vec)

instance (KnownNat n) => Applicative (TSeq n v) where
  pure a = (TSeq ((pure :: a -> Vector n a) a))
  (TSeq f) <*> (TSeq a) = TSeq (f <*> a)

data ContainerType = SeqType | SSeqType | TSeqType

sSSeq0_2 :: SSeq 2 Int
sSSeq0_2 = SSeq $ fromTuple (2, 2)
sSSeq0_3 :: SSeq 3 Int
sSSeq0_3 = SSeq $ fromTuple (2, 2, 3)
sSSeq0_22 :: SSeq 2 (SSeq 2 Int)
sSSeq0_22 = SSeq $ fromTuple (sSSeq0_2, sSSeq0_2)

sSSeq1_2 :: SSeq 2 Int
sSSeq1_2 = SSeq $ fromTuple (4, 6)
sSSeq1_3 :: SSeq 3 Int
sSSeq1_3 = SSeq $ fromTuple (1, 2, 3)

tSeq0_2 :: TSeq 2 0 (SSeq 2 Int)
tSeq0_2 = TSeq $ fromTuple (sSSeq0_2, sSSeq1_2)
tSeq0_3 :: TSeq 2 0 (SSeq 3 Int)
tSeq0_3 = TSeq $ fromTuple (sSSeq0_3, sSSeq1_3)
tSeq1_3 :: TSeq 3 0 (SSeq 2 Int)
tSeq1_3 = TSeq $ fromTuple (sSSeq1_2, sSSeq1_2, sSSeq1_2)

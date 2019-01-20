module ModulesDecl where 
import Data.Bits
import DataTypes
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import qualified Data.Vector.Sized as V

type family SeqBaseType (x :: *) :: * where
  SeqBaseType (Seq _ a) = SeqBaseType a
  SeqBaseType (TSeq _ _ a) = SeqBaseType a
  SeqBaseType (SSeq _ a) = SeqBaseType a
  SeqBaseType a = a

class Monad m => Circuit m where
  -- unary operators
  absC, notC, noop :: Atom -> m Atom
  -- binary operators
  addC, subC, divC, mulC, minC, maxC, ashrC,
    shlC, andC, orC, xorC, eqC, neqC, ltC, leqC,
    gtC, geqC :: Atom -> m Atom
  -- generators
  lutGenC :: [Atom] -> (Atom) -> m Atom
  constGenC :: Atom -> () -> m Atom
  -- sequence operators
  upC :: (KnownNat n) => Proxy n -> Seq 1 a -> Seq n a
  downC :: (KnownNat n, KnownNat o, n ~ (o+1)) => Proxy n -> (Seq n a) -> (Seq 1 a)
  foldC :: (KnownNat n) => (a -> b -> m a) -> a -> Seq n b -> m a
  partition :: (KnownNat n, KnownNat o, KnownNat p, p ~ (n*o)) => 
    Proxy o -> Seq p a -> Seq n (Seq o a)

  -- higher-order operators
  iterC :: (KnownNat n, SeqBaseType a ~ Atom, SeqBaseType b ~ Atom) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  (***) :: (SeqBaseType a ~ Atom, SeqBaseType b ~ Atom, SeqBaseType c ~ Atom,
            SeqBaseType d ~ Atom, SeqBaseType e ~ Atom, SeqBaseType f ~ Atom) =>
    (a -> m c) -> (b -> m d) -> (e -> m f)

  (>>>) ::  (SeqBaseType a ~ Atom, SeqBaseType b ~ Atom, SeqBaseType c ~ Atom) =>
    (a -> m b) -> (b -> m c) -> (a -> m c)

  -- scheduling operators
  split_seq_to_sseqC :: (KnownNat totalInputLength, KnownNat totalOutputLength,
                         KnownNat outerLength, KnownNat innerInputLength,
                         KnownNat innerOutputLength,
                         totalInputLength ~ (outerLength*innerInputLength),
                         totalOutputLength ~ (outerLength*innerOutputLength)) =>
    Proxy outerLength -> (Seq totalInputLength a -> m (Seq totalOutputLength b)) ->
    Seq outerLength (SSeq innerInputLength a) -> m (Seq outerLength (SSeq innerOutputLength b))

  split_seq_to_tseqC :: (KnownNat totalInputLength, KnownNat totalOutputLength,
                         KnownNat outerLength, KnownNat innerInputLength,
                         KnownNat innerOutputLength,
                         totalInputLength ~ (outerLength*innerInputLength),
                         totalOutputLength ~ (outerLength*innerOutputLength)) =>
    Proxy outerLength -> (Seq totalInputLength a -> m (Seq totalOutputLength b)) ->
    Seq outerLength (TSeq innerInputLength 0 a) -> m (Seq outerLength (TSeq innerOutputLength 0 b))

  sseq_to_seqC :: (SSeq inputLength a -> m (SSeq outputLength b)) ->
    Seq inputLength a -> m (Seq outputLength b)

  tseq_to_seqC :: (TSeq inputLength v a -> m (TSeq outputLength u b)) ->
    Seq inputLength a -> m (Seq outputLength b)

  seq_to_sseqC :: (Seq inputLength a -> m (Seq outputLength b)) ->
    SSeq inputLength a -> m (SSeq outputLength b)

  seq_to_tseqC :: (Seq inputLength a -> m (Seq outputLength b)) ->
    TSeq inputLength v a -> m (TSeq outputLength u b)

  sseq_to_tseqC :: Proxy v -> Proxy u -> (SSeq inputLength a -> m (SSeq outputLength b)) ->
    TSeq inputLength v a -> m (TSeq outputLength u b)

  tseq_to_sseqC :: (TSeq inputLength v a -> m (TSeq outputLength u b)) ->
    SSeq inputLength a -> m (SSeq outputLength b)

  underutilC :: (KnownNat n, KnownNat v, KnownNat o, KnownNat u,
                 KnownNat underutilMult, 1 <= underutilMult) => 
    Proxy underutilMult -> (TSeq n v a -> m (TSeq o u b)) ->
    TSeq n ((n + v) * underutilMult) a -> m (TSeq o ((o + u) * underutilMult) b)


{-
-- unary modules
absInt :: Module Int Int
absInt = abs

notBit :: Module Bit Bit
notBit = not

noopAtom :: (Atom a) => Module a a
noopAtom = id

-- binary modules
addInt :: Module (Int, Int) Int
addInt = uncurry (+) 

subInt :: Module (Int, Int) Int
subInt = uncurry (-)

divInt :: Module (Int, Int) Int
divInt = uncurry (-)

mulInt :: Module (Int, Int) Int
mulInt = uncurry (*)

minInt :: Module (Int, Int) Int
minInt = uncurry min

maxInt :: Module (Int, Int) Int
maxInt = uncurry max

ashrInt :: Int -> Module Int Int
ashrInt amount input = shiftR input amount

shlInt :: Int -> Module Int Int
shlInt amount input = shiftL input amount

andBit :: Module (Bit, Bit) Bit
andBit = uncurry (&&)

orBit :: Module (Bit, Bit) Bit
orBit = uncurry (||)

xOrBit :: Module (Bit, Bit) Bit
xOrBit (b0, b1) = (b0 /= b1) && (b0 || b1)

eqAtom :: (Atom a) => Module (a, a) Bit
eqAtom = uncurry (==)

neqAtom :: (Atom a) => Module (a, a) Bit
neqAtom = uncurry (/=)

ltInt :: Module (Int, Int) Bit
ltInt = uncurry (<)
  
leqInt :: Module (Int, Int) Bit
leqInt = uncurry (<=)

gtInt :: Module (Int, Int) Bit
gtInt = uncurry (>)

geqInt :: Module (Int, Int) Bit
geqInt = uncurry (>=)

-- module generators
lutAtomGen :: [a] -> Module Int a
lutAtomGen as = \i -> as !! i

constAtomGen :: (Atom a) => a -> Module () a
constAtomGen a = \_ -> a

-- multi-rate modules
up :: (KnownNat n) => Proxy n -> Module (STIOC 1 a) (STIOC n a)
up _ = \(STIOC vec) -> STIOC $ V.replicate $ V.head vec

down :: (KnownNat n, KnownNat m, n ~ (m+1)) => Proxy n -> Module (STIOC n a) (STIOC 1 a)
down _ = \(STIOC vec) -> STIOC $ V.singleton $ V.head vec

-}

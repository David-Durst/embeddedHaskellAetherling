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
  SeqBaseType ((a, _)) = SeqBaseType a
  SeqBaseType a = a

class Monad m => Circuit m where
  -- unary operators
  absC, notC, noop :: Atom -> m Atom
  -- binary operators
  addC, subC, divC, mulC, minC, maxC, ashrC,
    shlC, andC, orC, xorC, eqC, neqC, ltC, leqC,
    gtC, geqC :: (Atom, Atom) -> m Atom
  -- generators
  lutGenC :: [Atom] -> (Atom) -> m Atom
  constGenC :: Atom -> Atom -> m Atom
  -- sequence operators
  upC :: (KnownNat n, SizeOf a) => Proxy n -> Seq 1 a -> m (Seq n a)
  downC :: (KnownNat n, KnownNat o, n ~ (o+1), SizeOf a) => Proxy n -> (Seq n a) -> m (Seq 1 a)
  foldC :: (KnownNat n) => (a -> b -> m a) -> a -> Seq n b -> m a
  partition :: (KnownNat n, KnownNat o, KnownNat p, p ~ (n*o)) => 
    Proxy o -> Seq p a -> Seq n (Seq o a)

  -- higher-order operators
  iterC :: (KnownNat n, SeqBaseType a ~ Atom, SeqBaseType b ~ Atom) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  (***) :: (SeqBaseType a ~ Atom, SeqBaseType b ~ Atom, SeqBaseType c ~ Atom,
            SeqBaseType d ~ Atom) =>
    (a -> m c) -> (b -> m d) -> ((a,b) -> m (c, d))

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

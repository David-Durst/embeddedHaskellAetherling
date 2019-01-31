module ModulesDecl where 
import Data.Bits
import DataTypes
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import GHC.Exts (Constraint)
import LineBuffer
import qualified Data.Vector.Sized as V

-- this is hack to give better error messages
-- when the AtomBaseType check fails
newtype A_Type_Containing_Atoms = A_Type_Containing_Atoms Int

type family AtomBaseType (x :: *) :: Constraint where
  AtomBaseType (Atom a) = Atom a ~ Atom a
  AtomBaseType (TSeq _ _ a) = AtomBaseType a
  AtomBaseType (SSeq _ a) = AtomBaseType a
  AtomBaseType ((a, _)) = AtomBaseType a
  AtomBaseType a = a ~ A_Type_Containing_Atoms

-- this constraint also bans sequences or atoms
newtype Atom_Or_Tuple_Of_Atom = Atom_Or_Tuple_Of_Atom Int

type family AtomType (x :: *) :: Constraint where
  AtomType (Atom a) = Atom a ~ Atom a
  AtomType ((a, _)) = AtomType a
  AtomType a = a ~ Atom_Or_Tuple_Of_Atom
{-
type family LineBufferOutputSeq (parallelism :: Nat)
  (windowYSize :: KnownNat) (windowXSize :: Nat)
-}
newtype Not_Same_Nesting_As a = Not_Same_Nesting Int
-- this verifies that a nested set of sequences (any parallelism)
-- have the same amount of nested and same length at each layer
type family SameSeqNesting (lType :: *) (rType :: *) :: Constraint where
  SameSeqNesting (Seq n a) (Seq n b) = SameSeqNesting a b
  SameSeqNesting (Seq n a) b = (Seq n a) ~ Not_Same_Nesting_As b
  SameSeqNesting (SSeq n a) (SSeq n b) = SameSeqNesting a b
  SameSeqNesting (SSeq n a) b = (SSeq n a) ~ Not_Same_Nesting_As b
  SameSeqNesting (TSeq n v a) (TSeq n v b) = SameSeqNesting a b
  SameSeqNesting (TSeq n v a) b = (TSeq n v a) ~ Not_Same_Nesting_As b
  SameSeqNesting a b = True ~ True

type family ZipSeqTypes (lType :: *) (rType :: *) :: * where
  ZipSeqTypes (Seq n a) (Seq n b) = Seq n (ZipSeqTypes a b)
  ZipSeqTypes (SSeq n a) (SSeq n b) = SSeq n (ZipSeqTypes a b)
  ZipSeqTypes (TSeq n v a) (TSeq n v b) = TSeq n v (ZipSeqTypes a b)
  ZipSeqTypes a b = Atom (a, b)
  
class Monad m => Circuit m where
  -- unary operators
  absC :: Atom Int -> m (Atom Int)
  notC :: Atom Bool -> m (Atom Bool)
  noop :: (KnownNat (TypeSize a)) => Atom a -> m (Atom a)
  -- binary operators
  addC, subC, divC, mulC, minC, maxC, ashrC,
    shlC :: Atom (Atom Int, Atom Int) -> m (Atom Int)
  eqIntC, neqIntC, ltIntC, leqIntC,
    gtIntC, geqIntC :: Atom (Atom Int, Atom Int) -> m (Atom Bool)
  andC, orC, xorC, eqBitC, neqBitC, ltBitC, leqBitC,
    gtBitC, geqBitC :: Atom (Atom Bool, Atom Bool) -> m (Atom Bool)
  -- generators
  lutGenIntC :: [Atom Int] -> (Atom Int) -> m (Atom Int)
  lutGenBitC :: [Atom Bool] -> (Atom Int) -> m (Atom Bool)
  constGenIntC :: Atom Int -> Atom () -> m (Atom Int)
  constGenBitC :: Atom Bool -> Atom () -> m (Atom Bool)
  -- sequence operators
  upC :: (KnownNat n, KnownNat (TypeSize a), Typeable (Proxy a)) => Proxy n -> Seq 1 a -> m (Seq n a)
  downC :: (KnownNat n, KnownNat o, n ~ (o+1), KnownNat (TypeSize a), Typeable (Proxy a)) =>
    Proxy n -> (Seq n a) -> m (Seq 1 a)
  -- maybe in future allow them to be different types (accum and seq elements)
  -- take seqences of length p, break them up into sequences of length o and
  -- fold over each subsequence of length o
  foldC :: (KnownNat n, KnownNat o, KnownNat p, p ~ (n*o),
            (KnownNat (TypeSize a))) =>
           Proxy o -> (Atom (Atom a, Atom a) -> m (Atom a)) -> Atom a ->
           Seq p (Atom a) -> m (Seq n (Atom a))
  partitionC :: (KnownNat n, KnownNat o, KnownNat p, p ~ (n*o)) => 
    Proxy o -> Seq p a -> m (Seq n (Seq o a))

  -- if i make the inside of linebuffer sseq, and wrap that with a seq, then
  -- everything else has to match it with parallelism that can't be down scheduled
  -- without underutilizing.
  -- need a way to zip this output with constants generated. Probably do this
  -- by making *** either zip or join
  -- need to convert *** to a tuple with a type family to lower the zip
  -- to a seq of zipped atoms
  lineBuffer :: (KnownNat windowYSize, KnownNat windowXSize,
                 KnownNat imageYSize, KnownNat imageXSize,
                 KnownNat strideY, KnownNat strideX, KnownNat originY,
                 KnownNat originX, Typeable a) =>
    Proxy windowYSize -> Proxy windowXSize ->
    Proxy imageYSize -> Proxy imageXSize ->
    Proxy strideY -> Proxy strideX -> Proxy originY -> Proxy originX ->
    -- need strideY*strideX here as, if running at least 1 pixel
    -- out per clock, need at least these many pixels in per clock
    -- can get rid of this once I have underutilize working
    Seq (strideY * strideX) (Atom a) ->
    m (Seq 1 (SSeq windowYSize (SSeq windowXSize (Atom a))))

  -- higher-order operators
  iterC :: (KnownNat n, AtomBaseType a, AtomBaseType b) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  (***) :: (AtomBaseType a, AtomBaseType b, AtomBaseType c,
            AtomBaseType d) =>
    (a -> m c) -> (b -> m d) -> ((a,b) -> m (c, d))

  (>***<) :: (AtomBaseType a, AtomBaseType b, AtomBaseType c,
              AtomBaseType d, SameSeqNesting c d) =>
    (a -> m c) -> (b -> m d) -> ((a,b) -> m (ZipSeqTypes c d))

  (>>>) ::  (AtomBaseType a, AtomBaseType b, AtomBaseType c) =>
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

  sseq_to_seqC :: (KnownNat inputLength, KnownNat outputLength) =>
    (SSeq inputLength a -> m (SSeq outputLength b)) ->
    Seq inputLength a -> m (Seq outputLength b)

  tseq_to_seqC :: (TSeq inputLength v a -> m (TSeq outputLength u b)) ->
    Seq inputLength a -> m (Seq outputLength b)

  seq_to_sseqC :: (KnownNat inputLength, KnownNat outputLength) =>
    (Seq inputLength a -> m (Seq outputLength b)) ->
    SSeq inputLength a -> m (SSeq outputLength b)

  seq_to_tseqC :: (Seq inputLength a -> m (Seq outputLength b)) ->
    TSeq inputLength 0 a -> m (TSeq outputLength 0 b)

  sseq_to_tseqC :: (KnownNat inputLength, KnownNat outputLength) =>
    (SSeq inputLength a -> m (SSeq outputLength b)) ->
    TSeq inputLength 0 a -> m (TSeq outputLength 0 b)

  tseq_to_sseqC :: (KnownNat inputLength, KnownNat outputLength) =>
    (TSeq inputLength v a -> m (TSeq outputLength u b)) ->
    SSeq inputLength a -> m (SSeq outputLength b)

  underutilC :: (KnownNat n, KnownNat v, KnownNat o, KnownNat u,
                 KnownNat underutilMult, 1 <= underutilMult) => 
    Proxy underutilMult -> (TSeq n v a -> m (TSeq o u b)) ->
    TSeq n ((n + v) * underutilMult) a -> m (TSeq o ((o + u) * underutilMult) b)

  mergeSSeqs :: (KnownNat n, KnownNat o) => (SSeq n (SSeq o a)) -> m (SSeq (n*o) a)

-- these are the types of the nodes in a DAG
data NodeType =
  AbsT
  | NotT
  | NoopT
  | AddT
  | SubT
  | DivT
  | MulT
  | MinT
  | MaxT
  | AshrT
  | ShlT 
  | EqIntT
  | NeqIntT
  | LtIntT
  | LeqIntT
  | GtIntT
  | GeqIntT 
  | AndT
  | OrT
  | XorT
  | EqBitT
  | NeqBitT
  | LtBitT
  | LeqBitT
  | GtBitT
  | GeqBitT 
  | LutGenIntT [Atom Int]
  | LutGenBitT [Atom Bool]
  | ConstGenIntT (Atom Int)
  | ConstGenBitT (Atom Bool)
  | forall a . (Typeable (Proxy a)) => UpT (Proxy a) Int
  | forall a . (Typeable (Proxy a)) => DownT (Proxy a) Int
  -- nodet is the operation inside the fold
  -- at this point only single operations are supports
  -- int is total sequence length
  | forall a . FoldT NodeType Int
  | ForkJoinT
  | LineBufferT LineBufferData
  --deriving (Show, Eq)

instance Show NodeType where
  show AbsT = "AbsT"
  show NotT = "NotT"
  show NoopT = "NoopT"
  show AddT = "AddT"
  show SubT = "SubT"
  show DivT = "DivT"
  show MulT = "MulT"
  show MinT = "MinT"
  show MaxT = "MaxT"
  show AshrT = "AshrT"
  show ShlT = "ShlT" 
  show EqIntT = "EqIntT"
  show NeqIntT = "NeqIntT"
  show LtIntT = "LtIntT"
  show LeqIntT = "LeqIntT"
  show GtIntT = "GtIntT"
  show GeqIntT = "GeqIntT" 
  show AndT = "AndT"
  show OrT = "OrT"
  show XorT = "XorT"
  show EqBitT = "EqBitT"
  show NeqBitT = "NeqBitT"
  show LtBitT = "LtBitT"
  show LeqBitT = "LeqBitT"
  show GtBitT = "GtBitT"
  show GeqBitT = "GeqBitT" 
  show (LutGenIntT as) = "LutGenIntT " ++ show as
  show (LutGenBitT as) = "LutGenBitT " ++ show as
  show (ConstGenIntT a) = "ConstGenIntT " ++ show a
  show (ConstGenBitT a) = "ConstGenBitT " ++ show a
  show (UpT proxy n) = "UpT " ++ show proxy ++ " " ++ show n
  show (DownT proxy n) = "DownT " ++ show proxy ++ " " ++ show n
  show (FoldT nt totalLen) = "FoldT " ++ show nt ++ " " ++
    show totalLen
  show ForkJoinT = "ForkJoinT"
  show (LineBufferT lbData) = "LineBufferT " ++ show lbData

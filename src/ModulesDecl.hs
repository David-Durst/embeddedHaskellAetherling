module ModulesDecl where 
import Data.Bits
import DataTypes
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import GHC.Exts (Constraint)
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

class Monad m => Circuit m where
  -- unary operators
  absC :: Atom Int -> m (Atom Int)
  notC :: Atom Bool -> m (Atom Bool)
  noop :: (KnownNat (TypeSize a)) => Atom a -> m (Atom a)
  -- binary operators
  addC, subC, divC, mulC, minC, maxC, ashrC,
    shlC :: (Atom Int, Atom Int) -> m (Atom Int)
  eqIntC, neqIntC, ltIntC, leqIntC,
    gtIntC, geqIntC :: (Atom Int, Atom Int) -> m (Atom Bool)
  andC, orC, xorC, eqBitC, neqBitC, ltBitC, leqBitC,
    gtBitC, geqBitC :: (Atom Bool, Atom Bool) -> m (Atom Bool)
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

  -- higher-order operators
  iterC :: (KnownNat n, AtomBaseType a, AtomBaseType b) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  (***) :: (AtomBaseType a, AtomBaseType b, AtomBaseType c,
            AtomBaseType d) =>
    (a -> m c) -> (b -> m d) -> ((a,b) -> m (c, d))

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

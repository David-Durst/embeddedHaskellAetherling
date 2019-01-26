module DAGComputer where 
import Data.Bits
import DataTypes
import Data.Proxy
import Data.Maybe
import GHC.TypeLits
import GHC.TypeLits.Extra
import ModulesDecl
import Data.List.Split
import Data.Types.Injective
import Data.Types.Isomorphic
import Isomorphism
import Control.Monad.State
import Data.Typeable
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V

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
  | forall a . ConstGenT (Atom a)
  | forall a . UpT (Proxy a) Int
  | forall a . DownT (Proxy a) Int
  | forall a . FoldT (Proxy a) 
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
  show (ConstGenT a) = "ConstGenT " ++ show a
  show (UpT proxy n) = "UpT " ++ show proxy ++ " " ++ show n
  show (DownT proxy n) = "DownT " ++ show proxy ++ " " ++ show n
  show (FoldT proxy) = "FoldT " ++ show proxy
  show ForkJoinT = "ForkJoinT"

-- This is all the info about a dag necessary to compile it to Magma
-- and measure it's resources
data NodeInfo = NodeInfo {
  nodeType :: NodeType,
  nodeThroughputNumerator :: Int,
  nodeThroughputDenominator :: Int,
  childNodes :: ([NodeInfo],[NodeInfo])
  }
  deriving Show

multiplyNodeThroughput :: Int -> NodeInfo -> NodeInfo
multiplyNodeThroughput n (NodeInfo nt@(FoldT _) numerator denominator children) =
  NodeInfo nt (numerator * n) denominator children
multiplyNodeThroughput n (NodeInfo nt numerator denominator children) =
  NodeInfo nt (numerator * n) denominator
  (fmap (multiplyNodeThroughput n) $ fst children,
   fmap (multiplyNodeThroughput n) $ snd children)

divideNodeThroughput :: Int -> NodeInfo -> NodeInfo
divideNodeThroughput n (NodeInfo nt@(FoldT _) numerator denominator children) =
  NodeInfo nt numerator (denominator * n) children
divideNodeThroughput n (NodeInfo nt numerator denominator children) =
  NodeInfo nt numerator (denominator * n) 
  (fmap (divideNodeThroughput n) $ fst children,
   fmap (divideNodeThroughput n) $ snd children)

data PipelineDAG = PipelineDAG [NodeInfo] deriving Show

{-
instance Show PipelineDAG where
  show (PipelineDAG map) = show map 
-}

emptyDAG :: PipelineDAG
emptyDAG = PipelineDAG []


buildDAG :: (a -> State PipelineDAG b) -> PipelineDAG 
buildDAG functionYieldingMonad = snd $
  runState (functionYieldingMonad undefined) emptyDAG

appendToPipeline :: NodeInfo -> State PipelineDAG a
appendToPipeline newStage = do  
    PipelineDAG stages <- get 
    put $ PipelineDAG (stages ++ [newStage])
    return undefined

getInnerPipeline :: (a -> State PipelineDAG b) -> PipelineDAG -> [NodeInfo]
getInnerPipeline f startingDAG = innerStages
  where
    -- this walks the monads for the inner collection of stages to build of a single
    -- function that combines all the stages together
    -- can pass undefined as the value as all the stages don't actually look
    -- at the value
    startingDAGToPipelineDAG = runState $ f undefined
    -- this passes in an emptyDAG for start and collects the final state,
    -- the state with all stages
    (_, PipelineDAG innerStages) = startingDAGToPipelineDAG startingDAG

-- This is for combinators that do nothing and so just append the dag
-- that they contain to the one surrounding them
appendInnerDAGToOuterDAG :: (a -> State PipelineDAG b) -> State PipelineDAG c
appendInnerDAGToOuterDAG f = do
    PipelineDAG stages <- get 
    put $ PipelineDAG (stages ++ getInnerPipeline f emptyDAG)
    return undefined

instance Circuit (State PipelineDAG) where
  -- unary operators
  absC _ = appendToPipeline (NodeInfo AbsT 1 1 ([],[]))
  notC _ = appendToPipeline (NodeInfo NotT 1 1 ([],[]))
  noop c = appendToPipeline  (NodeInfo NoopT 1 1 ([],[]))

  -- binary operators
  -- the values returned here, they are only to emit things of the right types
  -- so the state computations can occur
  addC _ = appendToPipeline (NodeInfo AddT 2 1 ([],[]))
  subC _ = appendToPipeline (NodeInfo SubT 2 1 ([],[]))
  mulC _ = appendToPipeline (NodeInfo MulT 2 1 ([],[]))
  divC _ = appendToPipeline (NodeInfo DivT 2 1 ([],[]))
  minC _ = appendToPipeline (NodeInfo MinT 2 1 ([],[]))
  maxC _ = appendToPipeline (NodeInfo MaxT 2 1 ([],[]))
  ashrC _ = appendToPipeline (NodeInfo AshrT 2 1 ([],[]))
  shlC _ = appendToPipeline (NodeInfo ShlT 2 1 ([],[]))
  andC _ = appendToPipeline (NodeInfo AndT 2 1 ([],[]))
  orC _ = appendToPipeline (NodeInfo OrT 2 1 ([],[]))
  xorC _ = appendToPipeline (NodeInfo XorT 2 1 ([],[]))
  eqIntC _ = appendToPipeline (NodeInfo EqIntT 2 1 ([],[]))
  eqBitC _ = appendToPipeline (NodeInfo EqBitT 2 1 ([],[]))
  neqIntC _ = appendToPipeline (NodeInfo NeqIntT 2 1 ([],[]))
  neqBitC _ = appendToPipeline (NodeInfo NeqBitT 2 1 ([],[]))
  ltIntC _ = appendToPipeline (NodeInfo LtIntT 1 1 ([],[]))
  ltBitC _ = appendToPipeline (NodeInfo LtBitT 2 1 ([],[]))
  leqIntC _ = appendToPipeline (NodeInfo LeqIntT 2 1 ([],[]))
  leqBitC _ = appendToPipeline (NodeInfo LeqBitT 2 1 ([],[]))
  gtIntC _ = appendToPipeline (NodeInfo GtIntT 2 1 ([],[]))
  gtBitC _ = appendToPipeline (NodeInfo GtBitT 2 1 ([],[]))
  geqIntC _ = appendToPipeline (NodeInfo GeqIntT 2 1 ([],[]))
  geqBitC _ = appendToPipeline (NodeInfo GeqBitT 2 1 ([],[]))

  -- module generator
  lutGenIntC as _ = appendToPipeline (NodeInfo (LutGenIntT as) 1 1 ([],[]))
  lutGenBitC as _ = appendToPipeline (NodeInfo (LutGenBitT as) 1 1 ([],[]))

  constGenC x _ = appendToPipeline (NodeInfo (ConstGenT x) 1 1 ([],[]))
  -- sequence operators
  -- need to fix upC to account for storage if tseq
  upC :: forall a n. (KnownNat n, KnownNat (TypeSize a)) =>
    Proxy n -> Seq 1 a -> State PipelineDAG (Seq n a)
  upC amountProxy _ = appendToPipeline (NodeInfo (UpT (Proxy :: Proxy a)
                                                      (fromInteger $ natVal amountProxy))
                                                 1 1 ([],[]))
  downC :: forall a n o . (KnownNat n, KnownNat o, n ~ (o+1), KnownNat (TypeSize a)) =>
    Proxy n -> (Seq n a) -> State PipelineDAG (Seq 1 a)
  downC amountProxy _ = appendToPipeline (NodeInfo (DownT (Proxy :: Proxy a)
                                                      (fromInteger $ natVal amountProxy))
                                                   1 1 ([],[]))

  foldC :: forall n o p a . (KnownNat n, KnownNat o, KnownNat p, p ~ (n*o),
            (KnownNat (TypeSize a))) =>
           Proxy o -> (Atom (Atom a, Atom a) -> State PipelineDAG (Atom a)) -> Atom a ->
           Seq p (Atom a) -> State PipelineDAG (Seq n (Atom a))
  foldC sublistLength f _ _ = do
    appendToPipeline (NodeInfo (FoldT (Proxy :: Proxy a)) 1 1 (getInnerPipeline f emptyDAG, []))

  -- higher-order operators

  -- ignore the iter since it does nothing, needs to be wrapped with a tseq or
  -- sseq converting function
  iterC _ f _ = appendInnerDAGToOuterDAG f 

  (f *** g) _ = do
    appendToPipeline (NodeInfo ForkJoinT 1 1
                      (getInnerPipeline g emptyDAG, getInnerPipeline f emptyDAG))

  (f >>> g) x = do
    PipelineDAG stages <- get 
    let fAndgPipelineStages = getInnerPipeline g $ PipelineDAG $ getInnerPipeline f emptyDAG
    put $ PipelineDAG (stages ++ fAndgPipelineStages)
    return undefined

  -- scheduling operators
  split_seq_to_sseqC :: forall totalInputLength totalOutputLength outerLength
                        innerInputLength innerOutputLength a b .
                        (KnownNat totalInputLength, KnownNat totalOutputLength,
                         KnownNat outerLength, KnownNat innerInputLength,
                         KnownNat innerOutputLength,
                         totalInputLength ~ (outerLength*innerInputLength),
                         totalOutputLength ~ (outerLength*innerOutputLength)) =>
                        Proxy outerLength ->
    (Seq totalInputLength a -> State PipelineDAG (Seq totalOutputLength b)) ->
    (Seq outerLength (SSeq innerInputLength a) ->
      State PipelineDAG (Seq outerLength (SSeq innerOutputLength b)))
  split_seq_to_sseqC _ f _ = do
    PipelineDAG stages <- get 
    let innerLengthProxy = Proxy :: Proxy innerOutputLength
    let innerLength = (fromInteger $ natVal innerLengthProxy)
    put $ PipelineDAG (fmap (multiplyNodeThroughput innerLength) stages)
    return undefined
    
  -- ignore the tseq since it does nothing, its the same as an iter, just chewing
  -- up iterations that don't need to be parallelized
  split_seq_to_tseqC _ f _ = appendInnerDAGToOuterDAG f

  -- since getting rid of sseq, undo parallelism
  sseq_to_seqC :: forall a b inputLength outputLength .
                  (KnownNat inputLength, KnownNat outputLength) =>
                  (SSeq inputLength a -> State PipelineDAG (SSeq outputLength b)) ->
                  Seq inputLength a -> State PipelineDAG (Seq outputLength b)
  sseq_to_seqC f _ = do 
    PipelineDAG stages <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ PipelineDAG (fmap (divideNodeThroughput inputLength) stages)
    return undefined

  -- ignore the seq since it does nothing and tseq did nothing as well 
  tseq_to_seqC f _ = appendInnerDAGToOuterDAG f

  seq_to_sseqC :: forall inputLength outputLength a b .
                  (KnownNat inputLength, KnownNat outputLength) =>
                  (Seq inputLength a -> State PipelineDAG (Seq outputLength b)) ->
                  SSeq inputLength a -> State PipelineDAG (SSeq outputLength b)
  seq_to_sseqC f _ = do
    PipelineDAG stages <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ PipelineDAG (fmap (multiplyNodeThroughput inputLength) stages)
    return undefined

  seq_to_tseqC f _ = appendInnerDAGToOuterDAG f

  -- this is almost same as sseq_to_seq as tseq and seq both don't change parallelism
  sseq_to_tseqC :: forall inputLength outputLength a b u v .
                   (KnownNat inputLength, KnownNat outputLength) =>
    Proxy v -> Proxy u -> (SSeq inputLength a -> State PipelineDAG (SSeq outputLength b)) ->
    TSeq inputLength v a -> State PipelineDAG (TSeq outputLength u b)
  sseq_to_tseqC _ _ f _ = do
    PipelineDAG stages <- get
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ PipelineDAG (fmap (divideNodeThroughput inputLength) stages)
    return undefined

  -- this is almost same as seq_to_sseq as tseq and seq both don't change parallelism
  tseq_to_sseqC :: forall inputLength outputLength a b u v .
                   (KnownNat inputLength, KnownNat outputLength) =>
    (TSeq inputLength v a -> State PipelineDAG (TSeq outputLength u b)) ->
    SSeq inputLength a -> State PipelineDAG (SSeq outputLength b)
  tseq_to_sseqC f _ = do 
    PipelineDAG stages <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ PipelineDAG (fmap (divideNodeThroughput inputLength) stages)
    return undefined

  underutilC :: forall n v o u a b underutilMult .
                (KnownNat n, KnownNat v, KnownNat o, KnownNat u,
                 KnownNat underutilMult, 1 <= underutilMult) => 
    Proxy underutilMult -> (TSeq n v a -> State PipelineDAG (TSeq o u b)) ->
    TSeq n ((n + v) * underutilMult) a -> State PipelineDAG (TSeq o ((o + u) * underutilMult) b)
  underutilC underutilProxy f _ = do 
    PipelineDAG stages <- get 
    let underutilAmount = (fromInteger $ natVal underutilProxy)
    put $ PipelineDAG (fmap (divideNodeThroughput underutilAmount) stages)
    return undefined
-- examples of programs in space and time
-- iterInput = Seq $ V.fromTuple ((Int 1, Int 2), (Int 3, Int 4), (Int 5, Int 6), (Int 7, Int 8))
-- replace unscheduledCirc with this one to see a composition
unscheduledPipeline = iterC (Proxy @4) $ (constGenC (Int 3) *** constGenC (Int 2)) >>> addC
unscheduledNode = iterC (Proxy @4) $ addC

unscheduledPipelineDAG = buildDAG unscheduledPipeline
unscheduledNodeDAG = buildDAG unscheduledNode 

sequentialPipelineDAG = buildDAG $ seq_to_tseqC unscheduledPipeline 
sequentialNodeDAG = buildDAG $ seq_to_tseqC unscheduledNode

parallelPipelineDAG = buildDAG $ seq_to_sseqC unscheduledPipeline 
parallelNodeDAG = buildDAG $ seq_to_sseqC unscheduledNode

partialParallelPipelineDAG = buildDAG $ seq_to_tseqC $ split_seq_to_sseqC (Proxy @2)
  unscheduledPipeline 
partialParallelNodeDAG = buildDAG $ seq_to_tseqC $ split_seq_to_sseqC (Proxy @2)
  unscheduledNode
{-
parallelResult = simulate $ seq_to_sseqC unscheduledCirc $ to iterInput
partialParallelInput :: TSeq 2 0 (SSeq 2 (Atom, Atom))
partialParallelInput = seqToTSeq $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq (Proxy @2) iterInput
partialParallelResult =
  simulate $
  (seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledCirc) $
  partialParallelInput
-}

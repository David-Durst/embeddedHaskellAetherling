module ResourceEstimator where 
import Data.Bits
import DataTypes
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import ModulesDecl
import Data.List.Split
import Data.Types.Injective
import Data.Types.Isomorphic
import Isomorphism
import Control.Monad.State
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
  | forall a . ConstGenT  (Atom a)
  | UpT Int
  | DownT Int
  | forall a . FoldT a NodeType
  | PartitionT Int
  --deriving (Show, Eq)

-- This is all the info about a dag necessary to compile it to Magma
-- and measure it's resources
data NodeInfo = NodeInfo {nodeThroughputNumerator :: Int,
                         nodeThroughputDenominator :: Int, consumerNodes :: [NodeInfo]}
  deriving (Eq, Show)

data PipelineDAG = PipelineDAG (Map.Map NodeType NodeInfo)

{-
instance Show PipelineDAG where
  show (PipelineDAG map) = show map 
-}

emptyDAG :: PipelineDAG
emptyDAG = PipelineDAG Map.empty 

data ResourceEstimate = ResourceEstimate {numWires :: Int, numALUs :: Int}
  deriving (Show, Eq)
{-
data REContainer a = REContainer ResourceEstimate a

instance Monad REContainer where
  return a = REContainer (ResourceEstimate 0 0) a
  (REContainer (ResourceEstimate oldWires oldALUs) a) >>= f = do
    let REContainer (ResourceEstimate wires alus) newValue = f a
    REContainer (ResourceEstimate (oldWires + wires) (oldALUs + alus)) newValue

instance MonadPlus REContainer where
  mzero = 

instance Applicative REContainer where
  pure = return
  (<*>) = ap

instance Functor REContainer where
  fmap = liftM
-}
estimateResources :: a -> (a -> State ResourceEstimate b) -> ResourceEstimate
estimateResources input functionYieldingMonad = snd $
  runState (functionYieldingMonad input) $ ResourceEstimate 0 0

buildDag :: (a -> State PipelineDAG b) -> PipelineDAG 
buildDag functionYieldingMonad = snd $
  runState (functionYieldingMonad undefined) emptyDAG
{-
instance Functor ResourceEstimatorEnv where
  fmap f (ResourceEstimatorEnv a) = ResourceEstimatorEnv (f a)
  
instance Applicative ResourceEstimatorEnv where
  pure a = ResourceEstimatorEnv a
  ResourceEstimatorEnv f <*> ResourceEstimatorEnv a = ResourceEstimatorEnv $ f a

instance Monad ResourceEstimatorEnv where
  (ResourceEstimatorEnv a) >>= f = f a
  return a = ResourceEstimatorEnv a

sizeOfElement :: Atom -> Int
sizeOfElement (Int _) = intSizeInBits
sizeOfElement (Bit _) = bitSizeInBits
sizeOfElement _ = -1
-}
incrementResourcesBy :: Int -> Int -> a -> State ResourceEstimate a
incrementResourcesBy newWireSize newALUSize a = do  
    (ResourceEstimate oldWires oldALUs) <- get 
    put $ ResourceEstimate (oldWires + newWireSize) (oldALUs + newALUSize)
    return a

instance Circuit (State ResourceEstimate) where
  -- unary operators
  absC _ = incrementResourcesBy intSizeInBits intSizeInBits (Int 2)
  notC _ = incrementResourcesBy bitSizeInBits bitSizeInBits undefined
  noop :: forall a . (KnownNat (TypeSize a)) => Atom a -> State ResourceEstimate (Atom a)
  noop c = incrementResourcesBy (size (Proxy :: Proxy a)) (size (Proxy :: Proxy a)) c

  -- binary operators
  -- the values returned here, they are only to emit things of the right types
  -- so the state computations can occur
  addC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  subC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  mulC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  divC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  minC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  maxC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  ashrC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  shlC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  andC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  orC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  xorC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  eqIntC (Int x, Int y) = incrementResourcesBy (2*intSizeInBits) bitSizeInBits (Bit True)
  eqBitC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  neqIntC (Int x, Int y) = incrementResourcesBy (2*intSizeInBits) bitSizeInBits (Bit True)
  neqBitC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  ltIntC (Int x, Int y) = incrementResourcesBy (2*intSizeInBits) bitSizeInBits (Bit True)
  ltBitC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  leqIntC (Int x, Int y) = incrementResourcesBy (2*intSizeInBits) bitSizeInBits (Bit True)
  leqBitC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  gtIntC (Int x, Int y) = incrementResourcesBy (2*intSizeInBits) bitSizeInBits (Bit True)
  gtBitC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  geqIntC (Int x, Int y) = incrementResourcesBy (2*intSizeInBits) bitSizeInBits (Bit True)
  geqBitC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)

  -- module generator
  lutGenIntC as _ = incrementResourcesBy (length as * intSizeInBits) intSizeInBits (head as)
  lutGenBitC as _ = incrementResourcesBy (length as * bitSizeInBits) bitSizeInBits (head as)

  constGenC x _ = incrementResourcesBy intSizeInBits intSizeInBits x

  -- sequence operators
  -- need to fix upC to account for storage if tseq
  upC :: forall a n. (KnownNat n, KnownNat (TypeSize a)) =>
    Proxy n -> Seq 1 a -> State ResourceEstimate (Seq n a)
  upC _ (Seq vec) = incrementResourcesBy 0 (size (Proxy :: Proxy a)) undefined
  downC :: forall a n o . (KnownNat n, KnownNat o, n ~ (o+1), KnownNat (TypeSize a)) =>
    Proxy n -> (Seq n a) -> State ResourceEstimate (Seq 1 a)
  downC _ (Seq vec) = incrementResourcesBy 0 (size (Proxy :: Proxy a)) undefined

  foldC sublistLength f _ _ = do
    (ResourceEstimate innerWires innerALU) <- get (f undefined undefined)
    -- need to fix this estimate 
    put $ ResourceEstimate (innerWires * (fromInteger $ natVal sublistLength))
      (innerALU * (fromInteger $ natVal sublistLength))
    return undefined

  -- higher-order operators
  iterC _ f (Seq inputVec) = do
    resultVec <- V.mapM f inputVec
    return $ Seq resultVec

  (f *** g) (inTypeA, inTypeB) = do
    outTypeC <- f inTypeA
    outTypeD <- g inTypeB
    return (outTypeC, outTypeD)

  (f >>> g) x = f x >>= g

  -- scheduling operators
  split_seq_to_sseqC outerLengthProxy f seqOfSSeq = do
    resultingFlatSeq <- f $ seqOfSeqToSeq $ seqOfSSeqToSeqOfSeq seqOfSSeq
    let innerLengthProxy = Proxy :: Proxy innerOutputLength
    return $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq innerLengthProxy resultingFlatSeq
    
  split_seq_to_tseqC outerLengthProxy f seqOfTSeq = do
    resultingFlatSeq <- f $ seqOfSeqToSeq $ seqOfTSeqToSeqOfSeq seqOfTSeq
    let innerLengthProxy = Proxy :: Proxy innerOutputLength
    return $ seqOfSeqToSeqOfTSeq $ seqToSeqOfSeq innerLengthProxy resultingFlatSeq

  sseq_to_seqC f seq = (f $ seqToSSeq seq) >>= (return . sseqToSeq)
  tseq_to_seqC f seq = (f $ seqToTSeq seq) >>= (return . tseqToSeq)
  seq_to_sseqC f sseq = (f $ sseqToSeq sseq) >>= (return . seqToSSeq)
  seq_to_tseqC f tseq = (f $ tseqToSeq tseq) >>= (return . seqToTSeq)
  sseq_to_tseqC _ _ f tseq = (f $ tseqToSSeq tseq) >>= (return . sseqToTSeq)
  tseq_to_sseqC f sseq = (f $ sseqToTSeq sseq) >>= (return . tseqToSSeq)
  underutilC _ f tseq = do 
    innerResultTSeq :: TSeq o u b <- f $ changeUtilTSeq tseq
    return $ changeUtilTSeq innerResultTSeq

{-
-- examples of programs in space and time
iterInput = Seq $ V.fromTuple ((Int 1, Int 2), (Int 3, Int 4), (Int 5, Int 6), (Int 7, Int 8))
-- replace unscheduledCirc with this one to see a composition
--unscheduledCirc = iterC (Proxy @4) $ (constGenC (Int 3) *** constGenC (Int 2)) >>> addC
unscheduledCirc = iterC (Proxy @4) $ addC
unscheduledResult = simulate $ unscheduledCirc iterInput
sequentialResult = simulate $ seq_to_tseqC unscheduledCirc $ to iterInput
parallelResult = simulate $ seq_to_sseqC unscheduledCirc $ to iterInput
partialParallelInput :: TSeq 2 0 (SSeq 2 (Atom, Atom))
partialParallelInput = seqToTSeq $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq (Proxy @2) iterInput
partialParallelResult =
  simulate $
  (seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledCirc) $
  partialParallelInput

-}

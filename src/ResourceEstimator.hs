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
import qualified Data.Vector.Sized as V

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
  notC _ = incrementResourcesBy bitSizeInBits bitSizeInBits (Bit True)
  notC _ = fail "notC only handles a bit"
  noop c = incrementResourcesBy (size (Proxy :: Proxy a)) (size (Proxy :: Proxy a)) c

  -- binary operators
  -- the values returned here, they are only to emit things of the right types
  -- so the state computations can occur
  addC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  addC (_, _) = fail "addC only handles 2 ints"
  subC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  subC (_, _) = fail "subC only handles 2 ints"
  mulC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  mulC (_, _) = fail "mulC only handles 2 ints"
  divC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  divC (_, _) = fail "divC only handles 2 ints"
  minC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  minC (_, _) = fail "minC only handles 2 ints"
  maxC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  maxC (_, _) = fail "maxC only handles 2 ints"
  ashrC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  ashrC (_, _) = fail "ashrC only handles 2 ints"
  shlC (Int _, Int _) = incrementResourcesBy (2*intSizeInBits) intSizeInBits (Int 2)
  shlC (_, _) = fail "shlC only handles 2 ints"
  andC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  andC (_, _) = fail "andC only handles 2 bits"
  orC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  orC (_, _) = fail "orC only handles 2 bits"
  xorC (Bit x, Bit y) = incrementResourcesBy (2*bitSizeInBits) bitSizeInBits (Bit True)
  xorC (_, _) = fail "xorC only handles 2 bits"
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
  upC _ (Seq vec) = incrementResourcesBy 0 (size (Proxy :: Proxy a)) undefined
  downC _ (Seq vec) = incrementResourcesBy 0 (size (Proxy :: Proxy a)) undefined

  foldC _ accum (Seq vec) = do
    result <- V.foldM f accum vec
    return result

  partition sublistLength (Seq inputVec) =
    let
      vectorOfVectors = nestVector sublistLength inputVec
      vectorOfSeqs = V.map (\x -> Seq x) vectorOfVectors
    in
      Seq vectorOfSeqs

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

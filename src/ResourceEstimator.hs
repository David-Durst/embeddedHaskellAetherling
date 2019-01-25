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
estimateResources :: State ResourceEstimate a -> ResourceEstimate
estimateResources a = snd $ runState a $ ResourceEstimate 0 0

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
  absC c@(Int _) = incrementResourcesBy (size c) (size c) c
  absC _ = fail "absC only handles an int"
  {-
  notC (Bit x) = return $ Resources bitSizeInBits bitSizeInBits
  notC _ = fail "notC only handles a bit"
  noop x = return x 

  -- binary operators
  addC (Int x, Int y) = return $ Resources (2*intSizeInBits) intSizeInBits
  addC (_, _) = fail "addC only handles 2 ints"
  subC (Int x, Int y) = return $ Resources (2*intSizeInBits) intSizeInBits
  subC (_, _) = fail "subC only handles 2 ints"
  mulC (Int x, Int y) = return $ Resources (2*intSizeInBits) intSizeInBits
  mulC (_, _) = fail "mulC only handles 2 ints"
  divC (Int x, Int y) = return $ Resources (2*intSizeInBits) intSizeInBits
  divC (_, _) = fail "divC only handles 2 ints"
  minC (Int x, Int y) = return $ Resources (2*intSizeInBits) intSizeInBits
  minC (_, _) = fail "minC only handles 2 ints"
  maxC (Int x, Int y) = return $ Resources (2*intSizeInBits) intSizeInBits
  maxC (_, _) = fail "maxC only handles 2 ints"
  ashrC (Int input, Int amount) = return $ Resources (2*intSizeInBits) intSizeInBits
  ashrC (_, _) = fail "ashrC only handles 2 ints"
  shlC (Int input, Int amount) = return $ Resources (2*intSizeInBits) intSizeInBits
  shlC (_, _) = fail "shlC only handles 2 ints"
  andC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  andC (_, _) = fail "andC only handles 2 bits"
  orC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  orC (_, _) = fail "orC only handles 2 bits"
  xorC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  xorC (_, _) = fail "xorC only handles 2 bits"
  eqC (Int x, Int y) = return $ Resources (2*intSizeInBits) bitSizeInBits
  eqC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  eqC (_, _) = fail "eqC only handles 2 bits or 2 ints, not a mix"
  neqC (Int x, Int y) = return $ Resources (2*intSizeInBits) bitSizeInBits
  neqC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  neqC (_, _) = fail "neqC only handles 2 bits or 2 ints, not a mix"
  ltC (Int x, Int y) = return $ Resources (2*intSizeInBits) bitSizeInBits
  ltC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  ltC (_, _) = fail "ltC only handles 2 bits or 2 ints, not a mix"
  leqC (Int x, Int y) = return $ Resources (2*intSizeInBits) bitSizeInBits
  leqC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  leqC (_, _) = fail "leqC only handles 2 bits or 2 ints, not a mix"
  gtC (Int x, Int y) = return $ Resources (2*intSizeInBits) bitSizeInBits
  gtC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  gtC (_, _) = fail "gtC only handles 2 bits or 2 ints, not a mix"
  geqC (Int x, Int y) = return $ Resources (2*intSizeInBits) bitSizeInBits
  geqC (Bit x, Bit y) = return $ Resources (2*bitSizeInBits) bitSizeInBits
  geqC (_, _) = fail "geqC only handles 2 bits or 2 ints, not a mix"

  -- module generator
  lutGenC as _ = return $ Resources (length as * elementSize) elementSize
    where
      elementSize = sizeOfElement $ head as

  constGenC (Int _) _ = return $ Resources intSizeInBits intSizeInBits
  constGenC (Bit _) _ = return $ Resources bitSizeInBits bitSizeInBits
  constGenC _ _ = fail "constGenC has no size for non-int and non-bit atoms"

  -- sequence operators
  -- THIS HAS TO BE A STATEFUL VECTOR. THIS ALLOWS ME TO GET AROUND THE ISSUE HERE
  -- Don't KNOW WHAT THIS IS, RETURNING A COUNTER, NEED TO BE TRACKING SIZE AND
  -- ACCUMULATING THAT IN MONAD STATE RATHER THAN AS RETURN RESULT
  upC _ (Seq vec) = return $ Resources 0 (size $ V.head vec)
  downC _ (Seq vec) = Seq $ V.singleton $ V.head vec

  foldC f accum (Seq vec) = do
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

module Simulator where 
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
import qualified Data.Vector.Sized as V

data SimulatorEnv a = SimulatorEnv a

simulate :: SimulatorEnv a -> a
simulate (SimulatorEnv a) = a

instance Functor SimulatorEnv where
  fmap f (SimulatorEnv a) = SimulatorEnv (f a)
  
instance Applicative SimulatorEnv where
  pure a = SimulatorEnv a
  SimulatorEnv f <*> SimulatorEnv a = SimulatorEnv $ f a

instance Monad SimulatorEnv where
  (SimulatorEnv a) >>= f = f a
  return a = SimulatorEnv a

instance Circuit SimulatorEnv where
  -- unary operators
  absC (Int x) = return $ Int $ abs x
  notC (Bit x) = return $ Bit $ not x
  noop x = return x 

  -- binary operators
  addC (Int x, Int y) = return $ Int $ x + y
  subC (Int x, Int y) = return $ Int $ x - y
  mulC (Int x, Int y) = return $ Int $ x * y
  divC (Int x, Int y) = return $ Int $ x `div` y
  minC (Int x, Int y) = return $ Int $ min x y
  maxC (Int x, Int y) = return $ Int $ max x y
  ashrC (Int input, Int amount) = return $ Int $ shiftR input amount
  shlC (Int input, Int amount) = return $ Int $ shiftL input amount
  andC (Bit x, Bit y) = return $ Bit $ x && y
  orC (Bit x, Bit y) = return $ Bit $ x || y
  xorC (Bit x, Bit y) = return $ Bit $ (x /= y) && (x || y)
  eqIntC (Int x, Int y) = return $ Bit $ x == y
  eqBitC (Bit x, Bit y) = return $ Bit $ x == y
  neqIntC (Int x, Int y) = return $ Bit $ x /= y
  neqBitC (Bit x, Bit y) = return $ Bit $ x /= y
  ltIntC (Int x, Int y) = return $ Bit $ x < y
  ltBitC (Bit x, Bit y) = return $ Bit $ x < y
  leqIntC (Int x, Int y) = return $ Bit $ x <= y
  leqBitC (Bit x, Bit y) = return $ Bit $ x <= y
  gtIntC (Int x, Int y) = return $ Bit $ x > y
  gtBitC (Bit x, Bit y) = return $ Bit $ x > y
  geqIntC (Int x, Int y) = return $ Bit $ x >= y
  geqBitC (Bit x, Bit y) = return $ Bit $ x >= y

  -- module generator
  lutGenIntC as (Int i) = return $ as !! i 

  lutGenBitC as (Int i) = return $ as !! i 

  constGenC x = \_ -> return x

  -- sequence operators
  upC _ (Seq vec) = return $ Seq $ V.replicate $ V.head vec
  downC _ (Seq vec) = return $ Seq $ V.singleton $ V.head vec

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
partialParallelInput :: TSeq 2 0 (SSeq 2 (Atom Int, Atom Int))
partialParallelInput = seqToTSeq $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq (Proxy @2) iterInput
partialParallelResult =
  simulate $
  (seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledCirc) $
  partialParallelInput

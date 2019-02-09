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
import Control.Monad
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
  noop _ x = return x

  -- binary operators
  addC (Tuple (Int x) (Int y)) = return $ Int $ x + y
  subC (Tuple (Int x) (Int y)) = return $ Int $ x - y
  mulC (Tuple (Int x) (Int y)) = return $ Int $ x * y
  divC (Tuple (Int x) (Int y)) = return $ Int $ x `div` y
  minC (Tuple (Int x) (Int y)) = return $ Int $ min x y
  maxC (Tuple (Int x) (Int y)) = return $ Int $ max x y
  ashrC (Tuple (Int input) (Int amount)) = return $ Int $ shiftR input amount
  shlC (Tuple (Int input) (Int amount)) = return $ Int $ shiftL input amount
  andC (Tuple (Bit x) (Bit y)) = return $ Bit $ x && y
  orC (Tuple (Bit x) (Bit y)) = return $ Bit $ x || y
  xorC (Tuple (Bit x) (Bit y)) = return $ Bit $ (x /= y) && (x || y)
  eqIntC (Tuple (Int x) (Int y)) = return $ Bit $ x == y
  eqBitC (Tuple (Bit x) (Bit y)) = return $ Bit $ x == y
  neqIntC (Tuple (Int x) (Int y)) = return $ Bit $ x /= y
  neqBitC (Tuple (Bit x) (Bit y)) = return $ Bit $ x /= y
  ltIntC (Tuple (Int x) (Int y)) = return $ Bit $ x < y
  ltBitC (Tuple (Bit x) (Bit y)) = return $ Bit $ x < y
  leqIntC (Tuple (Int x) (Int y)) = return $ Bit $ x <= y
  leqBitC (Tuple (Bit x) (Bit y)) = return $ Bit $ x <= y
  gtIntC (Tuple (Int x) (Int y)) = return $ Bit $ x > y
  gtBitC (Tuple (Bit x) (Bit y)) = return $ Bit $ x > y
  geqIntC (Tuple (Int x) (Int y)) = return $ Bit $ x >= y
  geqBitC (Tuple (Bit x) (Bit y)) = return $ Bit $ x >= y

  -- module generator
  lutGenIntC as (Int i) = return $ as !! i 

  lutGenBitC as (Int i) = return $ as !! i 

  constGenIntC x = \_ -> return x
  constGenBitC x = \_ -> return x

  -- sequence operators
  upC _ (Seq vec) = return $ Seq $ V.replicate $ V.head vec
  downC _ (Seq vec) = return $ Seq $ V.singleton $ V.head vec

{-
  foldC sublistLength f accum (Seq inputVec) =
    let
      zipAtoms atom1 atom2 = Tuple atom1 atom2
      vectorOfVectors = nestVector sublistLength inputVec
      vectorOfResults = V.mapM (\subVec ->
                                  V.foldM (\atom1 -> (\atom2 -> f $
                                                       Tuple atom1 atom2))
                                  (accum Unit) subVec) vectorOfVectors
      seqOfResults = liftM (\vec -> Seq vec) vectorOfResults
    in
      seqOfResults 
-}

  partitionC sublistLength (Seq inputVec) =
    let
      vectorOfVectors = nestVector sublistLength inputVec
      vectorOfSeqs = V.map (\x -> Seq x) vectorOfVectors
    in
      return $ Seq vectorOfSeqs

  -- higher-order operators
  iterC _ f (Seq inputVec) = do
    resultVec <- V.mapM f inputVec
    return $ Seq resultVec

{-
  (f *** g) (inTypeA, inTypeB) = do
    outTypeC <- f inTypeA
    outTypeD <- g inTypeB
    return (outTypeC, outTypeD)
  (f >***< g) (inTypeA, inTypeB) = do
    outTypeC <- f inTypeA
    outTypeD <- g inTypeB
    return (outTypeC, outTypeD)
-}
  (f >>> g) x = f x >>= g

  -- scheduling operators
  split_seq_to_sseqC innerLengthProxy f seqOfSSeq = do
    resultingFlatSeq <- f $ seqOfSeqToSeq $ seqOfSSeqToSeqOfSeq seqOfSSeq
    return $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq innerLengthProxy resultingFlatSeq
    
  split_seq_to_tseqC innerLengthProxy f seqOfTSeq = do
    resultingFlatSeq <- f $ seqOfSeqToSeq $ seqOfTSeqToSeqOfSeq seqOfTSeq
    return $ seqOfSeqToSeqOfTSeq $ seqToSeqOfSeq innerLengthProxy resultingFlatSeq

  sseq_to_seqC f seq = (f $ seqToSSeq seq) >>= (return . sseqToSeq)
  tseq_to_seqC f seq = (f $ seqToTSeq seq) >>= (return . tseqToSeq)
  seq_to_sseqC f sseq = (f $ sseqToSeq sseq) >>= (return . seqToSSeq)
  seq_to_tseqC f tseq = (f $ tseqToSeq tseq) >>= (return . seqToTSeq)
  sseq_to_tseqC f tseq = (f $ tseqToSSeq tseq) >>= (return . sseqToTSeq)
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
partialParallelInput :: TSeq 2 0 (SSeq 2 (Atom Int, Atom Int))
partialParallelInput = seqToTSeq $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq (Proxy @2) iterInput
partialParallelResult =
  simulate $
  (seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledCirc) $
  partialParallelInput

-}

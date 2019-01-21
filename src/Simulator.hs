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
  absC _ = fail "absC only handles an int"
  notC (Bit x) = return $ Bit $ not x
  notC _ = fail "notC only handles a bit"
  noop x = return x 

  -- binary operators
  addC (Int x, Int y) = return $ Int $ x + y
  addC (_, _) = fail "addC only handles 2 ints"
  subC (Int x, Int y) = return $ Int $ x - y
  subC (_, _) = fail "subC only handles 2 ints"
  mulC (Int x, Int y) = return $ Int $ x * y
  mulC (_, _) = fail "mulC only handles 2 ints"
  divC (Int x, Int y) = return $ Int $ x `div` y
  divC (_, _) = fail "divC only handles 2 ints"
  minC (Int x, Int y) = return $ Int $ min x y
  minC (_, _) = fail "minC only handles 2 ints"
  maxC (Int x, Int y) = return $ Int $ max x y
  maxC (_, _) = fail "maxC only handles 2 ints"
  ashrC (Int input, Int amount) = return $ Int $ shiftR input amount
  ashrC (_, _) = fail "ashrC only handles 2 ints"
  shlC (Int input, Int amount) = return $ Int $ shiftL input amount
  shlC (_, _) = fail "shlC only handles 2 ints"
  andC (Bit x, Bit y) = return $ Bit $ x && y
  andC (_, _) = fail "andC only handles 2 bits"
  orC (Bit x, Bit y) = return $ Bit $ x || y
  orC (_, _) = fail "orC only handles 2 bits"
  xorC (Bit x, Bit y) = return $ Bit $ (x /= y) && (x || y)
  xorC (_, _) = fail "xorC only handles 2 bits"
  eqC (Int x, Int y) = return $ Bit $ x == y
  eqC (Bit x, Bit y) = return $ Bit $ x == y
  eqC (_, _) = fail "eqC only handles 2 bits or 2 ints, not a mix"
  neqC (Int x, Int y) = return $ Bit $ x /= y
  neqC (Bit x, Bit y) = return $ Bit $ x /= y
  neqC (_, _) = fail "neqC only handles 2 bits or 2 ints, not a mix"
  ltC (Int x, Int y) = return $ Bit $ x < y
  ltC (Bit x, Bit y) = return $ Bit $ x < y
  ltC (_, _) = fail "ltC only handles 2 bits or 2 ints, not a mix"
  leqC (Int x, Int y) = return $ Bit $ x <= y
  leqC (Bit x, Bit y) = return $ Bit $ x <= y
  leqC (_, _) = fail "leqC only handles 2 bits or 2 ints, not a mix"
  gtC (Int x, Int y) = return $ Bit $ x > y
  gtC (Bit x, Bit y) = return $ Bit $ x > y
  gtC (_, _) = fail "gtC only handles 2 bits or 2 ints, not a mix"
  geqC (Int x, Int y) = return $ Bit $ x >= y
  geqC (Bit x, Bit y) = return $ Bit $ x >= y
  geqC (_, _) = fail "geqC only handles 2 bits or 2 ints, not a mix"

  -- module generator
  lutGenC as (Int i) = return $ as !! i 
  lutGenC as (Bit True) = return $ as !! 1
  lutGenC as (Bit False) = return $ as !! 0
  lutGenC _ (CompilerResult _) = fail $ "lutGenC can't handle compiler " ++
    "internals as an input"

  constGenC x = \_ -> return x

  -- sequence operators
  upC _ (Seq vec) = Seq $ V.replicate $ V.head vec
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

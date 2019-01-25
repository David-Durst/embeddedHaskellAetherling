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
  eqIntC (Int x, Int y) = return $ Bit $ x == y
  eqIntC (_, _) = fail "eqIntC only handles 2 ints"
  eqBitC (Bit x, Bit y) = return $ Bit $ x == y
  eqBitC (_, _) = fail "eqBitC only handles 2 bits"
  neqIntC (Int x, Int y) = return $ Bit $ x /= y
  neqIntC (_, _) = fail "neqIntC only handles 2 ints"
  neqBitC (Bit x, Bit y) = return $ Bit $ x /= y
  neqBitC (_, _) = fail "neqBitC only handles 2 bits"
  ltIntC (Int x, Int y) = return $ Bit $ x < y
  ltIntC (_, _) = fail "ltIntC only handles 2 ints"
  ltBitC (Bit x, Bit y) = return $ Bit $ x < y
  ltBitC (_, _) = fail "ltBitC only handles 2 bits"
  leqIntC (Int x, Int y) = return $ Bit $ x <= y
  leqIntC (_, _) = fail "leqIntC only handles 2 ints"
  leqBitC (Bit x, Bit y) = return $ Bit $ x <= y
  leqBitC (_, _) = fail "leqBitC only handles 2 bits"
  gtIntC (Int x, Int y) = return $ Bit $ x > y
  gtIntC (_, _) = fail "gtC only handles 2 ints, not a mix"
  gtBitC (Bit x, Bit y) = return $ Bit $ x > y
  gtBitC (_, _) = fail "gtC only handles 2 bits"
  geqIntC (Int x, Int y) = return $ Bit $ x >= y
  geqIntC (_, _) = fail "geqIntC only handles 2 ints"
  geqBitC (Bit x, Bit y) = return $ Bit $ x >= y
  geqBitC (_, _) = fail "geqBitC only handles 2 bits"

  -- module generator
  lutGenIntC as (Int i) = return $ as !! i 
  lutGenIntC as (Bit True) = return $ as !! 1
  lutGenIntC as (Bit False) = return $ as !! 0
  lutGenIntC _ (CompilerResult _) = fail $ "lutGenIntC can't handle compiler " ++
    "internals as an input"

  lutGenBitC as (Int i) = return $ as !! i 
  lutGenBitC as (Bit True) = return $ as !! 1
  lutGenBitC as (Bit False) = return $ as !! 0
  lutGenBitC _ (CompilerResult _) = fail $ "lutGenIntC can't handle compiler " ++
    "internals as an input"

  constGenIntC x = \_ -> return x
  constGenBitC x = \_ -> return x

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

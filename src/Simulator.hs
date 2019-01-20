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

simulate :: SimulatorEnv Atom -> Atom
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
  addC (Tuple (Int x, Int y)) = return $ Int $ x + y
  addC (Tuple (_, _)) = fail "addC only handles 2 ints"
  subC (Tuple (Int x, Int y)) = return $ Int $ x - y
  subC (Tuple (_, _)) = fail "subC only handles 2 ints"
  mulC (Tuple (Int x, Int y)) = return $ Int $ x * y
  mulC (Tuple (_, _)) = fail "mulC only handles 2 ints"
  divC (Tuple (Int x, Int y)) = return $ Int $ x `div` y
  divC (Tuple (_, _)) = fail "divC only handles 2 ints"
  minC (Tuple (Int x, Int y)) = return $ Int $ min x y
  minC (Tuple (_, _)) = fail "minC only handles 2 ints"
  maxC (Tuple (Int x, Int y)) = return $ Int $ max x y
  maxC (Tuple (_, _)) = fail "maxC only handles 2 ints"
  ashrC (Tuple (Int input, Int amount)) = return $ Int $ shiftR input amount
  ashrC (Tuple (_, _)) = fail "ashrC only handles 2 ints"
  shlC (Tuple (Int input, Int amount)) = return $ Int $ shiftL input amount
  shlC (Tuple (_, _)) = fail "shlC only handles 2 ints"
  andC (Tuple (Bit x, Bit y)) = return $ Bit $ x && y
  andC (Tuple (_, _)) = fail "andC only handles 2 bits"
  orC (Tuple (Bit x, Bit y)) = return $ Bit $ x || y
  orC (Tuple (_, _)) = fail "orC only handles 2 bits"
  xorC (Tuple (Bit x, Bit y) = return $ Bit $ (x /= y) && (x || y))
  xorC (Tuple (_, _)) = fail "xorC only handles 2 bits"
  eqC (Tuple (Int x, Int y)) = return $ Bit $ x == y
  eqC (Tuple (Bit x, Bit y)) = return $ Bit $ x == y
  eqC (Tuple (_, _)) = fail "eqC only handles 2 bits or 2 ints, not a mix"
  neqC (Tuple (Int x, Int y)) = return $ Bit $ x /= y
  neqC (Tuple (Bit x, Bit y)) = return $ Bit $ x /= y
  neqC (Tuple (_, _)) = fail "neqC only handles 2 bits or 2 ints, not a mix"
  ltC (Tuple (Int x, Int y)) = return $ Bit $ x < y
  ltC (Tuple (Bit x, Bit y)) = return $ Bit $ x < y
  ltC (Tuple (_, _)) = fail "ltC only handles 2 bits or 2 ints, not a mix"
  leqC (Tuple (Int x, Int y)) = return $ Bit $ x <= y
  leqC (Tuple (Bit x, Bit y)) = return $ Bit $ x <= y
  leqC (Tuple (_, _)) = fail "leqC only handles 2 bits or 2 ints, not a mix"
  gtC (Tuple (Int x, Int y)) = return $ Bit $ x > y
  gtC (Tuple (Bit x, Bit y)) = return $ Bit $ x > y
  gtC (Tuple (_, _)) = fail "gtC only handles 2 bits or 2 ints, not a mix"
  geqC (Tuple (Int x, Int y)) = return $ Bit $ x >= y
  geqC (Tuple (Bit x, Bit y)) = return $ Bit $ x >= y
  geqC (Tuple (_, _)) = fail "geqC only handles 2 bits or 2 ints, not a mix"

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

  (f *** g) (Tuple (inTypeA, inTypeB)) = do
    outTypeC <- f inTypeA
    outTypeD <- g inTypeB
    return (Tuple (outTypeC, outTypeD))

  (f *** g) _ = fail "*** must receive a tuple input"

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
{-
addFullyParallel = liftBinaryModuleToTime (Proxy @1) (Proxy @0) (liftBinaryModuleToSpace (Proxy @4) addInt)
unscheduled4 :: Seq 4 Int
unscheduled4 = Seq $ fromTuple (1, 2, 3, 4) 
unscheduled4Nested :: Seq 1 (Seq 4 Int)
unscheduled4Nested = to unscheduled4
partiallyScheduledFullyParallel4Nested :: Seq 1 (SSeq 4 Int)
partiallyScheduledFullyParallel4Nested = to unscheduled4Nested
fullyParallel4Nested :: TSeq 1 0 (SSeq 4 Int)
fullyParallel4Nested = to partiallyScheduledFullyParallel4Nested
resultFullyParallel = addFullyParallel (fullyParallel4Nested, fullyParallel4Nested)

addPartiallyParallel = liftBinaryModuleToTime (Proxy @2) (Proxy @0) (liftBinaryModuleToSpace (Proxy @2) addInt)
unscheduled4Split :: Seq 2 (Seq 2 Int)
unscheduled4Split = to unscheduled4
partiallyScheduled4Split :: Seq 2 (SSeq 2 Int)
partiallyScheduled4Split = to unscheduled4Split
partiallyParallel4 :: TSeq 2 0 (SSeq 2 Int)
partiallyParallel4 = to partiallyScheduled4Split 
resultPartiallyParallel = addPartiallyParallel (partiallyParallel4, partiallyParallel4)
-}

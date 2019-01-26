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
multiplyNodeThroughput n (NodeInfo nt numerator denominator children) =
  NodeInfo nt (numerator * n) denominator children

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
  addC (Int _, Int _) = appendToPipeline (NodeInfo AddT 2 1 ([],[]))
  subC (Int _, Int _) = appendToPipeline (NodeInfo SubT 2 1 ([],[]))
  mulC (Int _, Int _) = appendToPipeline (NodeInfo MulT 2 1 ([],[]))
  divC (Int _, Int _) = appendToPipeline (NodeInfo DivT 2 1 ([],[]))
  minC (Int _, Int _) = appendToPipeline (NodeInfo MinT 2 1 ([],[]))
  maxC (Int _, Int _) = appendToPipeline (NodeInfo MaxT 2 1 ([],[]))
  ashrC (Int _, Int _) = appendToPipeline (NodeInfo AshrT 2 1 ([],[]))
  shlC (Int _, Int _) = appendToPipeline (NodeInfo ShlT 2 1 ([],[]))
  andC (Bit x, Bit y) = appendToPipeline (NodeInfo AndT 2 1 ([],[]))
  orC (Bit x, Bit y) = appendToPipeline (NodeInfo OrT 2 1 ([],[]))
  xorC (Bit x, Bit y) = appendToPipeline (NodeInfo XorT 2 1 ([],[]))
  eqIntC (Int x, Int y) = appendToPipeline (NodeInfo EqIntT 2 1 ([],[]))
  eqBitC (Bit x, Bit y) = appendToPipeline (NodeInfo EqBitT 2 1 ([],[]))
  neqIntC (Int x, Int y) = appendToPipeline (NodeInfo NeqIntT 2 1 ([],[]))
  neqBitC (Bit x, Bit y) = appendToPipeline (NodeInfo NeqBitT 2 1 ([],[]))
  ltIntC (Int x, Int y) = appendToPipeline (NodeInfo LtIntT 1 1 ([],[]))
  ltBitC (Bit x, Bit y) = appendToPipeline (NodeInfo LtBitT 2 1 ([],[]))
  leqIntC (Int x, Int y) = appendToPipeline (NodeInfo LeqIntT 2 1 ([],[]))
  leqBitC (Bit x, Bit y) = appendToPipeline (NodeInfo LeqBitT 2 1 ([],[]))
  gtIntC (Int x, Int y) = appendToPipeline (NodeInfo GtIntT 2 1 ([],[]))
  gtBitC (Bit x, Bit y) = appendToPipeline (NodeInfo GtBitT 2 1 ([],[]))
  geqIntC (Int x, Int y) = appendToPipeline (NodeInfo GeqIntT 2 1 ([],[]))
  geqBitC (Bit x, Bit y) = appendToPipeline (NodeInfo GeqBitT 2 1 ([],[]))

  -- module generator
  lutGenIntC as _ = appendToPipeline (NodeInfo (LutGenIntT as) 1 1 ([],[]))
  lutGenBitC as _ = appendToPipeline (NodeInfo (LutGenBitT as) 1 1 ([],[]))

  constGenC x _ = appendToPipeline (NodeInfo (ConstGenT x) 1 1 ([],[]))
  -- sequence operators
  -- need to fix upC to account for storage if tseq
  upC :: forall a n. (KnownNat n, KnownNat (TypeSize a)) =>
    Proxy n -> Seq 1 a -> State PipelineDAG (Seq n a)
  upC amountProxy (Seq vec) = appendToPipeline (NodeInfo (UpT (Proxy :: Proxy a)
                                                      (fromInteger $ natVal amountProxy))
                                                 1 1 ([],[]))
  downC :: forall a n o . (KnownNat n, KnownNat o, n ~ (o+1), KnownNat (TypeSize a)) =>
    Proxy n -> (Seq n a) -> State PipelineDAG (Seq 1 a)
  downC amountProxy (Seq vec) = appendToPipeline (NodeInfo (DownT (Proxy :: Proxy a)
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
  iterC _ f _ = appendInnerDAGToOuterDAG f {-do
    PipelineDAG stages <- get 
    put $ PipelineDAG (stages ++ getInnerPipeline f emptyDAG)
    return undefined
    -- appendToPipeline (NodeInfo (FoldT (Proxy :: Proxy a)) 1 1 (getInnerPipeline f emptyDAG, []))
-}

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
  split_seq_to_tseqC outerLengthProxy f seqOfTSeq = do
    PipelineDAG stages <- get 
    put $ PipelineDAG (stages ++ getInnerPipeline f emptyDAG)
    return undefined

{-
  sseq_to_seqC f seq = (f $ seqToSSeq seq) >>= (return . sseqToSeq)
  tseq_to_seqC f seq = (f $ seqToTSeq seq) >>= (return . tseqToSeq)
  seq_to_sseqC f sseq = (f $ sseqToSeq sseq) >>= (return . seqToSSeq)
  seq_to_tseqC f tseq = (f $ tseqToSeq tseq) >>= (return . seqToTSeq)
  sseq_to_tseqC _ _ f tseq = (f $ tseqToSSeq tseq) >>= (return . sseqToTSeq)
  tseq_to_sseqC f sseq = (f $ sseqToTSeq sseq) >>= (return . tseqToSSeq)
  underutilC _ f tseq = do 
    innerResultTSeq :: TSeq o u b <- f $ changeUtilTSeq tseq
    return $ changeUtilTSeq innerResultTSeq
-}
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

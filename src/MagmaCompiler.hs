module MagmaCompiler where 
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
import Data.Either
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V
{-
magmaPrelude = "
-}

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
  | ConstGenIntT (Atom Int)
  | ConstGenBitT (Atom Bool)
  | forall a . (Typeable (Proxy a)) => UpT (Proxy a) Int
  | forall a . (Typeable (Proxy a)) => DownT (Proxy a) Int
  -- nodet is the operation inside the fold
  -- at this point only single operations are supports
  -- int is total sequence length
  | forall a . FoldT NodeType Int
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
  show (ConstGenIntT a) = "ConstGenIntT " ++ show a
  show (ConstGenBitT a) = "ConstGenBitT " ++ show a
  show (UpT proxy n) = "UpT " ++ show proxy ++ " " ++ show n
  show (DownT proxy n) = "DownT " ++ show proxy ++ " " ++ show n
  show (FoldT nt totalLen) = "FoldT " ++ show nt ++ " " ++
    show totalLen
  show ForkJoinT = "ForkJoinT"

-- left string is an error, right string is a valid result
createMagmaInstanceOfNode :: NodeType -> Int -> Either String String
createMagmaInstanceOfNode AbsT _ = Left "Abs node not implemented" 
createMagmaInstanceOfNode NotT _ = Right "DefineNegate(8)"
createMagmaInstanceOfNode NoopT _ = Left "NoOp shouldn't be printed to magma"
createMagmaInstanceOfNode AddT _ = Right "DefineAdd(8)"
createMagmaInstanceOfNode SubT _ = Right "DefineSub(8)"
createMagmaInstanceOfNode DivT _ = Right "DefineCoreirUDiv(8)"
createMagmaInstanceOfNode MulT _ = Right "DefineCoreirMul(8)"
createMagmaInstanceOfNode MinT _ = Left "Min node not implemented in magma" 
createMagmaInstanceOfNode MaxT _ = Left "Max node not implemented in magma" 
createMagmaInstanceOfNode AshrT _ = Right "DefineASR(8)"
createMagmaInstanceOfNode ShlT _ = Right "DefineLSL(8)"
createMagmaInstanceOfNode EqIntT _ = Right "DefineEQ(8)"
createMagmaInstanceOfNode NeqIntT _ = Right "DefineNE(8)"
createMagmaInstanceOfNode LtIntT _ = Right "DefineULT(8)"
createMagmaInstanceOfNode LeqIntT _ = Right "DefineULE(8)"
createMagmaInstanceOfNode GtIntT _ = Right "DefineUGT(8)"
createMagmaInstanceOfNode GeqIntT _ = Right "DefineUGE(8)" 
createMagmaInstanceOfNode AndT _ = Right "DefineAnd(8)"
createMagmaInstanceOfNode OrT _ = Right "DefineOr(8)"
createMagmaInstanceOfNode XorT _ = Right "DefineXOr(8)"
createMagmaInstanceOfNode EqBitT _ = Right "DefineEQ(1)"
createMagmaInstanceOfNode NeqBitT _ = Right "DefineNE(1)"
createMagmaInstanceOfNode LtBitT _ = Right "DefineULT(1)"
createMagmaInstanceOfNode LeqBitT _ = Right "DefineULE(1)"
createMagmaInstanceOfNode GtBitT _ = Right "DefineUGT(1)"
createMagmaInstanceOfNode GeqBitT _ = Right "DefineUGE(1)" 
createMagmaInstanceOfNode (LutGenIntT as) _ = Left "LUT not implemented in Magma"
createMagmaInstanceOfNode (LutGenBitT as) _ = Left "LUT not implemented in Magma"
createMagmaInstanceOfNode (ConstGenIntT x) _ = Right ("DefineCoreirConst(" ++
  show intSizeInBits ++ ", " ++ show x ++ ")")
createMagmaInstanceOfNode (ConstGenBitT x) _ = Right ("DefineCoreirConst(" ++
  show bitSizeInBits ++ ", " ++ show x ++ ")")
createMagmaInstanceOfNode (UpT proxy upAmount) par | par == upAmount = Right (
                                                     "DefineUpsampleParallel(" ++
                                                     show par ++ ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
createMagmaInstanceOfNode (UpT proxy upAmount) par | par > 1 = Left (
                                                   "Upsample partially parallel not implemented in Magma")
createMagmaInstanceOfNode (UpT proxy upAmount) 1 = Right (
                                                     "DefineUpsampleSequential(" ++
                                                     "cirb, " ++ show upAmount ++
                                                     ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
-- can't upsample by less than 1
createMagmaInstanceOfNode (UpT _ _) _ = Left "Upsample must have a par of at least 1"
createMagmaInstanceOfNode (DownT proxy upAmount) par | par == upAmount = Right (
                                                     "DefineDownsampleParallel(" ++
                                                     "cirb, " ++ show par ++ ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
createMagmaInstanceOfNode (DownT proxy upAmount) par | par > 1 = Left (
                                                   "Downsample partially parallel not implemented in Magma")
createMagmaInstanceOfNode (DownT proxy upAmount) 1 = Right (
                                                     "DefineDownsampleSequential(" ++
                                                     show upAmount ++
                                                     ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
-- can't upsample by less than 1
createMagmaInstanceOfNode (DownT _ _) _ = Left "Downsample must have a par of at least 1"
-- if the inner node doesn't work, just fail
createMagmaInstanceOfNode (FoldT nt totalLen) par |
  isLeft (createMagmaInstanceOfNode nt 1) = createMagmaInstanceOfNode nt 1
createMagmaInstanceOfNode (FoldT nt totalLen) par | par == totalLen = Right (
                                                     "ReduceParallel(" ++
                                                     "cirb, " ++ show par ++ ", " ++ 
                                                     "renameCircuitForReduce(" ++
                                                     innerString ++ ")).defn")
                                                  where
                                                    innerString = fromLeft "" (
                                                      createMagmaInstanceOfNode nt 1)
createMagmaInstanceOfNode (FoldT nt totalLen) par | par > 1 = Right (
                                                     "DefineReducePartiallyParallel(" ++
                                                     "cirb, " ++ show totalLen ++ ", " ++ 
                                                     show par ++ ", " ++
                                                     innerString ++ ")()")
                                                  where
                                                    innerString = fromLeft "" (
                                                      createMagmaInstanceOfNode nt 1)
createMagmaInstanceOfNode (FoldT nt totalLen) 1 = Right (
                                                     "ReduceSequential(" ++
                                                     "cirb, " ++ show totalLen ++ ", " ++ 
                                                     "renameCircuitForReduce(" ++
                                                     innerString ++ ")).defn")
                                                  where
                                                    innerString = fromLeft "" (
                                                      createMagmaInstanceOfNode nt 1)
createMagmaInstanceOfNode (FoldT _ _) _ = Left "FoldT must have a par of at least 1"
createMagmaInstanceOfNode ForkJoinT _ = Left "ForkJoin shouldn't be printed to magma"

type PortName = String
data Ports = Ports {
  inPorts :: [PortName],
  outPorts :: [PortName],
  ce :: [PortName],
  validPorts :: [PortName]
  }

mergePorts :: Ports -> Ports -> Ports
mergePorts ports1 ports2 = Ports allInPorts allOutPorts allCEPorts allValidPorts
  where
    allInPorts = (inPorts ports1) ++ (inPorts ports2)
    allOutPorts = (outPorts ports1) ++ (outPorts ports2)
    allCEPorts = (ce ports1) ++ (ce ports2)
    allValidPorts = (validPorts ports1) ++ (validPorts ports2)

binaryFunctionPorts fnName = Ports [fnName ++ ".I0", fnName ++ ".I1"] [fnName ++ ".O"] [] [] 

getPortNames :: NodeType -> String -> Int -> Either String Ports
getPortNames AbsT _ _ = Left "Abs node not implemented" 
getPortNames NotT fnName _ = Right $ Ports [fnName ++ "I"] [fnName ++ "O"] [] []
getPortNames NoopT _ _ = Left "NoOp shouldn't be printed to magma"
getPortNames AddT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames SubT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames DivT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames MulT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames MinT fnName _ = Left "Min node not implemented in magma" 
getPortNames MaxT fnName _ = Left "Max node not implemented in magma" 
getPortNames AshrT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames ShlT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames EqIntT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames NeqIntT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames LtIntT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames LeqIntT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames GtIntT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames GeqIntT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames AndT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames OrT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames XorT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames EqBitT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames NeqBitT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames LtBitT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames LeqBitT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames GtBitT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames GeqBitT fnName _ = Right $ binaryFunctionPorts fnName
getPortNames (LutGenIntT as) _ _ = Left "LUT not implemented in Magma"
getPortNames (LutGenBitT as) _ _ = Left "LUT not implemented in Magma"
getPortNames (ConstGenIntT x) fnName _ = Right $ Ports [] [fnName ++ ".O"] [] []
getPortNames (ConstGenBitT x) fnName _ = Right $ Ports [] [fnName ++ ".O"] [] []
-- can't upsample by less than 1
getPortNames (UpT _ _) _ _ = Left "Upsample not implemented yet for getPortNames"
getPortNames (DownT _ _) _ _ = Left "Downsample not implemented yet for getPortNames"
-- if the inner node doesn't work, just fail
getPortNames (FoldT nt totalLen) fnName par | par == totalLen = Right $
                                     Ports ([fnName ++ ".I.identity"] ++ inputsWithIndex) [fnName ++ ".out"] [] []
                                     where
                                       copiedInputs = replicate par (\x -> fnName ++ ".I.data[" ++ show x ++ "]") 
                                       inputsWithIndex :: [String]
                                       inputsWithIndex = zipWith (\f -> \x -> f x) copiedInputs [0..(par - 1)]

getPortNames (FoldT nt totalLen) fnName par | par > 1 = Right (
                                     Ports ([fnName ++ ".identity"] ++ inputsWithIndex) [fnName ++ ".O"] [] [fnName ++ ".valid"])
                                     where
                                       copiedInputs = replicate par (\x -> fnName ++ ".I[" ++ show x ++ "]") 
                                       inputsWithIndex :: [String]
                                       inputsWithIndex = zipWith (\f -> \x -> f x) copiedInputs [0..(par - 1)]

getPortNames (FoldT nt totalLen) fnName 1 = Right (
                                     Ports [fnName ++ ".I"] [fnName ++ ".out"] [] [fnName ++ ".valid"])
getPortNames (FoldT _ _) _ _ = Left "FoldT must have a par of at least 1"
getPortNames ForkJoinT _ _ = Left "ForkJoin shouldn't be printed to magma"
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
multiplyNodeThroughput n (NodeInfo nt@(FoldT _ _) numerator denominator children) =
  NodeInfo nt (numerator * n) denominator children
multiplyNodeThroughput n (NodeInfo nt numerator denominator children) =
  NodeInfo nt (numerator * n) denominator
  (fmap (multiplyNodeThroughput n) $ fst children,
   fmap (multiplyNodeThroughput n) $ snd children)

divideNodeThroughput :: Int -> NodeInfo -> NodeInfo
divideNodeThroughput n (NodeInfo nt@(FoldT _ _) numerator denominator children) =
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

  constGenIntC x _ = appendToPipeline (NodeInfo (ConstGenIntT x) 1 1 ([],[]))
  constGenBitC x _ = appendToPipeline (NodeInfo (ConstGenBitT x) 1 1 ([],[]))
  -- sequence operators
  -- need to fix upC to account for storage if tseq
  upC :: forall a n. (KnownNat n, KnownNat (TypeSize a), Typeable (Proxy a)) =>
    Proxy n -> Seq 1 a -> State PipelineDAG (Seq n a)
  upC amountProxy _ = appendToPipeline (NodeInfo (UpT (Proxy :: Proxy a)
                                                      (fromInteger $ natVal amountProxy))
                                                 1 1 ([],[]))
  downC :: forall a n o . (KnownNat n, KnownNat o, n ~ (o+1), KnownNat (TypeSize a), Typeable (Proxy a)) =>
    Proxy n -> (Seq n a) -> State PipelineDAG (Seq 1 a)
  downC amountProxy _ = appendToPipeline (NodeInfo (DownT (Proxy :: Proxy a)
                                                      (fromInteger $ natVal amountProxy))
                                                   1 1 ([],[]))

  foldC :: forall n o p a . (KnownNat n, KnownNat o, KnownNat p, p ~ (n*o),
            (KnownNat (TypeSize a))) =>
           Proxy o -> (Atom (Atom a, Atom a) -> State PipelineDAG (Atom a)) -> Atom a ->
           Seq p (Atom a) -> State PipelineDAG (Seq n (Atom a))
  foldC sublistLength f _ _ = do
    let innerPipeline = getInnerPipeline f emptyDAG
    let proxyNumToFold = Proxy :: Proxy o
    let numToFold = fromInteger $ natVal proxyNumToFold
    appendToPipeline (NodeInfo (FoldT (nodeType $ head innerPipeline) numToFold) 1 1 (innerPipeline, []))

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
    PipelineDAG priorStages <- get 
    let innerStages = getInnerPipeline f emptyDAG
    let innerLengthProxy = Proxy :: Proxy innerOutputLength
    let innerLength = (fromInteger $ natVal innerLengthProxy)
    let scheduledInnerStages = (fmap (multiplyNodeThroughput innerLength) innerStages)
    put $ PipelineDAG (priorStages ++ scheduledInnerStages)
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
    PipelineDAG priorStages <- get 
    let innerStages = getInnerPipeline f emptyDAG
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    let scheduledInnerStages = (fmap (divideNodeThroughput inputLength) innerStages)
    put $ PipelineDAG (priorStages ++ scheduledInnerStages)
    return undefined

  -- ignore the seq since it does nothing and tseq did nothing as well 
  tseq_to_seqC f _ = appendInnerDAGToOuterDAG f

  seq_to_sseqC :: forall inputLength outputLength a b .
                  (KnownNat inputLength, KnownNat outputLength) =>
                  (Seq inputLength a -> State PipelineDAG (Seq outputLength b)) ->
                  SSeq inputLength a -> State PipelineDAG (SSeq outputLength b)
  seq_to_sseqC f _ = do
    PipelineDAG priorStages <- get 
    let innerStages = getInnerPipeline f emptyDAG
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    let scheduledInnerStages = (fmap (multiplyNodeThroughput inputLength) innerStages)
    put $ PipelineDAG (priorStages ++ scheduledInnerStages)
    return undefined

  seq_to_tseqC f _ = appendInnerDAGToOuterDAG f

  -- this is almost same as sseq_to_seq as tseq and seq both don't change parallelism
  sseq_to_tseqC :: forall inputLength outputLength a b u v .
                   (KnownNat inputLength, KnownNat outputLength) =>
    Proxy v -> Proxy u -> (SSeq inputLength a -> State PipelineDAG (SSeq outputLength b)) ->
    TSeq inputLength v a -> State PipelineDAG (TSeq outputLength u b)
  sseq_to_tseqC _ _ f _ = do
    PipelineDAG priorStages <- get 
    let innerStages = getInnerPipeline f emptyDAG
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    let scheduledInnerStages = (fmap (divideNodeThroughput inputLength) innerStages)
    put $ PipelineDAG (priorStages ++ scheduledInnerStages)
    return undefined

  -- this is almost same as seq_to_sseq as tseq and seq both don't change parallelism
  tseq_to_sseqC :: forall inputLength outputLength a b u v .
                   (KnownNat inputLength, KnownNat outputLength) =>
    (TSeq inputLength v a -> State PipelineDAG (TSeq outputLength u b)) ->
    SSeq inputLength a -> State PipelineDAG (SSeq outputLength b)
  tseq_to_sseqC f _ = do 
    PipelineDAG priorStages <- get 
    let innerStages = getInnerPipeline f emptyDAG
    let inputLengthProxy = Proxy :: Proxy inputLength 
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    let scheduledInnerStages = (fmap (multiplyNodeThroughput inputLength) innerStages)
    put $ PipelineDAG (priorStages ++ scheduledInnerStages)
    return undefined

  underutilC :: forall n v o u a b underutilMult .
                (KnownNat n, KnownNat v, KnownNat o, KnownNat u,
                 KnownNat underutilMult, 1 <= underutilMult) => 
    Proxy underutilMult -> (TSeq n v a -> State PipelineDAG (TSeq o u b)) ->
    TSeq n ((n + v) * underutilMult) a -> State PipelineDAG (TSeq o ((o + u) * underutilMult) b)
  underutilC underutilProxy f _ = do 
    PipelineDAG priorStages <- get 
    let innerStages = getInnerPipeline f emptyDAG
    let underutilAmount = (fromInteger $ natVal underutilProxy)
    let scheduledInnerStages = (fmap (divideNodeThroughput underutilAmount) innerStages)
    put $ PipelineDAG (priorStages ++ scheduledInnerStages)
    return undefined
-- examples of programs in space and time
-- iterInput = Seq $ V.fromTuple ((Int 1, Int 2), (Int 3, Int 4), (Int 5, Int 6), (Int 7, Int 8))
-- replace unscheduledCirc with this one to see a composition
{-
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
parallelResult = simulate $ seq_to_sseqC unscheduledCirc $ to iterInput
partialParallelInput :: TSeq 2 0 (SSeq 2 (Atom, Atom))
partialParallelInput = seqToTSeq $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq (Proxy @2) iterInput
partialParallelResult =
  simulate $
  (seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledCirc) $
  partialParallelInput
-}

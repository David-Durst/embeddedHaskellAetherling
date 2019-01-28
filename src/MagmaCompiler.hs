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
import Control.Monad.Except
import Control.Monad.Identity
import Data.Typeable
import Data.Either
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V

magmaNodeBaseName = "magmaInstance"

copyStringWithInt :: Int -> (Int -> String) -> String
copyStringWithInt numCopies stringGenerator =
  foldl (++) "" $ fmap stringGenerator [0..(numCopies-1)]

-- left string is an error, right string is a valid result
-- first int is the index, second is the parallelism
duplicateAndInstantiateNode :: NodeType -> Int -> Either String String
-- up, down, and fold handle their own parallelization, so nothing to do here
duplicateAndInstantiateNode x@(UpT _ _) par = createMagmaDefOfNode x par
duplicateAndInstantiateNode x@(DownT _ _) par = createMagmaDefOfNode x par
duplicateAndInstantiateNode x@(FoldT _ _) par = createMagmaDefOfNode x par
-- otherwise, duplicate if success (if right), and propagate error if failure
duplicateAndInstantiateNode nodeType par |
  isRight (createMagmaDefOfNode nodeType par) =
  Right $ copyStringWithInt par $
  \x -> magmaNodeBaseName ++ show x ++ " = " ++
        (fromRight "" $ createMagmaDefOfNode nodeType par) ++ "()\n"
duplicateAndInstantiateNode nodeType par = createMagmaDefOfNode nodeType par

-- left string is an error, right string is a valid result
-- first int is the index, second is the parallelism
createMagmaDefOfNode :: NodeType -> Int -> Either String String
createMagmaDefOfNode AbsT _ = Left "Abs node not implemented" 
createMagmaDefOfNode NotT _ = Right "DefineNegate(8)"
createMagmaDefOfNode NoopT _ = Left "NoOp shouldn't be printed to magma"
createMagmaDefOfNode AddT _ = Right "DefineAdd(8)"
createMagmaDefOfNode SubT _ = Right "DefineSub(8)"
createMagmaDefOfNode DivT _ = Right "DefineCoreirUDiv(8)"
createMagmaDefOfNode MulT _ = Right "DefineCoreirMul(8)"
createMagmaDefOfNode MinT _ = Left "Min node not implemented in magma" 
createMagmaDefOfNode MaxT _ = Left "Max node not implemented in magma" 
createMagmaDefOfNode AshrT _ = Right "DefineASR(8)"
createMagmaDefOfNode ShlT _ = Right "DefineLSL(8)"
createMagmaDefOfNode EqIntT _ = Right "DefineEQ(8)"
createMagmaDefOfNode NeqIntT _ = Right "DefineNE(8)"
createMagmaDefOfNode LtIntT _ = Right "DefineULT(8)"
createMagmaDefOfNode LeqIntT _ = Right "DefineULE(8)"
createMagmaDefOfNode GtIntT _ = Right "DefineUGT(8)"
createMagmaDefOfNode GeqIntT _ = Right "DefineUGE(8)" 
createMagmaDefOfNode AndT _ = Right "DefineAnd(8)"
createMagmaDefOfNode OrT _ = Right "DefineOr(8)"
createMagmaDefOfNode XorT _ = Right "DefineXOr(8)"
createMagmaDefOfNode EqBitT _ = Right "DefineEQ(1)"
createMagmaDefOfNode NeqBitT _ = Right "DefineNE(1)"
createMagmaDefOfNode LtBitT _ = Right "DefineULT(1)"
createMagmaDefOfNode LeqBitT _ = Right "DefineULE(1)"
createMagmaDefOfNode GtBitT _ = Right "DefineUGT(1)"
createMagmaDefOfNode GeqBitT _ = Right "DefineUGE(1)" 
createMagmaDefOfNode (LutGenIntT as) _ = Left "LUT not implemented in Magma"
createMagmaDefOfNode (LutGenBitT as) _ = Left "LUT not implemented in Magma"
createMagmaDefOfNode (ConstGenIntT x) _ = Right ("DefineCoreirConst(" ++
  show intSizeInBits ++ ", " ++ show x ++ ")")
createMagmaDefOfNode (ConstGenBitT x) _ = Right ("DefineCoreirConst(" ++
  show bitSizeInBits ++ ", " ++ show x ++ ")")
createMagmaDefOfNode (UpT proxy upAmount) par | par == upAmount = Right (
                                                     "DefineUpsampleParallel(" ++
                                                     show par ++ ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
createMagmaDefOfNode (UpT proxy upAmount) par | par > 1 = Left (
                                                   "Upsample partially parallel not implemented in Magma")
createMagmaDefOfNode (UpT proxy upAmount) 1 = Right (
                                                     "DefineUpsampleSequential(" ++
                                                     "cirb, " ++ show upAmount ++
                                                     ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
-- can't upsample by less than 1
createMagmaDefOfNode (UpT _ _) _ = Left "Upsample must have a par of at least 1"
createMagmaDefOfNode (DownT proxy upAmount) par | par == upAmount = Right (
                                                     "DefineDownsampleParallel(" ++
                                                     "cirb, " ++ show par ++ ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
createMagmaDefOfNode (DownT proxy upAmount) par | par > 1 = Left (
                                                   "Downsample partially parallel not implemented in Magma")
createMagmaDefOfNode (DownT proxy upAmount) 1 = Right (
                                                     "DefineDownsampleSequential(" ++
                                                     show upAmount ++
                                                     ", " ++ 
                                                     (typeToMagmaString $ typeOf proxy) ++
                                                     ")")
-- can't upsample by less than 1
createMagmaDefOfNode (DownT _ _) _ = Left "Downsample must have a par of at least 1"
-- if the inner node doesn't work, just fail
createMagmaDefOfNode (FoldT nt totalLen) par |
  isLeft (createMagmaDefOfNode nt 1) = createMagmaDefOfNode nt 1
createMagmaDefOfNode (FoldT nt totalLen) par | par == totalLen = Right (
                                                     "ReduceParallel(" ++
                                                     "cirb, " ++ show par ++ ", " ++ 
                                                     "renameCircuitForReduce(" ++
                                                     innerString ++ ")).defn")
                                                  where
                                                    innerString = fromLeft "" (
                                                      createMagmaDefOfNode nt 1)
createMagmaDefOfNode (FoldT nt totalLen) par | par > 1 = Right (
                                                     "DefineReducePartiallyParallel(" ++
                                                     "cirb, " ++ show totalLen ++ ", " ++ 
                                                     show par ++ ", " ++
                                                     innerString ++ ")()")
                                                  where
                                                    innerString = fromLeft "" (
                                                      createMagmaDefOfNode nt 1)
createMagmaDefOfNode (FoldT nt totalLen) 1 = Right (
                                                     "ReduceSequential(" ++
                                                     "cirb, " ++ show totalLen ++ ", " ++ 
                                                     "renameCircuitForReduce(" ++
                                                     innerString ++ ")).defn")
                                                  where
                                                    innerString = fromLeft "" (
                                                      createMagmaDefOfNode nt 1)
createMagmaDefOfNode (FoldT _ _) _ = Left "FoldT must have a par of at least 1"
createMagmaDefOfNode ForkJoinT _ = Left "ForkJoin shouldn't be printed to magma"

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

-- get duplicated ports for parallel versions of nodes
getDuplicatedPorts :: NodeType -> Int -> Either String Ports
getDuplicatedPorts nodeType@(UpT _ _) par = getPortNames nodeType magmaNodeBaseName par
getDuplicatedPorts nodeType@(DownT _ _) par = getPortNames nodeType magmaNodeBaseName par
getDuplicatedPorts nodeType@(FoldT _ _) par = getPortNames nodeType magmaNodeBaseName par
getDuplicatedPorts nodeType par |
  isRight (getPortNames nodeType magmaNodeBaseName par) =
  Right $ Ports allNodesInPorts allNodesOutPorts allNodesCEPorts allNodesValidPorts
  where
    allNodesPorts = fmap (\idx -> fromRight undefined $ getPortNames nodeType ("magmaInstance" ++ show idx)
                           par) [0..(par - 1)]
    allNodesInPorts = foldl (++) [] $ fmap inPorts allNodesPorts
    allNodesOutPorts = foldl (++) [] $ fmap outPorts allNodesPorts
    allNodesCEPorts = foldl (++) [] $ fmap ce allNodesPorts
    allNodesValidPorts = foldl (++) [] $ fmap validPorts allNodesPorts
getDuplicatedPorts nodeType par = getPortNames nodeType magmaNodeBaseName par

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
data CompilationData = CompilationData {
  -- this tracks the number of nodes created
  -- each nodes magma name is appended with its index
  -- to ensure no duplicate python variable names
  nodeIndex :: Int,
  -- list of strings in reverse of Magma code
  -- reversed as prepend is cheaper
  reversedOutputText :: [String],
  -- the input ports to the circuit
  -- this is NOT REVERSED
  inputPorts :: [PortName],
  -- the output ports, used to wire up adjacent nodes
  -- this is NOT REVERSED
  outputPorts :: [PortName],
  -- list of valid ports with last in DAG
  -- as the last element
  reversedValidPorts :: [PortName],
  -- this tracks how parallel to make everything in the subpart
  throughputNumerator :: Int,
  throughputDenominator :: Int
  }
  deriving Show

multiplyThroughput :: Int -> CompilationData -> CompilationData
multiplyThroughput n compData =
  compData { throughputNumerator = n * (throughputNumerator compData) }


divideThroughput :: Int -> CompilationData -> CompilationData
divideThroughput n compData =
  compData { throughputDenominator = n * (throughputDenominator compData) }

emptyCompData :: CompilationData
emptyCompData = CompilationData 0 [] [] [] [] 1 1

validCircuitInterfaceString =
  "args = ['I', inType, 'O', outType, 'valid', Out(Bit)] + ClockInterface(False, False)\n"
noValidCircuitInterfaceString =
  "args = ['I', inType, 'O', outType] + ClockInterface(False, False)\n"

type StatefulErrorMonad a = StateT CompilationData (ExceptT String Identity) a

buildCompilationData :: (a -> StatefulErrorMonad b) -> CompilationData
buildCompilationData functionYieldingMonad = getErrorOrCompDataAsCompData $
  runIdentity $ runExceptT $ runStateT (functionYieldingMonad undefined) emptyCompData 
  where
    getErrorOrCompDataAsCompData :: Either String (b, CompilationData) -> CompilationData
    getErrorOrCompDataAsCompData (Left s) = emptyCompData { reversedOutputText = [s] }
    getErrorOrCompDataAsCompData (Right (_, compData)) = compData

writeProgramToFile :: forall a b . (Typeable (Proxy a), Typeable (Proxy b)) =>
  String -> String -> String -> (a -> StatefulErrorMonad b) -> IO ()
writeProgramToFile preludeLocation epilogueLocation outputLocation program = do
  let compData = buildCompilationData program
  preludeString <- readFile preludeLocation
  epilogueString <- readFile epilogueLocation
  let inputType = typeToMagmaString $ typeOf (Proxy :: Proxy a)
  let inputTypeString = "inType = In(" ++ inputTypeString ++ ")\n"
  let outputType = typeToMagmaString $ typeOf (Proxy :: Proxy b)
  let outputTypeString = "outType = Out(" ++ inputTypeString ++ ")\n"
  let interfaceString = (if (not $ null $ reversedValidPorts compData)
                         then validCircuitInterfaceString
                         else noValidCircuitInterfaceString)
  writeFile outputLocation (preludeString ++ inputTypeString ++
                            outputTypeString ++ interfaceString ++
                            (foldl (++) "" $ reverse $ reversedOutputText compData) ++
                           epilogueString)

-- this returns the wire calls in reverse order so they can be prepended to the
-- out text
wirePorts :: [PortName] -> [PortName] -> Either String [String]
wirePorts priorOutPorts nextInPorts |
  length priorOutPorts == length nextInPorts = Right wireStrings
  where
    portPairs = reverse $ zip priorOutPorts nextInPorts
    wireStrings = fmap (\(outName, inName) -> "wire(" ++ outName ++ ", " ++
                         inName ++ ")") portPairs
wirePorts priorOutPorts nextInPorts = Left ("Different lengths of ports " ++
                                            show priorOutPorts ++
                                            " and " ++
                                            show nextInPorts)

-- given a compilation data for a new stage, append it to the state
-- for a set of existing stages
appendToCompilationData :: CompilationData -> StatefulErrorMonad a
appendToCompilationData (CompilationData ni rot ip op rvp tNum tDenom) = do  
    priorData <- get 
    let portWirings = wirePorts (outputPorts priorData) ip
    if isLeft portWirings
      then liftEither portWirings
      else do
        let newOutText = rot ++ reversedOutputText priorData
        let newInPorts = if (null $ (inputPorts priorData))
                            then ip else inputPorts priorData
        let newOutPorts = op
        let newReversedValidPorts = rvp ++ reversedValidPorts priorData
        -- just propagate throughput numerator and denominator 
        -- as those are only modififed by scheduling combiators that are
        -- parents, and this is for combining siblines
        -- section as we are going along 
        let newThroughputNumerator = throughputNumerator priorData
        let newThroughputDenominator = throughputDenominator priorData
        put $ (CompilationData ni newOutText newInPorts newOutPorts
              newReversedValidPorts newThroughputNumerator newThroughputDenominator)
        return undefined
    return undefined

{-
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
-}
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

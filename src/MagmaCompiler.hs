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
import Debug.Trace
import MagmaNodeTextGenerator
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V


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
  inputPortsTypes :: [(TypeRep, Int)],
  -- the output ports, used to wire up adjacent nodes
  -- this is NOT REVERSED
  outputPorts :: [PortName],
  outputPortsTypes :: [(TypeRep, Int)],
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
emptyCompData = CompilationData 0 [] [] [] [] [] [] 1 1

circuitInterfaceString inTypesString outTypesString hasValid =
  startOfInterface ++ inTypesString ++ outTypesString ++ validStr ++ endOfInterface
  where
    startOfInterface = "args = ["
    endOfInterface = "]"
    validStr = if hasValid then "'valid', Out(Bit)," else ""

type StatefulErrorMonad = StateT CompilationData (ExceptT String Identity) 

buildCompilationData :: (a -> StatefulErrorMonad b) -> CompilationData
buildCompilationData functionYieldingMonad = getErrorOrCompDataAsCompData $
  runIdentity $ runExceptT $ runStateT (functionYieldingMonad undefined) emptyCompData 
  where
    getErrorOrCompDataAsCompData :: Either String (b, CompilationData) -> CompilationData
    getErrorOrCompDataAsCompData (Left s) = emptyCompData { reversedOutputText = [s] }
    getErrorOrCompDataAsCompData (Right (_, compData)) = compData

getModulePortsString :: String -> [(TypeRep, Int)] -> String
getModulePortsString baseString ports = foldl (++) "" portsStrings
  where
    portsWithIdxs = zip ports [0..(length ports - 1)]
    portsStrings = fmap (\(port, idx) ->
                           "'I'" ++ show idx ++ ", " ++ typeToMagmaString port ++ ", ")
                   portsWithIdxs
    

writeProgramToFile :: forall a b . (Typeable (Proxy a), Typeable (Proxy b)) =>
  String -> String -> String -> (a -> StatefulErrorMonad b) -> IO ()
writeProgramToFile preludeLocation epilogueLocation outputLocation program = do
  let compData = buildCompilationData program
  preludeString <- readFile preludeLocation
  epilogueString <- readFile epilogueLocation
  let inputTypeString = getModulePortsString "I" $ inputPortsTypes compData
  let outputTypeString = getModulePortsString "O" $ outputPortsTypes compData
  let interfaceString = (circuitInterfaceString inputTypeString
                         outputTypeString (not $ null $ reversedValidPorts compData))
  let circuitDefinition = "testcircuit = DefineCircuit('Test_Haskell_Circuit', *args)" 
  let wireInterfaceString = wireInterface "testcircuit" (inputPorts compData) (outputPorts compData)
  traceM "howdy"
  let upToBodyString = preludeString ++ inputTypeString ++
                       outputTypeString ++ interfaceString 
  traceM upToBodyString
  let bodyString = (foldl (++) "" $ reverse $ reversedOutputText compData) 
  traceM bodyString
  let outputString = (preludeString ++ inputTypeString ++
                      outputTypeString ++ interfaceString ++
                      (foldl (++) "" $ reverse $ reversedOutputText compData) ++
                      wireInterfaceString ++ epilogueString)
  traceM outputString
  writeFile outputLocation outputString

-- this returns the wire calls in reverse order so they can be prepended to the
-- out text
wirePorts :: [PortName] -> [PortName] -> Either String [String]
wirePorts priorOutPorts nextInPorts |
  length priorOutPorts == length nextInPorts = Right wireStrings
  where
    portPairs = reverse $ zip priorOutPorts nextInPorts
    wireStrings = fmap (\(outName, inName) -> "wire(" ++ outName ++ ", " ++
                         inName ++ ")\n") portPairs
wirePorts priorOutPorts nextInPorts = Left ("Different lengths of ports " ++
                                            show priorOutPorts ++
                                            " and " ++
                                            show nextInPorts)

wireInterface :: String -> [PortName] -> [PortName] -> String
wireInterface moduleName inputPorts outputPorts = foldl (++) "" $ 
  wireStrings "I" inputPortsWithIdxs ++ wireStrings "O" outputPortsWithIdxs
  where
    inputPortsWithIdxs = zip inputPorts [0..(length inputPorts - 1)]
    outputPortsWithIdxs = zip outputPorts [0..(length outputPorts - 1)]
    wireStrings baseString portsWithIdxs = fmap (\(inName, idx) -> "wire(" ++
                                                  moduleName ++ "." ++ baseString ++
                                                  show idx ++ ", " ++ inName ++ ")\n")
                                           portsWithIdxs

-- given a compilation data for a new stage, append it to the state
-- for a set of existing stages
appendToCompilationData :: CompilationData -> StatefulErrorMonad a
appendToCompilationData dd@(CompilationData ni rot ip it op ot rvp tNum tDenom) = do  
    priorData <- get 
    --traceM ("Old data" ++ show priorData)
    --traceM ("New data" ++ show dd)
    let portWirings = if (null $ (reversedOutputText priorData))
                       then Right [] else wirePorts (outputPorts priorData) ip
    if isLeft portWirings
      then liftEither portWirings
      else do
      let portWiringsStrings = fromRight [] portWirings
      let newOutText = portWiringsStrings ++ rot ++ reversedOutputText priorData
      let newInPorts = if (null $ (reversedOutputText priorData))
                       then ip else inputPorts priorData
      let newInTypes = if (null $ (reversedOutputText priorData))
                        then it else inputPortsTypes priorData
      let newOutPorts = op
      let newOutTypes = ot
      let newReversedValidPorts = rvp ++ reversedValidPorts priorData
      -- just propagate throughput numerator and denominator 
      -- as those are only modififed by scheduling combiators that are
      -- parents, and this is for combining siblines
      -- section as we are going along 
      let newThroughputNumerator = throughputNumerator priorData
      let newThroughputDenominator = throughputDenominator priorData
      put $ (CompilationData (ni+1) newOutText newInPorts newInTypes newOutPorts
            newOutTypes newReversedValidPorts newThroughputNumerator
            newThroughputDenominator)
      return undefined
    return undefined

createCompilationDataAndAppend :: NodeType -> StatefulErrorMonad a
createCompilationDataAndAppend nodeType = do
    priorData <- get
    let curNodeIndex = nodeIndex priorData
    let par = throughputNumerator priorData `div` throughputDenominator priorData
    let magmaInstances = duplicateAndInstantiateNode nodeType curNodeIndex par 
    --traceM ("nodeType" ++ show nodeType)
    --traceM ("par" ++ show par)
    --traceM ("curNodeIndex" ++ show curNodeIndex)
    --traceM ("magmaInstances" ++ show magmaInstances)
    if isLeft magmaInstances
      then do
      liftEither magmaInstances
      return undefined
      else do
      let ports = getDuplicatedPorts nodeType curNodeIndex par
      if isLeft ports
        then do
        liftEither ports
        return undefined
        else do
        let instancesValues = fromRight undefined magmaInstances
        let portsValues = fromRight undefined ports
        --traceM ("instanceValues" ++ show instancesValues)
        appendToCompilationData (CompilationData curNodeIndex
                                [instancesValues] (inPorts portsValues)
                                (inTypes portsValues)
                                (outPorts portsValues) 
                                (outTypes portsValues)
                                (validPorts portsValues)
                                (throughputNumerator priorData)
                                (throughputDenominator priorData))
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
-}
instance Circuit (StatefulErrorMonad) where
  -- unary operators
  absC _ = createCompilationDataAndAppend AbsT 
  notC _ = createCompilationDataAndAppend NotT
  noop c = return undefined

  -- binary operators
  -- the values returned here, they are only to emit things of the right types
  -- so the state computations can occur
  addC _ = createCompilationDataAndAppend AddT
  subC _ = createCompilationDataAndAppend SubT
  mulC _ = createCompilationDataAndAppend MulT
  divC _ = createCompilationDataAndAppend DivT
{-
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
-}
  -- module generator
  lutGenIntC as _ = createCompilationDataAndAppend (LutGenIntT as)
  lutGenBitC as _ = createCompilationDataAndAppend (LutGenBitT as) 
  constGenIntC x _ = createCompilationDataAndAppend (ConstGenIntT x)
  constGenBitC x _ = createCompilationDataAndAppend (ConstGenBitT x)
{-
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
-}
  -- ignore the iter since it does nothing, needs to be wrapped with a tseq or
  -- sseq converting function
  iterC _ f _ = do
    -- this should run f to have it update the state, then do nothing
    f undefined
    return undefined
  (f *** g) _ = do
    priorData <- get
    let tNum = throughputNumerator priorData
    let tDenom = throughputDenominator priorData
    let firstNodeIndex = nodeIndex priorData
    -- this has to have no prior text. appendToCompilationData 
    -- checks if prior text exists to see if inputPorts are inputPorts
    -- for modules. fPipeline and gPipeline are supposed to be
    -- independent pipelines which then get merged into the larger pipelines
    -- thus, no prior text so that their inputPorts are inputPorts for their
    -- modules
    let cData = emptyCompData { throughputNumerator = tNum,
                                throughputDenominator = tDenom,
                                nodeIndex = firstNodeIndex
                                }
    let fPipeline = runIdentity $ runExceptT $ (runStateT
          (f undefined) cData)
    --traceM $ "cData in for fpipeline " ++ show cData
    let secondNodeIndex = nodeIndex $ snd $ fromRight (undefined, emptyCompData) fPipeline
    -- this is not good type safety, unpack 
    let gPipeline = runIdentity $ runExceptT $ (runStateT
          (f undefined) (cData { nodeIndex = secondNodeIndex}))
    let errorMessages = fmap (fromLeft "") $ filter isLeft [fPipeline, gPipeline]
    if null errorMessages
      then do
      let fCompilerData = snd $ fromRight undefined fPipeline
      let gCompilerData = snd $ fromRight undefined gPipeline
      --traceM $ "f compilation: " ++ show fCompilerData
      --traceM $ "g compilation: " ++ show gCompilerData
      let mergedCompilerData = (CompilationData
                               -- subtract 1 here as g compiler data's
                               -- node index is incremented by 1 for the
                               -- next node, and then appendToCompilationData
                               -- will increment again. -1 to prevent double
                               -- counting.
                               (nodeIndex gCompilerData - 1)
                               (reversedOutputText gCompilerData ++
                                 reversedOutputText fCompilerData)
                               (inputPorts fCompilerData ++ inputPorts gCompilerData)
                               (inputPortsTypes fCompilerData ++ inputPortsTypes gCompilerData)
                               (outputPorts fCompilerData ++ outputPorts gCompilerData)
                               (outputPortsTypes fCompilerData ++ outputPortsTypes gCompilerData)
                               (reversedValidPorts fCompilerData ++
                                 reversedValidPorts gCompilerData)
                               tNum tDenom
                               )
      appendToCompilationData mergedCompilerData
      else do
      liftEither $ Left $ foldl (++) "" errorMessages
      return undefined
      

  (f >>> g) _ = do
    f undefined
    g undefined

  -- scheduling operators
  split_seq_to_sseqC :: forall totalInputLength totalOutputLength outerLength
                        innerInputLength innerOutputLength a b .
                        (KnownNat totalInputLength, KnownNat totalOutputLength,
                         KnownNat outerLength, KnownNat innerInputLength,
                         KnownNat innerOutputLength,
                         totalInputLength ~ (outerLength*innerInputLength),
                         totalOutputLength ~ (outerLength*innerOutputLength)) =>
                        Proxy outerLength ->
    (Seq totalInputLength a -> StatefulErrorMonad (Seq totalOutputLength b)) ->
    (Seq outerLength (SSeq innerInputLength a) ->
      StatefulErrorMonad (Seq outerLength (SSeq innerOutputLength b)))
  split_seq_to_sseqC _ f _ = do
    priorData <- get 
    let innerLengthProxy = Proxy :: Proxy innerOutputLength
    let innerLength = (fromInteger $ natVal innerLengthProxy)
    put $ multiplyThroughput innerLength priorData
    f undefined
    dataPostInnerPipeline <- get
    put $ divideThroughput innerLength dataPostInnerPipeline
    return undefined
    
  -- ignore the tseq since it does nothing, its the same as an iter, just chewing
  -- up iterations that don't need to be parallelized
  split_seq_to_tseqC _ f _ = do
    f undefined
    -- this is just a trick toget the return types to match, since the
    -- type system thinks we need a seq of f's, but f is just producing state
    -- when it runs
    return undefined

  -- since getting rid of sseq, undo parallelism
  sseq_to_seqC :: forall a b inputLength outputLength .
                  (KnownNat inputLength, KnownNat outputLength) =>
                  (SSeq inputLength a -> StatefulErrorMonad (SSeq outputLength b)) ->
                  Seq inputLength a -> StatefulErrorMonad (Seq outputLength b)
  sseq_to_seqC f _ = do 
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ divideThroughput inputLength priorData
    f undefined
    dataPostInnerPipeline <- get
    put $ multiplyThroughput inputLength dataPostInnerPipeline
    return undefined

  -- ignore the seq since it does nothing and tseq did nothing as well 
  tseq_to_seqC f _ = do
    f undefined
    return undefined

  seq_to_sseqC :: forall inputLength outputLength a b .
                  (KnownNat inputLength, KnownNat outputLength) =>
                  (Seq inputLength a -> StatefulErrorMonad (Seq outputLength b)) ->
                  SSeq inputLength a -> StatefulErrorMonad (SSeq outputLength b)
  seq_to_sseqC f _ = do
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ multiplyThroughput inputLength priorData
    --traceM $ "PriorData " ++ show priorData
    f undefined
    dataPostInnerPipeline <- get
    --traceM $ "dataPostInnerPipeline " ++ show dataPostInnerPipeline
    put $ divideThroughput inputLength dataPostInnerPipeline 
    return undefined

  seq_to_tseqC f _ = do
    f undefined
    return undefined

  -- this is almost same as sseq_to_seq as tseq and seq both don't change parallelism
  sseq_to_tseqC :: forall inputLength outputLength a b u v .
                   (KnownNat inputLength, KnownNat outputLength) =>
    Proxy v -> Proxy u -> (SSeq inputLength a -> StatefulErrorMonad (SSeq outputLength b)) ->
    TSeq inputLength v a -> StatefulErrorMonad (TSeq outputLength u b)
  sseq_to_tseqC _ _ f _ = do
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ divideThroughput inputLength priorData
    f undefined
    dataPostInnerPipeline <- get
    put $ multiplyThroughput inputLength dataPostInnerPipeline
    return undefined

  -- this is almost same as seq_to_sseq as tseq and seq both don't change parallelism
  tseq_to_sseqC :: forall inputLength outputLength a b u v .
                   (KnownNat inputLength, KnownNat outputLength) =>
    (TSeq inputLength v a -> StatefulErrorMonad (TSeq outputLength u b)) ->
    SSeq inputLength a -> StatefulErrorMonad (SSeq outputLength b)
  tseq_to_sseqC f _ = do 
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ multiplyThroughput inputLength priorData
    f undefined
    dataPostInnerPipeline <- get
    put $ divideThroughput inputLength dataPostInnerPipeline
    return undefined

  underutilC :: forall n v o u a b underutilMult .
                (KnownNat n, KnownNat v, KnownNat o, KnownNat u,
                 KnownNat underutilMult, 1 <= underutilMult) => 
    Proxy underutilMult -> (TSeq n v a -> StatefulErrorMonad (TSeq o u b)) ->
    TSeq n ((n + v) * underutilMult) a -> StatefulErrorMonad (TSeq o ((o + u) * underutilMult) b)
  underutilC underutilProxy f _ = do 
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy underutilMult
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ divideThroughput inputLength priorData
    f undefined
    dataPostInnerPipeline <- get
    put $ multiplyThroughput inputLength dataPostInnerPipeline
    return undefined
-- examples of programs in space and time
-- iterInput = Seq $ V.fromTuple ((Int 1, Int 2), (Int 3, Int 4), (Int 5, Int 6), (Int 7, Int 8))
-- replace unscheduledCirc with this one to see a composition

unscheduledPipeline = iterC (Proxy @4) $ (constGenIntC (Int 3) *** constGenIntC (Int 2)) >>> addC
unscheduledNode = iterC (Proxy @4) $ addC

unscheduledPipelineCData = buildCompilationData unscheduledPipeline
unscheduledNodeCData = buildCompilationData unscheduledNode 

sequentialPipelineCData = buildCompilationData $ seq_to_tseqC unscheduledPipeline 
sequentialNodeCData = buildCompilationData $ seq_to_tseqC unscheduledNode

parallelPipelineCData = buildCompilationData $ seq_to_sseqC unscheduledPipeline 
parallelNodeCData = buildCompilationData $ seq_to_sseqC unscheduledNode

partialParallelPipelineCData = buildCompilationData $ seq_to_tseqC $ split_seq_to_sseqC (Proxy @2)
  unscheduledPipeline 
partialParallelNodeCData = buildCompilationData $ seq_to_tseqC $ split_seq_to_sseqC (Proxy @2)
  unscheduledNode
{-
parallelResult = simulate $ seq_to_sseqC unscheduledCirc $ to iterInput
partialParallelInput :: TSeq 2 0 (SSeq 2 (Atom, Atom))
partialParallelInput = seqToTSeq $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq (Proxy @2) iterInput
partialParallelResult =
  simulate $
  (seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledCirc) $
  partialParallelInput
-}

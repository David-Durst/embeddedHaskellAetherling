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
import LineBuffer
import Data.List
import ReadyValid
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V


-- This is all the info about a dag necessary to compile it to Magma
data CompilationData = CompilationData {
  -- this tracks the number of nodes created
  -- each nodes magma name is appended with its index
  -- to ensure no duplicate python variable names
  nodeIndex :: Int,
  -- the list of nodes in this dag
  -- this won't track for the nodes that don't have node types
  nodeTypes :: [NodeType],
  outputText :: [String],
  -- the input ports to the circuit
  inputPorts :: [PortName],
  -- the int was supposed to be if these ports
  -- need to be wrapped in an array. But that is actually
  -- not done since all ports are flattened. Future
  -- code revision is to make this (and outputPortsTypes)
  -- just [TypeRep]
  inputPortsTypes :: [(TypeRep, Int)],
  -- the output ports, used to wire up adjacent nodes
  outputPorts :: [PortName],
  outputPortsTypes :: [(TypeRep, Int)],
  -- this represents the ready, valid, and CE ports
  -- of the entire dag rather than just the interface edges
  -- like the inputPorts and outputPorts
  entireDAGControlPorts :: [ControlPorts],
  -- this tracks how parallel to make everything in the subpart
  throughputNumerator :: Int,
  throughputDenominator :: Int
  -- this tracks how many clock cycle delays prior stages have added
  -- priorDelay :: Int
  }
  deriving Show

parDiv :: Int -> Int -> Int
parDiv n d = max (n `div` d) 1

multiplyThroughput :: Int -> CompilationData -> CompilationData
multiplyThroughput n compData =
  compData { throughputNumerator = n * (throughputNumerator compData) }

divideThroughput :: Int -> CompilationData -> CompilationData
divideThroughput n compData =
  compData { throughputDenominator = n * (throughputDenominator compData) }

emptyCompData :: CompilationData
emptyCompData = CompilationData 0 [] [] [] [] [] [] [] 1 1

valid_data_in_str = "valid_data_in"
valid_data_out_str = "valid_data_out"
ready_data_in_str = "ready_data_in"
ready_data_out_str = "ready_data_out"

circuitInterfaceString inTypesString outTypesString =
  startOfInterface ++ inTypesString ++ outTypesString ++ validStr ++ endOfInterface
  where
    startOfInterface = "args = ["
    endOfInterface = "] + ClockInterface(has_ce=True)\n"
    validInStr = "'" ++ valid_data_in_str ++ "', In(Bit), '" ++ ready_data_in_str ++
      "', Out(Bit), "
    validOutStr = "'" ++ valid_data_out_str ++ "', Out(Bit), '" ++ ready_data_out_str ++
      "', In(Bit), "
    validStr = validInStr ++ validOutStr


type StatefulErrorMonad = StateT CompilationData (ExceptT String Identity) 

buildCompilationData :: (a -> StatefulErrorMonad b) -> CompilationData
buildCompilationData functionYieldingMonad = getErrorOrCompDataAsCompData $
  runIdentity $ runExceptT $ runStateT (functionYieldingMonad undefined) emptyCompData 
  where
    getErrorOrCompDataAsCompData :: Either String (b, CompilationData) -> CompilationData
    getErrorOrCompDataAsCompData (Left s) = emptyCompData { outputText = [s] }
    getErrorOrCompDataAsCompData (Right (_, compData)) = compData

getModulePortsString :: Bool -> String -> [(TypeRep, Int)] -> String
getModulePortsString isInput baseString ports = foldl (++) "" portsStrings
  where
    portsWithIdxs = zip ports [0..(length ports - 1)]
    portsStrings = fmap (\(port, idx) ->
                           "'" ++ baseString ++ show idx ++ "', " ++
                           typeToMagmaString isInput port ++ ", ")
                   portsWithIdxs

saveToCoreIR :: String -> String
saveToCoreIR circuitName = getCoreIRModuleString
  where
    getCoreIRModuleString = "magma.compile(\"" ++ circuitName ++ "\", " ++ circuitName ++ ", output=\"verilog\", passes=[\"rungenerators\", \"wireclocks-coreir\", \"verifyconnectivity --noclkrst\", \"flattentypes\", \"flatten\", \"verifyconnectivity --noclkrst\", \"deletedeadinstances\"], namespaces=[\"aetherlinglib\", \"commonlib\", \"mantle\", \"coreir\", \"global\"], context=c)\n"

writeProgramToFile :: forall a b . (Typeable (Proxy a), Typeable (Proxy b)) =>
  String -> String -> String -> String -> Bool -> (a -> StatefulErrorMonad b) -> IO ()
writeProgramToFile circuitName preludeLocation epilogueLocation outputLocation
  shouldSaveToCoreIR program = do
  -- traceM "preCompileData"
  let compData = buildCompilationData program
  -- traceM $ show compData
  -- traceM "postCompileData"
  preludeString <- readFile preludeLocation
  epilogueString <- readFile epilogueLocation
  let inputTypeString = getModulePortsString True "I" $ inputPortsTypes compData
  -- traceM inputTypeString
  let outputTypeString = getModulePortsString False "O" $ outputPortsTypes compData
  -- traceM outputTypeString
  let interfaceString = circuitInterfaceString inputTypeString outputTypeString
  -- traceM interfaceString
  let circuitDefinition = circuitName ++ " = DefineCircuit('" ++ circuitName ++ "_Circuit', *args)\n" 
  -- traceM circuitDefinition
  -- traceM $ show compData
  let wireDataInterfaceString = wireDataInterface circuitName
                                (inputPorts compData) (outputPorts compData)
  let wireRVString = wireRV circuitName (entireDAGControlPorts compData)
  -- always wire the CE to a term so that if nothing else uses it, no problems
  let wireCEToTerm = "ceTerm = TermAnyType(cirb, Enable)\nwire(ceTerm.I, " ++ circuitName ++ ".CE)\n" 
  let saveToCoreIRString = if shouldSaveToCoreIR then saveToCoreIR circuitName else ""
  {-
  traceM "howdy"
  let upToBodyString = preludeString ++ inputTypeString ++
                       outputTypeString ++ interfaceString 
  traceM upToBodyString
  let bodyString = (foldl (++) "" $ reverse $ reversedOutputText compData) 
  traceM bodyString
  -}
  let outputString = (preludeString ++ interfaceString ++ circuitDefinition ++
                      (foldl (++) "" $ outputText compData) ++
                      wireDataInterfaceString ++ wireRVString ++
                      wireCEToTerm ++
                      epilogueString ++ saveToCoreIRString)
  --traceM outputString
  writeFile outputLocation outputString

-- this returns the wire calls
wirePorts :: [PortName] -> [PortName] -> Either String [String]
wirePorts priorOutPorts nextInPorts |
  length priorOutPorts == length nextInPorts = Right wireStrings
  where
    portPairs = zip priorOutPorts nextInPorts
    wireStrings = fmap (\(outName, inName) -> "wire(" ++ outName ++ ", " ++
                         inName ++ ")\n") portPairs
wirePorts priorOutPorts nextInPorts = Left ("Different lengths of ports " ++
                                            show priorOutPorts ++
                                            " and " ++
                                            show nextInPorts)

wireRV :: String -> [ControlPorts] -> String
wireRV moduleName allCPorts = foldl (++) "" $
  [
    "wire(" ++ combinedFirstReadyPorts ++ ", " ++ ready_data_in_port ++ ")\n",
    "wire(" ++ combinedLastValidPorts ++ ", " ++ valid_data_out_port ++ ")\n"
  ] ++ internalRVWiring
  {-
  foldl (++) "" $ 
  -- this module is ready to process when the downstream is ready 
  ["wire(" ++ moduleName ++ "." ++ ready_data_in_str ++ ", " ++ moduleName ++
    "." ++ ready_data_out_str ++ ")\n"] ++
  -- enable the top of the module when input is valid
  connectReadyValidPorts [valid_data_in_port, ce_port] innerStartingCEPorts ++
  -- instead of a CE port at end, send all the last valid ports out of the data out
  -- valid port of the whole module
  connectReadyValidPorts lastValidPorts [moduleName ++ "." ++ valid_data_out_str]
-}
  where
    cePorts = fmap ce allCPorts
    rPorts = fmap readyPorts allCPorts
    vPorts = fmap validPorts allCPorts
    valid_data_in_port = moduleName ++ "." ++ valid_data_in_str
    valid_data_out_port = moduleName ++ "." ++ valid_data_out_str
    ready_data_in_port = moduleName ++ "." ++ ready_data_in_str
    ready_data_out_port = moduleName ++ "." ++ ready_data_out_str
    outerCEPort = moduleName ++ ".CE"
    -- the first cePort i
    -- thus the top node in the DAG gets a valid signal when input data is good
    -- the last cePort is wired to the interfaces data out valid port
    -- thus the last node in the DAG gets a readyy signal when the overall system
    -- is given a ready signal
    alignedPorts = zip3 cePorts ([[valid_data_in_port]] ++ vPorts)
      -- intentionally using drop 1 so empty list if its empty
      ((drop 1 rPorts) ++ [[ready_data_out_port]])
    -- wiring of rv interfaces to dags in node, not outer interface
    -- of this whole circuit
    internalRVWiring = fmap (\(c,v,r) -> connectReadyValidPorts c v r outerCEPort)
      alignedPorts
    -- these are the ports that will be used to wiring to the outer interface
    firstReadyPorts = if null rPorts then [ready_data_out_port] else head rPorts
    combinedFirstReadyPorts = andRVPorts firstReadyPorts
    lastValidPorts = if null vPorts then [valid_data_in_port] else last vPorts
    combinedLastValidPorts = andRVPorts lastValidPorts
    
    --
  {-
    valid_data_in_port = moduleName ++ "." ++ valid_data_in_str
    ce_port = "bit(" ++ moduleName ++ ".CE)"
    -- if there are no valid ports in the module, wire the input valid port
    -- to the output valid port
    lastValidPorts = if null innerEndingValidPorts then [valid_data_in_port]
      else innerEndingValidPorts
-}

wireDataInterface :: String -> [PortName] -> [PortName] -> String
wireDataInterface moduleName inputPorts outputPorts = foldl (++) "" $ 
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
appendToCompilationData :: NodeType -> CompilationData -> StatefulErrorMonad a
appendToCompilationData nodeType newData@(CompilationData ni nts ot ip iTypes op oTypes
                                          cp tNum tDenom) = do  
    priorData <- get 
    -- just propagate throughput numerator and denominator 
    -- as those are only modififed by scheduling combiators that are
    -- parents, and this is for combining siblines
    -- section as we are going along 
    let newThroughputNumerator = throughputNumerator priorData
    let newThroughputDenominator = throughputDenominator priorData
    --traceM ("Old data" ++ show priorData)
    --traceM ("New data" ++ show newData)
    let portWirings = if (null $ (outputText priorData))
                       then Right [] else wirePorts (outputPorts priorData) ip
    if isLeft portWirings
      then liftEither portWirings
      else do
      let dataWiringsStrings = fromRight [] portWirings
      let newOutText = outputText priorData ++ ot ++
            getIDGenString nts ni (newThroughputNumerator `parDiv` newThroughputDenominator) ++
            wireIDGen nts ni (newThroughputNumerator `parDiv` newThroughputDenominator) ++
            dataWiringsStrings
      let newInPorts = if (null $ (outputText priorData))
                       then ip else inputPorts priorData
      let newInTypes = if (null $ (outputText priorData))
                        then iTypes else inputPortsTypes priorData
      let newInTypes = if (null $ (outputText priorData))
                        then iTypes else inputPortsTypes priorData
      let newOutPorts = op
      let newOutTypes = oTypes
      -- unlike at for first CE and valid ports,
      -- propagate last ones from priorData only if current stage has no ports
      let newControlPorts = (entireDAGControlPorts priorData) ++ (
            if cp == [emptyControlPorts] then [] else cp)

      let newPar = newThroughputNumerator `parDiv` newThroughputDenominator
      let nodeIndexIncrement = numCopiesToParallelize nodeType newPar
      put $ (CompilationData (ni+nodeIndexIncrement) (nodeTypes priorData ++ nts)
             newOutText newInPorts newInTypes newOutPorts newOutTypes
             newControlPorts newThroughputNumerator newThroughputDenominator)
      return undefined
    return undefined
  where
    -- in the case of fold, need a helper here to create its identity generator
    -- and wire that into the fold. A better version of this system
    -- would allow identity generators to be injected smarter than
    -- this, ideally in the monad
    getIDGenString :: [NodeType] -> Int -> Int -> [String]
    getIDGenString [FoldT _ idGenType totalLen] curNodeIndex par | par > 1 ||
                                                                   par == totalLen =
      [magmaNodeBaseName ++ show curNodeIndex ++ "_identityGen = " ++
       (fromRight "" $ createMagmaDefOfNode idGenType 1) ++ "()\n"]
    getIDGenString _ _ _ = []
    wireIDGen :: [NodeType] -> Int -> Int -> [String]
    wireIDGen [nt@(FoldT _ _ totalLen)] curNodeIndex par | par >= totalLen =
      foldl (++) [] $ (fmap (\idx -> ["wire(" ++ magmaNodeBaseName ++
                              show curNodeIndex ++ "_identityGen.O, " ++
                              magmaNodeBaseName ++ show (curNodeIndex + idx) ++
                              ".I.identity)\n"]) [0..(numCopiesToParallelize nt par - 1)])
    wireIDGen [FoldT _ _ totalLen] curNodeIndex par | (par > 1) && par < totalLen =
      ["wire(" ++ magmaNodeBaseName ++ show curNodeIndex ++ "_identityGen.O, " ++
       magmaNodeBaseName ++ show curNodeIndex ++ ".identity)\n"]
    wireIDGen _ _ _ = []

createCompilationDataAndAppend :: NodeType -> StatefulErrorMonad a
createCompilationDataAndAppend nodeType = do
    -- traceM "start of createCompilationDataAndAppend"
    priorData <- get
    let curNodeIndex = nodeIndex priorData
    let par = throughputNumerator priorData `parDiv` throughputDenominator priorData
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
        -- traceM ("instanceValues" ++ show instancesValues)
        appendToCompilationData nodeType
          (CompilationData curNodeIndex [nodeType] [instancesValues] (inPorts portsValues)
            (inTypes portsValues) (outPorts portsValues) 
            (outTypes portsValues) 
            [controlPorts portsValues]
            (throughputNumerator priorData) (throughputDenominator priorData))
    return undefined


-- note this zip is to get the ports and types together so than can be organized together
groupPortsAndTypes ungroupedParallelPorts ungroupedParallelPortsTypes = (groupedParallelPorts, groupedParallelPortTypes)
  where
    ungroupedParallelPortsAndTypes = zip ungroupedParallelPorts
                                        ungroupedParallelPortsTypes
    groupedParallelPortsAndTypes = groupBy (\x -> \y -> ((snd $ snd x) == (snd $ snd y))) $
                                      sortBy (\x -> \y -> compare (snd $ snd x) (snd $ snd y))
                                      ungroupedParallelPortsAndTypes
    groupedFlattenedParallelPortsAndTypes = foldl (++) [] groupedParallelPortsAndTypes
    groupedParallelPorts = fmap fst groupedFlattenedParallelPortsAndTypes
    groupedParallelPortTypes = fmap snd groupedFlattenedParallelPortsAndTypes

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
  noop f _ = do
    let fPipeline = runIdentity $ runExceptT $ (runStateT
          (f undefined) emptyCompData)
    if isLeft fPipeline
      then do
      liftEither fPipeline
      return undefined
      else do
      createCompilationDataAndAppend (NoopT
                                      (head $ nodeTypes $ snd $ fromRight undefined fPipeline))

  -- binary operators
  -- the values returned here, they are only to emit things of the right types
  -- so the state computations can occur
  addC _ = createCompilationDataAndAppend AddT
  subC _ = createCompilationDataAndAppend SubT
  mulC _ = createCompilationDataAndAppend MulT
  divC _ = createCompilationDataAndAppend DivT
  minC _ = createCompilationDataAndAppend MinT
  maxC _ = createCompilationDataAndAppend MaxT
  ashrC _ = createCompilationDataAndAppend AshrT
  shlC _ = createCompilationDataAndAppend ShlT
  andC _ = createCompilationDataAndAppend AndT
  orC _ = createCompilationDataAndAppend OrT
  xorC _ = createCompilationDataAndAppend XorT
  eqIntC _ = createCompilationDataAndAppend EqIntT
  eqBitC _ = createCompilationDataAndAppend EqBitT
  neqIntC _ = createCompilationDataAndAppend NeqIntT
  neqBitC _ = createCompilationDataAndAppend NeqBitT
  ltIntC _ = createCompilationDataAndAppend LtIntT
  ltBitC _ = createCompilationDataAndAppend LtBitT
  leqIntC _ = createCompilationDataAndAppend LeqIntT
  leqBitC _ = createCompilationDataAndAppend LeqBitT
  gtIntC _ = createCompilationDataAndAppend GtIntT
  gtBitC _ = createCompilationDataAndAppend GtBitT
  geqIntC _ = createCompilationDataAndAppend GeqIntT
  geqBitC _ = createCompilationDataAndAppend GeqBitT
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
-}
  -- note that getIDGenString and wireIDGen in appendToCompilationData are
  -- a hack that are a special case for fold to work. They make the idgen and wire it up
  -- to the identity port of the fold.
  foldC :: forall n a . (KnownNat n, (KnownNat (TypeSize (Atom a)))) =>
           Proxy n -> (Atom (Atom a, Atom a) -> StatefulErrorMonad (Atom a)) ->
           (Atom () -> StatefulErrorMonad (Atom a)) ->
           Seq n (Atom a) -> StatefulErrorMonad (Seq 1 (Atom a))
  foldC sublistLength f idGen _ = do
    priorData <- get
    -- this has to have no prior text. appendToCompilationData 
    -- checks if prior text exists to see if inputPorts are inputPorts
    -- for modules. fPipeline and gPipeline are supposed to be
    -- independent pipelines which then get merged into the larger pipelines
    -- thus, no prior text so that their inputPorts are inputPorts for their
    -- modules
    let fPipeline = runIdentity $ runExceptT $ (runStateT
          (f undefined) emptyCompData)
    let identityPipeline = runIdentity $ runExceptT $ (runStateT
          (idGen undefined) emptyCompData)
    let totalLengthProxy = Proxy :: Proxy n
    let totalLength = fromInteger $ natVal totalLengthProxy
    if isLeft fPipeline
      then do
      liftEither fPipeline
      return undefined
      else do
      if isLeft identityPipeline
        then do
        liftEither identityPipeline
        return undefined
        else do
        createCompilationDataAndAppend (FoldT
                                        (head $ nodeTypes $ snd $ fromRight undefined fPipeline)
                                        (head $ nodeTypes $ snd $ fromRight undefined identityPipeline)
                                        totalLength)

  lineBuffer :: forall windowYSize windowXSize imageYSize imageXSize
                 strideY strideX originY originX imageArea strideArea
                 outputParallelism windowCount outerSequenceLength a.
                 (KnownNat windowYSize,
                 KnownNat windowXSize, KnownNat imageYSize, KnownNat imageXSize,
                 KnownNat strideY, KnownNat strideX, KnownNat originY,
                 KnownNat originX, Typeable a, 1 <= (strideX * strideY)) =>
    Proxy (Atom a) -> Proxy windowYSize -> Proxy windowXSize ->
    Proxy imageYSize -> Proxy imageXSize ->
    Proxy strideY -> Proxy strideX -> Proxy originY -> Proxy originX ->
    -- need strideY*strideX here as, if running at least 1 pixel
    -- out per clock, need at least these many pixels in per clock
    -- can get rid of this once I have underutilize working
    (Seq (imageYSize * imageXSize) (Atom a)) ->
    StatefulErrorMonad (Seq (Div (imageYSize * imageXSize) (strideY * strideX))
                        (Atom (V.Vector windowYSize
                               (Atom (V.Vector windowXSize (Atom a))))))
  lineBuffer _ _ _ _ _ _ _ _ _ _ = do
    currentCompData <- get
    let tNum = throughputNumerator currentCompData
    let tDenom = throughputDenominator currentCompData
    let par = tNum `parDiv` tDenom
    let paramCheck = linebufferDataValid par lbData
    -- traceM $ show par
    -- traceM $ show lbData
    if null paramCheck
      then createCompilationDataAndAppend (LineBufferT lbData)
      else liftEither $ Left $ (
      "LineBuffer has invalid parameters, params are " ++ show lbData ++
      ". par is " ++ show par ++ " and the errors are " ++ (foldl (++) "" paramCheck))
    return undefined
    where
      windowYSizeValue = fromInteger $ natVal $ (Proxy :: Proxy windowYSize)
      windowXSizeValue = fromInteger $ natVal $ (Proxy :: Proxy windowXSize)
      imageYSizeValue = fromInteger $ natVal $ (Proxy :: Proxy imageYSize)
      imageXSizeValue = fromInteger $ natVal $ (Proxy :: Proxy imageXSize)
      strideYValue = fromInteger $ natVal $ (Proxy :: Proxy strideY)
      strideXValue = fromInteger $ natVal $ (Proxy :: Proxy strideX)
      originYValue = fromInteger $ natVal $ (Proxy :: Proxy originY)
      originXValue = fromInteger $ natVal $ (Proxy :: Proxy originX)
      tokenType = typeOf (Proxy :: Proxy (Atom a))
      lbData = LineBufferData
        (windowYSizeValue, windowXSizeValue)
        (imageYSizeValue, imageXSizeValue) (strideYValue, strideXValue)
        (originYValue, originXValue) tokenType
      
  -- higher-order operators
  mapC :: forall n a b . (KnownNat n) =>
    Proxy n -> (Atom a -> StatefulErrorMonad (Atom b)) ->
    (Atom (V.Vector n (Atom a)) -> StatefulErrorMonad (Atom (V.Vector n (Atom b))))
  mapC _ f _ = do
    priorData <- get 
    let priorNum = throughputNumerator priorData
    let priorDenom = throughputDenominator priorData
    let priorPar = priorNum `parDiv` priorDenom
    let mapParallelismProxy = Proxy :: Proxy n 
    let mapParallelism = (fromInteger $ natVal mapParallelismProxy)
    -- since this map is doing atoms, it's parallelism must be at least the n.
    -- any less and we are underutilizng a vector that cannot be underutilized
    put $ priorData {
      throughputNumerator = priorPar * mapParallelism,
      throughputDenominator = 1}
    --traceM $ "PriorData " ++ show priorData
    f undefined
    dataPostInnerPipeline <- get
    --traceM $ "dataPostInnerPipeline " ++ show dataPostInnerPipeline
    put $ dataPostInnerPipeline {
      throughputNumerator = priorNum,
      throughputDenominator = priorDenom} 
    return undefined

  seq_to_vectorC :: forall n o a b . (KnownNat n, KnownNat o) =>
    (Seq n (Atom a) -> StatefulErrorMonad (Seq o (Atom b))) ->
    (Atom (V.Vector n (Atom a)) -> StatefulErrorMonad (Atom (V.Vector o (Atom b))))
  seq_to_vectorC f _ = do
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy n
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ multiplyThroughput inputLength priorData
    --traceM $ "PriorData " ++ show priorData
    f undefined
    dataPostInnerPipeline <- get
    --traceM $ "dataPostInnerPipeline " ++ show dataPostInnerPipeline
    put $ divideThroughput inputLength dataPostInnerPipeline 
    return undefined

  -- ignore the iter since it does nothing, needs to be wrapped with a tseq or
  -- sseq converting function
  iterC _ f _ = do
    -- this should run f to have it update the state, then do nothing
    f undefined
    return undefined

  zipC shouldMergePortsAfterSort f g _ = do
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
          (g undefined) (cData { nodeIndex = secondNodeIndex}))
    let errorMessages = filter (not . null) $ [fromLeft "" fPipeline, fromLeft "" gPipeline]
    if null errorMessages
      then do
      let fCompilerData = snd $ fromRight undefined fPipeline
      let gCompilerData = snd $ fromRight undefined gPipeline
      -- traceM $ "f compilation: " ++ show fCompilerData
      -- traceM $ "g compilation: " ++ show gCompilerData
      let fControlPorts = entireDAGControlPorts fCompilerData
      let gControlPorts = entireDAGControlPorts gCompilerData
      -- group the parallel output ports together
      -- only need this for output ports as need order right for next stage for those
      let (groupedParallelPorts, groupedParallelPortTypes) =
            if shouldMergePortsAfterSort
            then do
              -- ZipSeqTypes should ensure that f and g have same number of output ports
              -- will need to fix this if that assumption is not true
              -- only get to this condition if called from >***< which means
              -- f and g produce types that satisfy ZipSeqTypes
              let (fParallelPorts, fParallelPortTypes) =
                    groupPortsAndTypes (outputPorts fCompilerData) (outputPortsTypes fCompilerData)
              let (gParallelPorts, gParallelPortTypes) =
                    groupPortsAndTypes (outputPorts gCompilerData) (outputPortsTypes gCompilerData)
              let interleave xs ys = concat (transpose [xs, ys])
              (interleave fParallelPorts gParallelPorts,
               interleave fParallelPortTypes gParallelPortTypes)
            else do
              let ungroupedParallelPorts = outputPorts fCompilerData ++ outputPorts gCompilerData
              let ungroupedParallelPortsTypes = outputPortsTypes fCompilerData ++
                                                outputPortsTypes gCompilerData
              groupPortsAndTypes ungroupedParallelPorts ungroupedParallelPortsTypes
      let mergedCompilerData = (CompilationData
                               -- subtract 1 here as g compiler data's
                               -- node index is incremented by 1 for the
                               -- next node, and then appendToCompilationData
                               -- will increment again. -1 to prevent double
                               -- counting.
                               (nodeIndex gCompilerData - 1)
                               [ForkJoinT (nodeTypes fCompilerData) (nodeTypes gCompilerData)]
                               (outputText fCompilerData ++
                                 outputText gCompilerData)
                               (inputPorts fCompilerData ++ inputPorts gCompilerData)
                               (inputPortsTypes fCompilerData ++ inputPortsTypes gCompilerData)
                               groupedParallelPorts
                               groupedParallelPortTypes
                               -- at this point, only allow left or right part of zip
                               -- to have ready-valid ports, will address this later
                               (if null fControlPorts then gControlPorts else fControlPorts)
                               tNum tDenom
                               )
      -- passing in AddT to ensure that nodeIndex increases by parallelism amount
      -- safer to over count than undercount
      -- not sure how to peek inside g and see what its last node is and wehtehr
      -- that is internally parallelized. The NodeType is only used to determine
      -- how much to increment NodeIndex based on the paralleism technique of the
      -- NodeType
      appendToCompilationData AddT mergedCompilerData
      else do
      liftEither $ Left $ foldl (++) "" errorMessages
      return undefined

  (f *** g) _ = zipC False f g undefined

  (f >***< g) _ = zipC True f g undefined --do
    {-
    (f *** g) undefined
    priorData <- get
    let allOutputPorts = outputPorts priorData
    let allOutputPortsTypes = outputPortsTypes priorData
    -- ZipSeqTypes should ensure that f and g have same number of output ports
    -- will need to fix this if that assumption is not true
    -- instead of just merging these, need to merge those with same parallelism number
    let fAndGOutputPorts =
          chunksOf (length (outputPorts priorData) `div` 2) allOutputPorts
    let fAndGOutputPortsTypes =
          chunksOf (length (outputPortsTypes priorData) `div` 2) allOutputPortsTypes
    -- this zipping is to merge
    let (fGroupedParallelPorts, fGroupedParallelPortTypes) =
            groupPortsAndTypes (fAndGOutputPorts !! 0) (fAndGOutputPortsTypes !! 0)
    -- traceM "priorTo !!"
    -- traceM $ show fAndGOutputPorts
    -- traceM $ show fAndGOutputPortsTypes
    -- traceM $ show priorData
    put $ priorData {
      outputPorts = interleave (fAndGOutputPorts !! 0)  (fAndGOutputPorts !! 1),
      outputPortsTypes = interleave (fAndGOutputPortsTypes !! 0) (fAndGOutputPortsTypes !! 1)
      }
    -- traceM "after !!"
    return undefined
    where
      interleave xs ys = concat (transpose [xs, ys])
-}

  addUnitType _ = do
    return undefined
  produceRightUnitMix _ _ = do
    return undefined

  (>>>) :: forall a b c.
    (KnownNat (UnscheduledLength a), KnownNat (UnscheduledLength b),
      AtomBaseType a, AtomBaseType b, AtomBaseType c) =>
    (a -> StatefulErrorMonad b) -> (b -> StatefulErrorMonad c) -> (a -> StatefulErrorMonad c)
  (f >>> g) _ = do
    priorData <- get
    let priorThroughputNumerator = throughputNumerator priorData
    let priorThroughputDenominator = throughputDenominator priorData
    --traceM $ "throughput before f " ++ show (throughputNumerator priorData, throughputDenominator priorData)
    f undefined
    -- the parallelism for the second one depends on the parallelism of the first one
    -- since we are always setting parallelism based on inputs per clock,
    -- make the second node run at the right rate to match the parallelism of
    -- the first node.
    dataAfterF <- get
    let fInputLengthProxy = Proxy :: Proxy (UnscheduledLength a)
    let fInputLength = (fromInteger $ natVal fInputLengthProxy)
    let fOutputLengthProxy = Proxy :: Proxy (UnscheduledLength b)
    let fOutputLength = (fromInteger $ natVal fOutputLengthProxy)
    --traceM $ show fInputLength
    --traceM $ show fOutputLength
    --traceM $ "throughput before change " ++ show (throughputNumerator dataAfterF, throughputDenominator dataAfterF)
    -- increase/decrease output parallelism depending on if a is rate increase or
    -- decreasing
    if fInputLength > fOutputLength
      then do
      --traceM "a"
      put $ divideThroughput (fInputLength `div` fOutputLength) dataAfterF
      else do
      --traceM "b"
      put $ multiplyThroughput (fOutputLength `div` fInputLength) dataAfterF
    --traceM $ "throughput after change " ++ show (throughputNumerator dataAfterF, throughputDenominator dataAfterF)
    ----traceM $ "PriorData " ++ show priorData
    g undefined
    dataPostInnerPipeline <- get
    --traceM $ "throughput after g " ++ show (throughputNumerator dataPostInnerPipeline, throughputDenominator dataPostInnerPipeline)
    put $ dataPostInnerPipeline {
      throughputNumerator = priorThroughputNumerator,
      throughputDenominator = priorThroughputDenominator
                     }
    --traceM $ "throughput after setting " ++ show (priorThroughputNumerator, priorThroughputDenominator)
    return undefined

  -- scheduling operators
  split_seq_to_sseqC :: forall totalInputLength totalOutputLength
                        outerInputLength outerOutputLength
                        innerInputLength innerOutputLength a b .
                        (KnownNat totalInputLength, KnownNat totalOutputLength,
                         KnownNat outerInputLength, KnownNat outerOutputLength,
                         KnownNat innerInputLength, KnownNat innerOutputLength,
                         innerOutputLength ~ Max 1 (
                            Div (totalOutputLength * innerInputLength) totalInputLength),
                         totalInputLength ~ (outerInputLength*innerInputLength),
                         totalOutputLength ~ (outerOutputLength*innerOutputLength)) =>
                        Proxy innerInputLength ->
    (Seq totalInputLength a -> StatefulErrorMonad (Seq totalOutputLength b)) ->
    (Seq outerInputLength (SSeq innerInputLength a) ->
      StatefulErrorMonad (Seq outerOutputLength (SSeq innerOutputLength b)))
  split_seq_to_sseqC innerInputLengthProxy f _ = do
    priorData <- get 
    let innerInputLength = (fromInteger $ natVal innerInputLengthProxy)
    put $ multiplyThroughput innerInputLength priorData
    f undefined
    dataPostInnerPipeline <- get
    put $ divideThroughput innerInputLength dataPostInnerPipeline
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
  sseq_to_tseqC :: forall inputLength outputLength a b .
                   (KnownNat inputLength, KnownNat outputLength) =>
    (SSeq inputLength a -> StatefulErrorMonad (SSeq outputLength b)) ->
    TSeq inputLength ((Max inputLength outputLength) - inputLength) a ->
    StatefulErrorMonad (TSeq outputLength ((Max inputLength outputLength) - outputLength) b)
  sseq_to_tseqC f _ = do
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy inputLength
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ divideThroughput inputLength priorData
    f undefined
    dataPostInnerPipeline <- get
    put $ multiplyThroughput inputLength dataPostInnerPipeline
    return undefined

  -- this is almost same as seq_to_sseq as tseq and seq both don't change parallelism
  tseq_to_sseqC :: forall inputLength outputLength a b v u .
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
    TSeq n ((n + v) * underutilMult - n) a -> StatefulErrorMonad (TSeq o ((o + u) * underutilMult - o) b)
  underutilC underutilProxy f _ = do 
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy underutilMult
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    f undefined
    return undefined

  increaseUtilC :: forall n v o u a b increaseUtilMult .
                (KnownNat n, KnownNat v, KnownNat o, KnownNat u,
                 KnownNat increaseUtilMult, 1 <= increaseUtilMult,
                 1 <= v, 1 <= u,
                 increaseUtilMult <= (n + v), increaseUtilMult <= (o + u)) => 
    Proxy increaseUtilMult -> (TSeq n v a -> StatefulErrorMonad (TSeq o u b)) ->
    TSeq n ((n + v) `Div` increaseUtilMult - n) a ->
    StatefulErrorMonad (TSeq o ((o + u) `Div` increaseUtilMult - o) b)
  increaseUtilC increaseUtilProxy f _ = do 
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy increaseUtilMult
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    f undefined
    return undefined

  increaseUtilTtoSC :: forall n o u a b increaseUtilMult .
                       (KnownNat n, KnownNat o, KnownNat u,
                        KnownNat increaseUtilMult, 1 <= increaseUtilMult,
                        increaseUtilMult <= u) =>
    Proxy increaseUtilMult -> (TSeq n 0 a -> StatefulErrorMonad (TSeq o u b)) ->
    -- subtract n/o as n + v * underutilMult is the new base of the utilization
    -- and keeping n around
    TSeq (n `Div` increaseUtilMult) 0 (SSeq increaseUtilMult a) ->
    StatefulErrorMonad (TSeq o ((o + u) `Div` increaseUtilMult - o) b)
  increaseUtilTtoSC increaseUtilProxy f _ = do
    priorData <- get 
    let inputLengthProxy = Proxy :: Proxy increaseUtilMult
    let inputLength = (fromInteger $ natVal inputLengthProxy)
    put $ multiplyThroughput inputLength priorData
    f undefined
    return undefined

  -- since the ports and types are already flattened, and same amount of parallelism
  -- flattened or unflattened, no need to do anything here
  -- this is just for manipulating the type system.
  mergeSSeqs _ = return undefined

  reshapeC _ _ _ = return undefined
  reshapeImplicitC _ = return undefined

  forceMinPortParallelism :: forall p a b . (KnownNat p) => Proxy p ->
                             (a -> StatefulErrorMonad b) -> a -> StatefulErrorMonad b
  forceMinPortParallelism _ f _ = do
    priorData <- get 
    let priorNum = throughputNumerator priorData
    let priorDenom = throughputDenominator priorData
    let priorPar = priorNum `parDiv` priorDenom
    let minParallelismProxy = Proxy :: Proxy p
    let minParallelism = (fromInteger $ natVal minParallelismProxy)
    let parallelism = max minParallelism priorPar
    -- since this map is doing atoms, it's parallelism must be at least the n.
    -- any less and we are underutilizng a vector that cannot be underutilized
    put $ priorData {
      throughputNumerator = parallelism,
      throughputDenominator = 1}
    --traceM $ "PriorData " ++ show priorData
    f undefined
    dataPostInnerPipeline <- get
    --traceM $ "dataPostInnerPipeline " ++ show dataPostInnerPipeline
    put $ dataPostInnerPipeline {
      throughputNumerator = priorNum,
      throughputDenominator = priorDenom} 
    return undefined

-- examples of programs in space and time
-- iterInput = Seq $ V.fromTuple ((Int 1, Int 2), (Int 3, Int 4), (Int 5, Int 6), (Int 7, Int 8))
-- replace unscheduledCirc with this one to see a composition

unscheduledPipeline = iterC (Proxy @4) $ (constGenIntC (Int 3) >***< constGenIntC (Int 2)) >>> addC
unscheduledNode = iterC (Proxy @4) $ addC

lb2x2Example = (lineBuffer (Proxy :: Proxy (Atom Int)) (Proxy @2) (Proxy @2) (Proxy @8) (Proxy @8)
                (Proxy @1) (Proxy @1) (Proxy @0) (Proxy @0))

lbExampleConsts = iterC (Proxy @64) $
  (constGenIntC (Int 1) *** constGenIntC (Int 2)) ***
  (constGenIntC (Int 2) *** constGenIntC (Int 1)) >>>
  reshapeC (Proxy :: Proxy (Atom (Atom (Atom Int, Atom Int), Atom (Atom Int, Atom Int))))
  (Proxy :: Proxy (Atom (V.Vector 2 (Atom (V.Vector 2 (Atom Int))))))

--lbExampleConsts = iterC (Proxy @100) $ mapC (Proxy @2) $ mapC (Proxy @2) $ constGenIntC (Int 3)
lbExampleMuls = iterC (Proxy @64) $ mapC (Proxy @2) $ mapC (Proxy @2) $ mulC
flattenNestedNTuples = iterC (Proxy @64) $
  reshapeC (Proxy :: Proxy (Atom (V.Vector 2 (Atom (V.Vector 2 (Atom Int))))))
  (Proxy :: Proxy (Atom (V.Vector 4 (Atom Int))))
unscheduledLBExample = (iterC (Proxy @64) addUnitType) >>>
  (lb2x2Example >***< lbExampleConsts) >>> lbExampleMuls >>> flattenNestedNTuples
foldExample = iterC (Proxy @64) $ seq_to_vectorC $
  foldC (Proxy @4) addC (constGenIntC (Int 0))
unscheduledConvolution = unscheduledLBExample >>> foldExample
  
convOutputToInput = iterC (Proxy @64) $
  reshapeC (Proxy :: Proxy (Atom (V.Vector 1 (Atom Int)))) (Proxy :: Proxy (Atom Int))

unscheduledConvChain = unscheduledConvolution >>> convOutputToInput >>>
  unscheduledConvolution >>> convOutputToInput >>> unscheduledConvolution

unscheduledPipelineCData = buildCompilationData unscheduledPipeline
unscheduledNodeCData = buildCompilationData unscheduledNode 
unscheduledLBCData = buildCompilationData unscheduledLBExample
unscheduledConvolutionCData = buildCompilationData unscheduledConvolution
unscheduledConvChainCData = buildCompilationData unscheduledConvChain

sequentialPipeline = seq_to_tseqC unscheduledPipeline 
sequentialPipelineCData = buildCompilationData $ seq_to_tseqC unscheduledPipeline 
sequentialNodeCData = buildCompilationData $ seq_to_tseqC unscheduledNode
sequentialLB = seq_to_tseqC unscheduledLBExample
sequentialLBCData = buildCompilationData sequentialLB 
sequentialConvolution = seq_to_tseqC unscheduledConvolution
sequentialConvolutionCData = buildCompilationData sequentialConvolution
sequentialConvChain = seq_to_tseqC unscheduledConvChain
sequentialConvChainCData = buildCompilationData sequentialConvChain
{-
sequentialLBCData = buildCompilationData $ seq_to_tseqC (unscheduledLBExample .
                                                         (mergeSeqTuples
                                                          (Proxy :: Proxy 1)
                                                          (Proxy :: Proxy (Atom Int))
                                                          (Proxy :: Proxy (SSeq 2 (SSeq 2 (Atom ()))))))
-}
parallelPipeline = seq_to_sseqC unscheduledPipeline 
parallelPipelineCData = buildCompilationData $ seq_to_sseqC unscheduledPipeline 
parallelNodeCData = buildCompilationData $ seq_to_sseqC unscheduledNode
parallelLB = seq_to_sseqC unscheduledLBExample
parallelLBCData = buildCompilationData parallelLB
parallelConvolution = seq_to_sseqC unscheduledConvolution
parallelConvolutionCData = buildCompilationData parallelConvolution

partialParallelPipeline = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledPipeline 
partialParallelPipelineCData = buildCompilationData $ seq_to_tseqC $ split_seq_to_sseqC (Proxy @2)
  unscheduledPipeline 
partialParallelNodeCData = buildCompilationData $ seq_to_tseqC $ split_seq_to_sseqC (Proxy @2)
  unscheduledNode
-- partialParallelLB = seq_to_tseqC $ split_seq_to_sseqC (Proxy @32) unscheduledLBExample
--partialParallelLBCData = buildCompilationData $ partialParallelLB
-- note that the proxy for the split is the outer sequence length. Divide into 32
-- segments to get inner parallelism of 2 in an 8x8 image
partialParallel2Convolution = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledConvolution
partialParallel2ConvolutionCData = buildCompilationData partialParallel2Convolution
partialParallel4Convolution = seq_to_tseqC $ split_seq_to_sseqC (Proxy @4) unscheduledConvolution
partialParallel4ConvolutionCData = buildCompilationData partialParallel4Convolution
partialParallel8Convolution = seq_to_tseqC $ split_seq_to_sseqC (Proxy @8) unscheduledConvolution
partialParallel8ConvolutionCData = buildCompilationData partialParallel8Convolution
partialParallel16Convolution = seq_to_tseqC $ split_seq_to_sseqC (Proxy @16) unscheduledConvolution
partialParallel16ConvolutionCData = buildCompilationData partialParallel16Convolution
partialParallel2ConvChain = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledConvChain
partialParallel2ConvChainCData = buildCompilationData partialParallel2ConvChain
partialParallel4ConvChain = seq_to_tseqC $ split_seq_to_sseqC (Proxy @4) unscheduledConvChain
partialParallel4ConvChainCData = buildCompilationData partialParallel4ConvChain
partialParallel8ConvChain = seq_to_tseqC $ split_seq_to_sseqC (Proxy @8) unscheduledConvChain
partialParallel8ConvChainCData = buildCompilationData partialParallel8ConvChain
partialParallel16ConvChain = seq_to_tseqC $ split_seq_to_sseqC (Proxy @16) unscheduledConvChain
partialParallel16ConvChainCData = buildCompilationData partialParallel16ConvChain
{-
parallelResult = simulate $ seq_to_sseqC unscheduledCirc $ to iterInput
partialParallelInput :: TSeq 2 0 (SSeq 2 (Atom, Atom))
partialParallelInput = seqToTSeq $ seqOfSeqToSeqOfSSeq $ seqToSeqOfSeq (Proxy @2) iterInput
partialParallelResult =
  simulate $
  (seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledCirc) $
  partialParallelInput
-}

preludeLocationStrForEx = "../../aetherling/aetherling/HaskellPrelude.py"
epilogueLocationStrForEx = "../../aetherling/aetherling/HaskellEpilogue.py"
writeAllExamples = do
  writeProgramToFile "sequentialSimpleAdd" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/sequentialSimpleAdd.py" False sequentialPipeline
  writeProgramToFile "parallelSimpleAdd" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/parallelSimpleAdd.py" False parallelPipeline
  writeProgramToFile "partialParallelSimpleAdd" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallelSimpleAdd.py" False partialParallelPipeline
  writeProgramToFile "sequentialLineBufferWithAdd" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/sequentialLineBufferWithAdd.py" False sequentialLB
  writeProgramToFile "parallelLineBufferWithAdd" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/parallelLineBufferWithAdd.py" False parallelLB
  --writeProgramToFile "partialParallelLineBufferWithAdd" preludeLocationStrForEx epilogueLocationStrForEx
  -- "pyExamples/partialParallelLineBufferWithAdd.py" False partialParallelLB
  writeProgramToFile "sequentialConvolution" preludeLocationStrForEx epilogueLocationStrForEx 
    "pyExamples/sequentialConvolution.py" False sequentialConvolution
  writeProgramToFile "parallelConvolution" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/parallelConvolution.py" False parallelConvolution
  writeProgramToFile "partialParallel2Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel2Convolution.py" False partialParallel2Convolution
  writeProgramToFile "partialParallel4Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel4Convolution.py" False partialParallel4Convolution
  writeProgramToFile "partialParallel8Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel8Convolution.py" False partialParallel8Convolution
  writeProgramToFile "partialParallel16Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel16Convolution.py" False partialParallel16Convolution
  writeProgramToFile "sequentialConvChain" preludeLocationStrForEx epilogueLocationStrForEx 
    "pyExamples/sequentialConvChain.py" False sequentialConvChain
  writeProgramToFile "partialParallel2ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel2ConvChain.py" False partialParallel2ConvChain
  writeProgramToFile "partialParallel4ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel4ConvChain.py" False partialParallel4ConvChain
  writeProgramToFile "partialParallel8ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel8ConvChain.py" False partialParallel8ConvChain
  writeProgramToFile "partialParallel16ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/partialParallel16ConvChain.py" False partialParallel16ConvChain

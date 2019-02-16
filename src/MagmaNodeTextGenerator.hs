module MagmaNodeTextGenerator where
import DataTypes
import Data.Proxy
import Data.Maybe
import GHC.TypeLits
import GHC.TypeLits.Extra
import ModulesDecl
import Data.List.Split
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Identity
import Data.Typeable
import Data.Either
import Debug.Trace
import LineBuffer
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V

magmaNodeBaseName = "magmaInstance"

copyStringWithInt :: Int -> Int -> (Int -> String) -> String
copyStringWithInt baseNum numCopies stringGenerator =
  foldl (++) "" $ fmap stringGenerator [baseNum..(baseNum + numCopies - 1)]

-- how many copies of a node are necessary to parallelize it
-- some nodes internally parallelize, so don't need to copy
-- to parallelize
numCopiesToParallelize :: NodeType -> Int -> Int
numCopiesToParallelize (UpT _ _) _ = 1
numCopiesToParallelize (DownT _ _) _ = 1
numCopiesToParallelize (FoldT _ _ totalLen) par = max 1 (par `div` totalLen)
numCopiesToParallelize (LineBufferT _) _ = 1
numCopiesToParallelize (NoopT nt par) _ = numCopiesToParallelize nt par
numCopiesToParallelize _ par = par

-- left string is an error, right string is a valid result
-- first int is the index, second is the parallelism
duplicateAndInstantiateNode :: NodeType -> Int -> Int -> Either String String
-- otherwise, duplicate if success (if right), and propagate error if failure
duplicateAndInstantiateNode nodeType baseNum par |
  isRight (createMagmaDefOfNode nodeType par) =
  Right $ copyStringWithInt baseNum numCopies $
  \x -> magmaNodeBaseName ++ show x ++ " = " ++
        (fromRight "" $ createMagmaDefOfNode nodeType par) ++ "()\n"
  where
    numCopies = numCopiesToParallelize nodeType par
duplicateAndInstantiateNode nodeType _ par = createMagmaDefOfNode nodeType par

-- left string is an error, right string is a valid result
-- int is the parallelism
createMagmaDefOfNode :: NodeType -> Int -> Either String String
createMagmaDefOfNode AbsT _ = Left "Abs node not implemented" 
createMagmaDefOfNode NotT _ = Right "DefineNegate(8)"
createMagmaDefOfNode (NoopT nt par) _ = Right $ "DefineNoop(" ++
  (fromRight "bad Noop inner def" $ createMagmaDefOfNode nt par) ++ ")"
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
                                                     -- direction doesn't matter
                                                     -- just need the boolean flag
                                                     -- for oneTypeToMagmaString
                                                     (oneTypeToMagmaString True $ typeOf proxy) ++
                                                     ")")
createMagmaDefOfNode (UpT proxy upAmount) par | par > 1 = Left (
                                                   "Upsample partially parallel not implemented in Magma")
createMagmaDefOfNode (UpT proxy upAmount) 1 = Right (
                                                     "DefineUpsampleSequential(" ++
                                                     "cirb, " ++ show upAmount ++
                                                     ", " ++ 
                                                     (oneTypeToMagmaString True $ typeOf proxy) ++
                                                     ")")
-- can't upsample by less than 1
createMagmaDefOfNode (UpT _ _) _ = Left "Upsample must have a par of at least 1"
createMagmaDefOfNode (DownT proxy upAmount) par | par == upAmount = Right (
                                                     "DefineDownsampleParallel(" ++
                                                     "cirb, " ++ show par ++ ", " ++ 
                                                     (oneTypeToMagmaString True $ typeOf proxy) ++
                                                     ")")
createMagmaDefOfNode (DownT proxy upAmount) par | par > 1 = Left (
                                                   "Downsample partially parallel not implemented in Magma")
createMagmaDefOfNode (DownT proxy upAmount) 1 = Right (
                                                     "DefineDownsampleSequential(" ++
                                                     show upAmount ++
                                                     ", " ++ 
                                                     (oneTypeToMagmaString True $ typeOf proxy) ++
                                                     ")")
-- can't upsample by less than 1
createMagmaDefOfNode (DownT _ _) _ = Left "Downsample must have a par of at least 1"
-- if the inner node doesn't work, just fail
createMagmaDefOfNode (FoldT nt _ totalLen) par |
  isLeft (createMagmaDefOfNode nt 1) = createMagmaDefOfNode nt 1
createMagmaDefOfNode (FoldT nt _ totalLen) par |
  (par >= totalLen) && (par `mod` totalLen == 0) = Right (
    "DefineReduceParallel(cirb, " ++ show totalLen ++ ", " ++
    "renameCircuitForReduce(" ++ innerString ++ "))")
  where
    innerString = fromRight "" (createMagmaDefOfNode nt 1)
createMagmaDefOfNode (FoldT nt _ totalLen) par |
  (par > 1) && (par < totalLen) && (totalLen `mod` par == 0) = Right (
    "DefineReducePartiallyParallel(cirb, " ++ show totalLen ++ ", " ++
      show par ++ ", " ++ innerString ++ ")()")
  where
    innerString = fromRight "" (
      createMagmaDefOfNode nt 1)
createMagmaDefOfNode (FoldT nt _ totalLen) 1 = Right (
                                                     "DefineReduceSequential(" ++
                                                     "cirb, " ++ show totalLen ++ ", " ++ 
                                                     "renameCircuitForReduce(" ++
                                                     innerString ++ "))")
                                                  where
                                                    innerString = fromRight "" (
                                                      createMagmaDefOfNode nt 1)
createMagmaDefOfNode (FoldT _ _ _) _ = Left ("FoldT must have a par of " ++
  "at least 1 and either totalLen % par == 0 (if par < totalLen) or " ++
  "par % totalLen == 0 (if par >= totalLen)")
createMagmaDefOfNode (ForkJoinT _ _) _ = Left "ForkJoin shouldn't be printed to magma"
createMagmaDefOfNode (LineBufferT lbData) par | not (null paramCheck) =
                                                Left $ "LineBuffer has invalid" ++
                                                " parameters, params are " ++
                                                show lbData ++ ". par is " ++
                                                show par ++ " and the errors are " ++
                                                (foldl (++) "" paramCheck)
  where
    paramCheck = linebufferDataValid par lbData
createMagmaDefOfNode (LineBufferT (LineBufferData windowSize imageSize
                                   stride origin tokenType)) par =
  Right ( "DefineTwoDimensionalLineBuffer(cirb, " ++
          (oneTypeToMagmaString True tokenType) ++ ", " ++
          -- this is the parallelism computation for row and col dimensions of image
          (show xParallelism) ++ ", " ++
          (show yParallelism) ++ ", " ++
          (show $ snd windowSize) ++ ", " ++ (show $ fst windowSize) ++ ", " ++
          (show $ snd imageSize) ++ ", " ++ (show $ fst imageSize) ++ ", " ++
          (show $ snd stride) ++ ", " ++ (show $ fst stride) ++ ", " ++
          (show $ ((*) (-1)) $ snd origin) ++ ", " ++ (show $ ((*) (-1)) $ fst origin) ++
          ")"
        )
  where
    -- for now, need to emit at least a complete stride every clock so emit once
    -- every clock as no underutil yet
    (yParallelism, xParallelism) = linebufferPxPerClock par (snd imageSize)

type PortName = String

-- the control ports for one stage of the DAG, duplicated
-- ports for parallelism or zip stages with multiple elements
-- that all need to be parallelized
data ControlPorts = ControlPorts {
  ce :: [PortName],
  readyPorts :: [PortName],
  validPorts :: [PortName]
  } deriving (Show, Eq)

emptyControlPorts = ControlPorts [] [] []
standardControlPorts fnName =
  ControlPorts [fnName ++ ".CE"] [fnName ++ ".ready"] [fnName ++ ".valid"]

-- zip together the control ports that are in the same stage of the pipeline
zipControlPorts :: ControlPorts -> ControlPorts -> ControlPorts
zipControlPorts ports1 ports2 = ControlPorts
  (ce ports1 ++ ce ports2)
  (readyPorts ports1 ++ readyPorts ports2)
  (validPorts ports1 ++ validPorts ports2)

data Ports = Ports {
  inPorts :: [PortName],
  -- the int is how many copies in an array to make
  -- if this is 1, no array. If greater than 1, need to wrap the string
  -- from oneTypeToMagmaString in an array
  -- may be able to get rid of all ints in these tuples. All ports are flattend out
  -- so may not need to have a tracker of parallelism.
  inTypes :: [(TypeRep, Int)],
  outPorts :: [PortName],
  outTypes :: [(TypeRep, Int)],
  controlPorts :: ControlPorts
  } deriving (Show, Eq)

emptyPorts = Ports [] [] [] [] emptyControlPorts

mergePorts :: Ports -> Ports -> Ports
mergePorts ports1 ports2 =
  Ports allInPorts allInTypes allOutPorts allOutTypes (ControlPorts allCEPorts
                                                      allReadyPorts allValidPorts)
  where
    allInPorts = (inPorts ports1) ++ (inPorts ports2)
    allInTypes = (inTypes ports1) ++ (inTypes ports2)
    allOutPorts = (outPorts ports1) ++ (outPorts ports2)
    allOutTypes = (outTypes ports1) ++ (outTypes ports2)
    zippedControlPorts = zipControlPorts (controlPorts ports1) (controlPorts ports2)
    allCEPorts = ce zippedControlPorts
    allReadyPorts = readyPorts zippedControlPorts
    allValidPorts = validPorts zippedControlPorts

binaryFunctionPorts fnName fnInTypes fnOutTypes =
  Ports [fnName ++ ".I0", fnName ++ ".I1"] fnInTypes [fnName ++ ".O"]
  fnOutTypes emptyControlPorts 

-- get duplicated ports for parallel versions of nodes
getDuplicatedPorts :: NodeType -> Int -> Int -> Either String Ports
getDuplicatedPorts nodeType baseNum par |
  isRight (getPorts nodeType magmaNodeBaseName par) =
  Right $ (Ports allNodesInPorts allNodesInTypes
           allNodesOutPorts allNodesOutTypes allControlPorts)
  where
    --numCopies = trace (show (numCopiesToParallelize nodeType par) ++ " " ++ show par ++ " " ++ show nodeType) $ numCopiesToParallelize nodeType par
    numCopies = numCopiesToParallelize nodeType par
    allNodesPorts = fmap (\idx -> fromRight undefined $
                           getPorts nodeType ("magmaInstance" ++ show idx)
                           par) [baseNum .. (baseNum + numCopies - 1)]
    allNodesInPorts = foldl (++) [] $ fmap inPorts allNodesPorts
    allNodesInTypes = foldl (++) [] $ fmap inTypes allNodesPorts
    allNodesOutPorts = foldl (++) [] $ fmap outPorts allNodesPorts
    -- for all nodes out types, set the second number in tuple to indicate
    -- which parallel instance they correspond to
    -- for the nodes which parallelize themselves, length of top level list is
    -- 1, so will just multiply by 1 for all them, allowing their own grouping
    -- for the nodes that don't parallelize themselves, their initial numbers
    -- are all 1, so they will all take their groups number
    setAllTypesOfSameIndex (pts, idx) = fmap (\pt -> (fst pt, snd pt * idx)) pts
    setAllParallelTypes listOfListOfTypes = fmap setAllTypesOfSameIndex
      (zip listOfListOfTypes [1..length listOfListOfTypes])
    allNodesOutTypes = foldl (++) [] $ setAllParallelTypes $ fmap outTypes allNodesPorts
    allNodesCEPorts = foldl (++) [] $ fmap (ce . controlPorts) allNodesPorts
    allNodesReadyPorts = foldl (++) [] $ fmap (readyPorts . controlPorts) allNodesPorts
    allNodesValidPorts = foldl (++) [] $ fmap (validPorts . controlPorts) allNodesPorts
    allControlPorts = ControlPorts allNodesCEPorts allNodesReadyPorts allNodesValidPorts
getDuplicatedPorts nodeType baseNum par = getPorts nodeType magmaNodeBaseName par

bitType = (typeOf (Proxy :: Proxy (Atom Bool)), 1)
intType = (typeOf (Proxy :: Proxy (Atom Int)), 1)
unitType = (typeOf (Proxy :: Proxy (Atom ())), 1)

getPorts :: NodeType -> String -> Int -> Either String Ports
getPorts AbsT _ _ = Left "Abs node not implemented" 
getPorts NotT fnName _ = Right $ Ports [fnName ++ "I"] [bitType]
                         [fnName ++ "O"] [bitType] emptyControlPorts
getPorts (NoopT nt par) fnName _ = Right (
  Ports noopInputPortNames (outTypes innerPorts)
    noopOutputPortNames (outTypes innerPorts) emptyControlPorts)
  where
    innerPorts = fromRight (emptyPorts {inPorts = ["bad inner ports to Noop"]}) $
                 getPorts nt "toRemove" par
    noopInputPortNames = fmap (replaceAString "toRemove." (fnName ++ ".in_")) $ outPorts innerPorts
    noopOutputPortNames = fmap (replaceAString "toRemove" (fnName)) $ outPorts innerPorts
getPorts AddT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [intType]
getPorts SubT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [intType]
getPorts DivT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [intType]
getPorts MulT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [intType]
getPorts MinT fnName _ = Left "Min node not implemented in magma" 
getPorts MaxT fnName _ = Left "Max node not implemented in magma" 
getPorts AshrT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [intType]
getPorts ShlT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [intType]
getPorts EqIntT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [bitType]
getPorts NeqIntT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [bitType]
getPorts LtIntT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [bitType]
getPorts LeqIntT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [bitType]
getPorts GtIntT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [bitType]
getPorts GeqIntT fnName _ = Right $ binaryFunctionPorts fnName [intType, intType] [bitType]
getPorts AndT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts OrT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts XorT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts EqBitT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts NeqBitT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts LtBitT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts LeqBitT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts GtBitT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts GeqBitT fnName _ = Right $ binaryFunctionPorts fnName [bitType, bitType] [bitType]
getPorts (LutGenIntT as) _ _ = Left "LUT not implemented in Magma"
getPorts (LutGenBitT as) _ _ = Left "LUT not implemented in Magma"
getPorts (ConstGenIntT x) fnName _ = Right $ Ports [] [] [fnName ++ ".O"] [intType] emptyControlPorts
getPorts (ConstGenBitT x) fnName _ = Right $ Ports [] [] [fnName ++ ".O"] [bitType] emptyControlPorts
-- can't upsample by less than 1
getPorts (UpT _ _) _ _ = Left "Upsample not implemented yet for getPorts"
getPorts (DownT _ _) _ _ = Left "Downsample not implemented yet for getPorts"
-- if the inner node doesn't work, just fail
getPorts (FoldT nt _ _) _ _ | isLeft (getPorts nt "" 1) = Left "Must be able to get ports of inner node in to get ports of FoldT"
getPorts (FoldT nt _ totalLen) fnName par |
  (par >= totalLen) && (par `mod` totalLen == 0) = Right (
    Ports inputsWithIndex inputTypes [fnName ++ ".out"]
      [innerPortOutputType] emptyControlPorts)
  where
    copiedInputs = replicate totalLen (\x -> fnName ++ ".I.data[" ++ show x ++ "]") 
    inputsWithIndex :: [String]
    inputsWithIndex = zipWith (\f -> \x -> f x) copiedInputs [0..(totalLen - 1)]
    -- this is used to get the type of the inner port
    innerPorts = fromRight undefined $ getPorts nt "" 0
    innerPortInputType = fst $ head $ inTypes $ innerPorts
    inputTypes = replicate (length inputsWithIndex) (innerPortInputType, 1)
    innerPortOutputType = head $ outTypes $ innerPorts

getPorts (FoldT nt _ totalLen) fnName par |
  (par > 1) && (par < totalLen) && (totalLen `mod` par == 0) = Right (
    Ports inputsWithIndex inputTypes [fnName ++ ".O"]
      [innerPortOutputType] (standardControlPorts fnName))
  where
    copiedInputs = replicate par (\x -> fnName ++ ".I[" ++ show x ++ "]") 
    inputsWithIndex :: [String]
    inputsWithIndex = zipWith (\f -> \x -> f x) copiedInputs [0..(par - 1)]
    innerPorts = fromRight undefined $ getPorts nt "" 0
    innerPortInputType = fst $ head $ inTypes $ innerPorts
    inputTypes = replicate (length inputsWithIndex) (innerPortInputType, 1)
    innerPortOutputType = head $ outTypes $ innerPorts

getPorts (FoldT nt _ totalLen) fnName 1 = Right (
  Ports [fnName ++ ".I"] [innerPortInputType] [fnName ++ ".out"]
  [innerPortOutputType] (standardControlPorts fnName))
  where
    innerPorts = fromRight undefined $ getPorts nt "" 0
    innerPortInputType = head $ inTypes $ innerPorts
    innerPortOutputType = head $ outTypes $ innerPorts
getPorts (FoldT _ _ _) _ _ = Left ("FoldT must have a par of " ++
  "at least 1 and either totalLen % par == 0 (if par < totalLen) or " ++
  "par % totalLen == 0 (if par >= totalLen)")
getPorts (ForkJoinT _ _) _ _ = Left "ForkJoin shouldn't be printed to magma"
getPorts (LineBufferT lbData) _ par | not (null paramCheck) =
                                        Left $ "LineBuffer has invalid" ++
                                        " parameters, params are " ++
                                        show lbData ++ ". par is " ++
                                        show par ++ "and the errors are " ++
                                        (foldl (++) "" paramCheck)
  where
    paramCheck = linebufferDataValid par lbData
getPorts (LineBufferT (LineBufferData windowSize imageSize stride origin
                       tokenType)) fnName par =
  Right (Ports inputPorts (replicate (length inputPorts) (tokenType, 0))
         outputPorts outputTypes
         (standardControlPorts fnName))
  where
    -- for now, need to emit at least a complete stride every clock so emit once
    -- every clock as no underutil yet
    (rows_of_pixels_per_clock, pixels_per_row_per_clock) =
      linebufferPxPerClock par (snd imageSize)
    inputPorts = [ fnName ++ ".I[" ++ show cur_row ++ "][" ++ show cur_col ++ "]"
                 | cur_row <- [0..(rows_of_pixels_per_clock - 1)],
                   cur_col <- [0..(pixels_per_row_per_clock - 1)]]
    -- when underutil allowed, this will get much more complicated
    -- check with ports in Python implementation
    windows_per_active_clock =
      max ((rows_of_pixels_per_clock * pixels_per_row_per_clock) `div`
      (fst stride * snd stride)) 1
    outputPorts = [ fnName ++ ".O[" ++ show cur_window ++ "][" ++ show cur_row
                    ++ "][" ++ show cur_col ++ "]"
                  | cur_window <- [0 .. (windows_per_active_clock - 1)],
                    cur_row <- [0..((fst windowSize) - 1)],
                    cur_col <- [0..((snd windowSize) - 1)]]
    outputTypes = [(tokenType, cur_window) |
                   cur_window <- [1 .. windows_per_active_clock],
                   element_in_window <- [1..(fst windowSize * snd windowSize)]]
  {-
windows_per_active_clock, Array(window_rows, Array(window_cols,
 windows_per_row_per_clock = max(pixels_per_row_per_clock // stride_cols, 1)
        rows_of_windows_per_clock = max(rows_of_pixels_per_clock // stride_rows, 1)
        if stride_rows <= rows_of_pixels_per_clock:
            windows_per_active_clock = windows_per_row_per_clock * rows_of_windows_per_clock
-}


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
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V

magmaNodeBaseName = "magmaInstance"

copyStringWithInt :: Int -> Int -> (Int -> String) -> String
copyStringWithInt baseNum numCopies stringGenerator =
  foldl (++) "" $ fmap stringGenerator [baseNum..(baseNum + numCopies - 1)]

nodeParallelizesBySelf :: NodeType -> Bool
nodeParallelizesBySelf (UpT _ _) = True
nodeParallelizesBySelf (DownT _ _) = True
nodeParallelizesBySelf (FoldT _ _) = True
nodeParallelizesBySelf _ = False

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
    numCopies = if nodeParallelizesBySelf nodeType then 1 else par
duplicateAndInstantiateNode nodeType _ par = createMagmaDefOfNode nodeType par

-- left string is an error, right string is a valid result
-- int is the parallelism
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
  } deriving Show

mergePorts :: Ports -> Ports -> Ports
mergePorts ports1 ports2 = Ports allInPorts allOutPorts allCEPorts allValidPorts
  where
    allInPorts = (inPorts ports1) ++ (inPorts ports2)
    allOutPorts = (outPorts ports1) ++ (outPorts ports2)
    allCEPorts = (ce ports1) ++ (ce ports2)
    allValidPorts = (validPorts ports1) ++ (validPorts ports2)

binaryFunctionPorts fnName = Ports [fnName ++ ".I0", fnName ++ ".I1"] [fnName ++ ".O"] [] [] 

-- get duplicated ports for parallel versions of nodes
getDuplicatedPorts :: NodeType -> Int -> Int -> Either String Ports
getDuplicatedPorts nodeType baseNum par |
  isRight (getPortNames nodeType magmaNodeBaseName par) =
  Right $ Ports allNodesInPorts allNodesOutPorts allNodesCEPorts allNodesValidPorts
  where
    numCopies = if nodeParallelizesBySelf nodeType then 1 else par
    allNodesPorts = fmap (\idx -> fromRight undefined $ getPortNames nodeType ("magmaInstance" ++ show idx)
                           par) [baseNum .. (baseNum + numCopies - 1)]
    allNodesInPorts = foldl (++) [] $ fmap inPorts allNodesPorts
    allNodesOutPorts = foldl (++) [] $ fmap outPorts allNodesPorts
    allNodesCEPorts = foldl (++) [] $ fmap ce allNodesPorts
    allNodesValidPorts = foldl (++) [] $ fmap validPorts allNodesPorts
getDuplicatedPorts nodeType baseNum par = getPortNames nodeType magmaNodeBaseName par

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

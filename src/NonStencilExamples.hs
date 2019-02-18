module NonStencilExamples where
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
import MagmaCompiler
import MagmaNodeTextGenerator
import LineBuffer
import Data.List
import ReadyValid
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V

-- examples of programs in space and time
-- iterInput = Seq $ V.fromTuple ((Int 1, Int 2), (Int 3, Int 4), (Int 5, Int 6), (Int 7, Int 8))
-- replace unscheduledCirc with this one to see a composition

unscheduledPipeline = iterC (Proxy @4) $ addUnitType >>>
                                     (noop (constGenIntC (Int 1)) *** constGenIntC (Int 1)) >>> addC
unscheduledNode = iterC (Proxy @4) $ addC

lb2x2Example = (lineBuffer (Proxy :: Proxy (Atom Int)) (Proxy @2) (Proxy @2) (Proxy @8) (Proxy @8)
                (Proxy @1) (Proxy @1) (Proxy @0) (Proxy @0))

lbExampleConsts lengthProxy = iterC lengthProxy $
  (constGenIntC (Int 1) *** constGenIntC (Int 2)) ***
  (constGenIntC (Int 2) *** constGenIntC (Int 1)) >>>
  reshapeC (Proxy :: Proxy (Atom (Atom (Atom Int, Atom Int), Atom (Atom Int, Atom Int))))
  (Proxy :: Proxy (Atom (V.Vector 2 (Atom (V.Vector 2 (Atom Int))))))

--lbExampleConsts = iterC (Proxy @100) $ mapC (Proxy @2) $ mapC (Proxy @2) $ constGenIntC (Int 3)
lbExampleMuls lengthProxy = iterC lengthProxy $ seq_to_vectorC $ iterC (Proxy @2) $
  seq_to_vectorC $ iterC (Proxy @2) $ mulC
flattenNestedNTuples lengthProxy = iterC lengthProxy $
  reshapeC (Proxy :: Proxy (Atom (V.Vector 2 (Atom (V.Vector 2 (Atom Int))))))
  (Proxy :: Proxy (Atom (V.Vector 4 (Atom Int))))
unscheduledLBExample = (iterC (Proxy @64) addUnitType) >>>
  (lb2x2Example >***< lbExampleConsts (Proxy @64)) >>>
  lbExampleMuls (Proxy @64) >>> flattenNestedNTuples (Proxy @64)
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

lb_32x32Im_2x2Win_Example = (lineBuffer (Proxy :: Proxy (Atom Int))
                             (Proxy @2) (Proxy @2) (Proxy @32) (Proxy @32)
                             (Proxy @1) (Proxy @1) (Proxy @0) (Proxy @0))

foldParameterizedExample lengthProxy = iterC lengthProxy $ seq_to_vectorC $
  foldC (Proxy @4) addC (constGenIntC (Int 0))

unscheduledConvolution_32x32Im_2x2Win_Example = (iterC lengthProxy addUnitType) >>>
  (lb_32x32Im_2x2Win_Example >***< lbExampleConsts lengthProxy) >>>
  lbExampleMuls lengthProxy >>> flattenNestedNTuples lengthProxy >>>
  foldParameterizedExample lengthProxy
  where
    lengthProxy = Proxy @1024

unscheduledConvolution_32x32Im_2x2Win_ExampleCData = buildCompilationData unscheduledConvolution_32x32Im_2x2Win_Example
convolution_32x32Im_2x2Win_1px_in_per_clk = seq_to_tseqC unscheduledConvolution_32x32Im_2x2Win_Example
convolution_32x32Im_2x2Win_2px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduledConvolution_32x32Im_2x2Win_Example
convolution_32x32Im_2x2Win_4px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @4) unscheduledConvolution_32x32Im_2x2Win_Example
convolution_32x32Im_2x2Win_8px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @8) unscheduledConvolution_32x32Im_2x2Win_Example
  
-- if compile to verilog is set, put this in the verilog directory. Otherwise
-- put it in the normal py examples directory
writeAllExamples compileToVerilog = do
  let dirToWrite = if compileToVerilog then "pyExamples/verilog/" else "pyExamples/simulation/"
  writeProgramToFile "sequentialSimpleAdd" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "sequentialSimpleAdd.py") compileToVerilog sequentialPipeline
  writeProgramToFile "parallelSimpleAdd" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "parallelSimpleAdd.py") compileToVerilog parallelPipeline
  writeProgramToFile "partialParallelSimpleAdd" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallelSimpleAdd.py") compileToVerilog partialParallelPipeline
  writeProgramToFile "sequentialLineBufferWithAdd" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "sequentialLineBufferWithAdd.py") compileToVerilog sequentialLB
  writeProgramToFile "parallelLineBufferWithAdd" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "parallelLineBufferWithAdd.py") compileToVerilog parallelLB
  --writeProgramToFile "partialParallelLineBufferWithAdd" preludeLocationStrForEx epilogueLocationStrForEx
  -- (dirToWrite ++ "partialParallelLineBufferWithAdd.py") compileToVerilog partialParallelLB
  writeProgramToFile "sequentialConvolution" preludeLocationStrForEx epilogueLocationStrForEx 
    (dirToWrite ++ "sequentialConvolution.py") compileToVerilog sequentialConvolution
  writeProgramToFile "parallelConvolution" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "parallelConvolution.py") compileToVerilog parallelConvolution
  writeProgramToFile "partialParallel2Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel2Convolution.py") compileToVerilog partialParallel2Convolution
  writeProgramToFile "partialParallel4Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel4Convolution.py") compileToVerilog partialParallel4Convolution
  writeProgramToFile "partialParallel8Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel8Convolution.py") compileToVerilog partialParallel8Convolution
  writeProgramToFile "partialParallel16Convolution" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel16Convolution.py") compileToVerilog partialParallel16Convolution
  writeProgramToFile "sequentialConvChain" preludeLocationStrForEx epilogueLocationStrForEx 
    (dirToWrite ++ "sequentialConvChain.py") compileToVerilog sequentialConvChain
  writeProgramToFile "partialParallel2ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel2ConvChain.py") compileToVerilog partialParallel2ConvChain
  writeProgramToFile "partialParallel4ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel4ConvChain.py") compileToVerilog partialParallel4ConvChain
  writeProgramToFile "partialParallel8ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel8ConvChain.py") compileToVerilog partialParallel8ConvChain
  writeProgramToFile "partialParallel16ConvChain" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "partialParallel16ConvChain.py") compileToVerilog partialParallel16ConvChain
  writeProgramToFile "convolution_32x32Im_2x2Win_1px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "convolution_32x32Im_2x2Win_1px_in_per_clk.py")
    compileToVerilog convolution_32x32Im_2x2Win_1px_in_per_clk
  writeProgramToFile "convolution_32x32Im_2x2Win_2px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "convolution_32x32Im_2x2Win_2px_in_per_clk.py")
    compileToVerilog convolution_32x32Im_2x2Win_2px_in_per_clk
  writeProgramToFile "convolution_32x32Im_2x2Win_4px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "convolution_32x32Im_2x2Win_4px_in_per_clk.py")
    compileToVerilog convolution_32x32Im_2x2Win_4px_in_per_clk
  writeProgramToFile "convolution_32x32Im_2x2Win_8px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "convolution_32x32Im_2x2Win_8px_in_per_clk.py")
    compileToVerilog convolution_32x32Im_2x2Win_8px_in_per_clk

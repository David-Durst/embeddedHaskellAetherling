module StencilExamples where
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

downsampleLB16x16 = (lineBuffer (Proxy :: Proxy (Atom Int)) (Proxy @2) (Proxy @2) (Proxy @16) (Proxy @16)
                   (Proxy @2) (Proxy @2) (Proxy @0) (Proxy @0))
downsampleLB16x16CData = buildCompilationData downsampleLB16x16
downsampleLB8x8 = (lineBuffer (Proxy :: Proxy (Atom Int)) (Proxy @2) (Proxy @2) (Proxy @8) (Proxy @8)
                   (Proxy @2) (Proxy @2) (Proxy @0) (Proxy @0))
downsampleLB8x8CData = buildCompilationData downsampleLB8x8
downsampleLB4x4 = (lineBuffer (Proxy :: Proxy (Atom Int)) (Proxy @2) (Proxy @2) (Proxy @4) (Proxy @4)
                   (Proxy @2) (Proxy @2) (Proxy @0) (Proxy @0))
downsampleLB4x4CData = buildCompilationData downsampleLB4x4

convMuls lengthProxy = iterC lengthProxy $ mapC (Proxy @2) $ mapC (Proxy @2) $ mulC
convConsts lengthProxy = iterC lengthProxy $
  (constGenIntC (Int 1) *** constGenIntC (Int 2)) ***
  (constGenIntC (Int 3) *** constGenIntC (Int 4)) >>>
  reshapeC (Proxy :: Proxy (Atom (Atom (Atom Int, Atom Int), Atom (Atom Int, Atom Int))))
  (Proxy :: Proxy (Atom (V.Vector 2 (Atom (V.Vector 2 (Atom Int))))))

tupleLBOutWithConvConsts lengthProxy lb = iterC lengthProxy addUnitType >>>
  (noop lb >***< convConsts lengthProxy)
-- actually not doing this, issue was just braces ordering for zipping
-- need to pair consts with a noop as can't get consts to type match with a downsampling 
-- linebuffer. The different seq in and out lengths of the downsample lb mean it
-- can't be zipped with the consts that have the same lengths in and out
{-
scalableConvConstsForLB lengthProxy = (iterC lengthProxy addUnitType) >>>
  ((iterC lengthProxy noop) >***< (scalableConvConsts lengthProxy))
-}

flattenNTuples lengthProxy = iterC lengthProxy $
  reshapeC (Proxy :: Proxy (Atom (V.Vector 2 (Atom (V.Vector 2 (Atom Int))))))
  (Proxy :: Proxy (Atom (V.Vector 4 (Atom Int))))

convFold lengthProxy = iterC lengthProxy $ seq_to_vectorC $
  foldC (Proxy @4) addC (constGenIntC (Int 0)) 

foldOutputToDivInput lengthProxy = iterC lengthProxy $
  reshapeC (Proxy :: Proxy (Atom (V.Vector 1 (Atom Int)))) (Proxy :: Proxy (Atom Int))

divBy4 lengthProxy = iterC lengthProxy $
  addUnitType >>> (noop (constGenIntC (Int 0)) >***< constGenIntC (Int 4)) >>> divC

firstConv = downsampleLB16x16 >>>
  tupleLBOutWithConvConsts lengthProxy downsampleLB16x16 >>>
  convMuls lengthProxy >>>
  flattenNTuples lengthProxy >>>
  convFold lengthProxy >>>
  foldOutputToDivInput lengthProxy >>>
  divBy4 lengthProxy
  where
    lengthProxy = Proxy @64

secondConv = downsampleLB8x8 >>>
  tupleLBOutWithConvConsts lengthProxy downsampleLB8x8 >>>
  convMuls lengthProxy >>>
  flattenNTuples lengthProxy >>>
  convFold lengthProxy >>>
  foldOutputToDivInput lengthProxy >>>
  divBy4 lengthProxy
  where
    lengthProxy = Proxy @16

thirdConv = downsampleLB4x4 >>>
  tupleLBOutWithConvConsts lengthProxy downsampleLB4x4 >>>
  convMuls lengthProxy >>>
  flattenNTuples lengthProxy >>>
  convFold lengthProxy >>>
  foldOutputToDivInput lengthProxy >>>
  divBy4 lengthProxy
  where
    lengthProxy = Proxy @4

downsampleStencilChain = firstConv >>> secondConv >>> thirdConv
downsampleStencilChain1Per64 = seq_to_tseqC downsampleStencilChain
downsampleStencilChain1Per32 = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) downsampleStencilChain

makeConv downsample lengthProxy = downsample >>>
  tupleLBOutWithConvConsts lengthProxy downsample >>>
  convMuls lengthProxy >>>
  flattenNTuples lengthProxy >>>
  convFold lengthProxy >>>
  foldOutputToDivInput lengthProxy >>>
  divBy4 lengthProxy

-- bigger downsample examples
-- this will allow 16, 32, and 64 in per clock so can do 1, 2, and 4 px out per clock
-- in per clock determine out per clock. 256x256 ensures need real amount of ram
-- for rowbuffer as 64 is 1/4 rather than 1/2 of row size
lb_256x256Im_2x2Win_2x2Downsample = (lineBuffer (Proxy :: Proxy (Atom Int))
                       (Proxy @2) (Proxy @2) (Proxy @256) (Proxy @256)
                       (Proxy @2) (Proxy @2) (Proxy @0) (Proxy @0))
lb_256x256Im_2x2Win_2x2DownsampleCData = buildCompilationData lb_256x256Im_2x2Win_2x2Downsample
lb_128x128Im_2x2Win_2x2Downsample = (lineBuffer (Proxy :: Proxy (Atom Int))
                       (Proxy @2) (Proxy @2) (Proxy @128) (Proxy @128)
                       (Proxy @2) (Proxy @2) (Proxy @0) (Proxy @0))
lb_128x128Im_2x2Win_2x2DownsampleCData = buildCompilationData lb_128x128Im_2x2Win_2x2Downsample
lb_64x64Im_2x2Win_2x2Downsample = (lineBuffer (Proxy :: Proxy (Atom Int))
                       (Proxy @2) (Proxy @2) (Proxy @64) (Proxy @64)
                       (Proxy @2) (Proxy @2) (Proxy @0) (Proxy @0))
lb_64x64Im_2x2Win_2x2DownsampleCData = buildCompilationData lb_64x64Im_2x2Win_2x2Downsample

conv_256x256 = makeConv lb_256x256Im_2x2Win_2x2Downsample (Proxy @16384)
conv_128x128 = makeConv lb_128x128Im_2x2Win_2x2Downsample (Proxy @4096)
conv_64x64 = makeConv lb_64x64Im_2x2Win_2x2Downsample (Proxy @1024)
--second_256x256_conv = makeConv lb_256x256Im_2x2Win_2x2Downsample

unscheduled_downsample_256x256_to_32x32 = conv_256x256 >>> conv_128x128 >>> conv_64x64
downsample_256x256_to_32x32_1px_in_per_clk = seq_to_tseqC unscheduled_downsample_256x256_to_32x32
downsample_256x256_to_32x32_2px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) unscheduled_downsample_256x256_to_32x32
downsample_256x256_to_32x32_4px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @4) unscheduled_downsample_256x256_to_32x32
downsample_256x256_to_32x32_8px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @8) unscheduled_downsample_256x256_to_32x32
downsample_256x256_to_32x32_16px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @16) unscheduled_downsample_256x256_to_32x32
downsample_256x256_to_32x32_32px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @32) unscheduled_downsample_256x256_to_32x32
downsample_256x256_to_32x32_64px_in_per_clk = seq_to_tseqC $ split_seq_to_sseqC (Proxy @64) unscheduled_downsample_256x256_to_32x32
{-
downsampleStencilChain1Per64 = seq_to_tseqC downsampleStencilChain
downsampleStencilChain1Per32 = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) downsampleStencilChain
-}
--increaseUtilTtoSC (Proxy @2) downsampleStencilChain1Per64
writeAllStencils compileToVerilog = do
  let dirToWrite = if compileToVerilog then "pyExamples/verilog/" else "pyExamples/simulation/"
  writeProgramToFile "downsampleStencilChain1Per64" preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsampleStencilChain1Per64.py") compileToVerilog downsampleStencilChain1Per64 --firstConv --(divBy4 (Proxy @64) (Proxy @4))-- firstConv --downsampleStencilChain1Per64
  writeProgramToFile "downsample_256x256_to_32x32_1px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsample_256x256_to_32x32_1px_in_per_clk.py")
    compileToVerilog downsample_256x256_to_32x32_1px_in_per_clk
  writeProgramToFile "downsample_256x256_to_32x32_2px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsample_256x256_to_32x32_2px_in_per_clk.py")
    compileToVerilog downsample_256x256_to_32x32_2px_in_per_clk
  writeProgramToFile "downsample_256x256_to_32x32_4px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsample_256x256_to_32x32_4px_in_per_clk.py")
    compileToVerilog downsample_256x256_to_32x32_4px_in_per_clk
  writeProgramToFile "downsample_256x256_to_32x32_8px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsample_256x256_to_32x32_8px_in_per_clk.py")
    compileToVerilog downsample_256x256_to_32x32_8px_in_per_clk
  writeProgramToFile "downsample_256x256_to_32x32_16px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsample_256x256_to_32x32_16px_in_per_clk.py")
    compileToVerilog downsample_256x256_to_32x32_16px_in_per_clk
  writeProgramToFile "downsample_256x256_to_32x32_32px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsample_256x256_to_32x32_32px_in_per_clk.py")
    compileToVerilog downsample_256x256_to_32x32_32px_in_per_clk
  writeProgramToFile "downsample_256x256_to_32x32_64px_in_per_clk"
    preludeLocationStrForEx epilogueLocationStrForEx
    (dirToWrite ++ "downsample_256x256_to_32x32_64px_in_per_clk.py")
    compileToVerilog downsample_256x256_to_32x32_64px_in_per_clk

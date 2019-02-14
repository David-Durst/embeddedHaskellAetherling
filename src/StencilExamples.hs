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
{-
-- downsampleLB8x8 >>> scalableConvConstsForLB lengthProxy >>>
xxz = (downsampleLB8x8 >***<
        (produceRightUnitMix (Proxy :: Proxy (TSeq 64 0 (Atom ()))) >>>
         scalableConvConsts (Proxy @16) (Proxy @4)))
secondConv = seq_to_tseqC (iterC fullLengthProxy addUnitType) >>>
  (downsampleLB8x8 >***< (produceRightUnitMix (Proxy :: Proxy (TSeq 64 0 (Atom ()))) >>>
                           scalableConvConsts underutilLengthProxy underutilMult)) >>>
  scalableConvMuls underutilLengthProxy underutilMult >>>
  scalableNTuplesToFlatSSeq underutilLengthProxy underutilMult >>>
  scalableConvFold underutilLengthProxy underutilMult >>>
  divBy4 underutilLengthProxy underutilMult
  where
    fullLengthProxy = Proxy @64
    underutilLengthProxy = Proxy @16
    underutilMult = Proxy @4

thirdConv = seq_to_tseqC (iterC fullLengthProxy addUnitType) >>>
  (downsampleLB4x4 >***< (produceRightUnitMix (Proxy :: Proxy (TSeq 16 0 (Atom ()))) >>>
                           scalableConvConsts underutilLengthProxy underutilMult)) >>>
  scalableConvMuls underutilLengthProxy underutilMult >>>
  scalableNTuplesToFlatSSeq underutilLengthProxy underutilMult >>>
  scalableConvFold underutilLengthProxy underutilMult >>>
  divBy4 underutilLengthProxy underutilMult
  where
    fullLengthProxy = Proxy @16
    underutilLengthProxy = Proxy @4
    underutilMult = Proxy @4


-- later stencils are underutiled as they are only going to take in 1 input every nth
-- the second every 4th (as it is a 4x4 image that runs for as many clocks as the 8x8)
-- the third every 16th (as it is a 2x2 image that runs for as many clocks as the 8x8)
downsampleStencilChain = firstConv >>>
  (underutilC (Proxy @4) $ seq_to_tseqC $ iterC (Proxy @64) reshapeImplicitC) >>>
  underutilC (Proxy @4) secondConv >>>
  (underutilC (Proxy @16) $ seq_to_tseqC $ iterC (Proxy @16) reshapeImplicitC) >>>
  underutilC (Proxy @16) thirdConv
{-
secondConv = iterC lengthProxy addUnitType >>>
  (downsampleLB4x4 >***< scalableConvConsts lengthProxy) >>>
  scalableConvMuls lengthProxy >>> scalableNTuplesToFlatSSeq lengthProxy >>>
  scalableConvFold lengthProxy
  where
    lengthProxy = Proxy @4

thirdConv = iterC lengthProxy addUnitType >>>
  (downsampleLB2x2 >***< scalableConvConsts lengthProxy) >>>
  scalableConvMuls lengthProxy >>> scalableNTuplesToFlatSSeq lengthProxy >>>
  scalableConvFold lengthProxy
  where
    lengthProxy = Proxy @1

-}
downsampleStencilChain =
  seq_to_sseqC firstConv >>> reshapeImplicitC >>>
  seq_to_sseqC secondConv >>> reshapeImplicitC >>>
  seq_to_sseqC thirdConv

-}
downsampleStencilChain = firstConv >>> secondConv >>> thirdConv
downsampleStencilChain1Per64 = seq_to_tseqC downsampleStencilChain
downsampleStencilChain1Per32 = seq_to_tseqC $ split_seq_to_sseqC (Proxy @2) downsampleStencilChain
--increaseUtilTtoSC (Proxy @2) downsampleStencilChain1Per64
writeAllStencils = do
  writeProgramToFile "downsampleStencilChain1Per64" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/downsampleStencilChain1Per64.py" False downsampleStencilChain1Per64 --firstConv --(divBy4 (Proxy @64) (Proxy @4))-- firstConv --downsampleStencilChain1Per64
  writeProgramToFile "stencilChain1Per32" preludeLocationStrForEx epilogueLocationStrForEx
    "pyExamples/downsampleStencilChain1Per32.py" False downsampleStencilChain1Per32



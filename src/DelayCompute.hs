module DelayCompute where
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
import LineBuffer
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V

-- left string is an error, right string is a valid result
-- int is the parallelism
getNodeClockDelay :: NodeType -> Int -> Int
getNodeClockDelay AbsT _ = 0
getNodeClockDelay NotT _ = 0
getNodeClockDelay NoopT _ = 0
getNodeClockDelay AddT _ = 0
getNodeClockDelay SubT _ = 0
getNodeClockDelay DivT _ = 0
getNodeClockDelay MulT _ = 0
getNodeClockDelay MinT _ = 0
getNodeClockDelay MaxT _ = 0
getNodeClockDelay AshrT _ = 0
getNodeClockDelay ShlT _ = 0
getNodeClockDelay EqIntT _ = 0
getNodeClockDelay NeqIntT _ = 0
getNodeClockDelay LtIntT _ = 0
getNodeClockDelay LeqIntT _ = 0
getNodeClockDelay GtIntT _ = 0
getNodeClockDelay GeqIntT _ = 0
getNodeClockDelay AndT _ = 0
getNodeClockDelay OrT _ = 0
getNodeClockDelay XorT _ = 0
getNodeClockDelay EqBitT _ = 0
getNodeClockDelay NeqBitT _ = 0
getNodeClockDelay LtBitT _ = 0
getNodeClockDelay LeqBitT _ = 0
getNodeClockDelay GtBitT _ = 0
getNodeClockDelay GeqBitT _ = 0
getNodeClockDelay (LutGenIntT as) _ = 0
getNodeClockDelay (LutGenBitT as) _ = 0
getNodeClockDelay (ConstGenIntT x) _ = 0
getNodeClockDelay (ConstGenBitT x) _ = 0
-- up and down never should have delay
-- always emits on first clock
getNodeClockDelay (UpT _ _) _ = 0
getNodeClockDelay (DownT _ _) _ = 0
-- if the inner node doesn't work, just fail
getNodeClockDelay (FoldT nt totalLen) par | par == totalLen = 0
-- need to update this if adding registers inside the fold
getNodeClockDelay (FoldT nt totalLen) par = totalLen `div` par
-- forkjoin does nothing by itself, need to handle merging delays
-- in the compiler code
getNodeClockDelay ForkJoinT _ = 0
getNodeClockDelay (LineBufferT lbData) par =
  let
    (yPerClk, xPerClk) = lbPxPerClk lbData
    (originY, originX) = lbOrigin lbData
    (windowY, windowX) = lbWindow lbData
    (strideY, strideX) = lbStride lbData
    (imgY, imgX) = lbImage lbData
    parallelism = getLineBufferParallelism lbData

    -- First output window's lower-right coordinate.
    (firstLower, firstRight) = (originY + windowY - 1, originX + windowX - 1)

    -- Lower-right coordinate of the first batch of output windows'
    -- last (rightmost) window. (Crystal clear if you think about it).
    (lower, right) = (firstLower, firstRight + (parallelism-1)*strideX)
    -- I believe that the current constraints guarantee that the
    -- parallel output windows are all on the same row (so see that I
    -- could just add some multiple of strideX). Check that assumption
    -- at (1).

    -- index of lower-right pixel in overall ordering of pixels
    -- (left-to-right then top-to-bottom). Assume yPerClk = 1.
    pixelIndex = imgX * lower + right

    latency = (pixelIndex `div` xPerClk)
    in latency

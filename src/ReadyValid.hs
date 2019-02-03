module ReadyValid where
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
import MagmaNodeTextGenerator 
import qualified Data.Map.Strict as Map
import qualified Data.Vector.Sized as V

-- wire up all the valid ports from an earlier stage to the CE ports for a
-- later stage
-- do nothing if at least one of the list of ports is empty
connectReadyValidPorts :: [PortName] -> [PortName] -> [String]
connectReadyValidPorts firstStageValidPorts secondStageCEPorts =
  let
    atLeastOneStageEmpty = null firstStageValidPorts ||
      null secondStageCEPorts
    -- safe to use head and tail as atLeastOneStageEmpty prevents
    -- evaluation if empty
    allFirstStageValids = foldl (\x -> \y -> x ++ " && " ++ y)
      (head firstStageValidPorts) (tail firstStageValidPorts)
    wireCEToValids cePort = "wire(" ++ allFirstStageValids ++ ", " ++ cePort ++ ")\n"
  in 
    if atLeastOneStageEmpty then [] else fmap wireCEToValids secondStageCEPorts


-- this is necessary, for when have two different, non-zero
-- delays in a forkjoin, need to balance out their delays
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
    (originY, originX) = lbOrigin lbData
    (windowY, windowX) = lbWindow lbData
    (strideY, strideX) = lbStride lbData
    (imgY, imgX) = lbImage lbData
    (yPerClk, xPerClk) = linebufferPxPerClock par imgX

    -- First output window's lower-right coordinate.
    -- note that origins are positive rather than negative in this layer
    -- for conversion to proxies
    (firstLower, firstRight) = ((-1 * originY) + windowY - 1, (-1 * originX) + windowX - 1)

    -- Lower-right coordinate of the first batch of output windows'
    -- last (rightmost) window. (Crystal clear if you think about it).
    (lower, right) = (firstLower + (yPerClk-1)*strideY,
                      firstRight + (xPerClk-1)*strideX)

    -- index of lower-right pixel in overall ordering of pixels
    -- (left-to-right then top-to-bottom). I think this is
    -- able to support x and y parallelism
    pixelIndex = imgX * lower + right

    latency = (pixelIndex `div` (yPerClk * xPerClk))
    in latency

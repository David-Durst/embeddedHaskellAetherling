module Aetherling.Image_Helper where
import Data.STBImage
import Data.Either
import qualified Data.Vector.Storable as V

data Pixels = Pixels {
  r_px :: [Int],
  g_px :: [Int],
  b_px :: [Int],
  width :: Int,
  height :: Int
  } deriving (Show, Eq)

load_image_as_ints :: String -> IO Pixels
load_image_as_ints file_name = do
  img_either <- loadImage RGB file_name
  if isLeft img_either
    then fail $ fromLeft "" img_either
    else do
    let img = fromRight undefined img_either
    let pixels = V.toList $ _pixels $ img
    let red_px = fmap (\px -> (fromIntegral . red) px) pixels
    let green_px = fmap (\px -> (fromIntegral . green) px) pixels
    let blue_px = fmap (\px -> (fromIntegral . blue) px) pixels
    return $ Pixels red_px green_px blue_px (_width img) (_height img)

ints_to_image :: String -> Pixels -> IO ()
ints_to_image file_name pixels = do
  let pixels_zipped = zip3 (r_px pixels) (g_px pixels) (b_px pixels)
  let pixels_rgb = fmap (\(r, g, b) -> RGBColor (fromIntegral r) (fromIntegral g) (fromIntegral b)) pixels_zipped
  let pixels_vec = V.fromList pixels_rgb
  let img = Image pixels_vec (width pixels) (height pixels)
  writePNG file_name img

import Aetherling.Interpretations.Simulator
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.ASTs.Sequence
import GHC.TypeLits
import GHC.TypeLits.Extra
import GHC.Exts (Constraint)
import Data.Proxy
import Data.List.Split
import Aetherling.Types.Isomorphisms
import Text.Printf
import Control.Monad
import qualified Data.Vector.Sized as V
import System.Environment   
import Data.List
import Aetherling.Image_Helper

main = do
  args <- getArgs
  img <- load_image_as_ints (head args)
  let img_width = Proxy @192
  let img_height = Proxy @320
  let img_size = img_width `mul_p` img_height
  let sim_data :: Simulation_Env (Seq 3 0 (Seq (192 GHC.TypeLits.* 320) 8 Atom_Int)) = sim_input_seq' (Proxy @3) [
        Seq $ listToVector img_size $ fmap Atom_Int $ r_px img,
        Seq $ listToVector img_size $ fmap Atom_Int $ g_px img,
        Seq $ listToVector img_size $ fmap Atom_Int $ b_px img
        ]
  let result = simulate (blurC img_height img_width sim_data)
  let result_list = fmap (fmap atom_int_to_int) $ fmap seq_to_list $ seq_to_list result
  let result_img = Pixels (result_list !! 0) (result_list !! 1)
                   (result_list !! 2) (192 `div` 2) (320 `div` 2)
  ints_to_image "blurred_HalideParrot.png" result_img
  let result_pyramid = undefined -- simulate (blur_pyramidC img_height img_width sim_data)
  let result_pyramid_list = fmap (fmap atom_int_to_int) $ fmap seq_to_list $ seq_to_list result_pyramid
  let result_img_pyramid = Pixels (result_pyramid_list !! 0) (result_pyramid_list !! 1)
                   (result_pyramid_list !! 2) (192 `div` 8) (320 `div` 8)
  ints_to_image "blurred_pyramid_HalideParrot.png" result_img_pyramid

blur_pyramidC in_row in_col in_img = do
  let layer1 = blurC in_row in_col in_img
  let layer2 = blurC (in_row `div_p` (Proxy @2)) (in_col `div_p` (Proxy @2)) layer1
  blurC (in_row `div_p` (Proxy @4)) (in_col `div_p` (Proxy @4)) layer2

blurC in_row in_col in_img = mapC (blur_bwC in_row in_col) in_img

blur_bwC in_row in_col in_img = do
  let stencils = stencil_2dC (Proxy @3) (Proxy @3) in_col in_img
  let length_proxy = in_row `mul_p` in_col
  let kernels = const_genC gaussian_kernel in_img
  let zipped = mapC (\x -> (map2C atom_tupleC) x kernels) stencils 
  let multiplied = mapC (mapC mulC) zipped
  let sumed = mapC (reduceC addC) multiplied
  let normalizers = const_genC norm_consts in_img
  let zipped_norm = mapC (\x -> (map2C atom_tupleC) x normalizers) sumed 
  let normed = mapC (mapC divC) zipped_norm
  let flattened = unpartitionC normed
  down_2dC (Proxy @2) (Proxy @2) in_row in_col 0 0 flattened

gaussian_kernel :: Seq 9 0 Atom_Int
gaussian_kernel = Seq $ listToVector (Proxy @9) $ fmap Atom_Int [1,2,1,2,4,2,1,2,1]

norm_consts :: Seq 1 8 Atom_Int
norm_consts = Seq $ listToVector (Proxy @1) [Atom_Int 16]

stencil_2dC window_size_row window_size_col in_col in_img = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC in_col last_shifted_seq) : l)
                     [in_img] [0 .. natVal window_size_row - 2]
  let stenciled_seqs = fmap (stencil_1dC window_size_col) shifted_seqs
  let tupled_seqs = zipC window_size_row stenciled_seqs
  let unflattened_windows = seq_tuple_to_seqC Proxy (Proxy @0) tupled_seqs
  mapC unpartitionC unflattened_windows

stencil_1dC window_size in_seq | (natVal window_size) >= 2 = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC (Proxy @1) last_shifted_seq) : l)
                     [in_seq] [0 .. natVal window_size - 2]
  let tuple = zipC window_size shifted_seqs
  seq_tuple_to_seqC Proxy (Proxy @0) tuple
  
stencil_1dC window_size _ = fail $ printf "window size %d < 2" (natVal window_size)

  
stencil_1dC2 window_size in_seq | (natVal window_size) >= 2 = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC (Proxy @1) last_shifted_seq) : l)
                     [in_seq] [0 .. natVal window_size - 2]
  zipC window_size shifted_seqs
  --seq_tuple_to_seqC Proxy (Proxy @0) tuple
  
down_2dC down_row down_col in_row in_col idx_row idx_col =
  partitionC out_row (down_row `mul_p` down_col `mul_p` out_col) (Proxy @0) Proxy >>>
  mapC' out_row (down_2d_one_rowC down_row down_col out_col idx_row idx_col) >>>
  unpartitionC' out_row out_col
  where
    out_row = in_row `div_p` down_row
    out_col = in_col `div_p` down_col

down_2d_one_rowC down_row down_col out_col idx_row idx_col =
  partitionC (down_row `mul_p` out_col) down_col (Proxy @0) Proxy >>>
  (mapC' (down_row `mul_p` out_col) (down_1dC' down_col idx_col)) >>>
  unpartitionC' (down_row `mul_p` out_col) (Proxy @1) >>>
  partitionC down_row out_col (Proxy @0) Proxy >>>
  down_1dC' down_row idx_row >>>
  unpartitionC' (Proxy @1) out_col

mul_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (n GHC.TypeLits.* m)
mul_p _ _ = Proxy :: Proxy (n GHC.TypeLits.* m)

div_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (GHC.TypeLits.Div n m)
div_p _ _ = Proxy :: Proxy (GHC.TypeLits.Div n m)

example_image :: Simulation_Env (Seq 64 0 Atom_Int)
example_image = sim_input_seq $
  fmap Atom_Int [0..63]

example_image_seq :: Seq 64 0 Atom_Int
example_image_seq = Seq $ listToVector (Proxy @64) $ fmap Atom_Int [0..63]
  
example_rows_seq :: Seq 16 0 Atom_Int
example_rows_seq = Seq $ listToVector (Proxy @16) $ fmap Atom_Int [0..15]

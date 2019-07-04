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
  
main = do
  putStrLn "hi"

example_image :: Simulation_Env (Seq 64 0 Atom_Int)
example_image = sim_input_seq $
  fmap Atom_Int [0..63]

example_image_seq :: Seq 64 0 Atom_Int
example_image_seq = Seq $ listToVector (Proxy @64) $ fmap Atom_Int [0..63]
  
example_rows_seq :: Seq 16 0 Atom_Int
example_rows_seq = Seq $ listToVector (Proxy @16) $ fmap Atom_Int [0..15]

blurC in_row in_col in_img = do
  let stencils = stencil_2dC (Proxy @3) (Proxy @3) in_col in_img
  let length_proxy = in_row `mul_p` in_col
  --let length_num :: Int = fromInteger $ natVal length_proxy
  --let kernels_list = repeat gaussian_kernel
  let kernels_list = replicate (fromInteger $ natVal length_proxy) gaussian_kernel
  --let zipped = map2C length_proxy (map2C (Proxy @9) atom_tupleC)
  let kernels = const_genC' (Seq $ listToVector length_proxy $ kernels_list) in_img
  let zipped = map2C'' (map2C'' atom_tupleC') stencils kernels
  let multiplied = mapC'' (mapC'' mulC) zipped
  let sumed = mapC'' (reduceC' addC) multiplied
  let norms_list = replicate (fromInteger $ natVal length_proxy) norm_consts
  let normalizers = const_genC' (Seq $ listToVector length_proxy $ norms_list) in_img
  let zipped_norm = map2C'' (map2C'' atom_tupleC') sumed normalizers
  let normed = mapC'' (mapC'' addC) zipped_norm
  let flattened = unpartitionC' normed
  --down_2dC (Proxy @2) (Proxy @2) in_row in_col 0 0 in_img_val
  undefined

gaussian_kernel :: Seq 9 0 Atom_Int
gaussian_kernel = Seq $ listToVector (Proxy @9) $ fmap Atom_Int [1,2,1,2,4,2,1,2,1]

norm_consts :: Seq 1 8 Atom_Int
norm_consts = Seq $ listToVector (Proxy @1) [Atom_Int 1]

stencil_2dC window_size_row window_size_col in_col in_img = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC in_col last_shifted_seq) : l)
                     [in_img] [0 .. natVal window_size_row - 2]
  let stenciled_seqs = fmap (stencil_1dC window_size_col) shifted_seqs
  let tupled_seqs = zipC window_size_row stenciled_seqs
  let unflattened_windows = mapC' seq_tuple_to_seqC tupled_seqs
  mapC'' unpartitionC' unflattened_windows

stencil_1dC :: (KnownNat n, KnownNat i, KnownNat w, Sequence_Language m,
               Aetherling_Value a) =>
               Proxy w ->
               m (Seq (n + 1) i a) -> m (Seq (n + 1) i (Seq w 0 a))
stencil_1dC window_size in_seq | (natVal window_size) >= 2 = do
  let shifted_seqs = foldl (\l@(last_shifted_seq:_) _ ->
                               (shiftC (Proxy @1) last_shifted_seq) : l)
                     [in_seq] [0 .. natVal window_size - 2]
  let tuple = zipC window_size shifted_seqs
  mapC' seq_tuple_to_seqC tuple
  --let in_len = seq_length in_seq
  --mapC' in_len seq_tuple_to_seqC tuple
  --undefined
                     {-
  tuple <- zipC window_size $ reverse shifted_seqs
  mapC in_len seq_tuple_to_seqC tuple
-}
stencil_1dC window_size _ = fail $ printf "window size %d < 2" (natVal window_size)

down_2dC down_row down_col in_row in_col idx_row idx_col =
  partitionC out_row (down_row `mul_p` down_col `mul_p` out_col) >>>
  mapC out_row (down_2d_one_rowC down_row down_col out_col idx_row idx_col) >>>
  unpartitionC out_row out_col
  where
    out_row = in_row `div_p` down_row
    out_col = in_col `div_p` down_col


down_2d_one_rowC down_row down_col out_col idx_row idx_col =
  partitionC (down_row `mul_p` out_col) down_col >>>
  (mapC (down_row `mul_p` out_col) (down_1dC down_col idx_col)) >>>
  unpartitionC (down_row `mul_p` out_col) (Proxy @1) >>>
  partitionC' down_row out_col (Proxy @0) >>>
  down_1dC down_row idx_row >>>
  unpartitionC (Proxy @1) out_col

mul_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (n GHC.TypeLits.* m)
mul_p _ _ = Proxy :: Proxy (n GHC.TypeLits.* m)

div_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (GHC.TypeLits.Div n m)
div_p _ _ = Proxy :: Proxy (GHC.TypeLits.Div n m)

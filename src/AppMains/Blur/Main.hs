import Aetherling.Interpretations.Simulator
import Aetherling.Types.Declarations
import Aetherling.ASTs.Sequence
import GHC.TypeLits
import GHC.TypeLits.Extra
import GHC.Exts (Constraint)
import Data.Proxy
import Data.List.Split
import Aetherling.Types.Isomorphisms
  
main = do
  putStrLn "hi"

example_image :: Simulation_Env (Seq 64 0 Atom_Int)
example_image = sim_input_seq $
  fmap Atom_Int [0..63]

example_image_seq :: Seq 64 0 Atom_Int
example_image_seq = Seq $ listToVector (Proxy @64) $ fmap Atom_Int [0..63]
  
example_rows_seq :: Seq 16 0 Atom_Int
example_rows_seq = Seq $ listToVector (Proxy @16) $ fmap Atom_Int [0..15]

mapped_add x = do
  x_val <- x
  mapC (Proxy @2) addC x_val

blurC in_row in_col in_img = do
  in_img_val <- in_img
  down_2dC (Proxy @2) (Proxy @2) in_row in_col 0 0 in_img_val

--blurred_image = simulate (blurC example_image (Proxy @8) (Proxy @8))

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

test_down_2d_one_rowC down_row down_col out_col idx_row idx_col =
  partitionC (down_row `mul_p` out_col) down_col >>>
  (mapC (down_row `mul_p` out_col) (down_1dC down_col idx_col)) >>>
  unpartitionC (down_row `mul_p` out_col) (Proxy @1) {->>>
  partitionC down_row out_col >>>
  down_1dC down_row idx_row >>>
  unpartitionC (Proxy @1) out_col-}
mul_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (n GHC.TypeLits.* m)
mul_p _ _ = Proxy :: Proxy (n GHC.TypeLits.* m)

div_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (GHC.TypeLits.Div n m)
div_p _ _ = Proxy :: Proxy (GHC.TypeLits.Div n m)

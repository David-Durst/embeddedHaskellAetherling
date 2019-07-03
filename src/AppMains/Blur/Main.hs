import Aetherling.Interpretations.Simulator
import Aetherling.Types.Declarations
import Aetherling.ASTs.Sequence
import GHC.TypeLits
import GHC.TypeLits.Extra
import GHC.Exts (Constraint)
import Data.Proxy
  
main = do
  putStrLn "hi"

down_2d_mC down_row down_col in_col idx_row idx_col x = do
  y <- partitionC (down_row `mul_p` in_col) down_col x
  return $ unpartitionC (down_row `mul_p` in_col) (Proxy @1) 
  --return $ mapC (down_row `mul_p` in_col) (down_1dC down_col idx_col) y

simp l = mapC l absC >>> mapC l absC

down_2dC down_row down_col in_col in_row idx_row idx_col =
  partitionC down_2d_one_row_repeats (down_row `mul_p` down_col `mul_p` in_col) >>>
  mapC down_2d_one_row_repeats (down_2d_one_rowC down_row down_col in_col idx_row idx_col) 
  --unpartitionC down_2d_one_row_repeats (Proxy @1)
  where
    down_2d_one_row_repeats = in_row `div_p` down_row

down_2d_one_rowC down_row down_col in_col idx_row idx_col =
  partitionC (down_col `mul_p` in_col) down_col >>>
  (mapC (down_row `mul_p` in_col) (down_1dC down_col idx_col)) >>>
  unpartitionC (down_row `mul_p` in_col) (Proxy @1) >>>
  partitionC down_row in_col >>>
  down_1dC down_row idx_col >>>
  unpartitionC (Proxy @1) in_col
  --where
   -- out_col = total_col `div_p` down_col
  
  {-
  partitionC (down_row `mul_p` in_col) down_col >>>
  mapC (down_row `mul_p` in_col) (down_1dC down_col idx_col) >>>
  unpartitionC (down_row `mul_p` in_col) (Proxy @1) >>>
  unpartitionC (down_row `mul_p` in_col) down_col
-}

mul_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (n GHC.TypeLits.* m)
mul_p _ _ = Proxy :: Proxy (n GHC.TypeLits.* m)

div_p :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy (n GHC.TypeLits.* m) -> Proxy m
div_p _ _ = Proxy :: Proxy m

div_p' :: forall n m . (KnownNat n, KnownNat m) =>
  Proxy n -> Proxy m -> Proxy (GHC.TypeLits.Div n m)
div_p' _ _ = Proxy :: Proxy (GHC.TypeLits.Div n m)
   {-
down_1dC :: (KnownNat n, KnownNat i,
              Aetherling_Value a) =>
  Proxy (1+n) -> Seq (1+n) i a -> m (Seq 1 (n + i) a)
-}

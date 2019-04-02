module Aetherling.Interpretations.Simulator where
import Aetherling.Declarations.Sequence
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Types.Isomorphisms
import Aetherling.Interpretations.Monad_Helpers
import Data.Typeable
import Unsafe.Coerce
import qualified Data.Vector.Sized as V
import Util

simulate :: Simulation_Env a -> a
simulate (Simulation_Env a) = a

instance Sequence_Language Simulation_Env where
  -- unary operators
  idC x = return x

  absC (Atom_Int x) = return $ Atom_Int $ abs x
  absC _ = fail $ fail_message "absC" "Atom_Int"
  
  notC (Atom_Bit x) = return $ Atom_Bit $ not x
  notC _ = fail $ fail_message "absC" "Atom_Bit"

  -- binary operators
  addC (Atom_Tuple (Atom_Int x, Atom_Int y)) = return $ Atom_Int $ x+y
  addC _ = fail $ fail_message "addC" "Atom_Int's"

  eqC (Atom_Tuple (x,y)) = return $ Atom_Bit $ x == y 
  eqC _ = fail $ fail_message "eqC" "Atom_Tuple"

  -- generators
  lut_genC xs (Atom_Int i) | i < length xs = return $ xs !! i 
  lut_genC xs (Atom_Int i) = fail "lut lookup index out of bounds"
  lut_genC _ _ = fail $ fail_message "lut_genC" "Atom_Int"

  const_genC x _ = return x

  -- sequence operators
  up_1dC proxyN (Seq elem) = return $ Seq $
    V.replicate' proxyN $ V.head elem
  up_1dC _ _ = fail $ fail_message "up_1dC" "Seq"

  down_1dC proxyN (Seq vec) = return $ Seq $
    V.replicate' (Proxy @1) $ V.head vec
  down_1dC _ _ = fail $ fail_message "down_1dC" "Seq"

  partitionC _ proxy_ni unnested_seq =
    return $ seqToSeqOfSeq proxy_ni unnested_seq 

  unpartitionC _ _ unflattened_seq =
    return $ seqOfSeqToSeq unflattened_seq

  mapC _ f input = mapM f input
  map2C _ f input = traverse2 f input

  -- tuple operations
  fstC (Atom_Tuple (x, _)) = return x
  fstC _ = fail $ fail_message "fstC" "Atom_Tuple"

  sndC (Atom_Tuple (_, y)) = return y
  sndC _ = fail $ fail_message "sndC" "Atom_Tuple"

  zipC x y = return $ Atom_Tuple (x,y) 

  -- composition operators
  (>>>) f g x = f x >>= g

data Simulation_Env a = Simulation_Env a
  deriving (Show, Eq, Functor)

instance Applicative Simulation_Env where
  pure a = Simulation_Env a
  Simulation_Env f <*> Simulation_Env a = Simulation_Env $ f a

instance Monad Simulation_Env where
  (Simulation_Env a) >>= f = f a
  return a = Simulation_Env a

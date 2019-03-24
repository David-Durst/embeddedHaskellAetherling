module Aetherling.Interpretations.Simulator where
import Aetherling.Declarations.Sequence
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Aetherling.Types.Isomorphisms
import Data.Typeable
import Unsafe.Coerce
import qualified Data.Vector.Sized as V
  

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

 {-
  -- higher order operators
  mapC :: (KnownNat n) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

 -} 
  mapC _ f input = return $ fmap f input

  -- composition operators
  (>>>) f g x = f x >>= g

fail_message fName tName = fName ++ " must receive " ++ tName ++
  "not " ++ tName ++ "_Wires or " ++ tName ++ "_Resources."

data Simulation_Env a = Simulation_Env a
  deriving (Show, Eq, Functor)

instance Applicative Simulation_Env where
  pure a = Simulation_Env a
  Simulation_Env f <*> Simulation_Env a = Simulation_Env $ f a

instance Monad Simulation_Env where
  (Simulation_Env a) >>= f = f a
  return a = Simulation_Env a

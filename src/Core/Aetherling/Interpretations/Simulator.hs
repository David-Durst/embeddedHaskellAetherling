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
  addC (Atom_Int x) (Atom_Int y) = return $ Atom_Int $ x+y
  addC _ _ = fail $ fail_message "addC" "Atom_Int's"

  eqC x y = return $ Atom_Bit $ x == y 

  -- generators
  lut_genC xs (Atom_Int i) | i < length xs = return $ xs !! i 
  lut_genC xs (Atom_Int i) = fail "lut lookup index out of bounds"
  lut_genC _ _ = fail $ fail_message "lut_genC" "Atom_Int"

  const_genC x = return x

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
  mapC proxyN f |
    typeOf f == typeOf Atom_Unit || 
    typeOf f == typeOf (Atom_Bit True) ||
    typeOf f == typeOf (Atom_Int 1) =
    -- I need to say that Seq n a is the same as
    -- Type_Lifted_To_Seq n a. I know this as I'm only
    -- allowing things that are not functions in here.
    return $ unsafeCoerce $ Seq $ V.replicate' proxyN f
  -- only do following on functions
  {-
  mapC proxyN f |
    is_function f =
    return $ unsafeCoerce $ seq_all_args vector_of_fs
    where
      f_as_function :: 
      vector_of_fs = V.replicate' proxyN f
      is_function f = L.isInfixOf "->" $ show $ typeOf f
      seq_all_args f | is_function f =
                       V.zipWith ($)
-}

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

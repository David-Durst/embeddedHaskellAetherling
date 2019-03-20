module Aetherling.Declarations.Sequence where 
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import GHC.Exts (Constraint)
import qualified Data.Vector.Sized as V

class Monad m => Sequence_Language m where
  -- unary operators
  id :: (Check_Type_Is_Atom a) => a -> m a
  absC :: Atom_Int -> m Atom_Int
  notC :: Atom_Bit -> m Atom_Bit

  -- binary operators
  addC :: Atom_Int -> Atom_Int -> m Atom_Int
  eqC :: (Check_Type_Is_Atom a, Eq a) =>
    a -> a -> m Atom_Bit

  -- generators
  lut_genC :: (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
    [a] -> Atom_Int -> m a

  const_genC :: (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
    a -> m a

  -- sequence operators
  up_1dC :: (KnownNat n, 1 <= n, KnownNat (Type_Size a),
             Check_Type_Is_Atom a, Typeable (Proxy a)) =>
    Proxy n -> Seq 1 a -> m (Seq n a)

  down_1dC :: (KnownNat n, 1 <= n, KnownNat (Type_Size a),
                Check_Type_Is_Atom a, Typeable (Proxy a)) =>
    Proxy n -> Seq n a -> m (Seq 1 a)

  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) a -> m (Seq no (Seq ni a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni) =>
    Proxy no -> Proxy ni ->
    Seq no (Seq ni a) -> m (Seq (no GHC.TypeLits.* ni) a)

  -- higher order operators
  mapC :: (KnownNat n, Typeable a) => Proxy n ->
    a -> m (Type_Lifted_To_Seq n a)

  -- composition operators
  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

class Sequence_Language m => Symbolic_Sequence_Language m where
  input_unit :: m Atom_Unit
  input_int :: m Atom_Int
  input_bit :: m Atom_Bit
  input_seq :: m (Seq n a)

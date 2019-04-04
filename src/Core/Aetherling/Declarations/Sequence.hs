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
  idC :: (Check_Type_Is_Atom a) => a -> m a
  absC :: Atom_Int -> m Atom_Int
  notC :: Atom_Bit -> m Atom_Bit

  -- binary operators
  addC :: Atom_Tuple Atom_Int Atom_Int -> m Atom_Int
  eqC :: (Check_Type_Is_Atom a, Eq a) => Atom_Tuple a a -> m Atom_Bit

  -- generators
  lut_genC :: (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
    [a] -> Atom_Int -> m a

  const_genC :: (KnownNat (Type_Size a), Check_Type_Is_Atom a) =>
    a -> Atom_Unit -> m a

  -- sequence operators
  up_1dC :: (KnownNat n, KnownNat (Type_Size a),
             Check_Type_Is_Atom a, Typeable (Proxy a)) =>
    Proxy n -> Seq 1 a -> m (Seq n a)

  down_1dC :: (KnownNat n, KnownNat (Type_Size a),
                Check_Type_Is_Atom a, Typeable (Proxy a)) =>
    Proxy n -> Seq (1+n) a -> m (Seq 1 a)

  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) a -> m (Seq no (Seq ni a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni) =>
    Proxy no -> Proxy ni ->
    Seq no (Seq ni a) -> m (Seq (no GHC.TypeLits.* ni) a)

  -- higher order operators
  mapC :: (KnownNat n) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  map2C :: (KnownNat n) =>
    Proxy n -> (a -> b -> m c) -> (Seq n a -> Seq n b -> m (Seq n c))

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    Atom_Tuple a b -> m a
  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    Atom_Tuple a b -> m b

  zipC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    a -> b -> m (Atom_Tuple a b)

  -- composition operators
  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

-- the index of input and output nodes
type AST_Index = Int

data Sequence_Language_AST =
  IdN {input :: AST_Index, output :: AST_Index}
  | AbsN {input :: AST_Index, output :: AST_Index}
  | AddN {input :: AST_Index, output :: AST_Index}
  | EqN {input :: AST_Index, output :: AST_Index}

  -- generators
  | LUT_GenN {
      input :: AST_Index,
      output :: AST_Index,
      lookup_table :: [AST_Value]
      }
  | Const_GenN {
      input :: AST_Index,
      output :: AST_Index,
      constant :: AST_Value
      }

  -- sequence operators
  | Up_1dN {
      input :: AST_Index,
      output :: AST_Index,
      n :: Int,
      t :: AST_Type
      }
  | Down_1dN {
      input :: AST_Index,
      output :: AST_Index,
      n :: Int,
      t :: AST_Type
      }
  | PartitionN {
      input :: AST_Index,
      output :: AST_Index,
      no :: Int,
      ni :: Int,
      t :: AST_Type
      }
  | UnpartitionN {
      input :: AST_Index,
      output :: AST_Index,
      no :: Int,
      ni :: Int,
      t :: AST_Type
      }
  | MapN {n :: Int, f :: Sequence_Language_AST}
  | Map2N {n :: Int, f :: Sequence_Language_AST}
  | FstN {t :: AST_Type}
  | SndN {t :: AST_Type}
  | ZipN {t :: AST_Type}
  {-

  -- higher order operators

  -- tuple operations
  fstC :: (Typeable (Proxy a)Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    Atom_Tuple a b -> m a
  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    Atom_Tuple a b -> m b

  zipC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b) =>
    a -> b -> m (Atom_Tuple a b)

-}
class Sequence_Language m => Symbolic_Sequence_Language m where
  input_unit :: m Atom_Unit
  input_int :: m Atom_Int
  input_bit :: m Atom_Bit
  input_tuple :: m (Atom_Tuple a b)
  input_seq :: m (Seq n a)

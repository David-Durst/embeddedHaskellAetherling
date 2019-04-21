module Aetherling.ASTs.Sequence where 
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
  idC :: (Convertible_To_DAG_Data a, Check_Type_Is_Atom a) => a -> m a
  absC :: Atom_Int -> m Atom_Int
  notC :: Atom_Bit -> m Atom_Bit

  -- binary operators
  addC :: Atom_Tuple Atom_Int Atom_Int -> m Atom_Int
  eqC :: (Convertible_To_DAG_Data a, Check_Type_Is_Atom a, Eq a) =>
    Atom_Tuple a a -> m Atom_Bit

  -- generators
  lut_genC :: (KnownNat (Type_Size a),
               Convertible_To_AST_Value a, Convertible_To_DAG_Data a) =>
    [a] -> Atom_Int -> m a

  const_genC :: (KnownNat (Type_Size a),
                Convertible_To_AST_Value a, Convertible_To_DAG_Data a) =>
    a -> Atom_Unit -> m a

  -- sequence operators
  up_1dC :: (KnownNat n, KnownNat (Type_Size a), Typeable (Proxy a),
             Convertible_To_DAG_Data a) =>
    Proxy n -> Seq 1 a -> m (Seq n a)

  down_1dC :: (KnownNat n, KnownNat (Type_Size a), Typeable (Proxy a),
                Convertible_To_DAG_Data a) =>
    Proxy (1+n) -> Seq (1+n) a -> m (Seq 1 a)

  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                 Convertible_To_DAG_Data a) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) a -> m (Seq no (Seq ni a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                   Convertible_To_DAG_Data a) =>
    Proxy no -> Proxy ni ->
    Seq no (Seq ni a) -> m (Seq (no GHC.TypeLits.* ni) a)

  -- higher order operators
  mapC :: (KnownNat n, Convertible_To_DAG_Data a,
          Convertible_To_DAG_Data b) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  map2C :: (KnownNat n,
            Convertible_To_DAG_Data a,
            Convertible_To_DAG_Data b,
            Convertible_To_DAG_Data c) =>
    Proxy n -> (a -> b -> m c) -> (Seq n a -> Seq n b -> m (Seq n c))

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Convertible_To_DAG_Data a,
           Convertible_To_DAG_Data b) =>
    Atom_Tuple a b -> m a

  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Convertible_To_DAG_Data a,
           Convertible_To_DAG_Data b) =>
    Atom_Tuple a b -> m b

  zipC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Convertible_To_DAG_Data a,
           Convertible_To_DAG_Data b) =>
    a -> b -> m (Atom_Tuple a b)

  -- composition operators
  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

class Sequence_Language m => Simulation_Sequence_Language m where
  sim_input_unit :: () -> m Atom_Unit
  sim_input_int :: Int -> m Atom_Int
  sim_input_bit :: Bool -> m Atom_Bit
  sim_input_tuple :: (a,b) -> m (Atom_Tuple a b)
  sim_input_seq :: Seq n a -> m (Seq n a)
  
class Sequence_Language m => Symbolic_Sequence_Language m where
  sym_input_unit :: m Atom_Unit
  sym_input_int :: m Atom_Int
  sym_input_bit :: m Atom_Bit
  sym_input_tuple :: (Convertible_To_DAG_Data a, Convertible_To_DAG_Data b) =>
                     m (Atom_Tuple a b)
  sym_input_seq :: (KnownNat n, Convertible_To_DAG_Data a) => Proxy n -> m (Seq n a)

type Seq_DAG = DAG Sequence_Language_AST

data Sequence_Language_AST =
  IdN
  | AbsN
  | NotN
  | AddN
  | EqN {t :: AST_Type}

  -- generators
  | Lut_GenN {lookup_table :: [AST_Value]}
  | Const_GenN {constant :: AST_Value}

  -- sequence operators
  | Up_1dN {n :: Int, t :: AST_Type}
  | Down_1dN {n :: Int, t :: AST_Type}
  | PartitionN {no :: Int, ni :: Int, t :: AST_Type} 
  | UnpartitionN {no :: Int, ni :: Int, t :: AST_Type} 
  | MapN {n :: Int, f :: Seq_DAG}
  | Map2N {n :: Int, f :: Seq_DAG}
  | FstN {t0 :: AST_Type, t1 :: AST_Type}
  | SndN {t0 :: AST_Type, t1 :: AST_Type}
  | ZipN {t0 :: AST_Type, t1 :: AST_Type}
  | InputN {t :: AST_Type}
  deriving (Show, Eq)

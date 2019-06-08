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
  up_1dC :: (KnownNat n, KnownNat i,
             KnownNat (Type_Size a), Typeable (Proxy a),
             Convertible_To_DAG_Data a) =>
    Proxy n -> Proxy i -> Seq 1 (n + i - 1) a -> m (Seq n i a)

  select_1dC :: (KnownNat n, KnownNat i,
                 KnownNat (Type_Size a), Typeable (Proxy a),
                Convertible_To_DAG_Data a) =>
    Proxy (1+n) -> Proxy i -> Seq (1+n) i a -> m (Seq 1 (1 + n + i - 1) a)

-- Partition_t_tt no ni :: TSeq (no*ni) (vo + no*vi) t -> TSeq no vo (TSeq ni vi t)
  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                 KnownNat io, KnownNat ii,
                 Convertible_To_DAG_Data a) =>
    Proxy no -> Proxy ni ->
    Proxy io -> Proxy ii ->
    Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* vi)) a ->
    m (Seq no vo (Seq ni vi a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                   KnownNat vo, KnownNat vi,
                   Convertible_To_DAG_Data a) =>
    Proxy no -> Proxy ni ->
    Proxy io -> Proxy ii ->
    Seq no vo (Seq ni vi a) ->
    m (Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* vi)) a)


  -- higher order operators
  mapC :: (KnownNat n, KnownNat i,
           Convertible_To_DAG_Data a,
           Convertible_To_DAG_Data b) =>
    Proxy n -> Proxy i -> (a -> m b) -> (Seq n i a -> m (Seq n i b))

  map2C :: (KnownNat n, KnownNat i,
            Convertible_To_DAG_Data a,
            Convertible_To_DAG_Data b,
            Convertible_To_DAG_Data c) =>
    Proxy n -> Proxy i -> (a -> b -> m c) -> (Seq n i a -> Seq n i b -> m (Seq n i c))

  reduceC :: (KnownNat n, KnownNat i,
              Convertible_To_DAG_Data a) =>
    Proxy n -> Proxy i -> (a -> a -> m a) -> Seq n i a -> m (Seq 1 (n + i - 1) a)

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Convertible_To_DAG_Data a,
           Convertible_To_DAG_Data b) =>
    Atom_Tuple a b -> m a

  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Convertible_To_DAG_Data a,
           Convertible_To_DAG_Data b) =>
    Atom_Tuple a b -> m b

  atom_tupleC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                  Convertible_To_DAG_Data a,
                  Convertible_To_DAG_Data b) =>
    a -> b -> m (Atom_Tuple a b)

  seq_tupleC :: (Convertible_To_DAG_Data a) =>
    Seq n i a -> Seq n i a -> m (Seq_Tuple 2 (Seq n i a))

  seq_tuple_appendC :: (KnownNat n, Convertible_To_DAG_Data a) =>
    Seq_Tuple n a -> a -> m (Seq_Tuple (n+1) a)

  seq_tuple_to_seqC :: Convertible_To_DAG_Data a =>
    Seq_Tuple n a -> m (Seq n i a)

  seq_to_seq_tupleC :: Convertible_To_DAG_Data a =>
    Seq n i a -> m (Seq_Tuple n a)

  shiftC :: KnownNat n =>
    Proxy n -> Proxy i -> Int -> Seq n i a -> Seq n i a

  -- composition operators
  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

class Sequence_Language m => Simulation_Sequence_Language m where
  sim_input_unit :: () -> m Atom_Unit
  sim_input_int :: Int -> m Atom_Int
  sim_input_bit :: Bool -> m Atom_Bit
  sim_input_tuple :: (a,b) -> m (Atom_Tuple a b)
  sim_input_seq :: Seq n i a -> m (Seq n i a)
  
class Sequence_Language m => Symbolic_Sequence_Language m where
  sym_input_unit :: m Atom_Unit
  sym_input_int :: m Atom_Int
  sym_input_bit :: m Atom_Bit
  sym_input_tuple :: (Convertible_To_DAG_Data a, Convertible_To_DAG_Data b) =>
                     m (Atom_Tuple a b)
  sym_input_seq :: (KnownNat n, KnownNat i, Convertible_To_DAG_Data a) =>
    Proxy n -> m (Seq n i a)

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
  | Up_1dN {n :: Int, i :: Int, elem_t :: AST_Type}
  | Down_1dN {n :: Int, i :: Int, elem_t :: AST_Type}
  | PartitionN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      t :: AST_Type
      }
  | UnpartitionN {
      no :: Int,
      ni :: Int,
      io :: Int,
      ii :: Int,
      t :: AST_Type
      }
  | MapN {n :: Int, i :: Int, f :: Seq_DAG}
  | Map2N {n :: Int, i :: Int, f :: Seq_DAG}
  | FstN {t0 :: AST_Type, t1 :: AST_Type}
  | SndN {t0 :: AST_Type, t1 :: AST_Type}
  | ATupleN {t0 :: AST_Type, t1 :: AST_Type}
  | STupleN {tuple_t :: AST_Type}
  | STupleAppendN {tuple_t :: AST_Type}
  | STupleToSeqN {seq_t :: AST_Type}
  | SeqToSTupleN {seq_t :: AST_Type}
  | ShiftN {n :: Int, i :: Int, seq_t :: AST_Type}
  | InputN {t :: AST_Type}
  deriving (Show, Eq)

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
  idC :: (Aetherling_Value a, Check_Type_Is_Atom a) => a -> m a
  absC :: Atom_Int -> m Atom_Int
  notC :: Atom_Bit -> m Atom_Bit

  -- binary operators
  addC :: Atom_Tuple Atom_Int Atom_Int -> m Atom_Int
  eqC :: (Aetherling_Value a, Check_Type_Is_Atom a, Eq a) =>
    Atom_Tuple a a -> m Atom_Bit

  -- generators
  lut_genC :: Aetherling_Value a =>
    [a] -> Atom_Int -> m a

  const_genC :: Aetherling_Value a =>
    a -> m a

  -- sequence operators
  shiftC :: (KnownNat n, KnownNat r, KnownNat i,
              Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> Seq (n+r) i a -> m (Seq (n+r) i a)

  up_1dC :: (KnownNat n, KnownNat i,
             Aetherling_Value a) =>
    Proxy (1+n) -> Seq 1 (n + i) a -> m (Seq (1+n) i a)

  down_1dC :: (KnownNat n, KnownNat i,
                Aetherling_Value a) =>
    Proxy (1+n) -> Seq (1+n) i a -> m (Seq 1 (n + i) a)

  partitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                 KnownNat io, KnownNat ii,
                 Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a ->
    m (Seq no io (Seq ni ii a))

  unpartitionC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                   KnownNat io, KnownNat ii,
                   Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    Seq no io (Seq ni ii a) ->
    m (Seq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a)


  -- higher order operators
  mapC :: (KnownNat n, KnownNat i,
           Aetherling_Value a,
           Aetherling_Value b) =>
    Proxy n -> (a -> m b) -> (Seq n i a -> m (Seq n i b))

  map2C :: (KnownNat n, KnownNat i,
            Aetherling_Value a,
            Aetherling_Value b,
            Aetherling_Value c) =>
    Proxy n -> (a -> b -> m c) -> (Seq n i a -> Seq n i b -> m (Seq n i c))

  reduceC :: (KnownNat n, KnownNat i,
              Aetherling_Value a) =>
    Proxy (1+n) -> (Atom_Tuple a a -> m a) -> Seq (1+n) i a -> m (Seq 1 (n + i) a)

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a,
           Aetherling_Value b) =>
    Atom_Tuple a b -> m a

  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a,
           Aetherling_Value b) =>
    Atom_Tuple a b -> m b

  atom_tupleC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                  Aetherling_Value a,
                  Aetherling_Value b) =>
    a -> b -> m (Atom_Tuple a b)

  seq_tupleC :: (Aetherling_Value (Seq n i a)) =>
    Seq n i a -> Seq n i a -> m (Seq_Tuple 2 (Seq n i a))

  seq_tuple_appendC :: (KnownNat n, Aetherling_Value (Seq_Tuple n a),
                        Aetherling_Value a,
                        Aetherling_Value (Seq_Tuple (n+1) a)) =>
    Seq_Tuple n a -> a -> m (Seq_Tuple (n+1) a)

  seq_tuple_to_seqC :: (KnownNat n,
                        Aetherling_Value a,
                        Aetherling_Value (Seq n i a)) =>
    Seq_Tuple n a -> m (Seq n i a)

  seq_to_seq_tupleC :: (KnownNat n, KnownNat i,
                        Aetherling_Value a,
                        Aetherling_Value (Seq_Tuple n a)) =>
    Seq n i a -> m (Seq_Tuple n a)

  -- composition operators
  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

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
  | ShiftN {n :: Int, i :: Int, shift_amount :: Int, elem_t :: AST_Type}
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

  -- higher order operators
  | MapN {n :: Int, i :: Int, f :: Seq_DAG}
  | Map2N {n :: Int, i :: Int, f :: Seq_DAG}
  | ReduceN {n :: Int, i :: Int, f :: Seq_DAG}
  | FstN {t0 :: AST_Type, t1 :: AST_Type}
  | SndN {t0 :: AST_Type, t1 :: AST_Type}
  | ATupleN {t0 :: AST_Type, t1 :: AST_Type}
  | STupleN {tuple_elem_t :: AST_Type}
  | STupleAppendN {out_len :: Int, tuple_elem_t :: AST_Type}
  | STupleToSeqN {tuple_len :: Int, tuple_elem_t :: AST_Type}
  | SeqToSTupleN {tuple_len :: Int, tuple_elem_t :: AST_Type}
  | InputN {t :: AST_Type}
  deriving (Show, Eq)

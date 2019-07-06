module Aetherling.ASTs.Space_Time where 
import Aetherling.Types.Declarations
import Aetherling.Types.Functions
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import GHC.Exts (Constraint)
import qualified Data.Vector.Sized as V

class Monad m => Space_Time_Language m where
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
  fifoC :: (KnownNat n, KnownNat i, Aetherling_Value a) =>
    Proxy n -> Int -> TSeq n i a -> m (TSeq n i a)

  shift_sC :: (KnownNat n, KnownNat r, Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> SSeq (n+r) a -> m (SSeq (n+r) a)

  shift_tC :: (KnownNat n, KnownNat r, KnownNat i,
              Aetherling_Value a) =>
    Proxy (n+r) -> Proxy r -> TSeq (n+r) i a -> m (TSeq (n+r) i a)

  up_1d_sC :: (KnownNat n, Aetherling_Value a) =>
    Proxy (1+n) -> SSeq 1 a -> m (SSeq (1+n) a)

  up_1d_tC :: (KnownNat n, KnownNat i, Aetherling_Value a) =>
    Proxy (1+n) -> TSeq 1 (n + i) a -> m (TSeq (1+n) i a)

  down_1d_sC :: (KnownNat n, Aetherling_Value a) =>
    Proxy (1+n) -> SSeq (1+n) a -> m (SSeq 1 a)

  down_1d_tC :: (KnownNat n, KnownNat i, Aetherling_Value a) =>
    Proxy (1+n) -> TSeq (1+n) i a -> m (TSeq 1 (n + i) a)

  partition_s_ssC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                      Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    SSeq (no GHC.TypeLits.* ni) a -> m (SSeq no (SSeq ni a))

  partition_t_ttC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                      KnownNat io, KnownNat ii,
                      Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    TSeq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a ->
    m (TSeq no io (TSeq ni ii a))

  unpartition_s_ssC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                        Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    SSeq no (SSeq ni a) -> m (SSeq (no GHC.TypeLits.* ni) a)

  unpartition_t_ttC :: (KnownNat no, KnownNat ni, 1 <= no, 1 <= ni,
                        KnownNat io, KnownNat ii,
                         Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    TSeq no io (TSeq ni ii a) ->
    m (TSeq (no GHC.TypeLits.* ni) (io + (no GHC.TypeLits.* ii)) a)

  serializeC :: (KnownNat no, KnownNat ni, KnownNat io, KnownNat ii,
                 Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    TSeq no (io + no GHC.TypeLits.* ii) (SSeq ni a) ->
    m (TSeq no io (TSeq ni ii a))

  deserializeC :: (KnownNat no, KnownNat ni, KnownNat io, KnownNat ii,
                   Aetherling_Value a) =>
    Proxy no -> Proxy ni ->
    TSeq no io (TSeq ni ii a) ->
    m (TSeq no (io + no GHC.TypeLits.* ii) (SSeq ni a))

  -- higher order operators
  map_sC :: (KnownNat n, Aetherling_Value a, Aetherling_Value b) =>
    Proxy n -> (a -> m b) -> (SSeq n a -> m (SSeq n b))

  map_tC :: (KnownNat n, KnownNat i, Aetherling_Value a, Aetherling_Value b) =>
    Proxy n -> (a -> m b) -> (TSeq n i a -> m (TSeq n i b))

  map2_sC :: (KnownNat n,
              Aetherling_Value a, Aetherling_Value b, Aetherling_Value c) =>
    Proxy n -> (a -> b -> m c) -> (SSeq n a -> SSeq n b -> m (SSeq n c))

  map2_tC :: (KnownNat n, KnownNat i,
              Aetherling_Value a, Aetherling_Value b, Aetherling_Value c) =>
    Proxy n -> (a -> b -> m c) -> (TSeq n i a -> TSeq n i b -> m (TSeq n i c))

  reduce_sC :: (KnownNat n, Aetherling_Value a) =>
    Proxy (1+n) -> (Atom_Tuple a a -> m a) -> SSeq (1+n) a -> m (SSeq 1 a)

  reduce_tC :: (KnownNat n, KnownNat i, Aetherling_Value a) =>
    Proxy (1+n) -> (Atom_Tuple a a -> m a) -> TSeq (1+n) i a -> m (TSeq 1 (n + i) a)

  -- tuple operations
  fstC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a, Aetherling_Value b) =>
    Atom_Tuple a b -> m a

  sndC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
           Aetherling_Value a, Aetherling_Value b) =>
    Atom_Tuple a b -> m b

  atom_tupleC :: (Check_Type_Is_Atom a, Check_Type_Is_Atom b,
                  Aetherling_Value a, Aetherling_Value b) =>
    a -> b -> m (Atom_Tuple a b)

  seq_tupleC :: (Aetherling_Value (SSeq n a)) =>
    SSeq n a -> SSeq n a -> m (Seq_Tuple 2 (SSeq n a))

  seq_tuple_appendC :: (KnownNat n, Aetherling_Value (Seq_Tuple n a),
                        Aetherling_Value a,
                        Aetherling_Value (Seq_Tuple (n+1) a)) =>
    Seq_Tuple n a -> a -> m (Seq_Tuple (n+1) a)

  seq_tuple_to_sseqC :: (KnownNat n,
                        Aetherling_Value a,
                        Aetherling_Value (Seq n i a)) =>
    Seq_Tuple n a -> m (SSeq n a)

  sseq_to_seq_tupleC :: (KnownNat n, KnownNat i,
                         Aetherling_Value a,
                         Aetherling_Value (Seq_Tuple n a)) =>
    SSeq n a -> m (Seq_Tuple n a)

  -- composition operators
  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

--type ST_DAG = DAG Space_Time_Language_AST
{-
data Space_Time_Language_AST =
  IdN
  | AbsN
  | NotN
  | AddN
  | EqN {t :: AST_Type}

  -- generators
  | Lut_GenN {lookup_table :: [AST_Value], lookup_types :: AST_Type}
  | Const_GenN {constant :: AST_Value, constant_type :: AST_Type}

  -- sequence operators
  -- FIFO serve three roles:
  --   1. align clock signatures - delay clks
  --   2. break up combinational paths - does this by default
  --   3. match delays - delay_clks used on a per clock cycle basis
  -- note that delay_clks is number of clks, not number of periods
  | FIFON {n :: Int, i :: Int, delay_clks :: Int, elem_t :: AST_Type}
  | Shift_sN {n :: Int, shift_amount :: Int, elem_t :: AST_Type}
  | Shift_tN {n :: Int, i :: Int, shift_amount :: Int, elem_t :: AST_Type}
  | Up_1d_sN {n :: Int, t :: AST_Type}
  | Up_1d_tN {n :: Int, i :: Int, t :: AST_Type}
  | Down_1d_sN {n :: Int, t :: AST_Type}
  | Down_1d_tN {n :: Int, i :: Int, t :: AST_Type}
  | Partition_s_ssN {no :: Int, ni :: Int, t :: AST_Type}
  | Unpartition_s_ssN {no :: Int, ni :: Int, t :: AST_Type}
  | Partition_t_ttN {no :: Int, io :: Int,
                   ni :: Int, ii :: Int, t :: AST_Type}
  | Unpartition_t_ttN {no :: Int, io :: Int,
                     ni :: Int, ii :: Int, t :: AST_Type}
  | SerializeN {no :: Int, ni :: Int, io :: Int, ii :: Int, elem_t :: AST_Type}
  | DeserializeN {no :: Int, ni :: Int, io :: Int, ii :: Int, elem_t :: AST_Type}

  -- higher order operators
  | Map_sN {n :: Int, f :: ST_DAG}
  | Map_tN {n :: Int,  i :: Int, f :: ST_DAG}
  | Map2_sN {n :: Int, f :: ST_DAG}
  | Map2_tN {n :: Int, i :: Int, f :: ST_DAG}
  | Reduce_sN {n :: Int, f :: ST_DAG}
  | Reduce_tN {n :: Int, i :: Int, f :: ST_DAG}

  -- tuple operators
  | FstN {t0 :: AST_Type, t1 :: AST_Type}
  | SndN {t0 :: AST_Type, t1 :: AST_Type}
  | ATupleN {t0 :: AST_Type, t1 :: AST_Type}
  | STupleN {tuple_elem_t :: AST_Type}
  | STupleAppendN {out_len :: Int, tuple_elem_t :: AST_Type}
  | STupleToSSeqN {tuple_len :: Int, tuple_elem_t :: AST_Type}
  | SSeqToSTupleN {tuple_len :: Int, tuple_elem_t :: AST_Type}

  | InputN {t :: AST_Type}
  deriving (Show, Eq)
-}

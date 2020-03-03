module Aetherling.Languages.Space_Time.Deep.Types where
import Control.DeepSeq
import GHC.Generics (Generic)
import Data.Int
import Data.Word

data AST_Type =
  UnitT
  | BitT
  | Int8T
  | UInt8T
  | Int16T
  | UInt16T
  | Int32T
  | UInt32T
  | ATupleT AST_Type AST_Type
  | STupleT Int AST_Type
  | SSeqT Int AST_Type
  | TSeqT Int Int AST_Type
  deriving (Show, Ord, Eq, Generic, NFData)

st_int8 = Int8T
st_uint8 = UInt8T
st_int16 = Int16T
st_uint16 = UInt16T
st_int32 = Int32T
st_uint32 = UInt32T

{-
instance Eq AST_Type where
  UnitT == UnitT = True
  BitT == BitT = True
  IntT == IntT = True
  ATupleT l_x l_y == ATupleT r_x r_y = (l_x == r_x) && (l_y == r_y)
  (STupleT l_n l_t) == (STupleT r_n r_t) = (l_n == r_n) && (l_t == r_t)
  
  (SSeqT 1 l_t) == r@(SSeqT r_n r_t) = ((1 == r_n) && (l_t == r_t)) ||
    (l_t == r)
  (SSeqT 1 l_t) == r = (l_t == r)
  l@(SSeqT l_n l_t) == (SSeqT 1 r_t) = ((l_n == 1) && (l_t == r_t)) ||
    (l == r_t)
  l == (SSeqT 1 r_t) = l == r_t
  (SSeqT l_n l_t) == (SSeqT r_n r_t) = (l_n == r_n) && (l_t == r_t)
  
  (TSeqT 1 0 l_t) == r@(TSeqT r_n r_i r_t) = ((1 == r_n) && (1 == r_i) && (l_t == r_t)) ||
    (l_t == r)
  (TSeqT 1 0 l_t) == r = l_t == r
  l@(TSeqT l_n l_i l_t) == (TSeqT 1 0 r_t) = ((l_n == 1) && (l_i == 1) && (l_t == r_t)) ||
    (l == r_t)
  l == (TSeqT 1 0 r_t) = l == r_t
  (TSeqT l_n l_i l_t) == (TSeqT r_n r_i r_t) = (l_n == r_n) && (l_i == r_i) && (l_t == r_t)
  _ == _ = False
-}
-- these exist only because it's easier to have a value that is an Aetherling value
-- rather than a value that's a member of a type class of aetherling values,
-- like the above data types
data AST_Value =
  UnitV
  | BitV Bool
  | Int8V Int8
  | UInt8V Word8
  | Int16V Int16
  | UInt16V Word16
  | Int32V Int32
  | UInt32V Word32
  | ATupleV AST_Value AST_Value
  | STupleV [AST_Value]
  | SSeqV [AST_Value]
  | TSeqV {vals :: [AST_Value], i_v :: Int}
  deriving (Show, Eq, Ord, Generic, NFData)

-- | The size in bits of types
size_t :: AST_Type -> Int
size_t UnitT = 0
size_t BitT = 1
size_t Int8T = 8
size_t UInt8T = 8
size_t Int16T = 16
size_t UInt16T = 16
size_t Int32T = 32
size_t UInt32T = 32
size_t (ATupleT t0 t1) = size_t t0 + size_t t1
size_t (STupleT n t) = n * size_t t
size_t (SSeqT n t) = n * size_t t
size_t (TSeqT n _ t) = size_t t

num_atoms_total_t_st = num_atoms_total_t

num_atoms_total_t :: AST_Type -> Int
num_atoms_total_t UnitT = 1
num_atoms_total_t BitT = 1
num_atoms_total_t Int8T = 1
num_atoms_total_t UInt8T = 1
num_atoms_total_t Int16T = 1
num_atoms_total_t UInt16T = 1
num_atoms_total_t Int32T = 1
num_atoms_total_t UInt32T = 1
num_atoms_total_t (ATupleT t0 t1) = 1
num_atoms_total_t (STupleT n t) = num_atoms_total_t t
num_atoms_total_t (SSeqT n t) = n * num_atoms_total_t t
num_atoms_total_t (TSeqT n _ t) = n * num_atoms_total_t t

num_atoms_per_valid_t :: AST_Type -> Int
num_atoms_per_valid_t UnitT = 1
num_atoms_per_valid_t BitT = 1
num_atoms_per_valid_t Int8T = 1
num_atoms_per_valid_t UInt8T = 1
num_atoms_per_valid_t Int16T = 1
num_atoms_per_valid_t UInt16T = 1
num_atoms_per_valid_t Int32T = 1
num_atoms_per_valid_t UInt32T = 1
num_atoms_per_valid_t (ATupleT t0 t1) = 1
num_atoms_per_valid_t (STupleT n t) = num_atoms_per_valid_t t
num_atoms_per_valid_t (SSeqT n t) = n * num_atoms_per_valid_t t
num_atoms_per_valid_t (TSeqT n _ t) = num_atoms_per_valid_t t

clocks_t :: AST_Type -> Int
clocks_t UnitT = 1
clocks_t BitT = 1
clocks_t Int8T = 1
clocks_t UInt8T = 1
clocks_t Int16T = 1
clocks_t UInt16T = 1
clocks_t Int32T = 1
clocks_t UInt32T = 1
clocks_t (ATupleT t0 t1) = 1
clocks_t (STupleT n t) = clocks_t t
clocks_t (SSeqT n t) = clocks_t t
clocks_t (TSeqT n i t) = (n+i) * clocks_t t

valid_clocks_t :: AST_Type -> Int
valid_clocks_t UnitT = 1
valid_clocks_t BitT = 1
valid_clocks_t Int8T = 1
valid_clocks_t UInt8T = 1
valid_clocks_t Int16T = 1
valid_clocks_t UInt16T = 1
valid_clocks_t Int32T = 1
valid_clocks_t UInt32T = 1
valid_clocks_t (ATupleT t0 t1) = 1
valid_clocks_t (STupleT n t) = valid_clocks_t t
valid_clocks_t (SSeqT n t) = valid_clocks_t t
valid_clocks_t (TSeqT n _ t) = n * valid_clocks_t t

normalize_type = merge_layers . strip_empty_layers . replace_stuple_with_sseq

strip_empty_layers :: AST_Type -> AST_Type
strip_empty_layers (SSeqT 1 t) = strip_empty_layers t
strip_empty_layers (SSeqT n t) = SSeqT n $ strip_empty_layers t
strip_empty_layers (TSeqT 1 0 t) = strip_empty_layers t
strip_empty_layers (TSeqT n i t) = TSeqT n i $ strip_empty_layers t
strip_empty_layers (STupleT 1 t) = strip_empty_layers t
strip_empty_layers (STupleT n t) = STupleT n $ strip_empty_layers t
strip_empty_layers t = t

-- merge types where it doesn't change ordering of valids/invalids
merge_layers :: AST_Type -> AST_Type
merge_layers (SSeqT no (SSeqT ni t)) = merge_layers $ SSeqT (no*ni) t
merge_layers (SSeqT no (STupleT ni t)) = merge_layers $ SSeqT (no*ni) t
merge_layers (TSeqT no io (TSeqT ni 0 t)) = merge_layers $ TSeqT (no*ni) (io*ni) t
merge_layers (STupleT no (STupleT ni t)) = merge_layers $ SSeqT (no*ni) t
merge_layers (STupleT no (SSeqT ni t)) = merge_layers $ SSeqT (no*ni) t
merge_layers (SSeqT no t) = SSeqT no $ merge_layers t
merge_layers (TSeqT no io t) = TSeqT no io $ merge_layers t
merge_layers (STupleT no t) = SSeqT no $ merge_layers t
merge_layers t = t

replace_stuple_with_sseq :: AST_Type -> AST_Type
replace_stuple_with_sseq (STupleT n t) = SSeqT n $ replace_stuple_with_sseq t
replace_stuple_with_sseq (SSeqT n t) = SSeqT n $ replace_stuple_with_sseq t
replace_stuple_with_sseq (TSeqT n i t) = TSeqT n i $ replace_stuple_with_sseq t
replace_stuple_with_sseq t = t

diff_types :: AST_Type -> AST_Type -> Maybe AST_Type
diff_types a b | a == b = Nothing
diff_types (SSeqT na a) (SSeqT nb b) | na == nb = diff_types a b
diff_types (TSeqT na ia a) (TSeqT nb ib b) | (na == nb) && (ia == ib) = diff_types a b
diff_types (STupleT na a) (STupleT nb b) | na == nb = diff_types a b
diff_types a b = Just a

num_layers_t :: AST_Type -> Int
num_layers_t UnitT = 1
num_layers_t BitT = 1
num_layers_t Int8T = 1
num_layers_t UInt8T = 1
num_layers_t Int16T = 1
num_layers_t UInt16T = 1
num_layers_t Int32T = 1
num_layers_t UInt32T = 1
num_layers_t (ATupleT _ _) = 1
num_layers_t (STupleT n t) = num_layers_t t + 1
num_layers_t (SSeqT n t) = num_layers_t t + 1
num_layers_t (TSeqT n i t) = num_layers_t t + 1

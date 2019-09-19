module Aetherling.Languages.Space_Time.Deep.Types where

data AST_Type =
  UnitT
  | BitT
  | IntT
  | ATupleT AST_Type AST_Type
  | STupleT Int AST_Type
  | SSeqT Int AST_Type
  | TSeqT Int Int AST_Type
  deriving (Show, Ord)

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

-- these exist only because it's easier to have a value that is an Aetherling value
-- rather than a value that's a member of a type class of aetherling values,
-- like the above data types
data AST_Value =
  UnitV
  | BitV Bool
  | IntV Int
  | ATupleV AST_Value AST_Value
  | STupleV [AST_Value]
  | SSeqV [AST_Value]
  | TSeqV {vals :: [AST_Value], i_v :: Int}
  deriving (Show, Eq, Ord)

size_int :: Int
size_int = 8
size_bit :: Int
size_bit = 1

-- | The size in bits of types
size_t :: AST_Type -> Int
size_t UnitT = 0
size_t BitT = size_bit
size_t IntT = size_int
size_t (ATupleT t0 t1) = size_t t0 + size_t t1
size_t (STupleT n t) = n * size_t t
size_t (SSeqT n t) = n * size_t t
size_t (TSeqT n _ t) = size_t t

num_atoms_t :: AST_Type -> Int
num_atoms_t UnitT = 1
num_atoms_t BitT = 1
num_atoms_t IntT = 1
num_atoms_t (ATupleT t0 t1) = 1
num_atoms_t (STupleT n t) = n * num_atoms_t t
num_atoms_t (SSeqT n t) = n * num_atoms_t t
num_atoms_t (TSeqT n _ t) = num_atoms_t t

clocks_t :: AST_Type -> Int
clocks_t UnitT = 1
clocks_t BitT = 1
clocks_t IntT = 1
clocks_t (ATupleT t0 t1) = 1
clocks_t (STupleT n t) = clocks_t t
clocks_t (SSeqT n t) = clocks_t t
clocks_t (TSeqT n i t) = (n+i) * clocks_t t

valid_clocks_t :: AST_Type -> Int
valid_clocks_t UnitT = 1
valid_clocks_t BitT = 1
valid_clocks_t IntT = 1
valid_clocks_t (ATupleT t0 t1) = 1
valid_clocks_t (STupleT n t) = valid_clocks_t t
valid_clocks_t (SSeqT n t) = valid_clocks_t t
valid_clocks_t (TSeqT n _ t) = n * valid_clocks_t t

type_to_python :: AST_Type -> String
type_to_python UnitT = "undefined"
type_to_python BitT = "ST_Bit()"
type_to_python IntT = "ST_Int()"
type_to_python (ATupleT t0 t1) =
  "ST_Atom_Tuple(" ++
  type_to_python t0 ++ ", " ++
  type_to_python t1 ++
  ")"
type_to_python (STupleT n t) =
  "ST_SSeq_Tuple(" ++ show n ++ ", " ++ type_to_python t ++ ")"
type_to_python (SSeqT n t) =
  "ST_SSeq(" ++ show n ++ ", " ++ type_to_python t ++ ")"
type_to_python (TSeqT n i t) =
  "ST_TSeq(" ++ show n ++ ", " ++ show i ++ ", " ++ type_to_python t ++ ")"
  

module Aetherling.Languages.Sequence.Deep.Types where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Map.Lazy as M
import Data.Proxy
import GHC.Exts (Constraint)
import Data.Word
import Data.Int

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
  | SeqT Int AST_Type
  deriving (Eq, Ord)

instance Show AST_Type where
  show UnitT = "UnitT"
  show BitT = "BitT"
  show Int8T = "Int8T"
  show UInt8T = "UInt8T"
  show Int16T = "Int16T"
  show UInt16T = "UInt16T"
  show Int32T = "Int32T"
  show UInt32T = "UInt32T"
  show (ATupleT t0 t1) = "(ATupleT " ++ show t0 ++ " " ++ show t1 ++ ")"
  show (STupleT n t) = "(STupleT " ++ show n ++ " " ++ show t ++ ")"
  show (SeqT n t) = "(SeqT " ++ show n ++ " " ++ show t ++ ")"

seq_int8 = Int8T
seq_int32 = Int32T

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
  | SeqV {vals :: [AST_Value]}
  deriving (Show, Eq, Ord)

num_atoms_total_t_seq = num_atoms_total_t

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
num_atoms_total_t (STupleT n t) = num_atoms_total_t_seq t
num_atoms_total_t (SeqT n t) = n * num_atoms_total_t_seq t

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
size_t (SeqT _ _) = 0

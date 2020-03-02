module Aetherling.Languages.Sequence.Deep.Types where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Map.Lazy as M
import Data.Proxy
import GHC.Exts (Constraint)

data AST_Type =
  UnitT
  | BitT
  | IntT
  | ATupleT AST_Type AST_Type
  | STupleT Int AST_Type
  | SeqT Int AST_Type
  deriving (Show, Eq, Ord)

seq_int = IntT

-- these exist only because it's easier to have a value that is an Aetherling value
-- rather than a value that's a member of a type class of aetherling values,
-- like the above data types
data AST_Value =
  UnitV
  | BitV Bool
  | IntV Int
  | ATupleV AST_Value AST_Value
  | STupleV [AST_Value]
  | SeqV {vals :: [AST_Value]}
  deriving (Show, Eq, Ord)

num_atoms_total_t_seq = num_atoms_total_t

num_atoms_total_t :: AST_Type -> Int
num_atoms_total_t UnitT = 1
num_atoms_total_t BitT = 1
num_atoms_total_t IntT = 1
num_atoms_total_t (ATupleT t0 t1) = 1
num_atoms_total_t (STupleT n t) = num_atoms_total_t_seq t
num_atoms_total_t (SeqT n t) = n * num_atoms_total_t_seq t

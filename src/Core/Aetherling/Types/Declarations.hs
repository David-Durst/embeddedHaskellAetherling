module Aetherling.Types.Declarations where
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V
import Data.Proxy
import GHC.Exts (Constraint)
import qualified Data.List as L

{-
Each atomic type has versions for:
1. simulation - no postfix, this is just the value to pass on
2. compilation - Wire postfix, these are the wires coming out
to wire to the next operator
3. resources - all the resources used so far, used to compute
resources of a pipeline
-}
type Wires = [String]

data Atom_Unit =
  Atom_Unit
  | Atom_Unit_Wires Wires
  | Atom_Unit_Resources
  deriving (Show, Eq)

data Atom_Bit =
  Atom_Bit Bool
  | Atom_Bit_Wires Wires
  | Atom_Bit_Resources
  deriving (Show, Eq)

data Atom_Int =
  Atom_Int Int
  | Atom_Int_Wires Wires
  | Atom_Int_Resources
  deriving (Show, Eq)

data Seq n a =
  Seq {sVec :: Vector n a}
  | Seq_Wires Wires
  | Seq_Resources
  deriving (Functor, Show, Eq)

data SSeq n a =
  SSeq {ssVec :: Vector n a}
  | SSeq_Wires Wires
  | SSeq_Resources
  deriving (Functor, Show, Eq)

-- n is number of elements, v is number of clocks of delay
-- v is always 0 for now. Please ignore it for the time being
data TSeq n v a =
  TSeq {tsVec :: Vector n a}
  | TSeq_Wires Wires
  | TSeq_Resources
  deriving (Functor, Show, Eq)

sSSeq0_2 :: SSeq 2 Int
sSSeq0_2 = SSeq $ fromTuple (2, 2)
sSSeq0_3 :: SSeq 3 Int
sSSeq0_3 = SSeq $ fromTuple (2, 2, 3)
sSSeq0_22 :: SSeq 2 (SSeq 2 Int)
sSSeq0_22 = SSeq $ fromTuple (sSSeq0_2, sSSeq0_2)

sSSeq1_2 :: SSeq 2 Int
sSSeq1_2 = SSeq $ fromTuple (4, 6)
sSSeq1_3 :: SSeq 3 Int
sSSeq1_3 = SSeq $ fromTuple (1, 2, 3)

tSeq0_2 :: TSeq 2 0 (SSeq 2 Int)
tSeq0_2 = TSeq $ fromTuple (sSSeq0_2, sSSeq1_2)
tSeq0_3 :: TSeq 2 0 (SSeq 3 Int)
tSeq0_3 = TSeq $ fromTuple (sSSeq0_3, sSSeq1_3)
tSeq1_3 :: TSeq 3 0 (SSeq 2 Int)
tSeq1_3 = TSeq $ fromTuple (sSSeq1_2, sSSeq1_2, sSSeq1_2)

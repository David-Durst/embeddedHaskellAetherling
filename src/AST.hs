module AST where
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Vector.Sized as V

data Atom a where
  Unit :: Atom ()
  Int :: Int -> Atom Int
  Bit :: Bool -> Atom Bool
  Tuple :: Atom a -> Atom b -> Atom (Atom a, Atom b)
  -- example of how I'm going to restrict to sseqs of atoms or sseqs
  NTuple :: V.Vector n a -> Atom (V.Vector n (Atom a))

newtype Seq n a = Seq a

data Seq_AST_Node =
  Add
  | Id
  | Map Int Seq_AST_Node
  deriving (Eq, Show)

data ST_AST_Node where
  Add_ST :: ST_AST_Node

  | Map_S (ST_AST_Node m) | Map_T Int ST_AST_Node
  deriving (Eq, Show)

type family In_Type (node :: ST_AST_Node) :: * where
  In_Type Add_ST = Atom (Atom Int, Atom Int)
  In_Type (Map_S n inner_node) = Seq n (In_Type inner_node)


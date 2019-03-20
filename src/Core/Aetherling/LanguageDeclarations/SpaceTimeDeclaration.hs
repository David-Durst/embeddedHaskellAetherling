module Aetherling.LanguageDeclaration where 
import Aetherling.Types.TypeDeclarations
import Data.Bits
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import Data.Typeable
import GHC.Exts (Constraint)
import qualified Data.Vector.Sized as V



-- verify that a type contains only units
type family JustUnits (topType :: *) :: Constraint where
  JustUnits (Atom ()) = True ~ True
  JustUnits (Atom Int) = False ~ True
  JustUnits (Atom Bool) = False ~ True
  JustUnits (Atom (Atom a, Atom b)) = (JustUnits (Atom a), JustUnits (Atom b))
  JustUnits (Atom (V.Vector n (Atom a))) = JustUnits (Atom a)
  JustUnits (Seq n a) = JustUnits a
  JustUnits (SSeq n a) = JustUnits a
  JustUnits (TSeq n v a) = JustUnits a

class Monad m => Circuit m where
  -- unary operators
  absC :: Atom Int -> m (Atom Int)
  notC :: Atom Bool -> m (Atom Bool)
  -- binary operators
  addC :: Atom (Atom Int, Atom Int) -> m (Atom Int)
  eqIntC :: Atom (Atom Int, Atom Int) -> m (Atom Bool)
  eqBitC :: Atom (Atom Bool, Atom Bool) -> m (Atom Bool)
  -- generators
  lutGenIntC :: [Atom Int] -> (Atom Int) -> m (Atom Int)
  lutGenBitC :: [Atom Bool] -> (Atom Int) -> m (Atom Bool)
  constGenIntC :: Atom Int -> Atom () -> m (Atom Int)
  constGenBitC :: Atom Bool -> Atom () -> m (Atom Bool)
  -- sequence operators
  upC :: (KnownNat n, KnownNat (TypeSize a), Typeable (Proxy a)) => Proxy n -> Seq 1 a -> m (Seq n a)
  downC :: (KnownNat n, KnownNat o, n ~ (o+1), KnownNat (TypeSize a), Typeable (Proxy a)) =>
    Proxy n -> (Seq n a) -> m (Seq 1 a)

-- these are the types of the nodes in a DAG
data NodeType =
  AbsT
  | NotT
  -- int is for the par of the nodetype
  -- this is from prior in the DAG
  | NoopT NodeType Int
  | AddT
  | SubT
  | DivT
  | MulT
  | MinT
  | MaxT
  | AshrT
  | ShlT 
  | EqIntT
  | NeqIntT
  | LtIntT
  | LeqIntT
  | GtIntT
  | GeqIntT 
  | AndT
  | OrT
  | XorT
  | EqBitT
  | NeqBitT
  | LtBitT
  | LeqBitT
  | GtBitT
  | GeqBitT 
  | LutGenIntT [Atom Int]
  | LutGenBitT [Atom Bool]
  | ConstGenIntT (Atom Int)
  | ConstGenBitT (Atom Bool)
  | forall a . (Typeable (Proxy a)) => UpT (Proxy a) Int
  | forall a . (Typeable (Proxy a)) => DownT (Proxy a) Int
  -- first node is the operation inside the fold
  -- at this point only single operations are supports
  -- second node is the identity generator
  -- int is total sequence length
  | FoldT NodeType NodeType Int
  | ForkJoinT [NodeType] [NodeType]
  --deriving (Show, Eq)

instance Show NodeType where
  show AbsT = "AbsT"
  show NotT = "NotT"
  show (NoopT nt par) = "NoopT " ++ show nt ++ show par
  show AddT = "AddT"
  show SubT = "SubT"
  show DivT = "DivT"
  show MulT = "MulT"
  show MinT = "MinT"
  show MaxT = "MaxT"
  show AshrT = "AshrT"
  show ShlT = "ShlT" 
  show EqIntT = "EqIntT"
  show NeqIntT = "NeqIntT"
  show LtIntT = "LtIntT"
  show LeqIntT = "LeqIntT"
  show GtIntT = "GtIntT"
  show GeqIntT = "GeqIntT" 
  show AndT = "AndT"
  show OrT = "OrT"
  show XorT = "XorT"
  show EqBitT = "EqBitT"
  show NeqBitT = "NeqBitT"
  show LtBitT = "LtBitT"
  show LeqBitT = "LeqBitT"
  show GtBitT = "GtBitT"
  show GeqBitT = "GeqBitT" 
  show (LutGenIntT as) = "LutGenIntT " ++ show as
  show (LutGenBitT as) = "LutGenBitT " ++ show as
  show (ConstGenIntT a) = "ConstGenIntT " ++ show a
  show (ConstGenBitT a) = "ConstGenBitT " ++ show a
  show (UpT proxy n) = "UpT " ++ show proxy ++ " " ++ show n
  show (DownT proxy n) = "DownT " ++ show proxy ++ " " ++ show n
  show (FoldT nt idGen totalLen) = "FoldT " ++ show nt ++ " " ++
    show idGen ++ " " ++ show totalLen
  show (ForkJoinT node0 node1) = "ForkJoinT " ++ show node0 ++ " " ++ show node1
  show (LineBufferT lbData) = "LineBufferT " ++ show lbData

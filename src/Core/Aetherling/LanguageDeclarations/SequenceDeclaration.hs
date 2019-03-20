module Aetherling.LanguageDeclarations.SequenceDeclaration where 
import Aetherling.Types.TypeDeclarations
import Aetherling.Types.TypeFunctions
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

class Monad m => SequenceLanguage m where
  -- unary operators
  id :: Atom a -> m (Atom a)
  constGenC :: (KnownNat (TypeSize (Atom a))) => Atom a ->
    Atom () -> m (Atom Int)
  absC :: Atom Int -> m (Atom Int)
  notC :: Atom Bool -> m (Atom Bool)

  -- binary operators
  addC :: Atom (Atom Int, Atom Int) -> m (Atom Int)
  eqIntC :: Atom (Atom Int, Atom Int) -> m (Atom Bool)
  eqBitC :: Atom (Atom Bool, Atom Bool) -> m (Atom Bool)

  -- generators
  lutGenIntC :: [Atom Int] -> (Atom Int) -> m (Atom Int)
  lutGenBitC :: [Atom Bool] -> (Atom Int) -> m (Atom Bool)

  -- higher order operators
  mapC :: (KnownNat n) =>
    Proxy n -> (a -> m b) -> (Seq n a -> m (Seq n b))

  up_1dC :: (KnownNat n, KnownNat (TypeSize a), Typeable (Proxy a)) =>
    Proxy n -> Seq 1 a -> m (Seq n a)

  down_1dC :: (KnownNat n, 1 <= n,
               KnownNat (TypeSize a), Typeable (Proxy a)) =>
    Proxy n -> (Seq n a) -> m (Seq 1 a)

  -- tuple operations
  fstC :: Atom (Atom a, Atom b) -> Atom a
  sndC :: Atom (Atom a, Atom b) -> Atom b
  nthC :: (KnownNat i, KnownNat n, (i+1) <= n) =>
    Proxy i -> Atom (V.Vector n (Atom a)) -> m (Atom a)

  zipC :: (Check_Types_Conform (Seq n a) (Seq n b)) =>
    a -> b -> c

  -- composition operators
  (<=) :: Variable c -> (a -> m b) -> m (Variable (a -> m b))
  (>=) :: Variable (a -> m b) -> (b -> m c) -> (a -> m c)

  (>>>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

-- these are the types of the nodes in a DAG
data NodeType =
  AbsT
  | NotT
  | AddT
  | EqIntT
  | EqBitT
  | LutGenIntT [Atom Int]
  | LutGenBitT [Atom Bool]
  | ConstGenIntT (Atom Int)
  | ConstGenBitT (Atom Bool)

instance Show NodeType where
  show AbsT = "AbsT"
  show AddT = "AddT"
  show EqIntT = "EqIntT"
  show EqBitT = "EqBitT"
  show (LutGenIntT as) = "LutGenIntT " ++ show as
  show (LutGenBitT as) = "LutGenBitT " ++ show as
  show (ConstGenIntT a) = "ConstGenIntT " ++ show a
  show (ConstGenBitT a) = "ConstGenBitT " ++ show a

module AtomModules where 
import Data.Bits
import DataTypes
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra
import qualified Data.Vector.Sized as V

-- unary modules
absInt :: Module Int Int
absInt = abs

notBit :: Module Bit Bit
notBit = not

noopAtom :: (Atom a) => Module a a
noopAtom = id

-- binary modules
addInt :: Module (Int, Int) Int
addInt = uncurry (+) 

subInt :: Module (Int, Int) Int
subInt = uncurry (-)

divInt :: Module (Int, Int) Int
divInt = uncurry (-)

mulInt :: Module (Int, Int) Int
mulInt = uncurry (*)

minInt :: Module (Int, Int) Int
minInt = uncurry min

maxInt :: Module (Int, Int) Int
maxInt = uncurry max

ashrInt :: Int -> Module Int Int
ashrInt amount input = shiftR input amount

shlInt :: Int -> Module Int Int
shlInt amount input = shiftL input amount

andBit :: Module (Bit, Bit) Bit
andBit = uncurry (&&)

orBit :: Module (Bit, Bit) Bit
orBit = uncurry (||)

xOrBit :: Module (Bit, Bit) Bit
xOrBit (b0, b1) = (b0 /= b1) && (b0 || b1)

eqAtom :: (Atom a) => Module (a, a) Bit
eqAtom = uncurry (==)

neqAtom :: (Atom a) => Module (a, a) Bit
neqAtom = uncurry (/=)

ltInt :: Module (Int, Int) Bit
ltInt = uncurry (<)
  
leqInt :: Module (Int, Int) Bit
leqInt = uncurry (<=)

gtInt :: Module (Int, Int) Bit
gtInt = uncurry (>)

geqInt :: Module (Int, Int) Bit
geqInt = uncurry (>=)

-- module generators
lutAtomGen :: [a] -> Module Int a
lutAtomGen as = \i -> as !! i

constAtomGen :: (Atom a) => a -> Module () a
constAtomGen a = \_ -> a

-- multi-rate modules
up :: (KnownNat n) => Proxy n -> Module (STIOC 1 a) (STIOC n a)
up _ = \(STIOC vec) -> STIOC $ V.replicate $ V.head vec

down :: (KnownNat n, KnownNat m, n ~ (m+1)) => Proxy n -> Module (STIOC n a) (STIOC 1 a)
down _ = \(STIOC vec) -> STIOC $ V.singleton $ V.head vec

module MonadModules where
import Data.Bits
import DataTypes
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra

data MAtom = MInt Int | MBit Bool | CompilerResult String deriving Show

class Monad m => Circuit m where
  and2, or2 :: (MAtom, MAtom) -> m MAtom
  add2, sub2 :: (MAtom, MAtom) -> m MAtom

data SimulatorEnv a = SimulatorEnv a

simulate :: SimulatorEnv MAtom -> MAtom
simulate (SimulatorEnv a) = a

instance Functor SimulatorEnv where
  fmap f (SimulatorEnv a) = SimulatorEnv (f a)
  
instance Applicative SimulatorEnv where
  pure a = SimulatorEnv a
  SimulatorEnv f <*> SimulatorEnv a = SimulatorEnv $ f a

instance Monad SimulatorEnv where
  (SimulatorEnv a) >>= f = f a
  return a = SimulatorEnv a

instance Circuit SimulatorEnv where
  and2 (MBit x, MBit y) = return (MBit (x && y))
  and2 (_, _) = fail "and2 only handles 2 bits"
  or2 (MBit x, MBit y) = return (MBit (x || y))
  or2 (_, _) = fail "or2 only handles 2 bits"
  add2 (MInt x, MInt y) = return (MInt (x + y))
  add2 (_, _) = fail "add2 only haddles 2 ints"
  sub2 (MInt x, MInt y) = return (MInt (x - y))
  sub2 (_, _) = fail "sub2 only handles 2 ints"

data CompilerEnv a = CompilerEnv a 

compile :: CompilerEnv MAtom -> IO ()
compile (CompilerEnv (CompilerResult s)) = putStrLn s
compile (CompilerEnv _) = fail "Not Compiled"

instance Functor CompilerEnv where
  fmap f (CompilerEnv a) = CompilerEnv (f a)
  
instance Applicative CompilerEnv where
  pure a = CompilerEnv a
  CompilerEnv f <*> CompilerEnv a = CompilerEnv $ f a

instance Monad CompilerEnv where
  (CompilerEnv a) >>= f = f a
  return a = CompilerEnv a

instance Circuit CompilerEnv where
  and2 (MBit x, MBit y) = return $ CompilerResult (show x ++ " && " ++ show y)
  and2 (_, _) = fail "and2 only handles 2 bits"
  or2 (MBit x, MBit y) = return $ CompilerResult (show x ++ " || " ++ show y)
  or2 (_, _) = fail "or2 only handles 2 bits"
  add2 (MInt x, MInt y) = return $ CompilerResult (show x ++ " + " ++ show y)
  add2 (_, _) = fail "add2 only haddles 2 ints"
  sub2 (MInt x, MInt y) = return $ CompilerResult (show x ++ " - " ++ show y)
  sub2 (_, _) = fail "sub2 only handles 2 ints"

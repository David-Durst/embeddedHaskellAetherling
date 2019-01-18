module MonadModules where
import Data.Bits
import DataTypes
import Data.Proxy
import GHC.TypeLits
import GHC.TypeLits.Extra

class Monad m => Circuit m where
  and2, or2 :: (Atom, Atom) -> m Atom
  add2, sub2 :: (Atom, Atom) -> m Atom

data SimulatorEnv a = SimulatorEnv a

simulate :: SimulatorEnv Atom -> Atom
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
  and2 (Bit x, Bit y) = return (Bit (x && y))
  and2 (_, _) = fail "and2 only handles 2 bits"
  or2 (Bit x, Bit y) = return (Bit (x || y))
  or2 (_, _) = fail "or2 only handles 2 bits"
  add2 (Int x, Int y) = return (Int (x + y))
  add2 (_, _) = fail "add2 only haddles 2 ints"
  sub2 (Int x, Int y) = return (Int (x - y))
  sub2 (_, _) = fail "sub2 only handles 2 ints"

data CompilerEnv a = CompilerEnv a 

compile :: CompilerEnv Atom -> IO ()
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
  and2 (Bit x, Bit y) = return $ CompilerResult (show x ++ " && " ++ show y)
  and2 (_, _) = fail "and2 only handles 2 bits"
  or2 (Bit x, Bit y) = return $ CompilerResult (show x ++ " || " ++ show y)
  or2 (_, _) = fail "or2 only handles 2 bits"
  add2 (Int x, Int y) = return $ CompilerResult (show x ++ " + " ++ show y)
  add2 (_, _) = fail "add2 only haddles 2 ints"
  sub2 (Int x, Int y) = return $ CompilerResult (show x ++ " - " ++ show y)
  sub2 (_, _) = fail "sub2 only handles 2 ints"

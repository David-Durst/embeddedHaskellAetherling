module Monad_Memo_Messing where
import Control.Monad.Identity
import Control.Monad.State
import Aetherling.Monad_Helpers

data FibState = FibState { total_steps :: Int } deriving (Show, Eq)

empty_fib_state = FibState 0

type MemoInt a = DAG_MemoT (StateT FibState Identity) Integer a

instance Indexible Integer where
  get_index i = Index 0 (fromInteger i)

fibm ::  Integer -> MemoInt Integer
fibm 0 = do
  increment_state
  return 0
fibm 1 = do
  increment_state
  return 1
fibm n = do
  increment_state
  f1 <- memo (n-1) $ fibm (n-1)
  f2 <- memo (n-2) $ fibm (n-2)
  return (f1+f2)

increment_state :: MemoInt ()
increment_state = do
  cur_state <- lift get
  let cur_steps = total_steps cur_state
  lift $ put $ cur_state { total_steps = cur_steps + 1 }
  return ()
  
evalFibm :: Integer -> (Integer, FibState)
evalFibm x = runState (startEvalMemoT $ fibm x) empty_fib_state

fib ::  Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = do
  let f1 = fib (n-1)
  let f2 = fib (n-2)
  (f1+f2)

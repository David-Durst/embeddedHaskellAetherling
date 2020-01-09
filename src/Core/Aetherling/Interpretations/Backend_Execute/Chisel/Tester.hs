module Aetherling.Interpretations.Backend_Execute.Chisel.Tester where
import Aetherling.Interpretations.Backend_Execute.Chisel.Expr_To_String
import Aetherling.Interpretations.Backend_Execute.Expr_To_String_Helpers
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import Aetherling.Interpretations.Backend_Execute.Test_Helpers
import qualified Aetherling.Rewrites.Rewrite_Helpers as RH
import qualified Aetherling.Monad_Helpers as MH
import Aetherling.Languages.Space_Time.Deep.Expr
import Aetherling.Languages.Space_Time.Deep.Expr_Type_Conversions
import Aetherling.Languages.Space_Time.Deep.Types
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Identity
import Control.Applicative
import Aetherling.Monad_Helpers
import Data.List
import qualified Data.Map.Strict as M
import System.IO.Temp
import System.IO
import System.Process
import System.Environment
import System.Exit
import System.Directory
import Data.Maybe
import Debug.Trace

chisel_test_spec = 
  "class TopTester extends ChiselFlatSpec {\n" ++
  tab_str ++ "\"Top\" should \"behave correctly\" in {\n" ++ 
  tab_str ++ tab_str ++ "iotesters.Driver.execute(Array(\"--backend-name\"," ++
  " \"verilator\"), () => new TopAtomTuple(STInt(8), STInt(8))) {\n" ++
  tab_str ++ tab_str ++ tab_str ++ "c => new AtomTupleUnitTester(c)\n" ++
  tab_str ++ tab_str ++ "} should be(true)\n" ++
  tab_str ++ "}\n" ++
  "}"

module Aetherling.Interpretations.Monad_Helpers where

fail_message fName tName = fName ++ " must receive " ++ tName ++
  "not " ++ tName ++ "_Wires or " ++ tName ++ "_Resources_Env."

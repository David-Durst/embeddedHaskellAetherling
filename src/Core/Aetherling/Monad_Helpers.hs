module Aetherling.Monad_Helpers where

fail_message :: String -> String -> String
fail_message fName tName = fName ++ " must receive " ++ tName ++
  "not " ++ tName ++ "_Edge."

-- fail message where the function actually wants edges
fail_message_edge :: String -> String -> String
fail_message_edge fName tName = fName ++ " must receive " ++ tName ++
  "_Edge not " ++ tName ++ "."

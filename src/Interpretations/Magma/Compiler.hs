module Aetherling.Interpretations.Magma.Compiler where
x = 1
{-
What this needs:
1. declare module input ports, output ports
  1. data ports
    1. port names
    1. port types
  2. clock ports
  3. ready-valid in ports
  3. ready-valid out ports
2. get the strings for each node
3. get the port strings for each node
  1. in ports
    1. should these all be bits? Larger primitives?
  1. out ports
  1. ready-valid in ports
  1. ready-valid out ports
4. get the inner pipeline for each map
-}

# Basic Sequence Language Theory
This language has the most simple types and operators necessary to get multi-rate pipelines

## Types
1. `Int` - integer
2. `Tuple n t` - homogeneous ntuple
3. `Seq n t` - homogeneous, fixed-length sequence
4. `t -> t'` - function

## Operators
1. `Add :: Int -> Int`
2. `Map n :: (Num n) => (t -> t') -> Seq n t -> Seq n t'`
  - Note: I'm using [Haskell's type constraint notation here](https://en.wikibooks.org/wiki/Haskell/Classes_and_types#Type_constraints). The statement `Num n` means that `n` must be a number.
3. `Up n :: -> `

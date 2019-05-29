# Zip vs Map2
This document shows that Aetherling requires `Map2` and `Tuple` even if the
`Zip` operator is included.
1. defines the type signatures of all operators
1. provides example that require `Map2`

## Type Signatures

### Sequence Language
5. `Tuple :: t -> t' -> t x t'`
1. `Map2 (Config n) :: (t -> t' -> t'') -> Seq n t -> Seq n t' -> Seq n t''`
1. `Zip2 (Config n) :: Seq n t -> Seq n t' -> Seq n (t x t')`

### Space-Time IR
1. `Map2_s n :: (t -> t' -> t'') -> SSeq n t -> SSeq n t' -> SSeq n t''`
1. `Map2_t n :: (t -> t' -> t'') -> TSeq n v t -> TSeq n v t' -> TSeq n v t''`
1. `Zip2_s (Config n) :: SSeq n t -> SSeq n t' -> SSeq n (t x t')`
1. `Zip2_t (Config n) :: TSeq n v t -> TSeq n v t' -> TSeq n v (t x t')`

## Example Program

### Sequence Language
```
input :: Seq 5 (Seq 5 t)
output :: Seq 5 (Seq 5 (t x t))
output = Map2 Zip2 input
```
===
```
input :: Seq 5 (Seq 5 t)
output :: Seq 5 (Seq 5 (t x t))
output = Map2 (Map2 Tuple) input
```

### Space-Time IR
```
input :: TSeq 5 5 (TSeq 5 5 t)
output :: TSeq 5 (TSeq 5 (t x t))
output = Map2_t Zip2_t input
```
===
```
input :: TSeq 5 5 (TSeq 5 5 t)
output :: TSeq 5 (TSeq 5 (t x t))
output = Map2_t (Map2_t Tuple) input
```


`Map2_t` and `Zip2_t` both must handle phase alignment in the line `Map2_t Zip2_t input`.
`Map2_t` aligns the outer `TSeq`and `Zip2_t` aligns the inner `TSeq`.
Therefore, it would be better just to have `Map2_t` and created `Zip2_t` out of `Map2_t Tuple`.


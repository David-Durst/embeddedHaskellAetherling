# Zip vs Map2
This document shows that Aetherling should have `Map2` and `Tuple` instead of
`Zip2`.

There are two issues.
1. Which of the two choices are more general?
    1. `Map2` and `Tuple` are one choice. `Zip2` is the other choice.
1. Which of the two operators enable expressing more hardware schedules?

# Type Signatures
I must define my terms before I explain the issues.

### Sequence Language
5. `Tuple :: t -> t' -> t x t'`
1. `Map2 (Config n) :: (t -> t' -> t'') -> Seq n t -> Seq n t' -> Seq n t''`
1. `Zip2 (Config n) :: Seq n t -> Seq n t' -> Seq n (t x t')`

### Space-Time IR
1. `Map2_s n :: (t -> t' -> t'') -> SSeq n t -> SSeq n t' -> SSeq n t''`
1. `Map2_t n :: (t -> t' -> t'') -> TSeq n v t -> TSeq n v t' -> TSeq n v t''`
1. `Zip2_s (Config n) :: SSeq n t -> SSeq n t' -> SSeq n (t x t')`
1. `Zip2_t (Config n) :: TSeq n v t -> TSeq n v t' -> TSeq n v (t x t')`

# Generality
The generality issue is that `Map2` is required to zip nested sequences, even if `Zip2` is part of the language.
This problem would be avoidable if there was a `Zip2Inner` that handled every amount of nesting.
However, having one `Map2` function that can be nested is a cleaner solution.

I provide an example program that demonstrates the difference in generality.

## Example Program

### Sequence Language
```
input :: Seq 5 (Seq 5 t)
output :: Seq 5 (Seq 5 (t x t))
output = Map2 Zip2 input input
```
===
```
input :: Seq 5 (Seq 5 t)
output :: Seq 5 (Seq 5 (t x t))
output = Map2 (Map2 Tuple) input input
```

### Space-Time IR
```
input :: TSeq 5 5 (TSeq 5 5 t)
output :: TSeq 5 (TSeq 5 (t x t))
output = Map2_t Zip2_t input input
```
===
```
input :: TSeq 5 5 (TSeq 5 5 t)
output :: TSeq 5 5 (TSeq 5 5 (t x t))
output = Map2_t (Map2_t Tuple) input input
```


`Map2_t` and `Zip2_t` both must handle phase alignment in the line `Map2_t Zip2_t input`.
`Map2_t` aligns the outer `TSeq`and `Zip2_t` aligns the inner `TSeq`.
Since `Map2_t` must handle all the semantics of `Zip2_t`, it would be better just to have `Map2_t` and create `Zip2_t` out of `Map2_t Tuple`.

# Expressibility Of Schedules

Parallelism in the space-time IR is expressed by nesting `TSeq`s and `SSeq`s.
`Zip2` cannot be nested. `Zip2` operates on a flattened sequence. 
Therefore, in order to make `Zip2` partially parallel by lifting `Zip2_s` onto a `TSeq` or
lifting `Zip2_t` onto a `SSeq`, `Map2` is required.

We demonstrate this using the same example as above.

### Sequence Language
An alternative to the above example that only uses `Zip2`, `Partition`, and `Unpartition` is:

```
input :: Seq 5 (Seq 5 t)
output :: Seq 5 (Seq 5 (t x t))
output = Unpartition 5 5 . Zip2 (Partition input) (Partition input)
```
===
```
input :: Seq 5 (Seq 5 t)
output :: Seq 5 (Seq 5 (t x t))
output = Map2 (Map2 Tuple) input input
```

### Space-Time IR
The `Zip2`, `Partition`, and `Unpartition` approach limits the expressibility of the space-time IR. 
The only expressible schedules are fully parallel and fully sequential. 

**Fully Parallel**
```
input :: SSeq 5 (SSeq 5 t)
output :: SSeq 5 (SSeq 5 (t x t))
output = Unpartition_s_ss 5 5 . Zip2_s (Partition_s_ss input) (Partition_s_ss input)
```

**Fully Sequential**
```
input :: TSeq 5 5 (TSeq 5 5 t)
output :: TSeq 5 5 (TSeq 5 5 (t x t))
output = Unpartition_t_tt 5 5 . Zip2_t (Partition_t_tt input) (Partition_t_tt input)
```
The `Map2` approach allows for a broader array of schedules.

**Fully Parallel**
```
input :: SSeq 5 (SSeq 5 t)
output :: SSeq 5 (SSeq 5 (t x t))
output = Map2_s (Map2_s Tuple) input input
```

**Fully Sequential**
```
input :: TSeq 5 5 (TSeq 5 5 t)
output :: TSeq 5 5 (TSeq 5 5 (t x t))
output = Map2_t (Map2_t Tuple) input input
```

**Partially Parallel**
```
input :: TSeq 5 5 (SSeq 5 t)
output :: TSeq 5 5 (SSeq 5 (t x t))
output = Map2_t (Map2_s Tuple) input input
```

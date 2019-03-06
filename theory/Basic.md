# Basic Sequence Language Theory
This language has the most simple types and operators necessary to get multi-rate pipelines

## Types
1. `Ant` - integer
2. `Tuple n t` - homogeneous ntuple
2. `t x t'` - heterogeneous tuple
3. `Seq n t` - homogeneous, fixed-length sequence
4. `t -> t'` - function

### Type Constructors
These create types from other types. They are modeled after Haskell's type families.
1. `Merge_Seqs (t1 :: Seq n t) (t2 :: Seq n t') = Seq n (Merge_Seqs t t')`
1. `Merge_Seqs (t1 :: Int Or Tuple Or ()) (t2 :: Int Or Tuple Or ()) = t1 x t2`
1. `Merge_Seqs _ _ = Error`
1. `Add_Unit (t :: Seq n t) = Seq n (Add_Unit t)`
1. `Add_Unit (t :: Int Or Tuple Or ()) = t x ()`

## Sequence Operators
1. `Id :: t -> t`
1. `Const_Gen n :: () -> Int`
1. `Add :: (Int x Int) -> Int`
2. `Map n :: (t -> t') -> Seq n t -> Seq n t'`
3. `Up_1d n :: Seq 1 t -> Seq n t`
4. `Down_1d n :: Seq n t -> Seq 1 t`
5. `Fork_Join (f :: t1 -> t1') (g :: t2 -> t2') :: (Merge_Seqs t1 t2) -> (Merge_Seqs t1' t2')`
6. `Add_Unit t :: t -> (Add_Unit t)`

## Space-Time Types
Note: I'm including duplicate types from above to be thorough. 
1. `Int` - integer
2. `Tuple n t` - homogeneous ntuple
3. `SSeq n t` - homogeneous, fixed-length sequence in space
3. `TSeq n v t` - homogeneous, fixed-length sequence in time. n is number of utilized periods. v is number of unutilized periods. Total time for a TSeq is `(n+v) * time to process one t`.
4. `t -> t'` - function

## Space-Time Operators
2. `Map_s n :: (t -> t') -> SSeq n t -> SSeq n t'`
2. `Map_t n :: (t -> t') -> TSeq n v t -> TSeq n v t'`
3. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
3. `Up_1d_t n :: TSeq 1 (n+w-1) t -> TSeq n w t`
4. `Down_1d_s n :: SSeq n t -> SSeq 1 t`
4. `Down_1d_t n :: TSeq n v t -> TSeq 1 (n+v-1) t`
5. `Partition n m :: SSeq (n*m) t -> TSeq n v (SSeq m t)`
    - Should the input `SSeq` be wrapped in a `TSeq`? Otherwise, this is deferring until later the underutilization of the input TSeq that will eventually wrap the SSeq.
5. `Unpartition n m :: TSeq n v (SSeq m t) -> SSeq (n*m) t`


## Rewrite Rules
Each entry is the rule. Below it are the input and output types of the input and output expressions of the rule. I also may include the types of subexpressions that are useful.
### Map
1. Sequence To Space - `Map n f -> Map_s n f`
    1. `Map n f :: Seq n t -> Seq n t'`
    1. `Map_s n f :: SSeq n t -> SSeq n t'`
1. Slowdown - `Map_s (n*m) f -> Unpartition n m . Map_t n (Map_s m f) . Partition n m`
    1. `Map_s (n*m) f :: SSeq (n*m) t -> SSeq (n*m) t'`
    1. `Map_t n (Map_s m f) :: TSeq n v (SSeq m t) -> TSeq n v (SSeq m t')`
    1. `Unpartition n m . Map_t n (Map_s m f) . Partition n m :: SSeq (n*m) t -> SSeq (n*m) t'`
    
### Upsample
1. Sequence To Space - `Up_1d n -> Up_1d_s n`
    1. `Up_1d n :: Seq 1 t -> Seq n t`
    1. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
1. Slowdown - `Up_1d_s (n*m) -> Unpartition n m . Map_t n (Up_1d_s m) . Up_1d_t n . Partition 1 1`
    1. `Up_1d_s (n*m) :: SSeq 1 t -> SSeq (n*m) t`
    1. `Map_t n (Up_1d_s m) :: TSeq n (SSeq 1 t) -> TSeq n (SSeq m t)`
    1. `Up_1d_t n :: (TSeq 1 (SSeq 1 t)) -> (TSeq n (SSeq 1 t))`
    1. `Unpartition n m . Map_t n (Up_1d_s m) . Up_1d_t n . Partition 1 1 :: SSeq 1 t -> SSeq (n*m) t`

Note: I dropped the underutilization computation from `TSeq` where it became onerous.

### Downsample
1. Sequence To Space - `Down_1d n -> Down_1d_s n`
    1. `Down_1d n :: Seq n t -> Seq 1 t`
    1. `Down_1d_s n :: SSeq n t -> SSeq 1 t`
1. Slowdown - `Down_1d_s (n*m) -> Unpartition 1 1 . (Map_t 1 (Down_1d_s m)) . Down_1d_t n . Partition n m`
    1. `Down_1d_s (n*m) :: SSeq (n*m) t -> SSeq 1 t`
    1. `Map_t 1 (Down_1d_s m) :: TSeq 1 (SSeq m t) -> TSeq 1 (SSeq 1 t)`
    1. `Down_1d_t n :: (TSeq n (SSeq m t)) -> (TSeq 1 (SSeq m t))`
    1. `Unpartition 1 1 . (Map_t 1 (Down_1d_s m)) . Down_1d_t n . Partition n m :: SSeq (n*m) t -> SSeq 1 t`

### Unpartition/Partition Removal
1. `Partition n m . Unpartition n m = Id`
**Danger: This is not really Id in Space-Time. There will be underutilized clocks here. The partitioning and unpartitioning takes n clocks. However, the interface to both of these functions is just an `SSeq`. The `SSeq` doesn't account for time.**
2. `Unpartition n m . Partition n m = I`

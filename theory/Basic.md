# Basic Sequence Language Theory
This language has the most simple types and operators necessary to get multi-rate pipelines

## Types
1. `Int` - integer
2. `Tuple n t` - homogeneous ntuple
3. `Seq n t` - homogeneous, fixed-length sequence
4. `t -> t'` - function

## Sequence Operators
1. `Add :: Int -> Int`
2. `Map n :: (t -> t') -> Seq n t -> Seq n t'`
3. `Up_1d n :: Seq 1 t -> Seq n t`
4. `Down_1d n :: Seq n t -> Seq 1 t`

## Space-Time Types
Note: I'm including duplicate types from above to be thorough. 
1. `Int` - integer
2. `Tuple n t` - homogeneous ntuple
3. `SSeq n t` - homogeneous, fixed-length sequence in space
3. `TSeq n v t` - homogeneous, fixed-length sequence in time. n is number of utilized periods. v is number of unutilized periods. Total time for a TSeq is `(n+v) * time to process one t`.
4. `t -> t'` - function

## Space-Time Operators
1. `Add :: Int -> Int`
2. `Map_s n :: (t -> t') -> SSeq n t -> SSeq n t'`
2. `Map_t n :: (t -> t') -> TSeq n v t -> TSeq n v t'`
3. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
3. `Up_1d_t n :: TSeq 1 (n+w-1) t -> TSeq n w t`
4. `Down_1d_s n :: SSeq n t -> SSeq 1 t`
4. `Down_1d_t n :: TSeq n v t -> TSeq 1 (n+v-1) t`
5. `Partition n :: SSeq (m*n) t -> TSeq m (n*(m-1)) (SSeq n t)`
5. `Unpartition n :: TSeq m (n*(m-1)) (SSeq n t) -> SSeq (m*n) t`
5. `Vectorize n :: TSeq (m*n) v t -> TSeq m (v + m*(n-1)) (SSeq n t)`
5. `Devectorize n :: TSeq m (v + m*(n-1)) (SSeq n t) -> TSeq (m*n) v t`

## Rewrite Rules
1. `Map_s n f -> Unpartition (n*m) . Map_t n (Map_s m f) . Unpartition (n*m)`
    1. `Map n f :: SSeq n t -> SSeq n t'`
    1. `Map_t n (Map_s m f) :: TSeq n 0 (SSeq m t) -> TSeq n 0 (SSeq m t)`
    1. `Unpartition m . Map (n/m) (Map_s m f) . Vectorize m :: TSeq ()`

# Sequence Language With 2D Upsample and Downsample

## Types
1. `Int` - integer
2. `Tuple n t` - homogeneous ntuple
2. `t x t'` - heterogeneous tuple
3. `Seq n t` - homogeneous, fixed-length sequence
4. `t -> t'` - function

### Type Constructors
These create types from other types. They are modeled after Haskell's type families.
1. `Merge_Seqs (t1 :: Seq n t) (t2 :: Seq n t') = Seq n (Merge_Seqs t t')`
1. `Merge_Seqs (t1 :: Int Or Tuple Or ()) (t2 :: Int Or Tuple Or ()) = t1 x t2`
1. `Merge_Seqs _ _ = Error`
1. `Add_Unit (t :: Seq n t') = Seq n (Add_Unit t')`
1. `Add_Unit (t :: Int Or Tuple Or ()) = t x ()`

### Type Constraints
1. `Same_Seq_Length (t1 :: Seq n t) (t2 :: Seq n t') = Same_Seq_Length`
1. `Same_Seq_Length (t1 :: Seq n t) _ = False`
1. `Same_Seq_Length _ (t1 :: Seq n t) = False`
1. `Same_Seq_Length _ _ = True`

## Sequence Operators
1. `Id :: t -> t`
1. `Const_Gen n :: () -> Int`
1. `Add :: (Int x Int) -> Int`
2. `Map n :: (t -> t') -> Seq n t -> Seq n t'`
3. `Up_1d n :: Seq 1 t -> Seq n t`
3. `Up_2d nx ny w h :: Seq (w*h) t -> Seq (nx*ny*w*h) t`
4. `Down_1d n :: Seq n t -> Seq 1 t`
4. `Down_2d nx ny w h :: Seq (nx*ny*w*h) t -> Seq (w*h) t`
5. `Fork_Join (f :: t1 -> t1') (g :: t2 -> t2') :: Merge_Seqs t1 t2 -> Merge_Seqs t1' t2'`
6. `Reshape_Tuples t t' elem_map :: (Same_Seq_Length t t') => t -> t'`
    1. This converts `t` into type `t'`. The type constraint ensures that the sequence components are the same. `elem_map` indicates what elements in `t`'s tuples are mapped to elements in `s`'s tuples.
6. `Add_Unit t :: t -> (Add_Unit t)`
7. `Partition n m :: Seq (n*m) t -> Seq n (Seq m t)`
7. `Unpartition n m :: Seq n (Seq m t) -> Seq (n*m) t`

## Space-Time Types
Note: I'm duplicating types from above to be thorough. 
1. `Int` - integer
2. `Tuple n t` - homogeneous ntuple
3. `SSeq n t` - homogeneous, fixed-length sequence in space
3. `TSeq n v t` - homogeneous, fixed-length sequence in time. n is number of utilized periods. v is number of underutilized periods. Total time for a TSeq is `(n+v) * time to process one t`.
4. `t -> t'` - function

## Space-Time Operators
2. `Map_s n :: (t -> t') -> SSeq n t -> SSeq n t'`
2. `Map_t n :: (t -> t') -> TSeq n v t -> TSeq n v t'`
3. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
3. `Up_1d_t n :: TSeq 1 (n+w-1) t -> TSeq n w t`
3. `Up_2d_s nx ny w h :: SSeq (w*h) t -> SSeq (nx*ny*w*h) t`
3. `Up_2d_t nx ny w h :: TSeq (w*h) (nx*ny*w*h-w*h+v) t -> TSeq (nx*ny*w*h) v t`
4. `Down_1d_s n :: SSeq n t -> SSeq 1 t`
4. `Down_1d_t n :: TSeq n v t -> TSeq 1 (n+v-1) t`
4. `Down_2d_s nx ny w :: SSeq (nx*ny*w*h) t -> SSeq w*h t`
4. `Down_2d_t nx ny w :: TSeq (nx*ny*w*h) v t -> TSeq w*h (nx*ny*w*h-w*h+v) t`
5. `Partition_ts n m :: TSeq 1 (n + v - 1) (SSeq (n*m) t) -> TSeq n v (SSeq m t)`
5. `Unpartition_ts n m :: TSeq n v (SSeq m t) -> TSeq 1 (n + v - 1) (SSeq (n*m) t)`
5. `Partition_ss n m :: SSeq (n*m) t -> SSeq n (SSeq m t)`
5. `Unpartition_ss n m :: SSeq n (SSeq m t) -> SSeq 1 (SSeq (n*m) t)`



## Rewrite Rules
### Upsample 2D
1. Sequence To Space - `Up_2d nx ny w h -> Up_2d_s nx ny w h`
    1. `Up_2d nx ny w h :: Seq (w*h) t -> Seq (nx*ny*w*h) t`
    1. `Map_t 1 (Up_2d_s nx ny w h) :: SSeq (w*h) t -> SSeq (nx*ny*w*h) t`
1. Slowdown to `p` input pixels per clock, `p >= w` - `Up_2d_s nx ny w (n*m) -> Map_t n (Up_2d_s nx ny w m)` **need to fix types for this entry**
    1. `Map_t 1 (Up_1d_s (n*m)) :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (n*m) t)`
    1. `Map_t n (Up_1d_s m) :: TSeq n (SSeq 1 t) -> TSeq n (SSeq m t)`
    1. `Up_1d_t n :: (TSeq 1 (SSeq 1 t)) -> (TSeq n (SSeq 1 t))`
    1. `Unpartition_ts n m . Map_t n (Up_1d_s m) . Up_1d_t n . Partition_ts 1 1 :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (n*m) t)`
1. Slowdown to `p` input pixels per clock, `p < w`, `p < 1 || nx % (1/p) == 0`, `p*nx*ny > 1` - 
    1. Original - `Up_2d_s nx ny (o*p) h`
    1. Type Variables
        1. `input_pixels_per_clock=p`
        1. `output_pixels_per_clock=p*ny*nx`
        1. `input_to_all_time_upsamples=max 1 (p*ny)` - all time upsamples will feed into an `nx` space upsample if necessary
        1. `amount_space_upsamples=output_pixels_per_clock / input_to_all_time_upsamples` 
    1. New ` Map_t h (Map_s p (Up_1d_s (nx_p * p) . Up_2d_t (nx*p) ny o 1)) . retime` **need to fix types for this entry, figure out semantics of retime buffer, which loads a whole row and then distributes it over a shorter priod of time. This increases initial latency but ensures constant rate**
1. Slowdown to less than w pixels in per clock - `Map_t 1 (Up_1d_s (nx*(m/2) (ny*(m/2)))) -> Map_t n (Up_1d_s m) . Up_1d_t n . `
    1. `Map_t 1 (Up_1d_s (n*m)) :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (n*m) t)`
    1. `Map_t n (Up_1d_s m) :: TSeq n (SSeq 1 t) -> TSeq n (SSeq m t)`
    1. `Up_1d_t n :: (TSeq 1 (SSeq 1 t)) -> (TSeq n (SSeq 1 t))`
    1. `Unpartition_ts n m . Map_t n (Up_1d_s m) . Up_1d_t n . Partition_ts 1 1 :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (n*m) t)`

### Downsample 1D
1. Sequence To Space - `Down_1d n -> Map_t 1 (Down_1d_s n)`
    1. `Down_1d n :: Seq n t -> Seq 1 t`
    1. `Map_t 1 (Down_1d_s n) :: TSeq 1 _ (SSeq n t) -> TSeq 1 _ (SSeq 1 t)`
1. Slowdown - `Map_t 1 (Down_1d_s (n*m)) -> Unpartition_ts 1 1 . (Map_t 1 (Down_1d_s m)) . Down_1d_t n . Partition_ts n m`
    1. `Map_t 1 (Down_1d_s (n*m)) :: TSeq 1 _ (SSeq n t) -> TSeq 1 _ (SSeq 1 t)`
    1. `Map_t 1 (Down_1d_s m) :: TSeq 1 (SSeq m t) -> TSeq 1 (SSeq 1 t)`
    1. `Down_1d_t n :: (TSeq n (SSeq m t)) -> (TSeq 1 (SSeq m t))`
    1. `Unpartition_ts 1 1 . (Map_t 1 (Down_1d_s m)) . Down_1d_t n . Partition_ts n m :: TSeq 1 _ (SSeq n t) -> TSeq 1 _ (SSeq 1 t)`

### Unpartition_ts/Partition_ts Removal
1. `Partition_ts n m . Unpartition_ts n m = Id`
**Danger: `Partition_ts . Unpartition_ts` is not really Id in Space-Time. There will be underutilized clocks here. The partitioning and unpartitioning takes n clocks. However, the interface to both of these functions is just an `SSeq`. The `SSeq` doesn't account for time.**
2. `Unpartition_ts n m . Partition_ts n m = Id`

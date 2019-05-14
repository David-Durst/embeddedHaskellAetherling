# Stencil Operator
This document extends [the basic sequence language and space-time IR](Basic.md) to support stencils.
It adds:
1. sequence language primitives for shift registers and selecting from a sequence
1. space-time primitives for the shift registers and selects
1. rewrite rules for nesting the sequence primitives and converting between sequence and space-time versions
1. a stencil primitive in the sequence language built from the registers and selects
1. sequential, parallel, and partially parallel stencil primitives in the
   space-time IR built from the registers and selects
1. rewrites between the stencil primitives

# Sequence Language
## Sequence Operators
1. `Shift n init :: Seq n t -> Seq n t`
    1. `Shift` translates a sequence by 1 element.
    For `y <- Shift n w x`, the item at index `n+1` in `y` is equal to the item at index `n` in `x`.
    1. Element replaces the first element of the input `Seq` with `init`.
1. `Chain n w t :: (Seq n t -> Seq n t') -> Seq n t -> Seq n ((Seq w t'))`
    1. `Chain` creates a chain of `w-1` operators. 
    1. The output of `Chain` is a sequence where index i is a `Seq` of the ith index of the input and the output of each operator in the chain.
        1. The output of the ith operator is the input to the (w-i)th operator.
        1. The output at index w-1 is the input.
    1. The amount of nesting in per clock is used to compute the number of windows emitted every clock
1. `Select n i :: Seq n t -> Seq 1 t`
    1. For each inner Seq, take the ith element
1. `Transpose no ni :: Seq no (Seq ni t) -> Seq ni (Seq no t) `
1. `Merge no ni :: [Seq 1 (Seq ni t)] -> Seq no (Seq ni t)`
    1. The list must be of length no
1. `Stencil_1d n w :: Seq n t -> Seq n (Seq w t)`
    1. `Stencil_1d n w = Chain n w (Shift n w)`
1. `Window no ni init :: Seq no (Seq ni t) -> Seq no (Seq (ni+1) t)`
    1. For each `Seq ni` after the first one, prepends 1 element of the prior `Seq`
    1. For the first `Seq ni`,  preprends 1 instance of `init`
    1. Only the beginning is modified to preserve causality. The inputs to each
       `Seq` have already arrived as they were used by the prior `Seq`. The
       elements for the next `Seq` cannot be included in the current `Seq`
       because they may not have been materialized yet.
1. `Collapse no ni :: Seq no (Seq (ni+1) t) -> Seq no (Seq ni t)`
    1. Drops the first `w` of each `Seq ni`
1. `Filter n m i :: Seq n t -> Seq (n-m) t`
    1. Marks the element at position i for deletion when copying back to the CPU
1. `Map_Chain n w :: (Seq n t -> Seq n t) -> Seq n t -> Seq w (Seq n t)`
    1. Create w copies of the input operator, output each sequence.
    1. The output of the ith operator is the input to the (i-1)th operator.
    1. The jth output is the output of the (w-j)th operator.
1. `Stencil_Wire n wi wo :: Seq wi (Seq n t) -> Seq wo (Seq n t)`
    1. Decrease window sizes by walking down windows and then across them
1. `MapApply n :: Seq n (t -> t') -> Seq n t -> Seq n t'`
    1. This is equivalent to the [ZipList applictive functor in Haskell](https://en.wikibooks.org/wiki/Haskell/Applicative_functors#ZipList)

## Nesting Rewrite Rules

### Window
#### `Window` Nesting Outer
```
Window (ni*nj) nk init === Unpartition ni nj . Collapse ni nj . Map ni (Window nj nk init) . Window ni nj (Seq nk init) . Partition ni nj
```

#### `Window` Nesting Inner - NOT SURE THIS ONE WORKS
```
Window ni (nj*nk) init === Unpartition ni nj . Collapse ni nj . Map ni (Window nj nk init) . Window ni nj (Seq nk init) . Map ni (Partition nj nk)
```

### Shift
```
nested_shift no ni init input_partitions =
    windowed_inputs = Window no ni init input_partitions
    shifted_outputs = Map no (Shift ni init)
    return (Collapse no ni init shifted_outputs)

Shift (no*ni) === Unpartition no ni . nested_shift no ni . Partition no ni

Shift (no*ni) === Unpartition no ni . Collapse no ni init . Map no (Shift ni init) . Window no ni init . Partition no ni
```

### Chain

#### Chain `Partition` Removal
```
Chain no (Unpartition no ni . f . Partition no ni) === (Isomorphism Operator Removal)
Unpartition no ni . Chain no f . Partition no ni
```

All of the `f`'s `Unpartition`s and `Partition`s cancel each other out. 
The only impact is on the input and output.

### Stencil\_1d
#### Sequence To Space
```
wi = ceil((ni+w-1)/ni) -- how long each inner shift register needs to be to produce all the windows
Stencil_1d (no*ni) w ===
Chain (no*ni) w (Shift (no*ni) w init) ===
Unpartition no ni . Map no (Transpose ni w . Stencil_Wire ni wi w . Transpose ni wi) . Transpose ni no . Map ni (Chain no wi (Shift no init)) . Transpose no ni . Partition no ni ===
```

```
Stencil_1d (no*ni) w ===
Chain (no*ni) w (Shift n w) xs ===
Chain (no*ni) w (Unpartition no ni . Collapse no ni init . Map no (Shift ni init) . Window no ni init . Partition no ni) xs ===
Unpartition no ni (Seq w t) . Chain no (Collapse no ni init . Map no (Shift ni init) . Window no ni init) . Partition no ni t
```

# Space-Time IR
## Space-Time Operators
1. `Shift_s n init :: SSeq n t -> SSeq n t`
1. `Shift_t n init :: TSeq n v t -> TSeq n v t`
1. `Chain_s n w :: (SSeq n t -> SSeq n t') -> SSeq n t -> SSeq n (SSeq w t')`
1. `Chain_t n w :: (TSeq n v t -> TSeq n v t') -> TSeq n v t -> TSeq n v (SSeq w t')`
    1. The output has an `SSeq` on the inside as all the chained operators execute in parallel.
1. `MapApply_s n :: Seq n (t -> t') -> SSeq n t -> SSeq n t'`
1. `MapApply_t n :: Seq n (t -> t') -> TSeq n v t -> TSeq n v t'`
1. `Window_ss no ni init :: SSeq no (SSeq ni t) -> SSeq no (SSeq (ni+1) t)`
1. `Window_tt no ni init :: TSeq no vo (TSeq ni (vi+1) t) -> TSeq no vo (TSeq (ni+1) vi t)`
1. `Window_ts no ni init :: TSeq no vo (SSeq ni t) -> TSeq no vo (SSeq (ni+1) t)`
1. `Collapse_ss no ni :: SSeq no (SSeq (ni+1) t) -> SSeq no (SSeq ni t)`
1. `Collapse_tt no ni :: TSeq no vo (TSeq (ni+1) vi t) -> TSeq no vo (TSeq ni (vi+1) t)`
1. `Collapse_ts no ni :: TSeq no vo (SSeq (ni+1) t) -> TSeq no vo (SSeq ni t)`
1. `Transpose_ts no ni :: TSeq no vo (SSeq ni t) -> SSeq ni (TSeq no vo t)`
1. `Transpose_st no ni :: SSeq no (TSeq ni vi t) -> TSeq ni vi (SSeq no t)`
1. `Stencil_1d_s n w :: SSeq n t -> SSeq n (Seq w t)`
1. `Stencil_1d_t n w :: TSeq n v t -> TSeq n v (Seq w t)`

## Sequence To Space-Time Rewrite Rules

### All Operators Other Than `Shift` and `Stencil_1d`
All the operators have the same two rewrite rules with the same form.
We provide `Chain` as an example

I haven't been able to think of ways to partially parallelize the other operators. 
I may not allow them to be used as top-level primitives in auto-scheduled programs

#### Sequence To Space
`Chain n w f === SSeq_To_Seq . Map (SSeq_To_Seq) . Chain_s n w f . Seq_To_SSeq`

#### Sequence To Time
`Chain n w f === TSeq_To_Seq . Map (TSeq_To_Seq) . Chain_t n w f . Seq_To_TSeq`

### `Shift`

#### Sequence To Space
`Shift n init === SSeq_To_Seq . Shift_s n . Seq_To_SSeq`

#### Sequence To Time
`Shift n init === TSeq_To_Seq . Shift_t n . Seq_To_TSeq`

#### Sequence To Space-Time With Throughput `no` Less Than Fully Parallel
```
Shift (no*ni) init ===
Unpartition no ni . TSeq_To_Seq . Map_t no Seq_To_SSeq . 
    Transpose_st ni no
    Unpartition_s_ss ni 1 .
    MapApply_s (List_To_Seq 
        (Map_s 1 (Shift_t no init) . [Select_1d_s ni (ni-1)] ++ 
        [Select_1d_s ni i | i <- [0..n-2]) -- this collection of lists is created using Haskell's list comprehensions
        ) .
    Up_1d_s ni .
    Partition_s_ss 1 ni .
    Transpose_ts no ni .
    Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

### `Stencil_1d`

#### Sequence To Space
```
Stencil_1d n w === SSeq_To_Seq . Map_s n SSeq_To_Seq . Chain_s n w (Shift_s n w) . Seq_To_SSeq
```

#### Sequence To Time 
```
Stencil_1d n w === TSeq_To_Seq . Map_t n SSeq_To_Seq . Chain_t n w (Shift_t n w) . Seq_To_TSeq
```

#### Sequence To Space-Time With Throughput `no` Less Than Fully Parallel
```
wi = ceil( (ni+w-1) / ni ) -- how long each inner shift register needs to be to produce all the windows

output_window_indices = []

Select_2d_s no ni idx_o idx_i :: (SSeq no (SSeq ni t)) -> SSeq 1 (SSeq 1 t)
Select_2d_s no ni idx_o idx_i = Map_s 1 (Select_1d_s ni idx_i) . Select_1d_s no idx_o

Select_Window_s n wi wo w_start :: (SSeq n (SSeq wi t)) -> SSeq wo t
Select_Window_s n wi wo w_start = 
    Unpartition wo 1 .
    Map_s wo (Unpartition_s_ss 1 1) .
    MapApply ( List_To_Seq [
        Select_2d_s n wi ((w_start + w_elem) // wi) ((w_start + w_elem) % wi) | w_elem <- [0..wo-1]
        ]) .
    Up_1d_s wo .
    Partition_s_ss 1 n

Stencil_1d n w ===
Unpartition no ni . 
    Map_t no (
        MapApply ( List_To_Seq [Select_Window_s ni wi w w_idx | w_idx <- [0..ni]]) .
        Up_1d_s ni .
        Partition_s_ss 1 ni
        ) . 
    Transpose_st ni no . 
    Map_s ni (Chain_t no wi (Shift_t no init)) . 
    Transpose_ts no ni . 
    Partition no ni
```

## Stencil
## Sequence Operator
```
Stencil_1d n w :: Seq n t -> Seq n (Seq w t)
Stencil_1d n w = Shift n w 
```

## Space-Time Operators
```
Stencil_1d_s n w :: SSeq n t -> SSeq n (SSeq w t)
Stencil_1d_s n w = Sh

Stencil_1d_t w :: TSeq n v t -> TSeq n v (TSeq w 0 t)
Stencil_1d_t w = Shift_s n w 

Stencil_1d_t_ts w :: TSeq n v t -> TSeq n v (SSeq w t)
Stencil_1d_t_ts w = Shift_t_ts n w

Stencil_1d_ts_tss_split_t ni nj wk :: TSeq ni v (SSeq nj t) -> TSeq ni v (SSeq nj (SSeq wk t))
Stencil_1d_ts_tss_split_t ni nj wk xss =
    buffers <- Map_s nj (Shift_t_ts ni out_pixels_per_shift_register)
    unseparated_pixels <- Select_sts nj ni out_pixels_per_shift_register window_index_range
    return (Map_t ni (Partition_s_ss nj wk) unseparated_pixels)
    where
        total_out_pixels = nj + w - 1
        out_pixels_per_shift_register = total_out_pixels / nj
        window_index_range = [(idx // out_pixels_per_shift_register)x(idx `mod` w) | idx <- (nj*wk - 1)..0]
    
Stencil_1d_ts_tts_split_t ni nj wk :: TSeq ni (vo + ni*(nj + vi - 1)) (SSeq nj t) -> TSeq ni vo (TSeq nj vj (SSeq wk t))

Stencil_1d_ts_tts_split_s ni wj wk :: TSeq ni (vo + ni*(wj + vi - 1)) (SSeq wj t) -> TSeq ni vo (TSeq wj vj (SSeq wk t))

```

For stencil 
1. if output is 3d and splitting TSeq input, then ni and nj are number of
   windows, wi is window length
1. if output is 3d and splitting SSeq input, then ni is number of windows, wj
   and wk are window output

Note that `Stencil_1d_ts_tts_split_t` and `Stencil_1d_ts_tts_split_s` have the same type signature. They have different 
   
The stencil is different from the partition due to the number of parameters on
the input. The partition has 3 parameters divided among 2 input sequences. The
stencil has 2 paramaters divided among 2 input sequences. The difference is that
the 3rd parameter determines the amount of input data that is copied.

# Examples

## Sequence

### Example 1: 3x1 Sum
```
blur :: Int -> Seq n Int -> Seq n Int
blur n xs = 
    window <- Stencil_1d n 3 xs
    return (Map n (Reduce 3 Add) zipped_window_kernel)
```

### Example 2: 3x1 Blur
```
div5 :: Int -> Int -> Int
div5 x = div x 5

blur :: Int -> Seq n Int -> Seq n Int
blur n xs = 
    window <- Stencil_1d n 3 xs
    kernel <- Map n (Const_Gen [1, 3, 1]) [(), (), ()]
    summed_window_kernel = Map2 n (Map2 3 (Add . Zip)) window kernel
    return (Unpartition n 1 . Map n (Map 1 div5 . Reduce 3 Add) summed_window_kernel)
```

# garbage - ignore

Shift and Chain cannot be nested like the [sequence operators in the basic document](Basic.md#sequence-isomorphisms).
There are dependencies between inputs and outputs `w` elements away. If  `Shift n w` is not run over a number of partitions `p` 
such that `p % w == 0`, there will be dependencies between sequences.
This would require sequence reordering, which is complicated to do in time.


Shift cannot be nested like the [sequence operators in the basic document](Basic.md#sequence-isomorphisms).
Each output in `Shift n w` is dependent on an input `w` elements earlier. 
Partitioning a `Seq` and operating on the `Seq`s independently will always produce a different output than the unnested operator.
Take any partitioning amount `p`, take the input element `w-1` elements from the end of the first partition.
In the nested `Shift`, this element won't be used as it will be shifted off the end of the partition. 
In the unnested `Shift`, this element will be used as it will corresopnding to an output `w` away. That output will exist as the removal of the partitioning will make the `Seq` longer

The way you nest `Shift` is below, which is just the Stencil.
Stencil is the nested `Shift` when you have loop-carry dependencies.
```
nested_shift ni input_partition =
   non_shift_results = [Select no i input_partition| i <- [0..(no-2)]
   shifted_result = [Shift ni (Select no (no-1) input_partitions)]
   combined_results = map (Unpartition 1 ni) (non_shifted_results ++ shifted_results)
   return (Seq combined_results)

Shift (no*ni) === Unpartition no ni . nested_shift no ni . Partition no ni
```

```
Shift (no*ni) w === Unpartition no ni . Unpartition no 1 . Map no (Down_1d w) . Chain no w (Map ni (Shift no 1)) . Partition no ni
```

```
Shift (no*ni) w === Unpartition no ni . Partition no ni . Chain (no*ni) w (Shift (no*ni) w) . Unpartition no ni . Partition no ni
```

```
Shift (no*ni) w === Unpartition no ni . Transpose ni no . Map ni (Shift no w) . Transpose no ni . Partition no ni
```

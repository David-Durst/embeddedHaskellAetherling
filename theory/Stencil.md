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
## Type Constraints
### Type Containment
1. `t Contains t' = True`
1. `(Seq n t) Contains t' = t Contains t'`
1. `_ Contains t'' = False`

### Type Nesting
1. `t Nesting t' = 1`
1. `(Seq n t) Nesting t' = n * (t Nesting t')`

## Sequence Operators
1. `Shift n init :: Seq n t -> Seq n t`
    1. `Shift` translates a sequence by 1 element.
    For `y <- Shift n w x`, the item at index `n+1` in `y` is equal to the item at index `n` in `x`.
    1. Element replaces the first element of the input `Seq` with `init`.
1. `Chain n w t' :: (t Contains t', nst = t Nesting t') => (Seq n t -> Seq n t) -> Seq n t -> Seq n (Seq nst (Seq w t'))`
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
    1. `Stencil_1d n w xs = Chain n w (Shift n w) xs`
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

### Stencil
```
wi = ceil((ni+w-1)/ni) -- how long each inner shift register needs to be to produce all the windows
Stencil_1d (no*ni) w ===
Chain (no*ni) w (Shift (no*ni) w init) ===
Unpartition no ni . Map no (Chain_Select_Only ni w . UNKNOWN_DROP? . Unpartition wi ni . Transpose ni wi) . Transpose ni no . Map ni (Chain no wi (Shift no init)) . Transpose no ni . Partition no ni ===
```

```
Stencil_1d (no*ni) w ===
Chain (no*ni) w (Shift n w) xs ===
Chain (no*ni) w (Unpartition no ni . Collapse no ni init . Map no (Shift ni init) . Window no ni init . Partition no ni) xs ===
Unpartition no ni (Seq w t) . Chain no (Collapse no ni init . Map no (Shift ni init) . Window no ni init) . Partition no ni t
```

# Space-Time IR
## Space-Time Operators
1. `Shift_s n w :: SSeq n t -> SSeq n t`
1. `Shift_t n w :: TSeq n v t -> TSeq n v t`
1. `Shift_t_tt n w :: TSeq n (v+(n-1)*w*) k -> TSeq n v (TSeq w 0 t)`
1. `Shift_t_ts n w :: TSeq n v k -> TSeq n v (SSeq w t)`
1. `Select_s n (Seq w Int) :: SSeq n t -> SSeq w t`
1. `Select_t n (Seq w Int) :: TSeq n v t -> TSeq w (n-w+v) t`
1. `Select_sts ni nj nk (Seq w (Int x Int)) :: SSeq ni (TSeq nj v (SSeq nk t)) -> TSeq nj v (SSeq w t)`

## Space-Time Rewrite Rules
Not sure if I want this

# Stencil
## Sequence Operator
```
Stencil_1d n w :: Seq n t -> Seq n (Seq w t)
Stencil_1d n w = Shift n w 
```

## Space-Time Operators
```
Stencil_1d_s w :: SSeq n t -> SSeq n (SSeq w t)
Stencil_1d_s w = Shift_s n w 

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

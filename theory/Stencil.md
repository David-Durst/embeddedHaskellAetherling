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
1. `Shift n :: Seq n t -> Seq n t`
    1. `Shift` translates a sequence by 1 element.
    For `y <- Shift n w x`, the item at index `(n+w)` in `y` is equal to the item at index `n` in `x`.
1. `Chain n w :: (Seq n t -> Seq n t) -> Seq n t -> Seq n (Seq w t')`
    1. `Chain` creates a chain of `w` operators. 
    The output of the ith operator is the input to the (i+1)th operator.
    1. The output of `Chain` is a sequence where index i is a `Seq` of the ith outputs of each operator in the chain.
1. `Select no ni i :: Seq no (Seq ni t) -> Seq no t`
    1. For each inner Seq, take the ith element
1. `Stencil_1d n w :: Seq n t -> Seq n (Seq w t)`
    1. `Stencil_1d n w xs = Chain n w (Shift n w) xs`

## Nesting Rewrite Rules

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
Shift (no*ni) w === Unpartition no ni . Unpartition no 1 . Map no (Down_1d w) . Chain no w (Map ni (Shift no 1)) . Partition no ni
```

```
Shift (no*ni) w === Unpartition no ni . Partition no ni . Chain (no*ni) w (Shift (no*ni) w) . Unpartition no ni . Partition no ni
```

```
Shift (no*ni) w === Unpartition no ni . Transpose ni no . Map ni (Shift no w) . Transpose no ni . Partition no ni
```

### Stencil
```
Stencil_1d (no*ni) w ===
Chain (no*ni) w (Shift n w) xs ===
Unpartition no ni (Seq w t) . Chain no (Map ni (Shift no w)) . Partition no ni t
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

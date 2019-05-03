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
## Operators
1. `Shift n w :: Seq n t -> Seq n t`
    1. `Shift` translates a sequence. 
    For `y <- Shift n w x`, the item at index `(n+w)` in `y` is equal to the item at index `n` in `x`.
1. `Chain n w :: (Seq n t -> Seq n t) -> Seq n t -> Seq n (Seq w t')`
    1. `Chain` creates a chain of `w` operators. 
    The output of the ith operator is the input to the (i+1)th operator.
    1. The output of `Chain` is a sequence where index i is a `Seq` of the ith outputs of each operator in the chain.
1. `MapWithIndex n i :: (Config j -> Seq n t -> Seq n t) -> Seq  `
1. `Select n w :: (Seq w (Int x Int)) -> (Config w' -> Seq n t -> Seq n t) -> Seq n t -> Seq n (Seq w t)`
    1. We name the rest of Select's inputs:
        1. `indices :: Seq w (Int x Int)`
        1. `f :: Seq n t -> Seq n t 
        1. `xs :: Seq n t`
    1. `Select` creates `w` copies of `f` and calls each with `xs` as the input. 
    1. `Select` returns, for each `i` from `0` to `n-1`, a `Seq w t`.
    1. The `i`th index in the result 

    1. `f` is the function that processes `xs`. `w` copies are made of `f`
    1. `indices` are the 
    `(Seq w (Int x Int))` are the indexes
1. `Stencil_1d n w :: Seq n t -> Seq n (Seq w t)`

```
Stencil_1d n w xs = Chain n w (Shift n w) xs
```


**Note: [0..w] is a standard list comprehension notation. It is repurposed for `Seq` comprehensions.**

# Space-Time IR
## Space-Time Operators
1. `Shift_ss n w :: SSeq n k -> SSeq n (SSeq w t)`
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

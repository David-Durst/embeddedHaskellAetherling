# Stencil Operator
This document extends [the basic sequence language and space-time IR](Basic.md) to support stencils.
It adds:
1. sequence language primitives for shift registers, stencils, and other supporting operators
1. space-time primitives for shift registers, stencils, and other supporting operators
1. rewrite rules for converting the shift registers and stencils between sequence and space-time versions

# Sequence Language
## Sequence Operators
1. `Shift n init :: Seq n t -> Seq n t`
    1. `Shift` translates a sequence by 1 element.
    For `y <- Shift n x`, the item at index `n+1` in `y` is equal to the item at index `n` in `x`.
    1. `Shift` replaces the first element of the input `Seq` with `init`.
1. `Stencil_1d n w init :: Seq n t -> Seq n (Seq w t)`
```
Stencil_1d n w init = 
Transpose w n .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift n init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w .
    Partition 1 n

```

## Nesting Rewrite Rules
### `Shift`
```
Shift (no*ni) init ===
Unpartition no ni .
    Transpose ni no
    Unpartition ni 1 .
    HMap (List_To_Seq 
        [Map 1 (Shift_t no init) . Select_1d ni (ni-1)] ++ 
        [Select_1d ni i | i <- [0..n-2]] 
        ) .
    Up_1d ni .
    Partition 1 ni .
    Transpose no ni .
    Partition no ni
```

Let `Shift_Nested no ni init` be the above nested composition of operators without the outer `Unpartition no ni` and `Partition no ni`

![Partially Parallel Shift](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/stencil_1d/partially_parallel_shift_few_primitives.png "Partially Parallel Shift")

### `Stencil_1d`

**Key Insight** - You only ever need `w-1` registers for a `Stencil_1d` with
stride 1 no matter how parallel it is. If your input parallelism is `p`, you can
emit `p` output windows as have `p` pixels of new information and, since stride
is 1, each window only has 1 new pixel. This means, need `p+w-1` pixels to fill
all your windows. But, getting `p` pixels in per clock, so only need to remember
`w-1` pixels from the last clock to fill out the windows. This means need `w-1`
registers.

The stencil only makes `w-1` registers (with repeat register elimination). 
The nested shifts handle accessing data from those registers and from the current clock

```
Stencil_1d (no*ni) w xs = 

Transpose w (no*ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift (no*ni) init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w .
    Partition 1 (no*ni) === (Partition Nesting Inner)

Transpose w (no*ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift (no*ni) init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . Partition 1 (no*ni) === (Shift Nesting)

Transpose w (no*ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Unpartition no ni . Shift_Nested no ni init (Partition no ni . head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Isomorphism Operator Introduction)

Transpose w (no*ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Unpartition no ni . Shift_Nested no ni init (Partition no ni . head in_seqs) : in_seqs) (Unpartition no ni . Partition no ni) (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Identity Addition)

Transpose w (no*ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Unpartition no ni . Shift_Nested no ni init (Partition no ni . head in_seqs) : in_seqs) (Unpartition no ni . id . Partition no ni) (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (HMap Equivalence and HMap and Map Equivalence)

Transpose w (no*ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ ->  Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Map w (Partition no ni) . 
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Sequence Commutativity)

Transpose w (no*ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ ->  Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Map Fusion and Isomorphism Removal)

Transpose w (no*ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ ->  Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . Partition 1 (no*ni) === (Transpose Nesting Inner)

Unpartition no ni . Map no (Transpose w ni) . Transpose w no . Map w (Partition no ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ ->  Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . Partition 1 (no*ni) === (Isomorphism Removal)

Unpartition no ni . Map no (Transpose w ni) . Transpose w no .
    HMap w (List_To_Seq . foldl (\in_seqs _ ->  Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . Partition 1 (no*ni) === (Commutativity)

Unpartition no ni . Map no (Transpose w ni) . Transpose w no .
    HMap w (List_To_Seq . foldl (\in_seqs _ ->  Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Partition 1 (no*ni) . Partition no ni
```

# Space-Time IR
## Space-Time Operators
1. `Shift_s n init :: SSeq n t -> SSeq n t`
1. `Shift_t n init :: TSeq n v t -> TSeq n v t`
1. `Chain_s n w :: (SSeq n t -> SSeq n t') -> SSeq n t -> SSeq n (SSeq w t')`
1. `Chain_t n w :: (TSeq n v t -> TSeq n v t') -> TSeq n v t -> TSeq n v (SSeq w t')`
    1. The output has an `SSeq` on the inside as all the chained operators execute in parallel.
1. `HMap_s n :: Seq n (t -> t') -> SSeq n t -> SSeq n t'`
1. `HMap_t n :: Seq n (t -> t') -> TSeq n v t -> TSeq n v t'`
1. `Transpose_ts no ni :: TSeq no vo (SSeq ni t) -> SSeq ni (TSeq no vo t)`
1. `Transpose_st no ni :: SSeq no (TSeq ni vi t) -> TSeq ni vi (SSeq no t)`
1. `Stencil_1d_s n w :: SSeq n t -> SSeq n (Seq w t)`
1. `Stencil_1d_t n w :: TSeq n v t -> TSeq n v (Seq w t)`

## Sequence To Space-Time Rewrite Rules

### All Operators Other Than `Shift` and `Stencil_1d`
All the operators other than `Shift` and `Stencil_1d` have the same two rewrite rules with the same form.
We provide `Chain` as an example.

I haven't been able to think of ways to partially parallelize the other operators. 
Due to this limitation, I may not allow them to be used as top-level primitives in auto-scheduled programs.

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
    HMap_s (List_To_Seq 
        [Map_s 1 (Shift_t no init) . Select_1d_s ni (ni-1)] ++ 
        [Select_1d_s ni i | i <- [0..n-2]] -- this collection of lists is created using Haskell's list comprehensions
        ) .
    Up_1d_s ni .
    Partition_s_ss 1 ni .
    Transpose_ts no ni .
    Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

The first function in the argument list to `HMap_s` is equivalent to `shifted_results` in the Partially Parallel Shift diagram.
It takes the last element of the inner `Seq` and shifts it by 1. 

The other functions in the argument list to `HMap_s` are equivalent to `non_shifted_results` in Partially Parallel Shift diagram.
It takes all the other elements of the inner `Seq` and does nothing to them.

![Partially Parallel Shift](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/stencil_1d/partially_parallel_shift.png "Partially Parallel Shift")

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

Select_Window_s no ni w w_start :: (SSeq no (SSeq ni t)) -> SSeq w t
Select_Window_s no ni w w_start = 
    Unpartition w 1 .
    Map_s w (Unpartition_s_ss 1 1) .
    HMap ( List_To_Seq [
        Select_2d_s no ni ((w_start + w_elem) // ni) ((w_start + w_elem) % ni) | w_elem <- [0..w-1]
        ]) .
    Up_1d_s w .
    Partition_s_ss 1 no

Stencil_1d n w ===
Unpartition no ni . 
    Map_t no (
        HMap ( List_To_Seq [Select_Window_s ni wi w w_idx | w_idx <- [0..ni]]) .
        Up_1d_s ni .
        Partition_s_ss 1 ni
        ) . 
    Transpose_st ni no . 
    Map_s ni (Chain_t no wi (Shift_t no init)) . 
    Transpose_ts no ni . 
    Partition no ni
```

`Stencil_1d` has two main parts:
1. `Map_s ni (Chain_t no wi (Shift_t no init))` creates all the shift registers that store data in parallel
1. The function in the `Map_t no` selects the windows out of the shift registers
    1. `Select_Window_s` selects the windows from 2D nested `Seq`s. 
        1. `no` and `ni` form the 2D coordinate space to remove windows from
        1. `w` is the size of the window to emit
        1. `w_start` is the 1D index of the window. 
        Since this is a stride one stencil, each call to `Select_Window_s` increments `w_start` by 1.

# Examples

## Sequence

### Example 1: 3x1 Sum
```
blur :: Int -> Seq n Int -> Seq n Int
blur n xs = 
    windowed_seq <- Stencil_1d n 3 xs
    zipped_window_kernel = Map n (Map2 n (List_To_Seq [1, 2, 1]) windowed_seq)
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

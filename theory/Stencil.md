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
    HMap ni (List_To_Seq 
        [Map 1 (Shift no init) . Select_1d ni (ni-1)] ++ 
        [Select_1d ni i | i <- [0..n-2]] 
        ) .
    Up_1d ni .
    Partition 1 ni .
    Transpose no ni .
    Partition no ni
```

Let `Shift_Nested no ni init` be the above nested composition of operators without the outer `Unpartition no ni` and `Partition no ni`

![Nested Shift](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/stencil_1d/nested_shift.png "Nested Shift")

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
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Unpartition no ni . Shift_Nested no ni init . Partition no ni (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Isomorphism Operator Introduction)

Transpose w (no*ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Unpartition no ni . Shift_Nested no ni init . Partition no ni (head in_seqs) : in_seqs) (Unpartition no ni . Partition no ni) (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Identity Addition)

Transpose w (no*ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Unpartition no ni . Shift_Nested no ni init . Partition no ni (head in_seqs) : in_seqs) (Unpartition no ni . id . Partition no ni) (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (HMap Equivalence and HMap and Map Equivalence)

Transpose w (no*ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Map w (Partition no ni) . 
    Up_1d w . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Sequence Commutativity)

Transpose w (no*ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . 
    Map 1 (Unpartition no ni) . Map 1 (Partition no ni) . 
    Partition 1 (no*ni) === (Map Fusion and Isomorphism Removal)

Transpose w (no*ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . Partition 1 (no*ni) === (Transpose Nesting Inner)

Unpartition no ni . Map no (Transpose w ni) . Transpose w no . Map w (Partition no ni) .
    Map w (Unpartition no ni) .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . Partition 1 (no*ni) === (Isomorphism Removal)

Unpartition no ni . Map no (Transpose w ni) . Transpose w no .
    HMap w (List_To_Seq . foldl (\in_seqs _ ->  Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Map 1 (Partition no ni) . Partition 1 (no*ni) === (Commutativity)

Unpartition no ni . Map no (Transpose w ni) . Transpose w no .
    HMap w (List_To_Seq . foldl (\in_seqs _ -> Shift_Nested no ni init (head in_seqs) : in_seqs) id (reverse [0..w-2])) .
    Up_1d w . 
    Partition 1 no . Partition no ni
```

Let `Stencil_1d_Nested no ni init` be the above nested composition of operators without the outer `Unpartition no ni` and `Partition no ni**.

**Note:** This derivation is not an actual rewrite rule in the system. 
Since `Stencil_1d` is not a primitive in the language, it doesn't have rewrite rules. 
This derivation is only here to prove that standard application of the rewrite rules produces the nested stencil shown in the picture below.

![Nested Stencil\_1d](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/stencil_1d/nested_stencil_1d.png "Nested Stencil\_1d")

# Space-Time IR
## Space-Time Operators
1. `Shift_s n init :: SSeq n t -> SSeq n t`
1. `Shift_t n init :: TSeq n v t -> TSeq n v t`
1. `Stencil_1d_s n w init :: SSeq n t -> SSeq n (SSeq w t)`
1. `Stencil_1d_t n w init :: TSeq n v t -> TSeq n (TSeq w t)`

## Sequence To Space-Time Rewrite Rules

### `Shift`
#### Sequence To Space
`Shift n init === SSeq_To_Seq . Shift_s n . Seq_To_SSeq`

#### Sequence To Time
`Shift n init === TSeq_To_Seq . Shift_t n . Seq_To_TSeq`

#### Sequence To Space-Time With Throughput `no` Less Than Fully Parallel
```
Shift (no*ni) init === (Nesting)

Unpartition no ni .
    Transpose ni no
    Unpartition ni 1 .
    HMap ni (List_To_Seq 
        [Map 1 (Shift no init) . Select_1d ni (ni-1)] ++ 
        [Select_1d ni i | i <- [0..n-2]] 
        ) .
    Up_1d ni .
    Partition 1 ni .
    Transpose no ni .
    Partition no ni === (Seq To Space)
    
Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 . Map_s ni Seq_To_SSeq . Seq_To_SSeq
    SSeq_to_Seq . HMap_s ni (List_To_Seq 
        [Map 1 (Shift no init) . Select_1d ni (ni-1)] ++ 
        [Select_1d ni i | i <- [0..n-2]] 
        ) . Seq_To_SSeq
    SSeq_To_Seq . Up_1d_s ni . Seq_To_SSeq
    SSeq_To_Seq . Map_s 1 SSeq_To_Seq . Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Isomorphism Removal)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 . Map_s ni Seq_To_SSeq .
    HMap_s ni (List_To_Seq 
        [Map 1 (Shift no init) . Select_1d ni (ni-1)] ++ 
        [Select_1d ni i | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Map_s 1 SSeq_To_Seq . Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Seq To Space)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 . Map_s ni Seq_To_SSeq .
    HMap_s ni (List_To_Seq 
        [SSeq_To_Seq . Map_s 1 (Shift no init) . Seq_To_SSeq . SSeq_To_Seq . Select_1d_s ni (ni-1) . Seq_To_SSeq] ++ 
        [SSeq_To_Seq . Select_1d_s ni i . Seq_To_SSeq | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Map_s 1 SSeq_To_Seq . Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Identity Addition)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 . Map_s ni Seq_To_SSeq .
    HMap_s ni (List_To_Seq 
        [SSeq_To_Seq . Map_s 1 (Shift no init) . Seq_To_SSeq . SSeq_To_Seq . Select_1d_s ni (ni-1) . Seq_To_SSeq] ++ 
        [Map 1 (TSeq_To_Seq . Seq_To_TSeq) . SSeq_To_Seq . Select_1d_s ni i . Seq_To_SSeq | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Map_s 1 SSeq_To_Seq . Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Seq To Space and Isomorphism Removal)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 . Map_s ni Seq_To_SSeq .
    HMap_s ni (List_To_Seq 
        [SSeq_To_Seq . Map_s 1 (Shift no init) . Seq_To_SSeq . SSeq_To_Seq . Select_1d_s ni (ni-1) . Seq_To_SSeq] ++ 
        [SSeq_To_Seq . Map_s 1 (TSeq_To_Seq . Seq_To_TSeq) . Select_1d_s ni i . Seq_To_SSeq | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Map_s 1 SSeq_To_Seq . Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (HMap Equivalence and HMap and Map Equivalence)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 . Map_s ni Seq_To_SSeq .
    Map_s ni SSeq_To_Seq . 
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift no init) . Seq_To_SSeq . SSeq_To_Seq . Select_1d_s ni (ni-1)] ++ 
        [Map_s 1 (TSeq_To_Seq . Seq_To_TSeq) . Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Map_s ni Seq_To_SSeq . 
    Up_1d_s ni
    Map_s 1 SSeq_To_Seq . Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Commutativity)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 . Map_s ni Seq_To_SSeq .
    Map_s ni SSeq_To_Seq . 
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift no init) . Seq_To_SSeq . SSeq_To_Seq . Select_1d_s ni (ni-1)] ++ 
        [Map_s 1 (TSeq_To_Seq . Seq_To_TSeq) . Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Map_s ni Seq_To_SSeq . 
    Map_s ni SSeq_To_Seq . Up_1d_s ni
    Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Isomorphism Removal)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 .
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift no init) . Select_1d_s ni (ni-1)] ++ 
        [Map_s 1 (TSeq_To_Seq . Seq_To_TSeq) . Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Seq To TSeq and Identity Addition)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 .
    HMap_s ni (List_To_Seq 
        [Map_s 1 (TSeq_to_Seq . Shift_t no init . Seq_to_TSeq) . Select_1d_s ni (ni-1)] ++ 
        [Map_s 1 (TSeq_To_Seq . Seq_To_TSeq) . Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Map Functor Fusion and Commutativity)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 .
    HMap_s ni (List_To_Seq 
        [Map_s 1 TSeq_to_Seq . Map_s 1 (Shift_t no init) . Select_1d_s ni (ni-1) . Map_s ni Seq_To_TSeq] ++ 
        [Map_s 1 TSeq_To_Seq . Select_1d_s ni i . Map_s ni Seq_To_TSeq | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (HMap Equivalence and HMap and Map Equivalence)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 .
    Map_s ni (Map_s 1 TSeq_To_Seq) .
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift_t no init) . Select_1d_s ni (ni-1)] ++ 
        [Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Map_s ni (Map_s ni TSeq_To_Seq) .
    Up_1d_s ni
    Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Commutativity)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Unpartition_s_ss ni 1 .
    Map_s ni (Map_s 1 TSeq_To_Seq) .
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift_t no init) . Select_1d_s ni (ni-1)] ++ 
        [Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Map_s 1 (Map_s ni TSeq_To_Seq) .
    Partition_s_ss 1 ni . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Commutativity)

Unpartition no ni .
    Transpose ni no
    SSeq_To_Seq . Map_s ni TSeq_To_Seq .
    Unpartition_s_ss ni 1 .
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift_t no init) . Select_1d_s ni (ni-1)] ++ 
        [Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Partition_s_ss 1 ni . 
    Map_s ni TSeq_To_Seq . Seq_To_SSeq
    Transpose no ni .
    Partition no ni === (Sequence To Time-Space-To-Space-Time and Sequence To Space-Time-To-Time-Space)

Unpartition no ni .
    TSeq_To_Seq . Map_t no SSeq_To_Seq . Transpose_st_to_ts ni no . Map_s ni Seq_To_TSeq . Seq_To_SSeq
    SSeq_To_Seq . Map_s ni TSeq_To_Seq .
    Unpartition_s_ss ni 1 .
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift_t no init) . Select_1d_s ni (ni-1)] ++ 
        [Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Partition_s_ss 1 ni . 
    Map_s ni TSeq_To_Seq . Seq_To_SSeq
    SSeq_To_Seq . Map_s ni TSeq_To_Seq . Transpose_ts_to_st no ni . Map_t no Seq_To_SSeq . Seq_To_TSeq
    Partition no ni === (Isomorphism Removal)

Unpartition no ni . TSeq_To_Seq . Map_t no SSeq_To_Seq . 
    Transpose_st_to_ts ni no . 
    Unpartition_s_ss ni 1 .
    HMap_s ni (List_To_Seq 
        [Map_s 1 (Shift_t no init) . Select_1d_s ni (ni-1)] ++ 
        [Select_1d_s ni i | i <- [0..n-2]] 
        ) .
    Up_1d_s ni
    Partition_s_ss 1 ni . 
    Transpose_ts_to_st no ni . 
    Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

### `Stencil_1d`
`Stencil_1d`  doesn't have it's own rewrite rules. It is not a primitive in the language.
To schedule it in space-time, just apply the rewrite rules to the operators that compose it.

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

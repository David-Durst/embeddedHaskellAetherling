# Stencil Operator
This document extends [the basic sequence language and space-time IR](Basic.md) to support stencils.
It adds:
1. a sequence language primitive for shift registers 
1. space-time primitives for shift registers
1. rewrite rules for converting the shifts between sequence and space-time versions
1. definitions of sequence language stencils using other primitives

# Sequence Language
## Sequence Operators
1. `Shift n s :: Seq n t -> Seq n t`
    1. `Shift` translates a sequence by s elements.
    For `y <- Shift n 1 x`, the item at index `n+1` in `y` is equal to the item at index `n` in `x`.

## Nesting Rewrite Rules
### `Shift`
```
Shift (no*ni) s in_seq ===
Unpartition no ni .
    Tuple_To_Seq .
    foldl1 (\accum next -> Map2 no Tuple accum next) .
    fmap (\(i, in_seq) -> 
            Shift no ((ni - i + s - 1) // ni) $ Map no (Select_1d ni ((i - s) % ni)) in_seq
        ) .
    zipWith [0..]
    repeat ni .
    Partition no ni
```

Let `Shift_Nested no ni init` be the above nested composition of operators without the outer `Unpartition no ni` and `Partition no ni`

![Nested Shift](https://raw.githubusercontent.com/David-Durst/embeddedHaskellAetherling/rewrites/theory/computation_diagram/nested_shift/nested_shift_computation_explained.png "Nested Shift")


# Space-Time IR
## Space-Time Operators
1. `Shift_s n init :: SSeq n t -> SSeq n t`
1. `Shift_t n init :: TSeq n v t -> TSeq n v t`

The stencil operators don't need Space-Time versions because they are composed
of more basic Aetherling operators. The more basic Aetherling operators
will be mapped to the Space-Time IR.

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
    Tuple_To_Seq .
    foldl1 (\accum next -> Map2 no Tuple accum next) .
    fmap (if i == 0
              then Shift no 1 . Map no (Select_1d ni (ni-1))
              else Map no (Select_1d ni (i - 1)) in_seq
         ) .
    repeat ni .
    Partition no ni === (Seq To TSeq)

Unpartition no ni .
    Tuple_To_Seq .
    foldl (\accum next -> TSeq_To_Seq . Map2_t no Tuple
          (Seq_To_TSeq accum) (Seq_To_TSeq next)) .
    fmap (if i == 0
              then TSeq_To_Seq . Shift_t no 1 . Seq_To_TSeq .
                  TSeq_To_Seq . Map_t no (Select_1d ni (ni-1)) . Seq_To_TSeq
              else TSeq_To_Seq . Map_t no (Select_1d ni (i - 1)) . Seq_To_TSeq 
         )
    repeat ni .
    Partition no ni === (Isomorphism Removal)

Unpartition no ni .
    Tuple_To_Seq .
    foldl (\accum next -> TSeq_To_Seq . Map2_t no Tuple
          (Seq_To_TSeq accum) (Seq_To_TSeq next)) .
    fmap (if i == 0
              then TSeq_To_Seq . Shift_t no 1 .
                  Map_t no (Select_1d ni (ni-1)) . Seq_To_TSeq
              else TSeq_To_Seq . Map_t no (Select_1d ni (i - 1)) . Seq_To_TSeq 
         )
    repeat ni .
    Partition no ni === (Functor Map Fusion)

Unpartition no ni .
    Tuple_To_Seq .
    foldl (\accum next -> TSeq_To_Seq . Map2_t no Tuple
          (Seq_To_TSeq accum) (Seq_To_TSeq next)) .
    fmap TSeq_To_Seq .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no (Select_1d ni (ni-1))
              else Map_t no (Select_1d ni (i - 1))
         )
    fmap TSeq_To_Seq .
    repeat ni .
    Partition no ni === (Functor Map Fusion)

Unpartition no ni .
    Tuple_To_Seq .
    foldl (\accum next -> TSeq_To_Seq . Map2_t no Tuple
          (Seq_To_TSeq accum) (Seq_To_TSeq next)) .
    fmap TSeq_To_Seq .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no (Select_1d ni (ni-1))
              else Map_t no (Select_1d ni (i - 1))
         )
    fmap TSeq_To_Seq .
    repeat ni .
    Partition no ni === (By Fold and Repeat Semantics)

Unpartition no ni .
    Tuple_To_Seq .
    TSeq_To_Seq . 
    foldl (\accum next -> Map2_t no Tuple accum next) .
    fmap Seq_To_Seq .
    fmap TSeq_To_Seq .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no (Select_1d ni (ni-1))
              else Map_t no (Select_1d ni (i - 1))
         )
    repeat ni .
    TSeq_To_Seq .
    Partition no ni === (Isomorphism Removal)

Unpartition no ni .
    Tuple_To_Seq .
    TSeq_To_Seq . 
    foldl (\accum next -> Map2_t no Tuple accum next) .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no (Select_1d ni (ni-1))
              else Map_t no (Select_1d ni (i - 1))
         )
    repeat ni .
    TSeq_To_Seq .
    Partition no ni === (Seq To SSeq)

Unpartition no ni .
    Tuple_To_Seq .
    TSeq_To_Seq . 
    foldl (\accum next -> Map2_t no Tuple accum next) .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no (SSeq_To_Seq . Select_1d_s ni (ni-1) . Seq_To_SSeq)
              else Map_t no (SSeq_To_Seq . Select_1d_s ni (i - 1) . SSeq_To_Seq)
         )
    repeat ni .
    TSeq_To_Seq .
    Partition no ni === (Functor Map Fusion)

Unpartition no ni .
    Tuple_To_Seq .
    TSeq_To_Seq . 
    foldl (\accum next -> Map2_t no Tuple accum next) .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no SSeq_To_Seq .
                  Map_t no (Select_1d_s ni (ni-1)) . 
                  Map_t no Seq_To_SSeq
              else Map_t no SSeq_To_Seq . 
                   Map_t no (Select_1d_s ni (i - 1)) . 
                   Map_t no SSeq_To_Seq
         )
    repeat ni .
    TSeq_To_Seq .
    Partition no ni === (Repeating Same Process As For Seq_To_TSeq)

Unpartition no ni .
    Tuple_To_Seq .
    TSeq_To_Seq . 
    Map_t no SSeq_To_Seq
    foldl (\accum next -> Map2_t no Tuple accum next) .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no (Select_1d_s ni (ni-1))
              else Map_t no (Select_1d_s ni (i - 1)) . 
         )
    repeat ni .
    Map_t no Seq_To_SSeq
    TSeq_To_Seq .
    Partition no ni === (Partially Parallel Tuple_To_Seq)

Unpartition no ni .
    TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t no (Tuple_To_SSeq ni) . Map_t no Seq_To_SSeq . Seq_To_TSeq
    TSeq_To_Seq . 
    Map_t no SSeq_To_Seq
    foldl (\accum next -> Map2_t no Tuple accum next) .
    fmap (if i == 0
              then Shift_t no 1 . Map_t no (Select_1d_s ni (ni-1))
              else Map_t no (Select_1d_s ni (i - 1)) . 
         )
    repeat ni .
    Map_t no Seq_To_SSeq
    TSeq_To_Seq .
    Partition no ni === (Isomorphism Removal)

Unpartition no ni .
    TSeq_To_Seq . 
    Map_t no SSeq_To_Seq . 
    Map_t no (Tuple_To_SSeq ni) . 
    foldl (\accum next -> Map2_t no Tuple accum next) .
    fmap (\(i, in_seq) -> 
            Shift_t no ((ni - i + s - 1) // ni) $ Map_t no (Select_1d_s ni ((i - s) % ni)) in_seq
        ) .
    zipWith [0..]
    repeat ni .
    Map_t no Seq_To_SSeq
    TSeq_To_Seq .
    Partition no ni === (Isomorphism Removal)

```

# Stencils
1. `Stencil_1d n w :: Seq n t -> Seq n (Seq w t)`
```
Stencil_1d n w in_seq = 
Tuple_To_Seq .
    foldl1 (\accum next -> Map2 n Tuple accum next) .
    foldl (\l@(last_shifted_seq:_) _ -> (Shift n 1 last_shifted_seq) : l)
        [in_seq] [0 ..w-2]
```

1. `Stencil_2d n_row n_col w_row w_col init :: Seq (n_row*n_col) t -> Seq (n_row*n_col) (Seq w_row (Seq w_col t))`
```
Stencil_2d n_row n_col w_row w_col init = 
Map (n_row*n_col) (Unpartition w_row w_col) .
    Tuple_To_Seq .
    foldl1 (\accum next -> Map2 (n_row*n_col) Tuple accum next) .
    fmap (Stencil_1d (n_row*n_col) w_col) .
    foldl (\l@(last_shifted_seq:_) _ -> (Shift (n_row*n_col) n_col init last_shifted_seq) : l)
        [in_seq] [0 .. w_row - 2]
```

## Stencil Examples

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

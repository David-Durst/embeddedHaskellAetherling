# 2D Upsample and Downsample Operators
This document extends [the basic sequence language and space-time IR](Basic.md) to support 2D upsample and downsample.
It adds:
1. definitions of sequence language 2d upsample and downsample using other primitives

# Sequence Language
## Upsample
`Up_2d up_row up_col in_col :: Seq in_col t -> Seq (up_row * in_col * up_col) t`
```
Up_2d up_row up_col in_col = 
    Unpartition up_row (n_col * in_col) .
    Up_1d up_row .
    Partition 1 (up_col * in_col) .
    Unpartition in_col up_col .
    Map in_col (Up_1d up_col) .
    Partition in_col 1
```

## Downsample
`Select_2d down_row down_col in_col idx_row idx_col :: Seq (down_row * in_col * dow_col) -> Seq in_col t`
```
Select_2d down_row down_col in_col idx_row idx_col =
   Unpartition 1 in_col .
   Select_1d down_row idx_col .
   Partition down_row in_col .
   Unpartition (down_row * in_col) 1 .
   Map (down_row * in_col) (Select_1d down_col idx_col) . 
   Partition (down_row * in_col) down_col
```

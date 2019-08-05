# Sequence and Space-Time Types
The goal of this document is to give a visual intuition for the semantics of Aetherling's type systems.
It shows examples of values in the sequence language, visualizations of the values, isomorphic values in the space-time IR, and visualizations of those values.

Unlike other documents, the space-time IR types in this document indicate the order of valid and invalid clocks. 
In speaking with Gilbert, it appears that this is necessary in order to accurately estimate the cost due to delay buffers in the space-time IR.

# Flat Sequences
The simplest example of a sequence value in the sequence language is below.
It is a sequence of four integers. 
Following Haskell syntax, we provide the type after `::`.
```
[0, 1, 2, 3, 4, 5] :: Seq 6 Int
```

By the [sequence-to-space-time-isomorphisms](Basic.md#sequence-isomorphisms), the prior sequence can be converted to an `SSeq` or a `TSeq`.

## Flat SSeq
The above `Seq 6 Int` can be converted to an `SSeq 6 Int` with six integers on one clock cycle.
The below diagrams show the distribution of this value's elements in space and time.

The first diagram visualizes the structure of Aetherling's nested `SSeq`s and `TSeq`s.
The `()` indicate an `SSeq`.
This flat `SSeq` represents six elements on one clock cycle.

![SSeq 6 Int](other_diagrams/types/seq6/sseq6.png "SSeq 6 Int")

The second diagram shows the hardware perspective: what elements of the sequence will be materialized on which clock cycles. 
It does this by flattening the `SSeq`s and `TSeq`s.
The `SSeq 6 Int` materializes all six elements on the first clock cycle.
Note that the `0` in the below table indicates the element with value `0`, not time `0`.
The hardware perspective diagram does not have labels on the axes.

![SSeq 6 Int Table](other_diagrams/types/seq6/sseq6_table.png "SSeq 6 Int Table")

Note that, until the nested `Seq` example below, there is no flattening to demonstrate with this diagram.

## Flat TSeq With No Invalids
The above `Seq 6 Int` can be converted to an `TSeq 6 0 Int` with six integers on six clock cycles.
Just as with the `SSeq 6 Int` example, there are two diagrams.

The first diagram shows the nested structure of the Aetherling type.
Each box indicates one period of the `TSeq`.
This diagram has six boxes, each with one integer.
If a box contains only atoms and `SSeq`s, then the period for that box is one clock cycle.
Otherwise, the period of the box is computed based on the periods of the elements inside the box.
Therefore, the below diagram indicates one integer per clock for six clocks.

![TSeq 6 0 Int](other_diagrams/types/seq6/tseq60.png "TSeq 6 0 Int")

The second diagram shows the flattened, hardware perspective.
It also shows one integer per clock for six clocks.

![TSeq 6 0 Int Table](other_diagrams/types/seq6/tseq60_table.png "TSeq 6 0 Int Table")

## Flat TSeq With Invalids
The above `Seq 6 Int` can be converted to an `TSeq 6 2 Int` with six integers on eight clock cycles.
Just as with the `SSeq 6 Int` example, there are two diagrams.

The first diagram shows the nested structure of the Aetherling type.
This diagram has eight boxes.
The shaded ones indicate invalid periods with no data.
Therefore, it indicates one integer per clock for six clocks and then two invalid clocks.

![TSeq 6 2 Int](other_diagrams/types/seq6/tseq62.png "TSeq 6 2 Int")

The second diagram shows the flattened, hardware perspective.
It also shows one integer per clock for six clocks and then two invalid clocks.
The shaded regions indicate no data.

![TSeq 6 2 Int Table](other_diagrams/types/seq6/tseq62_table.png "TSeq 6 2 Int Table")


# Nested Sequence
By the [sequence language isomorphisms](Basic.md#sequence-isomorphisms), the above `Seq 6 Int` sequence can be converted into:
```
[[0, 1, 2], [3, 4, 5]] :: Seq 2 (Seq 3 Int)
```

The isomorphism preserves the order of the elements.
Flattening the nested sequence will produce a `Seq 6 Int` with integers in the same order as the initial `Seq 6 Int`.

By the [sequence-to-space-time-isomorphisms](Basic.md#sequence-isomorphisms), both of the `Seq`s in `Seq 2 (Seq 3 Int)` can be converted to a `SSeq` or a `TSeq`.

## Nested SSeq
The above `Seq 2 (Seq 3 Int)` can be converted into a `SSeq 2 (SSeq 3 Int)` with six integers on one clock cycle.

The nested, Aetherling structure diagram shows an outer `SSeq 2`.
Each element of the `SSeq 2` is an `SSeq 3 Int`.
The six integers in total are all on one clock cycle.

![SSeq 2 (SSeq 3 Int)](other_diagrams/types/seq2seq3/sseq2sseq3.png "SSeq 2 (SSeq 3 Int)")

The flattened, hardware diagram is the same as the one for the `SSeq 6 Int`.
All six integers are on one clock cycle.

![SSeq 2 (SSeq 3 Int) Table](other_diagrams/types/seq2seq3/sseq2sseq3_table.png "SSeq 2 (SSeq 3 Int) Table")

## Nested TSeq With no Invalids
The above `Seq 2 (Seq 3 Int)` can be converted into a `TSeq 2 0 (TSeq 3 0 Int)` with six integers on six clock cycle.

The nested, Aetherling structure diagram shows an outer `TSeq 2 0`.
Each element of the `TSeq 2 0` is an `TSeq 3 0 Int`.
The period of `TSeq 3 0 Int` is one clock cycle.
Since each element of the `TSeq 2 0` is a `TSeq 3 0 Int` that takes three clock cycles, the period of `TSeq 2 0 (TSeq 3 0 Int)` is three clock cycles.
The total time for the `TSeq 2 0 (TSeq 3 0 Int)` is `2 periods * 3 clocks / period = 6 clocks`.
The diagram shows that as each outer box, representing an element of the `TSeq 2 0`, contains three inner boxes, representing elements of `TSeq 3 0 Int`. 

![TSeq 2 0 (TSeq 3 0 Int)](other_diagrams/types/seq2seq3/tseq20tseq30.png "TSeq 2 0 (TSeq 3 0 Int)")

The flattened, hardware diagram is the same as the one for the `TSeq 6 0 Int`.
There is one integer per clock for six clock cycles.

![TSeq 2 0 (TSeq 3 0 Int) Table](other_diagrams/types/seq2seq3/tseq20tseq30_table.png "TSeq 2 0 (TSeq 3 0 Int) Table")

## Nested TSeq With Inner Invalids
The above `Seq 2 (Seq 3 Int)` can be converted into a `TSeq 2 0 (TSeq 3 1 Int)` with six integers on eight clock cycle.

The nested, Aetherling structure diagram shows an outer `TSeq 2 0` where each element is a `TSeq 3 1 Int`.
Each of the `TSeq 3 1 Int` has one invalid period.
Note that, unlike the `TSeq 6 2 Int`, one of the invalid periods occurs at the fourth clock cycle.
The diagram indicates this because the fourth inner box is shaded red.

![TSeq 2 0 (TSeq 3 1 Int)](other_diagrams/types/seq2seq3/tseq20tseq31.png "TSeq 2 0 (TSeq 3 1 Int)")

The flattened, hardware diagram is different from the one for `TSeq 6 2 Int`.
They both have six integers over eight clock cycles.
However, one of the invalid clocks occurs earlier in the below diagram. 
It occurs on the fourth clock cycle.

![TSeq 2 0 (TSeq 3 1 Int) Table](other_diagrams/types/seq2seq3/tseq20tseq31_table.png "TSeq 2 0 (TSeq 3 1 Int) Table")

## TSeq of SSeq
The above `Seq 2 (Seq 3 Int)` can be converted into a `TSeq 2 1 (SSeq 3 Int)` with six integers on three clock cycle.

The nested, Aetherling structure diagram shows an outer `TSeq 2 1` where each valid element is a `SSeq 3 Int`.
Since the time of `SSeq 3 Int` is one clock, each period of `TSeq 2 1` takes one clock.
Therefore, the `TSeq 2 1 (SSeq 3 Int)` takes 3 total clocks.

![TSeq 2 1 (SSeq 3 Int)](other_diagrams/types/seq2seq3/tseq21sseq3.png "TSeq 2 1 (SSeq 3 Int)")

The flattened, hardware diagram shows three clock cycles.
The first two each are an `SSeq 3 Int`. 
The last clock cycle is invalid.

![TSeq 2 1 (SSeq 3 Int) Table](other_diagrams/types/seq2seq3/tseq21sseq3_table.png "TSeq 2 1 (SSeq 3 Int) Table")

# Repeatedly Nested `TSeq` And `SSeq` Patterns
The last part of this document will address more complex examples. 
The below examples will not be based on the `Seq 6 Int` sequence like those above.

## TSeq of SSeq of TSeq
This example will be based on the following value in the sequence language:
```
[
    [
        [0, 1, 2], 
        [3, 4, 5]
    ], 
    [
        [6, 7, 8], 
        [9, 10, 11]
    ]
] :: Seq 2 (Seq 2 (Seq 3 Int))
```

By the [sequence-to-space-time-isomorphisms](Basic.md#sequence-isomorphisms), the type can be converted to `TSeq 2 1 (SSeq 2 (TSeq 3 1 Int))`.

The nested, Aetherling structure diagram shows the pattern of `SSeq`s and `TSeq`s.
Note the order of elements in the below diagram. The elements have this order since the `Tseq 3 1` is inside `SSeq 2`.
Also, the total number of clock cycles for this data type is twelve.
Each inner `TSeq` takes four clock cycles.
Each `SSeq` has a period of four clock cycles and takes one period.
The outer `TSeq` has a period of four clock cycles and takes three periods.
Therefore, the total time is twelve clock cycles.

![TSeq 2 1 (SSeq 2 (TSeq 3 1 Int))](other_diagrams/types/complex/tseq21sseq2tseq31.png "TSeq 2 1 (SSeq 2 (TSeq 3 1 Int))")

The flattened, hardware diagram shows twelve clock cycles.
There are two integers per valid clock cycle.
The integers are in an unusual order to match the nesting of `SSeq`s and `TSeq`s.

![TSeq 2 1 (SSeq 2 (TSeq 3 1 Int)) Table](other_diagrams/types/complex/tseq21sseq2tseq31_table.png "TSeq 2 1 (SSeq 2 (TSeq 3 1 Int)) Table")

## TSeq of SSeq of TSeq of SSeq
This example will be based on the following value in the sequence language:
```
[
    [
        [
            [0, 1, 2], 
            [3, 4, 5], 
            [6, 7, 8]
        ], 
        [
            [9, 10, 11],
            [12, 13, 14],
            [15, 16, 17]
        ]
    ], 
    [
        [
            [18, 19, 20], 
            [21, 22, 23], 
            [24, 25, 26]
        ], 
        [
            [27, 28, 29],
            [30, 31, 32],
            [33, 34, 35]
        ]
    ]
] :: Seq 2 (Seq 2 (Seq 3 (Seq 3 Int)))
```

By the [sequence-to-space-time-isomorphisms](Basic.md#sequence-isomorphisms), the type can be converted to `TSeq 2 1 (SSeq 2 (TSeq 3 1 (SSeq 3 Int)))`.

The nested, Aetherling structure diagram shows the pattern of `SSeq`s and `TSeq`s.

![TSeq 2 1 (SSeq 2 (TSeq 3 1 (SSeq 3 Int)))](other_diagrams/types/complex/tseq21sseq2tseq31sseq3.png "TSeq 2 1 (SSeq 2 (TSeq 3 1 (SSeq 3 Int)))")

The flattened, hardware diagram is below.

![TSeq 2 1 (SSeq 2 (TSeq 3 1 (SSeq 3 Int))) Table](other_diagrams/types/complex/tseq21sseq2tseq31sseq3_table.png "TSeq 2 1 (SSeq 2 (TSeq 3 1 (SSeq 3 Int))) Table")

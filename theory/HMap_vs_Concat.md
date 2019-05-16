# Why `HMap` is different from `Concat`
`HMap n fs` compiles either to applying fs to an `SSeq` or a `TSeq`. Either way, joining the outputs is well defined. 
If it's a `SSeq`, all the outputs join on the same clock.
If it's a `TSeq`, all the outputs are on separate clocks.
No delaying is necessary to smooth out the merged streams into an `SSeq` or `TSeq`

With `Concat`, can have the below operation. In it, one `x` will need to be delayed by a cycle in the Concat.
This means the Aetherling compiler will need to track which cycles `x` is empty, store `x`, and repeat it's output.
```
x :: TSeq 1 1 Int
Concat x x
```
Another problematic example. Y and Z could both have a non-empty cycle, empty cycle, non-empty cycle, empty cycle. 
`Concat` will need to figure this out and stall `z`
```
y :: TSeq 2 2 Int
z :: TSeq 2 2 Int
Concat y z
```

How streamit works
Fork, a bunch of functions in parallel, and join
How do they get this to work - streamit tracks the phase of the different inputs by tracking fork distribution strategy (round Robin vs duplicate) and how many  outputs are emitted per input for each phase

They use phase to compute size of buffer in join

I would need to do same, with implicit join, if concat. Instead, I use HMap where I know phaes muse align. If sseq, no phase to consider. If tseq, each operation on different clock so phases are aligned correctly

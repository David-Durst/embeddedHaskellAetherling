# Partition Aetherling Language Theory
This document extends [the basic Aetherling language theory][Basic.md] to support partitions.
It adds:
1. sequence language primitives for partition
1. isomorphisms for nesting the partitions and converting between the sequence and space-time primitives

## Goals
What do I want to do?

I want to take a partition in the sequence language and schedule it in space-time.
For all the prior operators, this has been done in 3 steps:
1. Define space-time operators:
  1. a fully parallel, space operator 
  1. a fully sequential, time operator 
1. Define isomorphisms
  1. isomorphism from seq operator to space operator
  1. isomorphism from seq operator to time operator
  1. isomorphism from the seq operator to the nested version
1. Define scheduling rewrite rules
  1. To schedule fully parallel, convert each seq operator to the space one
  1. To schedule partially parallel, nest each one with the slowdown factor as the outer SSeq length. 
    1. The outer operator becomes the time operator
    1. The inner operator becomes the sequence operator

Scheduling is done by converting Seqs to TSeqs and SSeqs with a certain slowdown.
Slowdown by a factor s does one of three things:
1. s == 1 - make all nested Seqs into SSeqs
1. s > 1, s < n of top Seq - split top nested Seq into TSeq (s) (SSeq (n /
   s) inner) and make all inner Seqs into SSeqs
1. S > 1, s > n of top Seq - make top Seq into TSeq (n) inner, and slowdown inner by (n / s)

For partition, will receive input from a Seq and emit to an Seq (Seq).
Since at most only one of the Seqs in a nesting gets split during scheduling, the needed types for scheduled partition are: 
1. SSeq -> SSeq (SSeq) - `Partition\_s\_ss`
1. TSeq -> TSeq (TSeq) - `Partition\_t\_tt`
1. TSeq (SSeq) -> TSeq (SSeq (SSeq))
  1. This type signature can be produced by either
    1. splitting the outer TSeq into a TSeq (SSeq) - `Partition\_ts\_tss\_split_t`
    1. splitting the inner SSeq into a SSeq (SSeq) - `Map_t (Partition\_s\_ss)`
1. TSeq (SSeq) -> TSeq (TSeq (SSeq))
  1. This type signature can be produced by either
    1. splitting the outer TSeq into a TSeq (TSeq) - `Partition\_ts\_tts\_split_t`
    1. splitting the inner SSeq into a TSeq (SSeq) - `Partition\_ts\_tts\_split_s`

The third type must be produced by splitting the inner SSeq into two SSeqs. Therefore, it i
There are two ways to produce the last two. Either, the outer TSeq is split into
a TSeq (SSeq) or the inner SSeq is split into a SSeq (SSeq).

## Partition Sequence Operators
1. `Partition no ni :: Seq (no*ni) t -> Seq no (Seq ni t)`
7. `Unpartition no ni :: Seq no (Seq ni t) -> Seq (no*ni) t`
## Partition Space-Time Operators
1. `Partition_t_tt no ni :: TSeq (no*ni) 0 t -> TSeq no 0 (TSeq ni 0 t)`
1. `Unpartition_t_tt no ni :: TSeq no 0 (TSeq ni 0 t) -> TSeq no 0 (TSeq ni 0 t)`
1. `Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t)`
1. `Unpartition_s_ss no ni :: SSeq no (SSeq ni t) -> SSeq no (SSeq ni t)`
1. `Partition_ts_tts ni nj nk r: TSeq (ni*nj) (vi) (SSeq nk t) -> TSeq ni vi (TSeq nj vj (SSeq nk 0))`
1. `Unpartition_ts_tts ni nj nk :: TSeq ni 0 (TSeq nj 0 (SSeq nk 0)) -> TSeq (ni*nj) 0 (SSeq nk t)`
-- the next two aren't necessary. Since splitting up the inner SSeq, just accomplish this with map_t over Partition_s_ss 
1. `Partition_ts_tss ni nj nk r: TSeq ni 0 (SSeq (nj*nk)nk t) -> TSeq ni 0 (TSeq nj 0 (SSeq nk 0))`
1. `Unpartition_ts_tss ni nj nk :: TSeq ni 0 (TSeq nj 0 (SSeq nk 0)) -> TSeq (ni*nj) 0 (SSeq nk t)`

## Partition Examples:
1. 




There are 4 options: 
1. fully parallel - then use `Parition_s_ss`
1. fully sequential - then use `Parition_t_tt`
1. partially parallel where splitting outer `TSeq` into 2 `TSeq` - `Parition_ts_tts`
1. partially parallel where splitting inner `SSeq` into 2 `SSeq` - `Map_t(Parition_s_ss)`
can't have any other because any partially parallel must be a Map\_t(Map\_s).
If Partition is nested inside many maps, just need to check the inner most map. The rest get converted as expected as not splitting more than 1 Seq at a time.

What about splitting the inner `Map_s` into a `Map_t (Map_s)` or the outer `Map_t` into a `Map_t (Map_s)`?

```
Map (noo*noi) (Map ni Abs) . Partition (noo*noi) ni === (Seq To TSeq/Seq To SSeq)
Map noo (Map noi (Map ni Abs)) . Map noo (Partition noi ni) === (Seq To TSeq/Seq To SSeq and Isomorphism Removal)
[Type Conversions] . Map_t (noo*noi) (Map_s ni Abs) . q . Seq_To_TSeq . TSeq_To_Seq . Map_t (no o*noi) SSeq_To_Seq . Partition (noo*noi) ni . Map_t (noo*noi) Seq_To_SSeq . Seq_To_TSeq === (Isomorphism Removal)
TSeq_To_Seq . Map_t (noo*noi) SSeq_To_Seq . Map_t (noo*noi) (Map_s ni Abs) . Partition (noo*noi) ni . Map_t (noo*noi) Seq_To_SSeq . Seq_To_TSeq === (Isomorphism Removal)



Map_t noo (Map_s noi (Map_s ni Abs)) . Map_t noo (Partition_s_ss noi ni)
```

```
Map no (Map (nio*nii) Abs) . Partition no (nio*nii) ===




Map_t no (Map_t nio (Map_s nii Abs)) . Partition_ts_tts no nio nii 
not -- Map_t no (Map_t nio (Map_s nii Abs)) . Map_t no (Partition_s_ts nio nii) 
```

```
Partition (noo*noi) ni . Map (noo*noi*ni) Abs ===




Partition_ts_tts noo noi ni . Map_t (noo*noi) (Map_s ni Abs)) 
not -- Map_t noo (Partition_s_ts nio nii) . Map_t (noo*noi) (Map_s nii Abs)) 
```

```
Partition no (nio*nii) ni . Map (no*nio*nii) Abs ===




 Map_t no (Partition_s_ss nio nii) . Map_t no (Map_s (nio*nii) Abs)) 
```


```
Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t)
Partition_s_ts noo noi ni :: TSeq noo (voo + (noo-1)*(noi+voi)) SSeq (no*ni) t -> TSeq noo voo (TSeq noi voi (SSeq ni t)
```
`Partition_s_ts` must have a `TSeq` on both sides. Otherwise, total time won't equal. It also must have an `SSeq` on both sides. As seen by 2 failed examples above with not --, it receives an `SSeq` input in the examples when doing partial parallelism. Finally, must have different number of nestings on both sides to be a `Partition_XX`, so minimal number is 2 `XSeq` on input and 3 `XSeq` on output. This also removes need for Map_t that all examples need

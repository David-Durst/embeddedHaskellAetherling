# Partition Aetherling Language Theory
This document extends [the basic Aetherling language theory](Basic.md) to support partitions.
It adds:
1. sequence language primitives for partition
1. isomorphisms for nesting the partitions and converting between the sequence and space-time primitives

## Goals
The goal is to allow the user to write `Partition` and `Unparitiion` in the
sequence language and schedule it with a slowdown in the space-time IR. 
For all the prior operators, this required operators and rewrite rules:
1. Define space-time operators:
    1. a fully parallel, space operator 
    1. a fully sequential, time operator 
1. Define isomorphisms-based semantics-preserving rewrites
    1. rewrite from seq operator to space operator
    1. rewrite from seq operator to time operator
    1. rewrite from the seq operator to the nested seq operator
1. Define scheduling rewrite rules
    1. To schedule fully parallel, convert each seq operator to the space one
    1. To schedule fully sequential, convert each seq operator to the time one
    1. To schedule partially parallel, nest each one with the slowdown factor as the outer SSeq length. 
        1. The outer operator becomes the time operator
        1. The inner operator becomes the sequence operator

Scheduling is then performed by converting (Seq n t) to TSeqs and SSeqs with a certain slowdown.
Slowdown by a factor s does one of three things:
1. s == 1 - make all nested Seqs into SSeqs
1. s > 1, s < n of top Seq - split top nested Seq into TSeq (s) (SSeq (n /
   s) inner) and make all inner Seqs into SSeqs
1. S > 1, s > n of top Seq - make top Seq into TSeq (n) inner, and slowdown inner by (n / s)

`Partition` receives input from a Seq and emit to an Seq (Seq).
Since at most only one of the Seqs in a nesting gets split during scheduling, 
the following cases must be handled when scheduling. 
For each case, we provide a sketch of the space-time operators that handle it: 
1. `SSeq -> SSeq (SSeq)` - `Partition_s_ss`
1. `TSeq -> TSeq (TSeq)` - `Partition_t_tt`
1. `TSeq (SSeq) -> TSeq (SSeq (SSeq))`
    1. This type signature can be produced by either
        1. splitting the outer TSeq into a TSeq (SSeq) - `Partition_ts_tss_split_t`
        1. splitting the inner SSeq into a SSeq (SSeq) - `Map_t (Partition_s_ss)`
1. `TSeq (SSeq) -> TSeq (TSeq (SSeq))`
    1. This type signature can be produced by either
        1. splitting the outer TSeq into a TSeq (TSeq) - `Partition_ts_tts_split_t`
        1. splitting the inner SSeq into a TSeq (SSeq) - `Partition_ts_tts_split_s`

`Partition` and `Unpartition` cannot be scheduled by just defining fully
parallel and sequential operators, fully parallel and sequential rewrite rules,
and a nesting rewrite rule. Some of the cases require custom operators because:

1. Any Space-Time `Partition` must have `TSeq`s on both input and output.
   Otherwise, it's number of input and output clocks will not be equal.
   Therefore, in cases like 4.1.2, `Map_t (Partition_s_st)` would be insufficient.
1. Implementing `Partition` to only operate on atom types is much simpler than
   allowing it to operate also on `SSeq`s. Since we're already adding
   another `Partition` operator to handle case 4.1.2, we might as well add the
   other two custom operators `Partition_ts_tss_split_t` and
   `Partition_ts_tts_split_t` and make the implementation easier.

## Partition Sequence Operators
1. `Partition no ni :: Seq (no*ni) t -> Seq no (Seq ni t)`
1. `Unpartition no ni :: Seq no (Seq ni t) -> Seq (no*ni) t`

## Partition Space-Time Operators
1. `Partition_t_tt no ni :: TSeq (no*ni) 0 t -> TSeq no 0 (TSeq ni 0 t)`
1. `Unpartition_t_tt no ni :: TSeq no 0 (TSeq ni 0 t) -> TSeq no 0 (TSeq ni 0 t)`
1. `Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t)`
1. `Unpartition_s_ss no ni :: SSeq no (SSeq ni t) -> SSeq no (SSeq ni t)`
1. `Partition_ts_tss_split_t ni nj nk :: TSeq (ni*nj) v (SSeq nk t) -> TSeq ni ((ni-1)*nj + v) (SSeq nj (SSeq nk t))`
1. `Unpartition_ts_tss_split_t ni nj nk :: TSeq ni ((ni-1)*nj + v) (SSeq nj (SSeq nk t)) -> TSeq (ni*nj) v (SSeq nk t)`
1. `Partition_ts_tts_split_t ni nj nk :: TSeq (ni*nj) v (SSeq nk t) -> TSeq ni v (TSeq nj 0 (SSeq nk t))`
    1. Only having one TSeq on the output with empty clocks should be ok. Whatever
      empty clocks the TSeq has, I'll put them all on the outer output TSeq.
1. `Unpartition_ts_tts_split_t ni nj nk :: TSeq ni vi (TSeq nj vj (SSeq nk t)) -> TSeq (ni*nj) (vi + ni*vj) (SSeq nk t)`
1. `Partition_ts_tts_split_s ni nj nk :: TSeq ni v (SSeq (nj*nk) t) -> TSeq ni v (TSeq nj 0 (SSeq nk t))`
1. `Unpartition_ts_tts_split_s ni nj nk :: TSeq ni vi (TSeq nj vj (SSeq nk t)) -> TSeq (ni) (vi + ni*vj) (SSeq (nj*nk) t)`

### Area
1. `area(Partition_t_tt no ni) = {0, 0, 0}`
1. `area(Unpartition_t_tt no ni) = {0, 0, 0}`
1. `area(Partition_s_ss no ni) = {0, 0, 0}`
1. `area(Unpartition_s_ss no ni) = {0, 0, 0}`
1. `area(Partition_ts_tss_split_t ni nj nk) = {0, ((nj-1) * nk) * num_bits(t), (nj * nk) * num_bits(t)} + area(counter)`
1. `area(Unpartition_ts_tss_split_t ni nj nk) = {0, ((nj-1) * nk) * num_bits(t), nk * num_bits(t)} + area(counter)`
1. `area(Partition_ts_tts_split_t ni nj nk) = {0, 0, 0}`
1. `area(Unpartition_ts_tts_split_t ni nj nk) = {0, 0, 0}`
1. `area(Partition_ts_tts_split_s ni nj nk) = {0, ((nj-1) * nk) * num_bits(t), nk * num_bits(t)} + area(counter)`
1. `area(Unpartition_ts_tts_split_s ni nj nk) = {0, ((nj-1) * nk) * num_bits(t), (nj * nk) * num_bits(t)} + area(counter)`

Most of them require no resources as splitting just in time or just in space, or
just in time where each element is an `SSeq` like `Partition_ts_tts_split_t`, is
just reshaping types. The partitioning in those cases doesn't affect how the
atomic elements are distributed in time and space.

## Partition Sequence To Space-Time Semantic Equivalence
In the [basic theory document](Basic.md) we used isomorphisms created with the `Partition`, `Unpartition`, and Seq/TSeq/SSeq converters to show semantic equivalence between the sequence and space-time operators other than `Partition` and `Unparition`.
In this document, we use the isomorphisms to do the same for `Partition` and `Unparitition`'s sequence and space-time operators.

As shown in the prior section, there are many ways to partition and unpartition while preserving semantics.
We provide one examples of the rewrite rules
```
Partition (ni*nj) nk === Unpartition . TSeq_To_SSeq . Map_t ni (SSeq_To_Seq) . Map_t ni (Map_s nj (SSeq_to_Seq)) . Partition_ts_tss_split_t . Map_t (ni*nj) (Seq_to_SSeq) . Seq_To_TSeq . Partition
```

All other semantic equivalence proofs follow the same pattern.

## Partition Examples:
Here we show how the rewrite rules are used in example applications.
We elide the intermediate steps. Since the types of the operators match, their `Seq`/`TSeq`/`SSeq` and `Partition`/`Unpartition` operators must all cancel out.
We use the `===~` operator here because we are ignoring the isomorphism operators on the ends of the equations.

Case 1: `Seq -> SSeq (SSeq)`
```
Map ni (Map nj Abs) . Partition ni nj . Map (ni*nj) Abs ===~ 
Map_s ni (Map_s nj Abs) . Partition_s_ss ni nj . Map_s (ni*nj) Abs 
```

Case 2: `TSeq -> TSeq (TSeq)`
```
Map ni (Map nj Abs) . Partition ni nj . Map (ni*nj) Abs ===~
Map_t ni (Map_t nj Abs) . Partition_t_tt ni nj . Map_t (ni*nj) Abs 
```

Case 3.1.1: `TSeq (SSeq) -> TSeq (SSeq (SSeq))` - splitting outer `TSeq`
```
Map (ni*nj) (Map nk Abs) . Partition (ni*nj) nk . Map (ni*nj*nk) Abs ===~
Map_t ni (Map_s nj (Map_s nj Abs)) . Partition_ts_tss_split_t ni nj nk . Map_t (ni*nj) (Map_s nk Abs) 
```

Case 3.1.2: `TSeq (SSeq) -> TSeq (SSeq (SSeq))` - splitting inner `SSeq`
```
Map ni (Map (nj*nk) Abs) . Partition ni (nj*nk) . Map (ni*nj*nk) Abs ===~
Map_t ni (Map_s nj (Map_s nj Abs)) . Map_t ni (Partition_s_ss_split_s nj nk) . Map_t ni (Map_s (nj*nk) Abs) 
```

Case 4.1.1: `TSeq (SSeq) -> TSeq (TSeq (SSeq))` - splitting outer `TSeq`
```
Map (ni*nj) (Map nk Abs) . Partition (ni*nj) nk . Map (ni*nj*nk) Abs ===~
Map_t ni (Map_t nj (Map_s nj Abs)) . Partition_ts_tts_split_t ni nj nk . Map_t (ni*nj) (Map_s nk Abs) 
```

Case 4.1.2: `TSeq (SSeq) -> TSeq (TSeq (SSeq))` - splitting inner `SSeq`
```
Map ni (Map (nj*nk) Abs) . Partition ni (nj*nk) . Map (ni*nj*nk) Abs ===~
Map_t ni (Map_t nj (Map_s nj Abs)) . Partition_ts_tts_split_s ni nj nk . Map_t ni (Map_s (nj*nk) Abs) 
```

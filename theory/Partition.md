# Partition Aetherling Language Theory
This document extends [the basic sequence language and space-time IR](Basic.md) to support partitions.
It adds:
1. `Partition` and `Unpartition` sequence language operators
1. Semantically equivalent space-time IR operators
1. Nesting, Sequence to Space, Sequence to Time, and Sequence to Space-Time rewrite rules

# Sequence Language
## Operators
1. `Partition no ni :: Seq (no*ni) t -> Seq no (Seq ni t)`
1. `Unpartition no ni :: Seq no (Seq ni t) -> Seq (no*ni) t`

## Nesting Rewrite Rules
These rewrite rules preserve semantics due to the [sequence isomorphisms in the basic language document](Basic.md#sequence-isomorphisms).
The proof is slightly different. The operators that form the isomorphisms are compositions of `Partition` and `Unpartition`.

### Partition
1. **`Partition` Nesting Outer** - `Partition (ni*nj) nk t === Unpartition ni nj (Seq nk t) .  Partition ni nj (Seq nk t) . Partition (ni*nj) nk t`
1. **`Partition` Nesting Inner** - `Partition ni (nj*nk) nk t === Map ni (Unpartition nj nk t) .  Map ni (Partition nj nk t) . Partition ni (nj*nk) t`

### Unpartition
1. **`Unpartition` Nesting Outer** - `Unpartition (ni*nj) nk t === Unpartition (ni*nj) nk t . Unpartition ni nj (Seq nk t) . Partition ni nj (Seq nk t)`
1. **`Unpartition` Nesting Inner** - `Unpartition ni (nj*nk) nk t === Unpartition ni (nj*nk) t .  Map ni (Unpartition nj nk t) . Map ni (Partition nj nk t)`

# Space-Time IR
## Operators
1. `Partition_t_tt no ni :: TSeq (no*ni) (vo*vi) t -> TSeq no vo (TSeq ni vi t)`
1. `Unpartition_t_tt no ni :: TSeq no vo (TSeq ni vi t) -> TSeq (no*ni) (vo*vi) t`
1. `Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t)`
1. `Unpartition_s_ss no ni :: SSeq no (SSeq ni t) -> SSeq no (SSeq ni t)`
1. `Partition_t_ts no ni :: TSeq (no*ni) v -> TSeq no (v + no*(ni-1)) (SSeq ni no)`
1. `Unpartition_t_ts no ni :: TSeq no (v + no*(ni-1)) (SSeq ni no) -> TSeq (no*ni) v`
1. `Partition_ts_tts_split_s ni nj nk :: TSeq ni (vi + ni*(nj + vj - 1)) (SSeq (nj*nk) t) -> TSeq ni vi (TSeq nj vj (SSeq nk t))`
1. `Unpartition_ts_tts_split_s ni nj nk :: TSeq ni vi (TSeq nj vj (SSeq nk t)) -> TSeq ni (vi + ni*(nj + vj - 1)) (SSeq (nj*nk) t)`

## Area Property
1. `area(Partition_t_tt no ni) = {0, 0, 0}`
1. `area(Unpartition_t_tt no ni) = {0, 0, 0}`
1. `area(Partition_s_ss no ni) = {0, 0, 0}`
1. `area(Unpartition_s_ss no ni) = {0, 0, 0}`
1. `area(Partition_t_ts no ni) = {0, (ni-1) * num_bits(t), ni * num_bits(t)} + area(counter)`
1. `area(Unpartition_t_ts ni nj nk) = {0, (ni-1) * num_bits(t), ni * num_bits(t)} + area(counter)`
1. `area(Partition_ts_tts_split_s ni nj nk) = {0, ((nj-1) * nk) * num_bits(t), nk * num_bits(t)} + area(counter)`
1. `area(Unpartition_ts_tts_split_s ni nj nk) = {0, ((nj-1) * nk) * num_bits(t), (nj * nk) * num_bits(t)} + area(counter)`

## Sequence To Space-Time Rewrite Rules
These rewrite rules preserve semantics due to the [sequence to space-time isomorphisms in the basic language document](Basic.md#sequence-to-space-time-isomorphisms).
The proof is slightly different. The operators that form the isomorphisms are compositions of `Partition`, `Unpartition`, and `Map`.

### Partition
1. Sequence To Space - `Partition no ni === SSeq_To_Seq . Map_s no (SSeq_To_Seq) . Partition_s_ss . Seq_To_SSeq`
1. Sequence To Time - `Partition no ni === TSeq_To_Seq . Map_t no (TSeq_To_Seq) . Partition_t_tt . Seq_To_TSeq`
1. Sequence To Space-Time - `Partition no ni === TSeq_To_Seq . Map_t no (SSeq_To_Seq) . Partition_t_ts . Seq_To_TSeq`
1. Outer Sequence To Space-Time With Throughput `nj` Less than Fully Parallel -
```
Partition (ni*nj) nk === (Nesting Outer)
Unpartition ni nj (Seq nk t) . Partition ni nj (Seq nk t) . Partition (ni*nj) nk t === (Seq To Space-Time)
Unpartition ni nj (Seq nk t) . TSeq_To_Seq . Map_t ni (SSeq_To_Seq) . Partition_t_ts ni nj (Seq nk t) . Seq_To_TSeq . Partition (ni*nj) nk t === (Seq To Space)
```

**PROBLEM: Need a Partition other than `Partition_s_ss` and `Partition_t_tt` to split the `Seq` into the `TSeq (SSeq)`**
**SOLUTION: Add `Partition_t_ts`**

1. Inner Sequence To Space-Time With Throughput `ni*nj` Less than Fully Parallel -
```
Partition ni (nj*nk) ===
TSeq_To_Seq . Map_t ni (Unpartition nj nk) . Map_t ni (TSeq_To_Seq) . Map_t ni (Map_t nj (SSeq_To_Seq)) . Partition_ts_tts_split_s ni nj nk . Map_t ni (Seq_To_SSeq) . Seq_To_TSeq . Partition ni (nj*nk)`
```

**PROBLEM: `Partition_s_ts no ni :: SSeq (no*ni) t -> TSeq no v (SSeq ni t)` can't exist. It breaks that assumption that `type_time(t) == type_time(t')` for all `f :: t -> t'`. Thus, the following approach using more standard operators doesn't work:** 
```
Partition ni (nj*nk) === (Nesting Inner)
Map ni (Unpartition nj nk t) .  Map ni (Partition nj nk t) . Partition ni (nj*nk) t === (Seq To Space)
Map ni (Unpartition nj nk t) . SSeq_To_Seq . Map_s ni (Partition_s_ts nj nk t) . Seq_To_SSeq . Partition ni (nj*nk) t === (Seq To Space)
```
**SOLUTION: Add `Partition_ts_tts_split_s`**

### Unpartition
1. Sequence To Space - `Unpartition no ni === SSeq_To_Seq . Partition_s_ss . Map_t no (SSeq_To_Seq) . SSeq_To_Seq`
1. Sequence To Time - `Unpartition no ni === TSeq_To_Seq . Partition_t_tt . Map_t no (TSeq_To_Seq) . TSeq_To_Seq`

# Why Partition Needs Custom Operators
During scheduling, at most one of the Seqs in the input and output types may be split. 
When scheduling other operators that are of the form `Seq n t -> Seq n t'`, there is only
one possible way to split the `Seq`s. Both the input and output `Seq` must be split in the same way. 
However, `Partition no ni :: Seq (no*ni) t -> Seq no (Seq ni t)` can be split in multiple ways.
For each case, we provide a sketch of the space-time operators that handle it.
Also, we denote that some of these splits cannot occur in the scheduling algorithm so we don't need
to handle them. 
A split only occurs in the scheduling algorithm if splitting a `Seq` into a `TSeq (SSeq)`
1. `TSeq (SSeq) -> TSeq (SSeq (SSeq))`
    1. This type signature can be produced by either
        1. splitting the outer Seq into a TSeq (SSeq) - `Partition_t_ts` with `t' = SSeq`
        1. splitting the inner Seq into a SSeq (SSeq) - `Map_t (Partition_s_ss)`
            1. This can never happen, not splitting into a TSeq (SSeq)
1. `TSeq (SSeq) -> TSeq (TSeq (SSeq))`
    1. This type signature can be produced by either
        1. splitting the outer Seq into a TSeq (TSeq) - `Partition_t_tt` with `t' = SSeq`
            1. This can never happen, not splitting into a TSeq (SSeq)
        1. splitting the inner Seq into a TSeq (SSeq) - `Partition_ts_tts_split_s`

1. Any Space-Time `Partition` must have `TSeq`s on both input and output.
   Otherwise, it's number of input and output clocks will not be equal.
   Therefore, in cases like 4.1.2, `Map_t (Partition_s_st)` would be insufficient.

# Space-Time IR
## Operators
1. `Partition_t_tt no ni :: TSeq (no*ni) 0 t -> TSeq no 0 (TSeq ni 0 t)`
1. `Unpartition_t_tt no ni :: TSeq no 0 (TSeq ni 0 t) -> TSeq no 0 (TSeq ni 0 t)`
1. `Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t)`
1. `Unpartition_s_ss no ni :: SSeq no (SSeq ni t) -> SSeq no (SSeq ni t)`
1. `Partition_ts_tss_split_t ni nj nk :: TSeq (ni*nj) v (SSeq nk t) -> TSeq ni (v + ni*(nj - 1)) (SSeq nj (SSeq nk t))`
1. `Unpartition_ts_tss_split_t ni nj nk :: TSeq ni (v + ni*(nj - 1)) (SSeq nj (SSeq nk t)) -> TSeq (ni*nj) v (SSeq nk t)`
1. `Partition_ts_tts_split_t ni nj nk :: TSeq (ni*nj) (vi + ni*vj) (SSeq nk t) -> TSeq ni vi (TSeq nj vj (SSeq nk t))`
    1. Only having one TSeq on the output with empty clocks should be ok. Whatever
      empty clocks the TSeq has, I'll put them all on the outer output TSeq.
1. `Unpartition_ts_tts_split_t ni nj nk :: TSeq ni vi (TSeq nj vj (SSeq nk t)) -> TSeq (ni*nj) (vi + ni*vj) (SSeq nk t)`
1. `Partition_ts_tts_split_s ni nj nk :: TSeq ni (vi + ni*(nj + vj - 1)) (SSeq (nj*nk) t) -> TSeq ni vi (TSeq nj vj (SSeq nk t))`
1. `Unpartition_ts_tts_split_s ni nj nk :: TSeq ni vi (TSeq nj vj (SSeq nk t)) -> TSeq ni (vi + ni*(nj + vj - 1)) (SSeq (nj*nk) t)`


## Sequence Language To Space-Time IR Rewrite Rules
These rewrite rules preserve semantics due to the [sequence to space-time isomorphisms in the basic language document](Basic.md#sequence-to-space-time-isomorphisms)

### Partition
1. Sequence To Space - 


Most of them require no resources as splitting just in time or just in space, or
just in time where each element is an `SSeq` like `Partition_ts_tts_split_t`, is
just reshaping types. The partitioning in those cases doesn't affect how the
atomic elements are distributed in time and space.

## Goals
The goal is to allow the user to write `Partition` and `Unparitiion` in the
sequence language and schedule in the space-time IR with a target throughput.
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

Scheduling is then performed by converting `Seq`s to `TSeq`s and `SSeq`s.
Different throughput schedules are expressed by different computations of `TSeq`s and `SSeq`s.
Scheduling a program P with a target throughput t is done by:
1. Let t_full be the throughput by of P when fully parallelized
1. Let t = t_full / s
1. Each `Seq n` is converted to `TSeq` and `SSeq` by:
    1. s == 1 - make all nested Seqs into SSeqs
    1. s > 1, s < n of top Seq - split top nested Seq into TSeq (s) (SSeq (n /
      s) inner) and make all inner Seqs into SSeqs
    1. S > 1, s > n of top Seq - make top `Seq` into `TSeq n` inner, schedule the inner `Seq` with s'=(n / s)


`Partition` and `Unpartition` cannot be scheduled by just defining fully
parallel and sequential operators, fully parallel and sequential rewrite rules,
and a nesting rewrite rule. Some of the cases require custom operators because:





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

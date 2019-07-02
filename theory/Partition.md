# Partition and Unpartition Operators
This document extends [the basic sequence language and space-time IR](Basic.md) to support partitions.
It adds:
1. `Partition` and `Unpartition` sequence language operators
1. Semantically equivalent space-time IR operators
1. Rewrite rules between the sequence language and space-time IR operators
1. An explanation of why the `Partition` and `Unpartition` operators need custom operators and rewrite rules

# Sequence Language
## Operators
1. `Partition no ni :: Seq (no*ni) t -> Seq no (Seq ni t)`
1. `Unpartition no ni :: Seq no (Seq ni t) -> Seq (no*ni) t`

**Note:** `Partition` and `Unpartition` are inverses.

## Nesting Rewrite Rules
These rewrite rules preserve semantics when the input to `Partition` and output from `Unpartition` is nested, meaning it's `Seq no (Seq ni t)`.
They can be proven directly from the [sequence isomorphisms in the basic language document](Basic.md#sequence-isomorphisms).
However, we proven them from the other rewrite rules because it is easier to understand. 

Unlike the [sequence operators in the basic document](Basic.md#sequence-isomorphisms), 
`Partition` and `Unpartition` each require two nesting rewrite rules.
The rules are part of the [Inner and Outer Sequence To Space-Time rewrite rules below.](#sequence-to-space-time-rewrite-rules).
The scheduling algorithm requires these Sequence To Space-Time rewrite rules.
See the [scheduling algorithm](Scheduling.md) for why and how the rules are used.


### Example Apps For Partition
These apps make it easier to understand when the partition nesting rules will be used
When partition is composed with other operators, will be doing nesting rewrite ruleson  other operators too.
Those rewrite rules will make an outer `Seq` that is either greater than, equal to, or less than the outer `Seq` that Partition is making.
These apps show when to use each `Partition` nesting rewrite rule to fit in the pipelines.

#### Nesting by Factor Greater Than `Partition ni`
```
Partition ni (nj*nk) . Map (ni*nj*nk) Abs ===
Map ni (Unpartition ni nj) . Partition ni nj . Partition (ni*nj) nk . Unpartition (ni*nj) nk . Map (ni*nj) (Map nk f) . Partition (ni*nj) nk ===
Map ni (Unpartition ni nj) . Partition ni nj . Map (ni*nj) (Map nk f) . Partition (ni*nj) nk ===
```

#### Nesting by Factor Equal To `ni`
```
Partition ni (nj*nk) . Map (ni*nj*nk) Abs ===
Partition ni (nj*nk) . Unpartition ni (nj*nk) . Map ni (Map (nj*nk) f) . Partition ni (nj*nk) ===
Map ni (Map (nj*nk) f) . Partition ni (nj*nk) ===
```

#### Nesting By Factor Less Than `ni*nj`
```
Partition (ni*nj) nk . Map (ni*nj*nk) Abs ===
Unpartition ni nj . Map ni (Partition nj nk) . Partition ni (nj*nk) . Unpartition ni (nj*nk) . Map ni (Map (nj*nk) f) . Partition ni (nj*nk) ===
Unpartition ni nj . Map ni (Partition nj nk) . Map ni (Map (nj*nk) f) . Partition ni (nj*nk)
```

### Partition
#### `Partition` Nesting with outer `Seq` `nj` less than `Partition`'s outer `Seq`
```
Partition (ni*nj) nk === (Identity Addition)
Id . Partition (ni*nj) nk === (Isomorphism Addition)
Unpartition ni nj . Partition ni nj . Partition (ni*nj) nk ===? (Commutativity)
Unpartition ni nj . Map ni (Partition nj nk) . Partition ni (nj*nk)
```

#### `Partition` Nesting with outer `Seq` `nj` greater than `Partition`'s outer `Seq`
```
Partition ni (nj*nk) t === (Identity Addition)
Id . Partition ni (nj*nk) t === (Map-Identity)
Map ni id . Partition ni (nj*nk) t === (Isomorphism Addition)
Map ni (Unpartition nj nk t . Partition nj nk t) . Partition ni (nj*nk) t === (Functor Fusion)
Map ni (Unpartition nj nk t) . Map ni (Partition nj nk t) . Partition ni (nj*nk) t ===? (Commutativity)
Map ni (Unpartition nj nk t) . Partition ni nj (Seq nk t) . Partition (ni*nj) nk t (Commutativity)
```


#### Examples Of Partition And Unpartition Nesting In Applications
I don't think these applications are necessary. The above rules handle them.
##### Nesting Outer 
The goal here is to have an outer `Map ni` on each application so, when map to space-time, can slow down by `ni`.
```
Map (ni*nj) (Map nk Abs) . Partition (ni*nj) nk . Map (ni*nj*nk) Abs === (Nesting Outer)

Unpartition ni nj . Map ni (Map nj (Map nk Abs)) . Partition ni nj .
    Unpartition ni nj . Partition ni nj . Partition (ni*nj) nk .
    Unpartition (ni*nj) nk . Map (ni*nj) (Map nk Abs) . Partition (ni*nj) nk === (Isomorphism Removal)

Unpartition ni nj . Map ni (Map nj (Map nk Abs)) .
    Partition ni nj .
    Map (ni*nj) (Map nk Abs) . Partition (ni*nj) nk === (Isomorphism Removal)

```

##### Nesting Inner
The goal here is to have an outer `Map (ni*nj)` on each application so, when map to space-time, can slow down by `ni*nj`.

```
Map ni (Map (nj*nk) Abs) . Partition ni (nj*nk) . Map (ni*nj*nk) Abs === (Nesting Inner)

Map ni (Unpartition nj nk . Map nj (Map nk Abs) . Partition nj nk) .
    Map ni (Unpartition nj nk) . Map ni (Partition nj nk) . Partition ni (nj*nk) .
    Unpartition ni (nj*nk) . Map ni (Map (nj*nk) Abs) . Partition ni (nj*nk)  === (Isomorphism Removal)

Map ni (Unpartition nj nk . Map nj (Map nk Abs) . Partition nj nk) .
    Map ni (Unpartition nj nk) . Map ni (Partition nj nk) .
    Map ni (Map (nj*nk) Abs) . Partition ni (nj*nk)  === (Map Functor Fusion)

Map ni (Unpartition nj nk) . Map ni (Map nj (Map nk Abs)) . Map ni (Partition nj nk) .
    Map ni (Unpartition nj nk) . Map ni (Partition nj nk) .
    Map ni (Map (nj*nk) Abs) . Partition ni (nj*nk)  === (Isomorphism Removal)

Map ni (Unpartition nj nk) . Map ni (Map nj (Map nk Abs)) .
    Map ni (Partition nj nk) .
    Map ni (Map (nj*nk) Abs) . Partition ni (nj*nk)  === (Isomorphism Removal)
```

**Should the middle resulting term be `Partition ni nj`? Should I apply the partition commutativity rule here?**
**Do I need the Unit Changes rules as well?**

### Unpartition
Note: the type parameters are not actually part of the `Unpartition`, but are included in the following proofs for interpretability.
#### `Unpartition` Nesting Outer
```
Unpartition (ni*nj) nk t === (Identity Addition)
Unpartition (ni*nj) nk t . Id === (Isomorphism Addition)
Unpartition (ni*nj) nk t . Unpartition ni nj (Seq nk t) . Partition ni nj (Seq nk t) 
```

#### `Unpartition` Nesting Inner
```
Unpartition ni (nj*nk) t === (Identity Addition)
Unpartition ni (nj*nk) t . Id === (Map-Identity)
Unpartition ni (nj*nk) t . Map ni id === (Isomorphism Addition)
Unpartition ni (nj*nk) t . Map ni (Unpartition nj nk t . Partition nj nk t) === (Functor Fusion)
Unpartition ni (nj*nk) t . Map ni (Unpartition nj nk t) . Map ni (Partition nj nk t)
```

#### 

# Space-Time IR
## Operators
1. `Partition_t_tt no ni :: TSeq (no*ni) (vo + no*vi) t -> TSeq no vo (TSeq ni vi t)`
1. `Unpartition_t_tt no ni :: TSeq no vo (TSeq ni vi t) -> TSeq (no*ni) (vo + no*vi) t`
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
The Sequence To Space, Sequence To Time, Sequence To Space-Time, and Mapped Sequence To Space-Time rewrite rules preserve semantics due to the [sequence to space-time isomorphisms in the basic language document](Basic.md#sequence-to-space-time-isomorphisms).
The proof is slightly different. These isomorphisms involve `Map` of the normal isomorphism-forming operators like `Seq_To_SSeq`.

The Outer and Inner rewrite rules are derived from the other ones in this section.

### Partition

#### Sequence To Space 
`Partition no ni === SSeq_To_Seq . Map_s no (SSeq_To_Seq) . Partition_s_ss . Seq_To_SSeq`

#### Sequence To Time 
`Partition no ni === TSeq_To_Seq . Map_t no (TSeq_To_Seq) . Partition_t_tt . Seq_To_TSeq`

#### Sequence To Space-Time 
`Partition no ni === TSeq_To_Seq . Map_t no (SSeq_To_Seq) . Partition_t_ts . Seq_To_TSeq`

#### Mapped Sequence To Space-Time
```
Map ni (Partition nj nk) === 
TSeq_To_Seq . Map_t ni (TSeq_To_Seq) . Map_t ni (Map_t nj (SSeq_To_Seq)) . Partition_ts_tts_split_s ni nj nk . Map_t ni (Seq_To_SSeq) . Seq_To_TSeq
```

#### Outer Sequence To Space-Time With Throughput `ni` Less than Fully Parallel
```
Partition (ni*nj) nk === (Nesting Outer)
Unpartition ni nj (Seq nk t) . Partition ni nj (Seq nk t) . Partition (ni*nj) nk t === (Seq To Space-Time)
Unpartition ni nj (Seq nk t) . TSeq_To_Seq . Map_t ni (SSeq_To_Seq) . Partition_t_ts ni nj (Seq nk t) . Seq_To_TSeq . Partition (ni*nj) nk t
```

**Note:** The scheduling algorithm will handle converting the `Seq` in `Partition_t_ts ni nj (Seq nk t)` to a `TSeq`.

**WE HAD A PROBLEM: Need a Partition other than `Partition_s_ss` and `Partition_t_tt` to split the `Seq` into the `TSeq (SSeq)`**
**SOLUTION: Add `Partition_t_ts`**

#### Inner Sequence To Space-Time With Throughput `ni*nj` Less than Fully Parallel
```
Partition ni (nj*nk) === (Nesting Inner)
Map ni (Unpartition nj nk t) . Map ni (Partition nj nk t) . Partition ni (nj*nk) t === (Mapped Sequence To Space-Time)
Map ni (Unpartition nj nk t) . TSeq_To_Seq . Map_t ni (TSeq_To_Seq) . Map_t ni (Map_t nj (SSeq_To_Seq)) . Partition_ts_tts_split_s ni nj nk . Map_t ni (Seq_To_SSeq) . Seq_To_TSeq . Partition ni (nj*nk) t
```

**WE HAD A PROBLEM**: `Partition_s_ts no ni :: SSeq (no*ni) t -> TSeq no v (SSeq ni t)` can't exist. It breaks that assumption that `type_time(t) == type_time(t')` for all `f :: t -> t'`. Thus, the following approach using more standard operators doesn't work:** 
**SOLUTION: Add `Partition_ts_tts_split_s`**

### Unpartition

#### Sequence To Space
`Unpartition no ni === SSeq_To_Seq . Partition_s_ss . Map_t no (SSeq_To_Seq) . SSeq_To_Seq`

#### Sequence To Time 
`Unpartition no ni === TSeq_To_Seq . Partition_t_tt . Map_t no (TSeq_To_Seq) . TSeq_To_Seq`

#### Sequence To Space-Time
`Unpartition no ni === TSeq_To_Seq . Unpartition_t_ts no ni . Map_t no (Seq_To_SSeq) . Seq_To_TSeq`

#### Mapped Sequence To Space-Time
```
Map ni (Unpartition nj nk) === 
TSeq_To_Seq . Map_t ni (SSeq_To_Seq) . Unpartition_ts_tts_split_s ni nj nk . Map_t ni (Map_t nj (Seq_To_SSeq)) . Map_t ni (Seq_To_TSeq) . Seq_To_TSeq
```

#### Outer Sequence To Space-Time With Throughput `ni` Less than Fully Parallel
```
Unpartition (ni*nj) nk === (Nesting Outer)
Unpartition (ni*nj) nk t . Unpartition ni nj (Seq nk t) . Partition ni nj (Seq nk t) === (Seq To Space-Time)
Unpartition (ni*nj) nk t . TSeq_To_Seq . Unpartition_t_ts ni nj (Seq nk t) . Map_t ni (Seq_To_SSeq) . Seq_To_TSeq . Partition ni nj (Seq nk t) 
```

#### Inner Sequence To Space-Time With Throughput `ni*nj` Less than Fully Parallel
```
Unpartition ni (nj*nk) === (Nesting Inner)
Unpartition ni (nj*nk) t . Map ni (Unpartition nj nk t) . Map ni (Partition nj nk t) === (Mapped Sequence To Space-Time)
Unpartition ni (nj*nk) t . TSeq_To_Seq . Map_t ni (SSeq_To_Seq) . Unpartition_ts_tts_split_s ni nj nk . Map_t ni (Map_t nj (Seq_To_SSeq)) . Map_t ni (Seq_To_TSeq) . Seq_To_TSeq . Map ni (Partition nj nk t)
```

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

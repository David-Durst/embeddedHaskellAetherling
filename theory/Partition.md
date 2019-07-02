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

#### Nesting By Factor Less Than `ni*nj`
```
Partition (ni*nj) nk . Map (ni*nj*nk) Abs ===
Unpartition ni nj . Map ni (Partition nj nk) . Partition ni (nj*nk) . Unpartition ni (nj*nk) . Map ni (Map (nj*nk) f) . Partition ni (nj*nk) ===
Unpartition ni nj . Map ni (Partition nj nk) . Map ni (Map (nj*nk) f) . Partition ni (nj*nk)
```

#### Nesting by Factor Equal To `ni`
```
Partition ni (nj*nk) . Map (ni*nj*nk) Abs ===
Partition ni (nj*nk) . Unpartition ni (nj*nk) . Map ni (Map (nj*nk) f) . Partition ni (nj*nk) ===
Map ni (Map (nj*nk) f) . Partition ni (nj*nk) ===
```

#### Nesting by Factor Greater Than `ni`
```
Partition ni (nj*nk) . Map (ni*nj*nk) Abs ===
Map ni (Unpartition ni nj) . Partition ni nj . Partition (ni*nj) nk . Unpartition (ni*nj) nk . Map (ni*nj) (Map nk f) . Partition (ni*nj) nk ===
Map ni (Unpartition ni nj) . Partition ni nj . Map (ni*nj) (Map nk f) . Partition (ni*nj) nk ===
```

### Partition
#### Nesting with Outer `Seq` `nj` Less Than `Partition`'s Outer `Seq`
```
Partition (ni*nj) nk === (Identity Addition)
Id . Partition (ni*nj) nk === (Isomorphism Addition)
Unpartition ni nj . Partition ni nj . Partition (ni*nj) nk ===? (Commutativity)
Unpartition ni nj . Map ni (Partition nj nk) . Partition ni (nj*nk)
```

#### Nesting with Outer `Seq` Equal To `Partition`'s Outer `Seq`
Do Nothing. The `Unpartition no ni` from applying the nesting rewrite rule to upstream will obliterate this and the downstream is already partitioned appropriately by `no` and `ni`.
```
Partition no ni
```

#### Nesting with Outer `Seq` `nj` Greater Than `Partition`'s Outer `Seq`
```
Partition ni (nj*nk) === (Identity Addition)
Id . Partition ni (nj*nk) === (Map-Identity)
Map ni id . Partition ni (nj*nk) === (Isomorphism Addition)
Map ni (Unpartition nj nk . Partition nj nk) . Partition ni (nj*nk) === (Functor Fusion)
Map ni (Unpartition nj nk) . Map ni (Partition nj nk) . Partition ni (nj*nk) ===? (Commutativity)
Map ni (Unpartition nj nk) . Partition ni nj . Partition (ni*nj) nk 
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
#### Nesting with Outer `Seq` `nj` Less Than `Unpartition`'s Outer `Seq`
```
Unpartition (ni*nj) nk === (Identity Addition)
Unpartition (ni*nj) nk . Id === (Isomorphism Addition)
Unpartition (ni*nj) nk . Unpartition ni nj . Partition ni nj ===? (Commutativity)
Unpartition ni (nj*nk) . Map ni (Unpartition nj nk) . Partition ni nj
```

#### Nesting With Outer `Seq` Equal To `UpPartition`'s Outer `Seq`
Do Nothing. The `Partition no ni` from applying the nesting rewrite rule to downstream will obliterate this and the upstream is already partitioned appropriately by `no` and `ni`.
```
Unpartition no ni
```

#### Nesting With Outer `Seq` `nj` Greater Than `Unpartition`'s Outer `Seq`
```
Unpartition ni (nj*nk) === (Identity Addition)
Unpartition ni (nj*nk) . Id === (Map-Identity)
Unpartition ni (nj*nk) . Map ni id === (Isomorphism Addition)
Unpartition ni (nj*nk) . Map ni (Unpartition nj nk . Partition nj nk) === (Functor Fusion)
Unpartition ni (nj*nk) . Map ni (Unpartition nj nk) . Map ni (Partition nj nk) ===? (Commutatvity)
Unpartition (ni*nj) nk . Unpartition ni nj . Map ni (Partition nj nk)
```

# Space-Time IR
## Operators
1. `Partition_t_tt no ni :: TSeq (no*ni) (vo + no*vi) t -> TSeq no vo (TSeq ni vi t)`
1. `Unpartition_t_tt no ni :: TSeq no vo (TSeq ni vi t) -> TSeq (no*ni) (vo + no*vi) t`
1. `Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t)`
1. `Unpartition_s_ss no ni :: SSeq no (SSeq ni t) -> SSeq no (SSeq ni t)`

## Area Property
1. `area(Partition_t_tt no ni) = {0, 0, 0}`
1. `area(Unpartition_t_tt no ni) = {0, 0, 0}`
1. `area(Partition_s_ss no ni) = {0, 0, 0}`
1. `area(Unpartition_s_ss no ni) = {0, 0, 0}`

## Sequence To Space-Time Rewrite Rules
The Sequence To Space, Sequence To Time, Sequence To Space-Time, and Mapped Sequence To Space-Time rewrite rules preserve semantics due to the [sequence to space-time isomorphisms in the basic language document](Basic.md#sequence-to-space-time-isomorphisms).
The proof is slightly different. These isomorphisms involve `Map` of the normal isomorphism-forming operators like `Seq_To_SSeq`.

The Outer and Inner rewrite rules are derived from the other ones in this section.

### Partition

#### Sequence To Space 
`Partition no ni === SSeq_To_Seq . Map_s no (SSeq_To_Seq) . Partition_s_ss . Seq_To_SSeq`

#### Sequence To Time 
`Partition no ni === TSeq_To_Seq . Map_t no (TSeq_To_Seq) . Partition_t_tt . Seq_To_TSeq`

#### Sequence To Space-Time with Outer `Seq` `nj` Less Than `Partition`'s Outer `Seq`
```
Partition (ni*nj) nk === (Partition Nesting Less Than)
Unpartition ni nj . Map ni (Partition nj nk) . Partition ni (nj*nk) === (Seq To TSeq)

Unpartition ni nj . 
    TSeq_To_Seq . Map_t ni (Partition nj nk) . Seq_To_TSeq .
    Partition ni (nj*nk) === (Seq To SSeq)

Unpartition ni nj . 
    TSeq_To_Seq . Map_t ni (SSeq_To_Seq . Map_s nj SSeq_To_Seq . Partition_s_ss nj nk . Seq_To_SSeq) . Seq_To_TSeq .
    Partition ni (nj*nk) === (Functor Map Fusion)

Unpartition ni nj . 
    TSeq_To_Seq . Map_t ni SSeq_To_Seq . Map_t ni (Map_s nj SSeq_To_Seq) . Map_t ni (Partition_s_ss nj nk) . Map_t ni Seq_To_SSeq . Seq_To_TSeq .
    Partition ni (nj*nk) ===

Unpartition ni nj . TSeq_To_Seq . 
    Map_t ni SSeq_To_Seq . Map_t ni (Map_s nj SSeq_To_Seq) . Map_t ni (Partition_s_ss nj nk) . Map_t ni Seq_To_SSeq . 
    Seq_To_TSeq . Partition ni (nj*nk)
```

#### Sequence To Space-Time with Outer `Seq` Equal To `Partition`'s Outer `Seq`
Do nothing. Same obliteration argument applies as above.
```
Partition no ni
```

#### Sequence To Space-Time with Outer `Seq` `nj` Greater Than `Partition`'s Outer `Seq`
```
Partition ni (nj*nk) === (Partition Nesting Greater Than)
Map ni (Unpartition nj nk) . Partition ni nj . Partition (ni*nj) nk === (Seq To TSeq)
Map ni (Unpartition nj nk) . TSeq_To_Seq . Map_t ni TSeq_To_Seq . Partition_t_tt ni nj . Seq_To_TSeq . Partition (ni*nj) nk
```

### Unpartition

#### Sequence To Space
`Unpartition no ni === SSeq_To_Seq . Unpartition_s_ss no ni . Map_s no (SSeq_To_Seq) . SSeq_To_Seq`

#### Sequence To Time 
`Unpartition no ni === TSeq_To_Seq . Unpartition_t_tt no ni . Map_t no (TSeq_To_Seq) . TSeq_To_Seq`

#### Sequence To Space-Time with Outer `Seq` `nj` Less Than `Unpartition`'s Outer `Seq`
```
Unpartition (ni*nj) nk === (Unpartition Nesting Less Than)
Unpartition ni (nj*nk) . Map ni (Unpartition nj nk) . Partition ni nj === (Seq To TSeq)

Unpartition ni (nj*nk) . 
    TSeq_To_Seq . Map_t ni (Unpartition nj nk) . Seq_To_TSeq . 
    Partition ni nj === (Seq To SSeq)

Unpartition ni (nj*nk) . 
    TSeq_To_Seq . Map_t ni (SSeq_To_Seq . Unpartition_s_ss nj nk . Map_s nj Seq_To_SSeq . Seq_To_SSeq) . Seq_To_TSeq . 
    Partition ni nj === (Map Functor Fusion)

Unpartition ni (nj*nk) . 
    TSeq_To_Seq . Map_t ni SSeq_To_Seq . Map_t ni (Unpartition_s_ss nj nk) . Map_t ni (Map_s nj Seq_To_SSeq) . Map_t ni Seq_To_SSeq . Seq_To_TSeq . 
    Partition ni nj === 

Unpartition ni (nj*nk) . TSeq_To_Seq . 
    Map_t ni SSeq_To_Seq . Map_t ni (Unpartition_s_ss nj nk) . Map_t ni (Map_s nj Seq_To_SSeq) . Map_t ni Seq_To_SSeq .
    Seq_To_TSeq . Partition ni nj
```

#### Nesting With Outer `Seq` Equal To `UpPartition`'s Outer `Seq`
Do nothing. Same obliteration argument applies as above.
```
Unpartition no ni
```

#### Nesting With Outer `Seq` `nj` Greater Than `Unpartition`'s Outer `Seq`
```
Unpartition ni (nj*nk) === (Unpartition Nesting Greater Than)
Unpartition (ni*nj) nk . Unpartition ni nj . Map ni (Partition nj nk) === (Seq To TSeq)
Unpartition (ni*nj) nk . TSeq_To_Seq . Unpartition_t_tt ni nj . Map_t ni TSeq_To_Seq . TSeq_To_Seq . Map ni (Partition nj nk)
```

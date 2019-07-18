# Basic Definitions
The goal of this language is to define for both the sequence language and space-time IR:
1. Types
1. Basic Operators
1. Operators' Properties
1. Isomorphisms Between Types

Also, this document will explain the rewrite rules between operators.

# Sequence Language
Programmers write code in the sequence language.
The sequence language uses standard functional programming operators to express data flow programs. 
Programs in the language are **unscheduled**: it is unspecified whether operations are parallel or sequential. 
There is no clear interpretation of unscheduled programs as hardware accelerators.

## Atom Types
The sequence language has two parts. The first part of the sequence language is the atoms. 
Atoms are standard primitives, such as integers and units.
Atoms also include the minimal derived types necessary to express arithmetic and boolean operators on the primitives. 

1. `Bit` - bit
2. `t x t'` - tuple
4. `t -> t'` - operators 
1. `Int === Bit x Bit x Bit x Bit x Bit x Bit x Bit x Bit` - integer

### Type Constructor
`NTuple (Config 0) t = t`
`NTuple (Config n) t = t x (NTuple (n-1) t)`

## Atom Operators
`t` must be an atomic type for the following operators.

1. `Id :: t -> t`
1. `Add :: (Int x Int) -> Int`
1. `Fst :: (t x t') -> t`
1. `Snd :: (t x t') -> t'`
5. `Tuple :: t -> t' -> t x t'`

### Identity Addition Rewrite Rule
For any function `f`, `f === Id . f === f . Id`

## Sequence Types
The second part of the language lifts types to fixed-length collections containing those types.

1. `Seq n t` - homogeneous, fixed-length sequence

`Seq` is a functor. It is a fixed length version of the `[]` list functor in Haskell. 
`Seq n t` lifts a type `t` to a sequence of `n` elements of type `t`. 
The `Map` operator in the [Sequence Operators](#sequence-operators) section is `Seq`'s `fmap`. 
`Map` lifts a function `t -> t'` to a function `Seq n t -> Seq n t'`. 

Tuples of sequences are only allowed if the sequences have the same type, such as `(Seq n Int) x (Seq n Int)`. 
For triples and larger n-tuples, we require that the non-tuple elements have the same type, such as `(Seq n Int) x ((Seq n Int) x (Seq n Int))`
We require this so that, when computing the time of tupled `TSeq`s, each part of the tuple takes equal amounts of time.
An operator that emits `(TSeq (2*n) v t) x (TSeq n v t)` is ill-defined. 
What do the output wires for the `TSeq n v t` do for the extra `n` clocks needed for the `TSeq (2*n) v t`?
We avoid this issue by removing such tuples from the type system.

## Sequence Operators
1. `Map (Config n) :: (t -> t') -> Seq n t -> Seq n t'`
1. `Map2 (Config n) :: (t -> t' -> t'') -> Seq n t -> Seq n t' -> Seq n t''`
1. `Reduce (Config n) :: (t -> t -> t) -> Seq n t -> Seq 1 t`
3. `Up_1d (Config n) :: Seq 1 t -> Seq n t`
4. `Select_1d (Config n) (Config idx) :: Seq n t -> Seq 1 t`
    1. The output `Seq` contains the `idx`th entry of the input `Seq`.
7. `Partition (Config no) (Config ni) :: Seq (no*ni) t -> Seq no (Seq ni t)`
7. `Unpartition (Config no) (Config ni) :: Seq no (Seq ni t) -> Seq (no*ni) t`
1. `Tuple_To_Seq (Config no) (Config ni) :: Seq no (NTuple ni t) -> Seq no (Seq ni t)`
1. `Seq_To_Tuple (Config no) (Config ni) :: Seq no (Seq ni t) -> Seq no (NTuple ni t)`


Note: Reduce's inner operator must be on atoms or sequences of length one. This ensures that resulting space-time reduce's f only takes one clock. I'm not sure how to handle partially parallel reduces at this time where the operator is pipelined over multiple clocks.

Note: Seq is also an applicative functor. Aetherling's `Map2` is equivalent to Haskell's `\f x -> f <*> x` for applicative functors. I will not put this note in final paper. This note is here to justify to Pat and Kayvon why `Map2` is a standard Haskell function.

### Configuration Parameters
In addition to Aetherling's operators and types that form the sequence language, developers 
need a way to pass values that configure the types of the operators.
**Configuration parameters** are values whose types determine the types of the
configured operators.
Above, we labeled the types-as-values with `Config`.
For example, `Map` requires a configuration parameter to set the length of sequences it operates on.
1. `Config 2 :: Config 2`
1. `Map (Config 2) :: (t -> t') -> Seq 2 t -> Seq 2 t'`
   
All of the types and values can be used as type parameters for `Config`. 
As shown above `Config 2` uses the integer `2` in a configuration parameter's type. 
`Config (Seq 2 Int)` uses `Seq 2 Int` in a configuration parameter's type.

For shorthand throughout the rest of the document, we drop the `Config` label.
It obfuscates the meaning of the code.
We provide the configuration parameters with the operator name. 
Operators' type signatures assume that the configuration parameter has already been provided.

## Properties
### Input and Output Types
Let `f :: t -> t'`
1. `input_type(f) = t`
1. `output_type(f) = t'`

### Length
The following operator tracks the total number of bits accepted and emitted by a sequence operator.

1. `type_length(Bit) = 1`
1. `type_length(t x t') = type_length(t) + type_length(t)`
1. `type_length(Seq n t) = n * type_length(t)`

`input_length(f)` and `output_length(f)` provide the syntax for applying `type_length` to an operator.
1. `input_length(f :: t -> t') = type_length(t)`
1. `output_length(f :: t -> t') = type_length(t')`

Since types incorporate length, two operators `f` and `g` in the sequence language cannot be composed as `g . f` unless `input_length(g) == output_length(f)`. **From Kayvon: move this down to proof section.**

## Sequence Isomorphisms
`Partition no ni` and `Unpartition no ni` form an isomorphism between the types `Seq (no*ni) t` and `Seq no (Seq ni t)` for all choices of `no` and `ni`. 
`Partition` and `Unpartition` convert between the types in a way that preserves the identity function. 
```
Unpartition no ni . Partition no ni === Id
Partition no ni . Unpartition no ni === Id
```

The following commutativity diagram shows the relationship between functions on isomorphic types. 

![General Isomorphism Diagram](isomorphism_general.png "General Isomorphism Diagram")

Specializing this diagram for `Seq` proves:
1. For any function `f :: Seq (no*ni) t -> Seq (no*ni) t'` there is a function `f' :: Seq no (Seq ni t) -> Seq no (Seq ni t')`. 
1. The inputs and outputs of `f` and `f'` are equivalent up to isomorphism: `f === Unpartition no ni . f' . Partition no ni`

**The rewrite rules based on this isomorphism are the first part of our minimal set of rewrite rules.** 
The following are the rules for each operator on sequences in the sequence language

### `Map` Nesting
`Map (no*ni) f === Unpartition no ni . Map no (Map ni f) . Partition no ni`

### `Map2` Nesting 
`Map2 (no*ni) f left_seq right_seq === Unpartition no ni . Map2 no (Map2 ni f) (Unpartition left_seq) (Unpartition right_seq)**

**Note** - unlike the other nesting rules, this one is not written in pointfree style. The arguments are necessary because `Map2` is a binary function rather than a unary one.

### `Reduce` Nesting
`Reduce (no*ni) f === Unpartition 1 1 . Reduce no (Map 1 f) . Map no (Reduce ni f) . Partition no ni` 

### `Up_1d` Nesting
`Up_1d (no*ni) ===  Unparition no ni . Map no (Up_1d ni) . Up_1d no . Partition 1 1`

### `Select_1d` Nesting
`Select_1d (no*ni) idx ===  Unpartition 1 1 . Map 1 (Select_1d ni (idx % no)) . Select_1d no (idx // no) . Partition no ni`

### `Partition` and `Unpartition` Nesting
Please see [the partition document](Partition.md).

### `Tuple_To_Seq` Nesting
`Tuple_To_Seq (ni*nj) nk === Unpartition ni nj . Map ni (Tuple_To_Seq nj nk) . Partition ni nj`

### `Seq_To_Tuple` Nesting
`Seq_To_Tuple (ni*nj) nk === Unpartition ni nj . Map ni (Seq_To_Tuple nj nk) . Partition ni nj`

## Map-Identity Rewrite Rule
`Map n Id === Id`

# Space-Time IR
Aetherling lowers the sequence language to a space-time IR. 
Programs in the IR are **scheduled**: the parallelism of each operators is specified. 
An operator can be parallel (scheduled in space) or sequential (scheduled in time).
All programs in the space-time IR can be interpreted hardware accelerators.
We say that the interpretations are efficient because they have the following properties: all operators correspond to hardware components that run in parallel with minimal buffering between components.

In order to ensure minimal buffering, the space-time IR must guarantee that producers and consumers match throughputs.
A **throughput** (or **rate**) is the average number of bits accepted or emitted per clock.
Each operator has both an input and output throughput, which may be different.
In a pipeline, the output throughput of each producer function must equal the input throughput of its consumer function.
In `g . f`, `f`'s output throughput must equal `g`'s input throughput.
This requirement is known as **producer-consumer rate matching**. 
If rates didn't match, the result would be over-provisioned hardware, e.g. a consumer with higher throughput than its producer. 
The mismatch would also require buffering between the two stages.
If the producer had a higher throughput, a buffer would be required to store the producer's output while waiting for the consumer. 

## Space-Time Types
The space-time IR encodes schedules using types.
The input and output sequence types of an operator define the schedule in which elements of the sequence are consumed and produced by the operator.
These schedules are encoded as two sequence types: space-sequences (`SSeq`) and time-sequences (`TSeq`). 

We define the behavior of corresponding to `SSeq`s and `TSeq`s in terms of a period.
A period for a `SSeq n t` or `TSeq n v t` is the number of clock cycles required for an operator to accept or emit one `t`.
If `t` is an atomic type, then the period is 1.
`SSeq` and `TSeq` are defined in terms of periods rather than clock cycles in order to support nested sequence types.

1. `SSeq n t` - homogeneous, fixed-length sequence in space. This sequence is parallel.
    1. An operator that produces a `SSeq` emits `n` values of type `t` over one period. 
3. `TSeq n v t` - homogeneous, fixed-length sequence in time. This sequence is sequential.
    1. `n` is number of valid periods. `v` is number of empty periods. We will explain the `v` parameter more in the [empty periods section](#empty-periods).
    1. An operator that produces a `TSeq` emits `n` values of type `t` over `(n+v)` periods.
     
### Period Example
We demonstrate the need for the term period first by showing two examples where a period is the same as a clock, and then showing a nested example where the two are different.

An operator `SSeq 5 Int -> SSeq 5 Int` accepts and emits 5 ints each period. A period is one clock because `Int` is an atomic type.

An operator `TSeq 5 1 Int -> TSeq 1 5 Int` accepts ints on five of six periods. It emits ints on one of six periods. A period is one clock because `Int` is an atomic type.

An operator `TSeq 5 1 (TSeq 3 0 Int) -> TSeq 2 4 (TSeq 2 1 Int)` accepts `TSeq 3 0 Int` on five of six periods. A period is three clocks because each `TSeq 3 0 Int` requires three clocks.

## Operators
1. `Id :: t -> t`
1. `Add :: (Int x Int) -> Int`
1. `Fst :: (t x t') -> t`
1. `Snd :: (t x t') -> t'`
5. `Tuple :: t1 -> t2 -> t1 x t2`
1. `Map_s n :: (t -> t') -> SSeq n t -> SSeq n t'`
2. `Map_t n v :: (t -> t') -> TSeq n v t -> TSeq n v t'`
2. `Map2_s n :: (t -> t' -> t'') -> SSeq n t -> SSeq n t' -> SSeq n t''`
2. `Map2_t n v :: (t -> t' -> t'') -> TSeq n v t -> TSeq n v t' -> TSeq n v t''`
1. `Reduce_s n :: (t -> t -> t) -> SSeq n t -> SSeq 1 t`
2. `Reduce_t n v :: (t -> t -> t) -> TSeq n v t -> TSeq 1 (n+v-1) 1`
1. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
3. `Up_1d_t n v :: TSeq 1 (n+v-1) t -> TSeq n v t`
4. `Select_1d_s n idx :: SSeq n t -> SSeq 1 t`
1. `Select_1d_t n v idx :: TSeq n v t -> TSeq 1 (n+v-1) t`
1. `Tuple_To_SSeq n :: NTuple n t -> SSeq n t`
1. `Serialize no ni vo vi :: TSeq no ((no * ((ni - 1) + vi)) + (vo * (ni + vi))) (SSeq ni t) -> TSeq no vo (TSeq ni vi t)`
1. `SSeq_To_Tuple n :: SSeq n t -> NTuple n t`
1. `Deserialize no ni vo vi :: TSeq no vo (TSeq ni vi t) -> TSeq no ((no * ((ni - 1) + vi)) + (vo * (ni + vi))) (SSeq ni t)`

**Note: reduce's type signature will need to be modified to handle pipelined operators.**
**Note: typically, the `v` parameters are implicit**

## Operator Properties
We can compute the following properties for all programs in the space-time IR: 
1. input and output types
1. time
1. input and output length
1. input and output throughput
1. area

In order to guarantee time and throughput matching, we must model the time, parallelism, and throughput of operators.
We also model the resources of operators to prove that our schedules produce efficient hardware accelerators. (We use the terms area and resources interchangeably.)

### Input and Output Types
Let `f :: t -> t'`
1. `input_type(f) = t`
1. `output_type(f) = t'`

### Time
As stated in [the space-time types section](#space-time-types), the input and output types of an operator fully specify the number of clock cycles it requires to process all inputs and emit all outputs.
`time(f :: t -> t') = type_time(t)`.
`type_time(t)` is the number of clock cycles needed for an operator to accept or emit one `t`.
`type_time` formalizes the [above definitions](#space-time-types) of `TSeq` and `SSeq`.

1. `type_time(Int) = 1`
1. `type_time(t x t') = type_time(t)`
1. `type_time(SSeq n t) = type_time(t)`
1. `type_time(TSeq n v t) = (n+v) * type_time(t)`

**Theorem** - `type_time(t) == type_time(t')` forall operators `f :: t -> t'`

### Length
`input_length` and `output_length` are the number of bits accepted and emitted by an operator. 
This property is the same as `length` for sequence operators. 
1. `input_length(f :: t -> t') = type_length(t)`
1. `output_length(f :: t -> t') = type_length(t')`


1. `type_length(Bit) = 1`
1. `type_length(t x t') = type_length(t) + type_length(t')`
1. `type_length(SSeq n t) = n * type_length(t)`
1. `type_length(TSeq n v t) = n * type_length(t)`


### Throughput
An operator's throughput is the number of bits produced or consumed per clock.

1. `input_throughput(f) = input_length(f) / time(f)`
1. `output_throughput(f) = output_length(f) / time(f)`

### Area
`area(f)` is the amount of area on the hardware accelerator required for a space-time operator `f`.
We model resource requirements as three types of area:

1. **Compute Area** is relative to a one-bit adder. 
For example, `Add` for an eight bit integer has eight compute units of area as it is roughly equivalent to eight one bit adders.
1. **Storage Area** is relative to a one-bit register. 
1. **Wire Area** is relative to one-bit wire connecting two components. 
The wiring is for connecting composed operators.
To avoid double counting wiring area, we only consider an operator's input wires. 
We choose to count input rather than output wires as an output can be used multiple times in a fork-join pattern but an input can only be wired into once.

We represent area as the vector `{compute_area, storage_area, wire_area}`. 
The area vector supports `+`, `*` by a scalar, and `*` by a scalar.
`num_bits` returns the number of bits in an `Int` or tuple type.

1. `area(Id) = {0, 0, num_bits(t)}`
1. `area(Add) = {num_bits(Int), 0, 2*num_bits(Int)}`
5. `area(Fst) = area(Snd) = area(Tuple) = {0, 0, 0}`
1. `area(Map_s n f) = n * area(f)`
2. `area(Map_t n f) = area(f)`
1. `area(Map2_s n f) = n * area(f)`
2. `area(Map2_t n f) = area(f)`
1. `area(Reduce_s n f) = (n-1) * area(f)`
1. `area(Reduce_t n f) = area(f) + {0, num_bits(t), num_bits(t)} + area(counter)`
1. `area(Up_1d_s n) = {0, 0, num_bits(t)}`
1. `area(Up_1d_t n) = {0, num_bits(t), num_bits(t)} + area(counter)`
1. `area(Select_1d_s n idx) = {0, 0, n * num_bits(t)}`
1. `area(Select_1d_t n idx) = {0, 0, num_bits(t)} + area(counter)`
1. `area(Tuple_To_SSeq n) = {0, 0, 0}`
1. `area(Serialize no ni) = {0, (ni-1)*num_bits(t), ni*num_bits(t)} + area(counter)`
1. `area(SSeq_To_Tuple n) = {0, 0, 0}`
1. `area(Deserialize no ni) = {0, (ni-1)*num_bits(t), num_bits(t)} + area(counter)`
1. `area(g.f) = area(g) + area(f)`

Many of the sequential operators require a counter to track clock cycles and muxes to select outputs.
1. `area(counter) = {num_bits(Int), num_bits(Int), num_bits(Int)}`
1. `area(mux(n, t)) = {log_2(n), 0, n*num_bits(t)}`

### Empty Periods
Operators do not accept or emit data during empty periods. 
Empty periods enable Aetherling to express (1) operators with different input and output throughputs and (2) schedules with underutilization.
1. Empty clocks enable `TSeq`s with different `n` parameters to express different throughputs.
    1. For example, `Up_1d_t` takes in one input on one clock cycle and then repeatedly outputs it for multiple clock cycles. 
    While `Up_1d_t` is busy emitting data, it cannot accept new input. 
    The empty periods indicate the lack of input so that the input and output `TSeq`s take the same amount of time.
1. Underutilized hardware is hardware that is unused on some clock cycles.
An operator with input and output `TSeq`s that have non-zero `v`s may be unused during those periods.
    1. If `Map_t 1 Add` had any empty clocks, it would be underutilized. 
    This is unlike `Up_1d_t`. 
    It is operator specific whether empty clocks mean underutilization or waiting while processing occurs.
    1. Underutilization is necessary to compose operators in multi-rate pipelines. 
    Consider `Up_1d_t 4 . Map_t 1 Add`.
    `Map_t` must accept input and emit output every fourth clock so that its output throughput matches `Up_1d_t`'s input throughput.
    To accomplish this rate matching, `Map_t` must be underutilized.
    
## Sequence To Space-Time Isomorphisms
`Seq n t` is isomorphic to `SSeq n t` and `TSeq n t` by construction. 
They are all ordered sequences of the same length. 

Just as [`Partition` and `Unpartition` form an isomorphism between `Seq` and `Seq (Seq)`](#sequence-isomorphisms), the following operators form isomorphisms between `Seq` and `Tseq` and `Seq` and `SSeq`.

1. `Seq_To_SSeq :: Seq n a -> SSeq n a`
1. `SSeq_To_Seq :: SSeq n a -> Seq n a`
1. `Seq_To_TSeq :: Seq n a -> TSeq n v a`
1. `TSeq_To_Seq :: TSeq n v a -> Seq n a`

The isomorphisms mean that any `f :: Seq n t -> Seq m t'` function must have semantically equivalent `TSeq` and `SSeq` versions. 
1. `f === TSeq_To_Seq . f_t . Seq_To_TSeq`
1. `f === SSeq_To_Seq . f_s . Seq_To_SSeq`

This is proven in the same way as shown in [the `Seq` isomorphism section.](#sequence-isomorphisms)
Two examples of semantics-preserving rewrite rules are:
1. **`Map` Seq To TSeq** - `Map === TSeq_To_Seq . Map_t . Seq_To_TSeq`
1. **`Map` Seq To SSeq** - `Map === SSeq_To_Seq . Map_s . Seq_To_SSeq`

All other operator-specific, semantics-preserving rewrite rules take the same form, so we do not enumerate them. 
**These rewrite rules make up the rest of our minimal set of rewrite rules.**
The next section contains the space-time operators used in these rewrite rules.

**Note: we do not have a rewrite for Partition since its type is not `f :: Seq n t -> Seq m t`.
Please see [the partition document](Partition.md) for details on that operator**

# Rewrites
The rewrite rules show how to use the above isomorphisms to schedule Aetherling operators. 
As stated previously, there are core rewrite rules that take the following forms:
1. Nesting Seqs - `f === Unpartition no ni . f' . Partition no ni`
1. Seq To TSeq - `f === TSeq_To_Seq . f_tseq . Seq_To_TSeq`
1. Seq To SSeq - `f === SSeq_To_Seq . f_sseq . Seq_To_SSeq`

Using these core rewrite rules, we now show how to convert between operators in the sequence language and those in the space-time IR.
We define **scheduling** to be converting from sequence operators to space-time ones with a slowdown factor.
When scheduling, an operator in the sequence language is rewritten as a semantically equivalent, fully parallel operator in the space-time IR. 
This is a repeat of the Seq To SSeq rewrite rules.
Then, this operator is converted to a less parallel one in order to trade off area and throughput.

## Map
### Sequence To Space
`Map n f === SSeq_To_Seq . Map_s n f . Seq_To_SSeq`

### Sequence To Time
`Map n f === TSeq_To_Seq . Map_t n f . Seq_To_TSeq`

### Sequence To Space-Time With Throughput `no` Less Than Fully Parallel
```
Map (no*ni) f === (Nesting)
Unpartition no ni . Map (no) (Map ni f) . Partition no ni === (Seq To SSeq)
Unpartition no ni . Map no (SSeq_To_Seq . Map_s ni f . Seq_To_SSeq) . Partition no ni === (Seq To TSeq)
Unpartition no ni . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Map_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni === (Functor Map Fusion)
Unpartition no ni . TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t no (Map_s ni f) . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

## Map2
The rewrite rules and proofs are the same as `Map`.
    
## Upsample
### Sequence To Space
`Up_1d n === SSeq_To_Seq . Up_1d_s n . Seq_To_SSeq`

### Sequence To Time
`Up_1d n === TSeq_To_Seq . Up_1d_t n . Seq_To_TSeq`

### Sequence To Space-Time With Throughput `no` Less Than Fully Parallel
```
Up_1d (no*ni) === (Nesting)
Unpartition no ni . Map no (Up_1d ni) . Up_1d no . Partition 1 1 === (Seq To SSeq)
Unpartition no ni . Map no (SSeq_To_Seq . Up_1d_s ni . Seq_To_SSeq) . Up_1d no . Partition 1 1 === (Seq To TSeq)
Unpartition no ni . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Up_1d_s ni . Seq_To_SSeq) . Seq_To_TSeq . TSeq_To_Seq . Up_1d_t no . Seq_To_TSeq . Partition 1 1 === (Isomorphism Operator Removal)
Unpartition no ni . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Up_1d_s ni . Seq_To_SSeq) . Up_1d_t no . Seq_To_TSeq . Partition 1 1 === (Functor Map Fusion)
Unpartition no ni . TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t no (Up_1d_s ni) . Map_t no Seq_To_SSeq . Up_1d_t no . Seq_To_TSeq . Partition 1 1 === (Commutativity)
Unpartition no ni . TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t no (Up_1d_s ni) . Up_1d_t no . Map_t 1 Seq_To_SSeq . Seq_To_TSeq . Partition 1 1 
```

See [the Functor Properties section](#functor-properties) for a description of Map Fusion.

## Select
### Sequence To Space
`Select_1d n idx === SSeq_To_Seq . Select_1d_s n idx . Seq_To_SSeq`

### Sequence To Time
`Select_1d n idx === TSeq_To_Seq . Select_1d_t n idx . Seq_To_TSeq`

### Scheduling With Throughput `no` Less Than Fully Parallel
```
Select_1d (no*ni) idx ===
Unpartition 1 1 . TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t 1 (Select_1d_s ni (idx % no)) . Select_1d_t no (idx // no) . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

The proof of this rewrite is the same as the Upsample proof.

## Reduce
### Sequence To Space
`Reduce n f === SSeq_To_Seq . Reduce_s n f . Seq_To_SSeq`

### Sequence To Time
`Reduce n f === TSeq_To_Seq . Reduce_t n f . Seq_To_TSeq`

### Sequence To Space-Time With Throughput `no` Less Than Fully Parallel
```
Reduce (no*ni) f === (Nesting)
Unpartition 1 1 . Reduce no (Map 1 f) . Map no (Reduce ni f) . Partition no ni === (Seq To SSeq)
Unpartition 1 1 . Reduce no (SSeq_To_Seq . Map_s 1 f . Seq_To_SSeq) . Map no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Partition no ni === (Seq To TSeq)
Unpartition 1 1 . TSeq_To_Seq . Reduce_t no (SSeq_To_Seq . Map_s 1 f . Seq_To_SSeq) . Seq_To_TSeq . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni === (Isomorphism Removal)
Unpartition 1 1 . TSeq_To_Seq . Reduce_t no (SSeq_To_Seq . Map_s 1 f . Seq_To_SSeq) . Map_t no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni === (Map Functor Fusion)
Unpartition 1 1 . TSeq_To_Seq . Reduce_t no (SSeq_To_Seq . Map_s 1 f . Seq_To_SSeq) . Map_t no SSeq_To_Seq . Map_t no (Reduce_s ni f) . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni === (Reduce Isomorphism Fusion)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Reduce_t no (Map_s 1 f) . Map_t no Seq_To_SSeq . Map_t no SSeq_To_Seq . Map_t no (Reduce_s ni f) . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni === (Isomorphism Removal)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Reduce_t no (Map_s 1 f) . Map_t no (Reduce_s ni f) . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni === (Isomorphism Removal)



Unpartition 1 1 . Reduce no (SSeq_To_Seq . Map_s 1 f . Seq_To_SSeq) . Map no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Partition no ni === (Map Functor Fusion)
Unpartition 1 1 . Reduce no (SSeq_To_Seq . Map 1 f . Seq_To_SSeq) . Map no SSeq_To_Seq . Map no (Reduce ni f) . Map no Seq_To_SSeq . Partition no ni === (Reduce Isomorphism Fusion)
Unpartition 1 1 . Map 1 SSeq_To_Seq . Reduce no (Map 1 f) . Map no Seq_To_SSeq . Map no SSeq_To_Seq . Map no (Reduce ni f) . Map no Seq_To_SSeq . Partition no ni === (Isomorphism Removal)
Unpartition 1 1 . Map 1 SSeq_To_Seq . Reduce no (Map 1 f) . Map no (Reduce ni f) . Map no Seq_To_SSeq . Partition no ni === (Seq To TSeq)
Unpartition 1 1 . Map_t 1 SSeq_To_Seq . Seq_To_TSeq . TSeq_To_Seq . Reduce_t no (Map 1 f) . Seq_To_TSeq . TSeq_To_Seq . Map_t no (Reduce ni f) . Seq_To_TSeq . Map no Seq_To_SSeq . Partition no ni === (Seq To TSeq)
Unpartition 1 1 . Reduce no (SSeq_To_Seq . Map 1 f) . Map no Seq_To_SSeq) . Map no (SSeq_To_Seq . Reduce ni f . Seq_To_SSeq) . Partition no ni === (Seq To TSeq)
Unpartition 1 1 . Partition 1 1 . TSeq_To_Seq . Reduce_t no f . Seq_To_TSeq . Unpartition no 1 . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni === (Partition and Unpartition Sequence To Space-Time)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Partition_t_ts 1 1 . Seq_To_TSeq . TSeq_To_Seq . Reduce_t no f . Seq_To_TSeq . TSeq_To_Seq . Unpartition_t_ts no 1 . Map_t no Seq_To_SSeq . Seq_To_TSeq . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni === (Isomorphism Removal)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Partition_t_ts 1 1 . Reduce_t no f .  Unpartition_t_ts no 1 . Map_t no Seq_To_SSeq . Map_t no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni === (Functor Map Fusion)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Partition_t_ts 1 1 . Reduce_t no f . Unpartition_t_ts no 1 . Map_t no Seq_To_SSeq . Map_t no SSeq_To_Seq . Map_t no (Reduce_s ni f) . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni === (Isomorphism Removal)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Partition_t_ts 1 1 . Reduce_t no f . Unpartition_t_ts no 1 . Map_t no (Reduce_s ni f) . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

## Tuple\_To\_Seq
### Sequence To Space
```
Tuple_To_Seq no ni === 
SSeq_To_Seq . Map_s no SSeq_To_Seq . 
    Map_s no (Tuple_To_SSeq ni) . 
    Seq_To_SSeq
```

### Sequence To Time
```
Tuple_To_Seq no ni === 
TSeq_To_Seq . Map_t no (TSeq_To_Seq) . 
    Serialize no ni . Map_t no (Tuple_To_SSeq ni) . 
    Seq_To_TSeq
```

### Sequence To Space-Time With Throughput `ni` Less Than Fully Parallel
This transformation allows for the outer `Seq` to be partially or fully in time, but forces the inner `Seq` to be fully parallel.
I can add a later transformation that allows both to be partially parallel if necessary.
I will need to further flesh out the scheduling algorithm to determine if that is necessary.
```
Tuple_To_Seq (ni*nj) nk === (Nesting)

Unpartition ni nj . 
    Map ni (Tuple_To_Seq nj nk) . 
    Partition ni nj === (Seq To TSeq)

Unpartition ni nj . 
    TSeq_To_Seq . Map_t ni (Tuple_To_Seq nj nk) . Seq_to_TSeq . 
    Partition ni nj === (Seq To SSeq)

Unpartition ni nj . TSeq_To_Seq .
    Map_t ni (
        SSeq_To_Seq . Map_s nj SSeq_To_Seq . 
            Map_s nj (Tuple_To_SSeq nk) . 
            Seq_To_SSeq
        ) . 
    Seq_To_TSeq . Partition ni nj === (Map Functor Fusion)

Unpartition ni nj . TSeq_To_Seq .
    Map_t ni SSeq_To_Seq . Map_t ni (Map_s nj SSeq_To_Seq) . 
    Map_t ni (Map_s nj (Tuple_To_SSeq nk)) . 
    Map_t ni Seq_To_SSeq .
    Seq_To_TSeq . Partition ni nj 
```

## Seq\_To\_Tuple
### Sequence To Space
```
Seq_To_Tuple no ni === 
SSeq_To_Seq . Map_s no SSeq_To_Seq . 
    Map_s no (SSeq_To_Tuple ni) . 
    Seq_To_SSeq
```

### Sequence To Time
```
Seq_To_Tuple no ni === 
TSeq_To_Seq .
    Map_t no (SSeq_To_Tuple ni) . Deserialize no ni .
    Map_t no (TSeq_To_Seq) . Seq_To_TSeq
```

### Sequence To Space-Time With Throughput `ni` Less Than Fully Parallel
```
Seq_To_Tuple (ni*nj) nk === (Nesting)

Unpartition ni nj . 
    Map ni (Seq_To_Tuple nj nk) . 
    Partition ni nj === (Seq To TSeq)

Unpartition ni nj . 
    TSeq_To_Seq . Map_t ni (Seq_To_Tuple nj nk) . Seq_to_TSeq . 
    Partition ni nj === (Seq To SSeq)

Unpartition ni nj . TSeq_To_Seq .
    Map_t ni (
        SSeq_To_Seq . 
            Map_s nj (SSeq_To_Tuple nk) . 
            Map_s nj Seq_To_SSeq . Seq_To_SSeq
        ) . 
    Seq_To_TSeq . Partition ni nj === (Map Functor Fusion)

Unpartition ni nj . TSeq_To_Seq .
    Map_t ni SSeq_To_Seq . 
    Map_t ni (Map_s nj (SSeq_To_Tuple nk))
    Map_t ni (Map_s nj Seq_To_SSeq) . Map_t ni Seq_To_SSeq
    Seq_To_TSeq . Partition ni nj
```

## Rewrite Rules Lemmas
The following rewrite rules are used as lemmas in the above rewrite rules.

### Isomorphism Operators Removal
When multiple slowed operators are composed, we will need to remove the wrapping, isomorphism operators. 
These rewrites show how to remove the operators.
1. `Seq_To_SSeq . SSeq_To_Seq === Id`
1. `SSeq_To_Seq . Seq_To_SSeq === Id`
1. `Seq_To_TSeq . TSeq_To_Seq === Id`
1. `TSeq_To_Seq . Seq_To_TSeq === Id`
1. `Seq_To_TSeq . SSeq_To_Seq === Id`
1. `Unpartition no ni . Partition no ni === Id`
1. `Partition_ss no ni . Unpartition_ss no ni === Id`
2. `Unpartition_ss no ni . Partition_ss no ni === Id`
1. `Partition_tt no ni . Unpartition_tt no ni === Id`
2. `Unpartition_tt no ni . Partition_tt no ni === Id`
1. `Partition_ts no ni . Unpartition_ts no ni === Id`
2. `Unpartition_ts no ni . Partition_ts no ni === Id`

### Sequence Commutativity
The following operators commute with each others. It is obvious that the two
forms are semantically equivalent.

```
Map 1 f . Select_1d n idx === Select_1d n idx . Map n f
Map n f . Up_1d n === Up_1d n . Map 1 f
Map ni (Partition nj nk) . Partition ni (nj*nk) === Partition ni nj . Partition (ni*nj) nk
```

The following operators commute when combined with the nesting rewrite rule.

```
Map (no*ni) f . Unpartition no ni f === Unpartition no ni f . Map no (Map ni f)
Partition no ni f . Map (no*ni) f ===  Map no (Map ni f) . Partition no ni f
```

The following commute if `f` and `g` commute
```
Map n f . Map n g === Map n g . Map n f
```

### Space-Time Commutativity
Since the sequence operators commute, their semantically equivalent operators in space-time also commute.

For example:
```
Map_t 1 f . Select_1d_t n idx === (Isomorphism Operator Addition)
Seq_To_TSeq . TSeq_To_Seq . Map_t 1 f . Seq_To_TSeq . TSeq_To_Seq . Select_1d_t n idx . Seq_To_TSeq . TSeq_To_Seq === (TSeq To Seq)
Seq_To_TSeq . Map 1 f . Select_1d n idx . TSeq_To_Seq === (Commutativity)
Seq_To_TSeq . Select_1d n idx . Map n f . TSeq_To_Seq === (Seq To TSeq)
Seq_To_TSeq . TSeq_To_Seq . Select_1d_t n idx . Seq_To_TSeq . TSeq_To_Seq . Map_t n f . Seq_To_TSeq . TSeq_To_Seq === (Isomorphism Removal)
Select_1d_t n idx . Map_t n f
```

### Functor Properties
The following rewrite rules must hold due to the fact that `Seq`, `TSeq`, and `SSeq` are functors.
We provide only the `Seq` rule, the same rules exist for `TSeq` and `SSeq`.

1. Map Fusion - `Map g . Map f === Map (g . f)`
1. Identity Preservation - `Map id === id`

### `HMap` Properties
1. `HMap` and `Map` Equivalence - If all `f`s in `HMap n fs` are the same, it's the same as `Map n f`. Both just apply `f` `n` times
    1. `HMap n (List_To_Seq [f | i <- [0..n-1]]) === Map n f`
1. `HMap` fusion - 
```
HMap n (List_To_Seq [f(i) . g(i) | i <- [0 .. n-1]]) === 
HMap n (List_To_Seq [f(i) | i <- [0 .. n-1]]) . HMap n (List_To_Seq [g(i) | i <- [0 .. n-1]])
```

**HOW TO PROVE THESE?**

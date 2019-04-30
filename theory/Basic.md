# Basic Aetherling Language Theory
Aetherling is a system for compiling data flow pipelines to efficient implementations in hardware accelerators.
Aetherling programs are written in a **sequence language**, a standard functional programming language.
The sequence language is a high-level language that does not address parallelism. 
The absence of parallelism makes the language simpler for developers.
This abstraction also means programs cannot be interpreted as hardware accelerators.

Aetherling transforms these programs into a **space-time IR**. 
The IR specifies the parallelism of all operators.
This information enables programs in the IR to be interpreted as hardware accelerators.
The IR also models the throughput and resource requirements of the corresponding hardware implementations.
An auto-scheduler uses semantics-preserving transformations in the IR to find the maximally parallel hardware implementation given resource constraints.

The transformations on programs are implemented using rewrite rules.
One set of rewrite rules convert programs in the sequence language to ones in the space-time IR.
Another set of the rewrite rules used by the auto-scheduler convert between programs in the space-time IR.

We define a minimal set of rewrite rules using isomorphisms to show that they preserve program semantics.
There are isomorphisms between data types in the sequence language.
There are also isomorphisms between sequence data types and ones in the space-time IR.
These isomorphisms mean that, for any function the sequence language, there are many semantically equivalent functions using the space-time IR.
The different functions in the space-time IR are different schedules with different amounts of parallelism.
The minimal set of rewrite rules, along with other derived ones, are the conversions between semantically equivalent functions.
Thus, the rewrite rules and auto-scheduler preserve semantics even while changing parallelism and resource requirements.

We also prove properties of the auto-scheduler by defining properties of the operators in the space-time IR.
We axiomatize the properties for time, throughput, and resource requirements of the IR's operators.
The properties enable us to prove that the auto-scheduler always produces programs in the space-time IR that are efficient and maximally parallel.

# Sequence Language
Programmers use Aetherling by writing code in the sequence language.
The sequence language uses standard functional programming operators to express data flow programs. 
Programs in the language are **unscheduled**: it is unspecified whether operations are parallel or sequential. 
There is no clear interpretation of unscheduled programs as hardware accelerators.

## Atom Types
The sequence language has two parts. The first part of the sequence language is the atoms. 
Atoms are standard primitives, such as integers and units.
Atoms also include the minimal derived types necessary to express arithmetic and boolean operators on the primitives. 

1. `()` - Unit
1. `Int` - integer
2. `t x t'` - tuple
4. `t -> t'` - function

### Atomic Values
Developers can directly create values of atomic types. 
Examples are:

1. `() :: ()`
1. `1 :: Int`
1. `1 x () :: Int x ()`

## Atom Operators
`t` must be an atomic type for the following operators.

1. `Id :: t -> t`
1. `Const_Gen :: t -> () -> t`
1. `Add :: (Int x Int) -> Int`
1. `Fst :: (t x t') -> t`
1. `Snd :: (t x t') -> t'`
5. `Zip :: t1 -> t2 -> t1 x t2`

## Sequence Types
The second part of the language lifts types to fixed-length collections containing those types.

1. `Seq n t` - homogeneous, fixed-length sequence

`Seq` is a functor. It is a fixed length version of the `[]` list functor in Haskell. 
`Seq n t` lifts a type `t` to a sequence of `n` elements of type `t`. 
The `Map` operator in the [Sequence Operators](#sequence-operators) section is `Seq`'s `fmap`. 
`Map` lifts a function `t -> t'` to a function `Seq n t -> Seq n t'`. 

We do not allow sequences of functions, such as `Seq n (Int -> Int)`, or tuples of sequences, such as `(Seq n Int) x (Seq n Int)`.

### Atomic Values
Developers can directly create values of atomic types. 
Examples are:

1. `[1, 2, 3] :: Seq 3 Int`
1. `[[1 x 2], [3 x 4]] :: Seq 2 (Seq 1 (Int x Int))`

## Sequence Operators
1. `Map (Meta n) :: (t -> t') -> Seq n t -> Seq n t'`
1. `Map2 (Meta n) :: (t -> t' -> t'') -> Seq n t -> Seq n t' -> Seq n t''`
1. `Reduce (Meta n) :: (t -> t -> t) -> Seq n t -> Seq 1 t`
3. `Up_1d (Meta n) :: Seq 1 t -> Seq n t`
4. `Down_1d (Meta n) :: Seq n t -> Seq 1 t`
7. `Partition (Meta no) (Meta ni) :: Seq (no*ni) t -> Seq no (Seq ni t)`
7. `Unpartition (Meta no) (Meta ni) :: Seq no (Seq ni t) -> Seq (no*ni) t`

Note: Reduce's inner operator must be on atoms or sequences of length one. This ensures that resulting space-time reduce's f only takes one clock. I'm not sure how to handle partially parallel reduces at this time where the operator is pipelined over multiple clocks.

Note: Seq is also an applicative functor. Aetherling's `Map2` is equivalent to Haskell's `liftA2` for applicative functors. I will not put this note in final paper. This note is here to justify to Pat and Kayvon why `Map2` is a standard Haskell function.

### Meta Language Atom Types
In addition to Aetherling's operators and values that form a language, there is a
**meta-language** for configuring the operators.
For example, `Map` requires a **configuration parameter** in the meta-language 
to set the length of sequences it operates on.
The configuration parameters are values whose types determine the types of the
configured operators.
In addition to using atomic data elements like `1` and `2` as values in the sequence 
language, we also use them as types in the meta-language to create the 
configuration parameters.
Above, we labeled the types-as-values in the meta language with `Meta`.
Examples are:
1. `Meta 2 :: Meta 2`
1. The actual type of `Map` is `Map :: Meta Int -> (t -> t') -> Seq n t -> Seq n t'`.
   When `Meta n` is applied, `Map (Meta n) :: (t -> t') -> Seq n t -> Seq n t'`
   
For shorthand throughout the rest of the document, we drop the `Meta` label.
It obfuscates the meaning of the code.
Additionally, it is unambiguous whether an argument to an operator is a value
or a type.

## Length Property
The following operator tracks the total number of atoms accepted and emitted by a sequence operator.

1. `type_length(Int) = 1`
1. `type_length(t x t') = 1`
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
1. For any function `f :: Seq (no*ni) t -> Seq (no*ni) t` there is a function `f' :: Seq no (Seq ni t) -> Seq no (Seq ni t')`. 
1. The inputs and outputs of `f` and `f'` are equivalent up to isomorphism: `f === Unpartition no ni . f' . Partition no ni`

**The rewrite rules based on this isomorphism are the first part of our minimal set of rewrite rules.** 
The following are the rules for each operator on sequences in the sequence language

1. **`Map` Nesting** - `Map (no*ni) f === Unpartition no ni . Map no (Map ni f) . Partition no ni`
1. **`Map2` Nesting**  - the same as `Map`. We elide it's definition as it requires a different syntax that has not yet been introduced.
1. **`Reduce` Nesting** - `Reduce (no*ni) f === Unpartition 1 1 . Reduce no (Map2 1 f) . Map no (Reduce ni f) . Partition no ni` 
1. **`Up_1d` Nesting** - `Up_1d (no*ni) ===  Unparition no ni . Map no (Up_1d ni) . Up_1d no . Partition 1 1`
1. **`Down_1d` Nesting** - `Up_1d (no*ni) ===  Unpartition 1 1 . Map 1 (Down_1d ni) . Down_1d no . Partition no ni`

## Commutativity
The following operators commute with each others. It is obvious that the two
forms are semantically equivalent.

```
Map 1 f . Down_1d n === Down_1d n . Map n f
Map n f . Up_1d n === Up_1d n . Map 1 f
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

# Space-Time IR
Aetherling lowers the sequence language to a space-time IR. 
Programs in the IR are **scheduled**: the parallelism of each operators is specified. 
An operator can be parallel (scheduled in space) or sequential (scheduled in time).
All programs in the space-time IR can be interpreted hardware accelerators.
We say that the interpretations are efficient because they have the following properties: all operators correspond to hardware components that run in parallel with minimal buffering between components.

In order to ensure minimal buffering, the space-time IR must guarantee that producers and consumers match throughputs.
A **throughput** (or **rate**) is the average number of atoms accepted or emitted per clock.
Each operator has both an input and output throughput, which may be different.
In a pipeline, the output throughput of each producer function must equal the input throughput of its consumer function.
In `g . f`, `f`'s output throughput must equal `g`'s input throughput.
This requirement is known as **producer-consumer rate matching**. 
If rates didn't match, the result would be over-provisioned hardware, e.g. a consumer with higher throughput than its producer. 
The mismatch would also require buffering between the two stages.
If the producer had a higher throughput, a buffer would be required to store the producer's output while waiting for the consumer. 

### Space-Time Types
The space-time IR encodes schedules using types.
The input and output sequence types of an operator define the schedule in which elements of the sequence are consumed and produced by the operator.
These schedules are encoded as two sequence types: space-sequences (`SSeq`) and time-sequences (`TSeq`). 

We define the behavior of corresponding to `SSeq`s and `TSeq`s in terms of a period.
A period for a `SSeq n t` or `TSeq n t` is the number of clock cycles required for an operator to accept or emit one `t`.
If `t` is an atomic type, then the period is 1.
`SSeq` and `TSeq` are defined in terms of periods rather than clock cycles in order to support nested sequence types.

1. `SSeq n t` - homogeneous, fixed-length sequence in space. This sequence is parallel.
    1. An operator that produces a `SSeq` emits `n` values of type `t` over one period. 
3. `TSeq n v t` - homogeneous, fixed-length sequence in time. This sequence is sequential.
    1. `n` is number of utilized periods. `v` is number of empty periods. We will explain the `v` parameter more in the [empty periods section](#empty-periods).
    1. An operator that produces a `TSeq` emits `n` values of type `t` over `(n+v)` periods.
     
#### Period Example
We demonstrate the need for the term period first by showing two examples where a period is the same as a clock, and then showing a nested example where the two are different.

An operator `SSeq 5 Int -> SSeq 5 Int` accepts and emits 5 ints each period. A period is one clock because `Int` is an atomic type.

An operator `TSeq 5 1 Int -> TSeq 1 5 Int` accepts ints on five of six periods. It emits ints on one of six periods. A period is one clock because `Int` is an atomic type.

An operator `TSeq 5 1 (TSeq 3 0 Int) -> TSeq 2 4 (TSeq 2 1 Int)` accepts `TSeq 3 0 Int` on five of six periods. A period is three clocks because each `TSeq 3 0 Int` requires three clocks.

### Sequence To Space-Time Isomorphisms
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

## Operators
1. `Id :: t -> t`
1. `Const_Gen :: t -> () -> t`
1. `Add :: (Int x Int) -> Int`
1. `Fst :: (t x t') -> t`
1. `Snd :: (t x t') -> t'`
5. `Zip :: t1 -> t2 -> t1 x t2`
1. `Map_s n :: (t -> t') -> SSeq n t -> SSeq n t'`
2. `Map_t n :: (t -> t') -> TSeq n v t -> TSeq n v t'`
2. `Map2_s n :: (t -> t' -> t'') -> SSeq n t -> SSeq n t' -> SSeq n t''`
2. `Map2_t n :: (t -> t' -> t'') -> TSeq n v t -> TSeq n v t' -> TSeq n v t''`
1. `Reduce_s n :: (t -> t -> t) -> SSeq n t -> SSeq 1 t`
2. `Reduce_t n :: (t -> t -> t) -> TSeq n v t -> TSeq 1 (n+v-1) 1`
1. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
3. `Up_1d_t n :: TSeq 1 (n+v-1) t -> TSeq n v t`
4. `Down_1d_s n :: SSeq n t -> SSeq 1 t`
4. `Down_1d_t n :: TSeq n v t -> TSeq 1 (n+v-1) t`

## Operator Properties
We can compute the following properties for all programs in the space-time IR: 
1. time
1. input and output length
1. input and output throughput
1. area

In order to guarantee time and throughput matching, we must model the time, parallelism, and throughput of operators.
We also model the resources of operators to prove that our schedules produce efficient hardware accelerators. (We use the terms area and resources interchangeably.)

### Time
As stated in [the space-time types section](#space-time-types), the input and output types of an operator fully specify the number of clock cycles it requires to process all inputs and emit all outputs.
`time(f :: t -> t') = type_time(t)`.
`type_time(t)` is the number of clock cycles needed for an operator to accept or emit one `t`.
`type_time` formalizes the [above definitions](#space-time-types) of `TSeq` and `SSeq`.

1. `type_time(Int) = 1`
1. `type_time(t x t') = 1`
1. `type_time(SSeq n t) = type_time(t)`
1. `type_time(TSeq n v t) = (n+v) * type_time(t)`

**Theorem** - `type_time(t) == type_time(t')` forall operators `f :: t -> t'`

### Length
`input_length` and `output_length` are the number of atoms accepted and emitted by an operator. 
This property is the same as `length` for sequence operators. 
1. `input_length(f :: t -> t') = type_length(t)`
1. `output_length(f :: t -> t') = type_length(t')`


1. `type_length(Int) = 1`
1. `type_length(t x t') = 1`
1. `type_length(SSeq n t) = n * type_length(t)`
1. `type_length(TSeq n v t) = n * type_length(t)`


### Throughput
An operator's throughput is the number of atoms produced or consumed per clock.

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
To avoid double counting wiring area, we only consider an operator's output wires.

We represent area as the vector `{compute_area, storage_area, wire_area}`. 
The area vector supports `+`, `*` by a scalar, and `*` by a scalar.
`num_bits` returns the number of bits in an `Int` or tuple type.

1. `area(Id) = {0, 0, 0}`
1. `area(Const_Gen n) = {0, num_bits(Int), num_bits(Int)}`
1. `area(Add) = {num_bits(Int), 0, num_bits(Int)}`
5. `area(Fst) = area(Snd) = area(Zip) = {0, 0, 0}`
1. `area(Map_s n f) = n * area(f)`
2. `area(Map_t n f) = area(f)`
1. `area(Map2_s n f) = n * area(f)`
2. `area(Map2_t n f) = area(f)`
1. `area(Reduce_s n f) = ceil(log_2(n)) * area(f)`
1. `area(Reduce_t n f) = area(f) + {0, num_bits(t), num_bits(t)} + area(counter)`
1. `area(Up_1d_s n) = {0, 0, n * num_bits(t)}`
1. `area(Up_1d_t n) = {0, num_bits(t), num_bits(t)} + area(counter)`
1. `area(Down_1d_s n) = {0, 0, num_bits(t)}`
1. `area(Down_1d_t n) = {0, 0, num_bits(t)} + area(counter)`
1. `area(g.f) = area(g) + area(f)`

Many of the sequential operators require a counter to track clock cycles.
1. `area(counter) = {num_bits(Int), num_bits(Int), num_bits(Int)}`

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

### Map
1. Fully Parallel Scheduling - `Map n f === SSeq_To_Seq . Map_s n f . Seq_To_SSeq`
1. Scheduling With Slowdown By `no` - 
```
Map (no*ni) f === (Nesting)
Unpartition no ni . Map (no) (Map ni f) . Partition no ni === (Seq To SSeq)
Unpartition no ni . Map no (SSeq_To_Seq . Map_s ni f . Seq_To_SSeq) . Partition no ni (Seq To TSeq)
Unpartition no ni . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Map_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni
```
    
### Upsample
1. Sequence To Space - `Up_1d n === SSeq_To_Seq . Up_1d_s n . Seq_To_SSeq`
1. Scheduling With Slowdown By `no` - 
```
Up_1d (no*ni) === (Nesting)
Unpartition no ni . Map no (Up_1d ni) . Up_1d no . Partition 1 1 === (Seq To SSeq)
Unpartition no ni . Map no (SSeq_To_Seq . Up_1d_s ni . Seq_To_SSeq) . Up_1d no . Partition 1 1 === (Seq To TSeq)
Unpartition no ni . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Up_1d_s ni . Seq_To_SSeq) . Seq_To_TSeq . TSeq_To_Seq . Up_1d_t no . Seq_To_TSeq . Partition 1 1 === (Isomorphism Operator Removal)
Unpartition no ni . TSeq_To_Seq . Map_t no (SSeq_To_Seq . Up_1d_s ni . Seq_To_SSeq) . Up_1d_t no . Seq_To_TSeq . Partition 1 1 === (Functor Map Fusion)
Unpartition no ni . TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t no (Up_1d_s ni) . Map_t no Seq_To_SSeq . Up_1d_t no . Seq_To_TSeq . Partition 1 1 === (Commutativity)
Unpartition no ni . TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t no (Up_1d_s ni) . Up_1d_t no . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition 1 1 
```

See [the Functor Rules section](#functor-rules) for a description of Map Fusion.

### Downsample
1. Sequence To Space - `Down_1d n === SSeq_To_Seq . Down_1d_s n . Seq_To_SSeq`
1. Scheduling With Slowdown By `no` - 
```
Down_1d (no*ni) ===
Unpartition 1 1 . TSeq_To_Seq . Map_t no SSeq_To_Seq . Map_t 1 (Down_1d_s ni) . Down_1d_t no . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

The proof of this rewrite is the same as the Upsample proof.

### Reduce
1. Sequence To Space - `Reduce n f === SSeq_To_Seq . Reduce_s n f . Seq_To_SSeq`
1. Scheduling With Slowdown By `no` - 
```
Reduce (no*ni) f === (Nesting)
Unpartition 1 1 . Reduce no (Map2 1 f) . Map no (Reduce ni f) . Partition no ni === (Seq To TSeq)
Unpartition 1 1 . TSeq_To_Seq . Reduce_t no (Map2 1 f) . Seq_To_TSeq . TSeq_To_Seq . Map_t no (Reduce ni f) . Seq_To_TSeq . Partition no ni === (Isomorphism Removal)
Unpartition 1 1 . TSeq_To_Seq . Reduce_t no (Map2 1 f) . Map_t no (Reduce ni f) . Seq_To_TSeq . Partition no ni === (Seq To SSeq / Reduce Fusion)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Reduce_t no (Map2_s 1 f) . Map_t no Seq_To_SSeq . Map_t no (SSeq_To_Seq . Reduce_s ni f . Seq_To_SSeq) . Seq_To_TSeq . Partition no ni === (Map Fusion)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Reduce_t no (Map2_s 1 f) . Map_t no Seq_To_SSeq . Map_t no SSeq_To_Seq . Map_t no Reduce_s ni f . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni === (Isomorphism Removal / Map Fusion / Identity Removal)
Unpartition 1 1 . TSeq_To_Seq . Map_t 1 SSeq_To_Seq . Reduce_t no (Map2_s 1 f) . Map_t no Reduce_s ni f . Map_t no Seq_To_SSeq . Seq_To_TSeq . Partition no ni
```

### Isomorphism Operators Removal
When multiple slowed operators are composed, we will need to remove the wrapping, isomorphism operators. 
These rewrites show how to remove the operators.
1. `Seq_To_SSeq . SSeq_To_Seq === Id`
1. `SSeq_To_Seq . Seq_To_SSeq === Id`
1. `Seq_To_TSeq . TSeq_To_Seq === Id`
1. `TSeq_To_Seq . Seq_To_TSeq === Id`
1. `Seq_To_TSeq . SSeq_To_Seq === Id`
1. `Unpartition . Partition === Id`
1. `Partition_ss no ni . Unpartition_ss no ni === Id`
2. `Unpartition_ss no ni . Partition_ss no ni === Id`
1. `Partition_tt no ni . Unpartition_tt no ni === Id`
2. `Unpartition_tt no ni . Partition_tt no ni === Id`
1. `Partition_ts no ni . Unpartition_ts no ni === Id`
2. `Unpartition_ts no ni . Partition_ts no ni === Id`

### Space-Time Commutativity
Since the sequence operators commute, their semantically equivalent operators in space-time also commute.

For example:
```
Map_t 1 f . Down_1d_t n === (Isomorphism Operator Addition)
Seq_To_TSeq . TSeq_To_Seq . Map_t 1 f . Seq_To_TSeq . TSeq_To_Seq . Down_1d_t n . Seq_To_TSeq . TSeq_To_Seq === (TSeq To Seq)
Seq_To_TSeq . Map 1 f . Down_1d n . TSeq_To_Seq === (Commutativity)
Seq_To_TSeq . Down_1d n . Map n f . TSeq_To_Seq === (Seq To TSeq)
Seq_To_TSeq . TSeq_To_Seq . Down_1d_t . Seq_To_TSeq . TSeq_To_Seq . Map_t n f . Seq_To_TSeq . TSeq_To_Seq === (Isomorphism Removal)
Down_1d_t n . Map_t n f
```

# Functor Rules
In addition to rules provided by the isomorphisms, we also have the following rewrite rules due to the fact that `Seq`, `TSeq`, and `SSeq` are functors.
We provide only the `Seq` rule, the same rules exist for `TSeq` and `SSeq`.

1. Map Fusion - `Map g . Map f === Map (g . f)`
1. Identity Preservation - `Map id === id`

## Reduce Fusion
If `g . h === Id`, then applying the g before and h fter each step in a
reduce tree is equivalent to applying g to each input to the reduce
and h to the output of the reduce:
We provide only the `Seq` rule, the same rules exist for `TSeq` and `SSeq`.

```
reduce_function f g h x y =
  intermediate_result <- f (g x) (g y)
  return (h intermediate_result)

Reduce n (reduce_function g h) === Map 1 h . Reduce n f . Map n g
```

**Do I need to prove the Reduce Fusion?**

# Auto-Scheduler 
The auto-scheduler finds the schedule with the maximum throughput given a
specified resource constraints.
1. Inputs: 
    1. `P_seq`: a program in the sequence language. 
    1. `area_max`: a resource constraint in area.
1. Outputs
    1. `P_st_optimal`: a program in the space-time IR with maximum throughput given resource constraints.

## Auto-Scheduler Algorithm
1. Apply the Sequence To Space rewrite rule to all operators in `P_seq`. Let `P_space` be the result.
1. If `area(P_space)` is less than `area_max`, stop. `P_space` is `P_st_optimal`
1. Let `N` be the set of all input and output sequence lengths, `n`, of all operators.
1. Let `N_factors` be the set of the common factors of all numbers in `N`. 
1. Sort `N_factors` from smallest to largest.
1. Let `factor_i = N_factors[i]`.
1. For `i` in `range(0, len(N_factors))`:
    1. Apply Slowdown rewrite rule to all operators in `P_space`. 
        1. Let `prod_factor_i` = product of `factor_j` for all j from 0 to i (inclusive).
        1. Let `P_i` be `P_space` after applying the slowdown rewrite rule with factor `prod_factor_i` rule to each operator in `P_space`.
    1. If `area(P_i)` is less than `area_max`, stop. `P_i` is `P_st_optimal`
1. If reached this point, fail as not able to fit program on chip even when fully slowed.

## Auto-Scheduler Correctness
We must prove that the auto-scheduling algorithm:

1. preserves time matching - **Pat: do we need to show this?**
2. preserves producer-consumer rate matching
3. trades-off time and area. Applying the slowdown rewrite rules decrease time without decreasing area. **Note: this can't be proven, see below.**
4. fins the maximum throughput schedule given resources constraints

### Slowdown Impact On Time And Area
Before proving the properties, we must formalize the impact of the slowdown rewrite rule on length, time, throughput.

1. **Length** - Inspecting the rewrite rules shows that length is unaffected by slowdown.
1. **Time** - Inspecting the rewrite rules shows that time is increased by slowdown `factor`. Formally, this is:
    - `time(slowdown(f, factor)) = time(f) * factor` 
1. **Throughput** - Since throughput is computed based on length and time:
    - `throughput(slowdown(f, factor)) = length(slowdown(f, factor)) / time(slowdown(f, factor)) =`
    - `length(f) / (time(f) * factor) = throuhgput(f) / factor`

**I don't know how to prove these statements.**

### Time Matching
We will show that all pipelines in the space-time IR that are produced by the auto-scheduler satisfy the time matching constraint.

1. `P_seq`. It has no time property.
1. `P_space` is fully parallel. For each operator `f_space` in `P_space`, `time(f_space) = 1`.
1. We will prove that `time(f_i)` is equal for all operators `f_i` in `P_i`. 
    1. Let `f_i` be the one or more operators produced by applying the slowdown rewrite rule to `f_space`: `f_i = slowdown(f_space, prod_factor_i)`.
    1. `time(f_space) = 1`
    1. `time(f_i) = prod_factor_i`
    1. All operators take same amount of time.
1. All operators in pipeline take same amount of time.

### Rate matching
We will show that all pipelines in the space-time IR that are produced by the auto-scheduler satisfy the producer-consumer rate matching constraint.

1. `P_seq`. It has no rate property.
1. `P_space` is fully parallel. We will prove that, for each pair of operators `g_space . f_space` in `P_space`, `input_throughput(g_space) == output_throughput(f_space)`.
    1. Let `f_seq` be an operator in `P_seq`. 
    1. Let `f_space` be the one or more operators produced by applying the sequence to space rewrite rule to `f_seq`.
    1. `time(f_space) = 1`.
    1. `input_length(f_space) = input_length(f_seq)` and `output_length(f_space) = output_length(f_seq)`, as noted in the [length property](#length) section.
    1. For any composition of operators `g_seq . f_seq`, `input_length(g_seq) == output_length(f_seq)`, as noted in the [sequence length property](#length-property) section.
    1. For the corresponding `g_space . f_space`, `input_length(g_space) == output_length(f_space)`.
    1. Also, `input_throughput(g_space) == output_throughput(f_space)`.

    ```
    input_throughput(g_space) == 
    input_length(g_space) / time(g_space) == 
    output_length(f_space) / time(f_space) == 
    output_throughput(f_space)
    ```

1. We will prove that, for each pair of operators `g_i . f_i` in `P_i`, `input_throughput(g_i) == output_throughput(f_i)`.
    1. For each `f_space`, let `f_i` be the one or more operators produced by applying the slowdown rewrite rule to `f_space`: `f_i = slowdown(f_space, prod_factor_i)`.
    1. `time(f_space) = 1`
    1. `time(f_i) = prod_factor_i`
    1. `input_length(f_i) = input_length(f_space)`
    1. `output_length(f_i) = output_length(f_space)`
    1. For all `g_i . f_i`, `input_throughput(g_i) == output_throughput(f_i)`.
    ```
    input_throughput(g_i) == 
    input_length(g_i) / time(g_i) == 
    input_length(g_space) / prod_factor_i == 
    output_length(f_space) / prod_factor_i == 
    output_length(f_i) / time(f_i) == 
    output_throughput(f_i)
    ```

All producer-consumer throughputs match in all pipelines.

### Time-Area Tradeoffs
Show for each operator that time value goes up, resources go down by evaluating the resources operator for each one

**Negative** - I don't think this can actually be proven. Increasing time increases area for `up_1d`. `up_1d_s` requires no memory area. `up_1d_t` requires memory. 

**Positive** - We still can have a linear search (following the common factors). The auto-scheduler provided above does this. It finds the most parallel implementation that fits on the target chip.

### Maximum Throughput Given Resource Constraints
This is the same proof as in the paper. I'm not going to reproduce here as it is not good. We already agreed it was too wordy.

# Miscellaneous Notes
### Type Atoms
`type_atom` is the atom type used in a potentially nested `TSeq` or `SSeq`.

1. `type_atom(Int) = Int`
1. `type_atom(t x t') = t x t'`
1. `type_atom(SSeq n t) = type_atom(t)`
1. `type_atom(TSeq n t) = type_atom(t)`

`input_atom(f)` and `output_atom(f)` provide the syntax for applying `type_atom` to an operator.

1. `input_atom(f :: t -> t') = type_atom(t)`
1. `output_atom(f :: t -> t') = type_atom(t')`

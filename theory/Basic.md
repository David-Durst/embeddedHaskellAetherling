# Basic Sequence Language Theory
Aetherling is a system for compiling data flow pipelines to efficient implementations in hardware accelerators.
Aetherling programs are written in a **sequence language**, a standard functional programming language.
These programs cannot be interpreted as hardware accelerators.
Aetherling transforms these programs into a **space-time IR** that models the throughput and resource requirements of the corresponding hardware implementations.
An auto-scheduler uses semantics-preserving transformations in the IR to find the maximally implementation given hardware constraints.
**From Paper** - were going to have a sequence language, goinkog to lower it to a spcae time ir so all programs in space-tiem ir are compilable to hardware. We will then provide an algorithm for finding amximal scheudle for hardware given reosurce constraints.

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

**Pat** - Is this enough of a callout to the fact that `Seq` is a functor? I really dislike making it its own section. Making a whole section about `Seq` due to it being a functor overplays its differences from the other types. Both `t x t'` and `t -> t'` are also functors when one type is applied.

## Sequence Operators
1. `Map n :: (t -> t') -> Seq n t -> Seq n t'`
1. `Map2 n :: (t -> t' -> t'') -> Seq n t -> Seq n t' -> Seq n t''`
3. `Up_1d n :: Seq 1 t -> Seq n t`
4. `Down_1d n :: Seq n t -> Seq 1 t`
7. `Partition no ni :: Seq (no*ni) t -> Seq no (Seq ni t)`
7. `Unpartition no ni :: Seq no (Seq ni t) -> Seq (no*ni) t`

Note: Seq is also an applicative functor. Aetherling's `Map2` is equivalent to Haskell's `liftA2` for applicative functors. I will not put this note in final paper. This note is here to justify to Pat and Kayvon why `Map2` is a standard Haskell function.

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
Unpartition no ni . Partition no ni == Id
Partition no ni . Unpartition no ni == Id
```

The following commutativity diagram shows the relationship between functions on isomorphic types. 

![General Isomorphism Diagram](isomorphism_general.png "General Isomorphism Diagram")

Specializing this diagram for `Seq` proves:
1. For any function `f :: Seq (no*ni) t -> Seq (no*ni) t` there is a function `f' :: Seq no (Seq ni t) -> Seq no (Seq ni t')`. 
1. The inputs and outputs of `f` and `f'`  are equivalent up to isomorphism. 

We can repeatedly apply this isomorphism to convert between a flat `Seq` and any arbitrarily nested `Seq`

We will use these isomorphisms to prove the existence of Aetherling's [rewrite rules](#rewrite-rules) that:
1. lower from the sequence language into the space-time IR.
1. schedule programs in the space-time IR.

# Space-Time IR
Aetherling lowers the sequence language to a space-time IR. 
Programs in the IR are **scheduled**: the parallelism of each operators is specified. 
An operator can be parallel (scheduled in space) or sequential (scheduled in time).
All programs in the space-time IR can be interpreted as efficient hardware accelerators with the following properties: all operators correspond to hardware components that run in parallel with minimal buffering between components.

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

Since they are isomorphic, any `f :: Seq n t -> Seq m t'` function must have contextually equivalent versions `f_t :: TSeq n v t -> TSeq m u t'` and `f_s :: SSeq n t -> SSeq m t'`.
This is proven in the same way as shown in [the `Seq` isomorphism section.](#sequence-isomorphisms**

We will use these isomorphisms to produce the rewrite rules that lower programs from the sequence language to the space-time IR.

## Operators

1. `Id :: t -> t`
1. `Const_Gen :: t -> () -> t`
1. `Add :: (Int x Int) -> Int`
1. `Fst :: (t x t') -> t`
1. `Snd :: (t x t') -> t'`
5. `Zip :: t1 -> t2 -> t1 x t2`
1. `Map_s n f :: (t -> t') -> SSeq n t -> SSeq n t'`
2. `Map_t n f :: (t -> t') -> TSeq n v t -> TSeq n v t'`
2. `Map2_s n f :: (t -> t' -> t'') -> SSeq n t -> SSeq n t' -> SSeq n t''`
2. `Map2_t n f :: (t -> t' -> t'') -> TSeq n v t -> TSeq n v t' -> TSeq n v t''`
1. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
3. `Up_1d_t n :: TSeq 1 (n+v-1) t -> TSeq n v t`
4. `Down_1d_s n :: SSeq n t -> SSeq 1 t`
4. `Down_1d_t n :: TSeq n v t -> TSeq 1 (n+v-1) t`
5. `Partition_tt no ni :: TSeq (no*ni) (vo*vi) t -> TSeq no vo (TSeq ni vi t)`
5. `Unpartition_tt no ni :: TSeq no vo (TSeq ni vi t) -> TSeq (no*ni) (vo*vi) t`
5. `Partition_ts no ni :: TSeq 1 (no + v - 1) (SSeq (no*ni) t) -> TSeq no v (SSeq ni t)`
5. `Unpartition_ts no ni :: TSeq no v (SSeq ni t) -> TSeq 1 (no + v - 1) (SSeq (no*ni) t)`
5. `Partition_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t)`
5. `Unpartition_ss no ni :: SSeq no (SSeq ni t) -> SSeq 1 (SSeq (no*ni) t)`

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

1. `area(Map_s n f) = n * area(f)`
2. `area(Map_t n f) = area(f)`
1. `area(Map2_s n f) = n * area(f)`
2. `area(Map2_t n f) = area(f)`
1. `area(Id) = {0, 0, 0}`
1. `area(Const_Gen n) = {0, num_bits(Int), num_bits(Int)}`
1. `area(Add) = {num_bits(Int), 0, num_bits(Int)}`
5. `area(Zip) = area(Fst) = area(Snd) = area(Add_Unit) = {0, 0, 0}`
1. `area(Up_1d_s n) = {0, 0, n * num_bits(t)}`
1. `area(Up_1d_t n) = {0, num_bits(t), num_bits(t)} + area(counter)`
1. `area(Down_1d_s n) = {0, 0, num_bits(t)}`
1. `area(Down_1d_t n) = {0, num_bits(t), num_bits(t)} + area(counter)`
1. `area(Partition_ts no ni) = {0, ((no-1) * ni) * num_bits(t), ni * num_bits(t)} + area(counter)`
1. `area(Unpartition_ts no ni) = {0, ((no-1) * ni) * num_bits(t), (no * ni) * num_bits(t)} + area(counter)`
1. `area(Partition_ss no ni) = {0, 0, 0}`
1. `area(Unpartition_ss no ni) = {0, 0, 0}`
1. `area(g.f) = area(g) + area(f)`

Many of the sequential operators require a counter to track clock cycles.
1. `area(counter) = {num_bits(Int), num_bits(Int), num_bits(Int)}`

### Empty Periods
Empty periods enable Aetherling to express (1) operators with different input and output throughputs and (2) schedules with underutilization.
**david - figure out how to say this with different throuhgputs**
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
    
Operators that have different inputwith empty periods are expressed in the type system using the `v` parameter of `TSeq n v t`. 
As a reminder:
- `n` is number of utilized periods.
- `v` is number of empty periods. 
- An operator with a `TSeq` output type emits `n` values of type `t` over `n+v` periods.

Operators does not accept or emit data during empty periods. 
### Space-Time Isomorphisms
Just like [`Partition` and `Unpartition` for `Seq`](#sequence-isomorphisms), the partitions and unpartitions in the space-time IR form isomorphisms between nested combinations of `TSeq` and `SSeq`.

These isomorphisms, along with those between `Seq` and `SSeq` and between different `Seq` nestings, mean that any `f :: Seq n t -> Seq m t'` function must have contextually equivalent versions with any nesting of `TSeq`s and `SSeq`s. 
The different nestings are different schedules. 
`f :: SSeq (no*ni) t -> SSeq (no*ni) t` is more parallel than `f :: TSeq (no*ni) 0 t -> TSeq (no*ni) 0 t`.
`f :: TSeq no (SSeq ni t) -> TSeq no (SSeq ni t)` is a schedule that trades off parallelism and area.
It is more parallel than the pure `TSeq` schedule, but uses fewer resources than the `SSeq` schedule.

# Rewrite Rules
The rewrite rules show how to use the above isomorphisms to schedule Aetherling operators. 
Each operator in the sequence language is rewritten as a contextually equivalent, fully parallel operator in the space-time IR.
Then, this operator is converted to a less parallel one in order to trade off area and throughput.

### Map
1. Sequence To Space - `Map n f -> Map_t 1 (Map_s n f)`
    1. `Map n f :: Seq n t -> Seq n t'`
    1. `Map_t 1 (Map_s n f) :: TSeq 1 0 (SSeq n t) -> TSeq 1 0 (SSeq n t')'`
1. Slowdown - `Map_t 1 (Map_s (no*ni) f) -> Unpartition_ts no ni . Map_t no (Map_s ni f) . Partition_ts no ni`
    1. `Map_t 1 (Map_s (no*ni) f) :: TSeq 1 _ (SSeq (no*ni) t) -> TSeq 1 _ (SSeq (no*ni) t)'`
    1. `Map_t no (Map_s ni f) :: TSeq no v (SSeq ni t) -> TSeq no v (SSeq ni t')`
    1. `Unpartition_ts no ni . Map_t no (Map_s ni f) . Partition_ts no ni :: TSeq 1 _ (SSeq (no*ni) t) -> TSeq 1 _ (SSeq (no*ni) t)'`
    
`Map2` has the same rewrite rules as `Map`.

Note: I dropped the underutilization computation from `TSeq` where it became onerous.

### Upsample
1. Sequence To Space - `Up_1d n === Map_t 1 (Up_1d_s n)`
    1. `Up_1d n :: Seq 1 t -> Seq n t`
    1. `Map_t 1 (Up_1d_s n) :: TSeq 1 0 (SSeq 1 t) -> TSeq 1 0 (SSeq n t)`
1. Slowdown by no - `Map_t 1 (Up_1d_s (no*ni)) === Unpartition_ts no ni . Map_t no (Up_1d_s ni) . Up_1d_t no . Partition_ts 1 1`
    1. `Map_t 1 (Up_1d_s (no*ni)) :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (no*ni) t)`
    1. `Map_t no (Up_1d_s ni) :: TSeq no (SSeq 1 t) -> TSeq no (SSeq ni t)`
    1. `Up_1d_t no :: (TSeq 1 (SSeq 1 t)) -> (TSeq no (SSeq 1 t))`
    1. `Unpartition_ts no ni . Map_t no (Up_1d_s ni) . Up_1d_t no . Partition_ts 1 1 :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (no*ni) t)`

### Downsample
1. Sequence To Space - `Down_1d n === Map_t 1 (Down_1d_s n)`
    1. `Down_1d n :: Seq n t -> Seq 1 t`
    1. `Map_t 1 (Down_1d_s n) :: TSeq 1 0 (SSeq n t) -> TSeq 1 0 (SSeq 1 t)`
1. Slowdown by no - `Map_t 1 (Down_1d_s (no*ni)) === Unpartition_ts 1 1 . (Map_t 1 (Down_1d_s ni)) . Down_1d_t no . Partition_ts no ni`
    1. `Map_t 1 (Down_1d_s (no*ni)) :: TSeq 1 _ (SSeq (no*ni) t) -> TSeq 1 _ (SSeq 1 t)`
    1. `Map_t 1 (Down_1d_s ni) :: TSeq 1 (SSeq ni t) -> TSeq 1 (SSeq 1 t)`
    1. `Down_1d_t no :: (TSeq no (SSeq ni t)) -> (TSeq 1 (SSeq ni t))`
    1. `Unpartition_ts 1 1 . (Map_t 1 (Down_1d_s ni)) . Down_1d_t no . Partition_ts no ni :: TSeq 1 _ (SSeq (no*ni) t) -> TSeq 1 _ (SSeq 1 t)`

### Unpartition/Partition Removal
1. `Partition_ts no ni . Unpartition_ts no ni === Id`
**Danger: `Partition_ts . Unpartition_ts` is not really Id in Space-Time. There will be underutilized clocks here. The partition_tsing and unpartition_tsing takes n clocks. However, the interface to both of these functions is just an `SSeq`. The `SSeq` doesn't account for time.**
2. `Unpartition_ts no ni . Partition_ts no ni === Id`

The same removal rule can be used for `Partition_tt`/`Unpartition_tt` and `Partition_ss`/`Unpartition_ss**.

## Auto-Scheduler Algorithm
The following algorithm finds the schedule with the maximum throughput given a specified resource constraints.
1. Inputs: 
    1. `P_seq`: a program in the sequence language. 
    1. `area_max`: a resource constraint in area.
1. Outputs
    1. `P_st_optimal`: a program in the space-time IR with maximum throughput given resource constraints.

Algorithm:
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

# Basic Sequence Language Theory
This language has the most simple types and operators necessary to get multi-rate pipelines

# Sequence Language
The sequence language is a combinator language for data flow programs with standard functional programming operators. 
Program in the language are **unscheduled**: it is unspecified whether operations occur in parallel or in sequence. 
There is no clear interpretation of programs as hardware accelerators.

## Types
There are two collection types, tuples and sequences. A tuple enables the unary, combinator operators to accept multiple arguments. A sequence shows how many elements an operator processes. 

1. `Int` - integer
2. `Tuple n t` - homogeneous ntuple
2. `t x t'` - heterogeneous tuple
3. `Seq n t` - homogeneous, fixed-length sequence
4. `t -> t'` - function

## Type Constructors
These create types from other types. They are modeled after Haskell's type families.
1. `Merge_Seqs (t1 :: Seq n t) (t2 :: Seq n t') = Seq n (Merge_Seqs t t')`
1. `Merge_Seqs (t1 :: Int Or Tuple Or ()) (t2 :: Int Or Tuple Or ()) = t1 x t2`
1. `Merge_Seqs _ _ = Error`
1. `Add_Unit_To_Type (t :: Seq n t) = Seq n (Add_Unit_To_Type t)`
1. `Add_Unit_To_Type (t :: Int Or Tuple Or ()) = t x ()`

## Sequence Operators
1. `Id :: t -> t`
1. `Const_Gen n :: () -> Int`
1. `Add :: (Int x Int) -> Int`
2. `Map n :: (t -> t') -> Seq n t -> Seq n t'`
3. `Up_1d n :: Seq 1 t -> Seq n t`
4. `Down_1d n :: Seq n t -> Seq 1 t`
5. `Fork_Join (f :: t1 -> t1') (g :: t2 -> t2') :: (Merge_Seqs t1 t2) -> (Merge_Seqs t1' t2')`
6. `Add_Unit t :: t -> (Add_Unit_To_Type t)`
7. `Partition n m :: Seq (n*m) t -> Seq n (Seq m t)`
7. `Unpartition n m :: Seq n (Seq m t) -> Seq (n*m) t`

# Space-Time IR
The space-time IR defines how to interpret the data flow programs as hardware accelerators. 
Programs in the IR are **scheduled**: the parallelism of all operators is specified. 
An operator can be parallel (scheduled in space) or sequential (scheduled in time).

## Single-Rate Pipelines
A rate (or throughput) is the average number of `Int`s per clock when processing a sequence.
Operators and pipelines have both input throughputs and output throughputs.
A **single-rate pipeline** is a pipeline of operators in which all input and output throughputs are equal. 

### Single-Rate Space-Time Types
Sequences are scheduled as space-sequences (`SSeq`) and time-sequences (`TSeq`). 

3. `SSeq n t` - homogeneous, fixed-length sequence in space. This sequence is parallel.
    1. An `SSeq` takes 1 period and materializes `n` values of type `t` in that period.
3. `TSeq n v t` - homogeneous, fixed-length sequence in time. This sequence is sequential.
    1. `n` is number of utilized periods. `v` is number of empty periods. We will explain the `v` parameter more when we get to multi-rate pipelines
    1. A `TSeq` materializes `n` values of type `t` over `(n+v) * periods to process one t` periods.

An empty period is one in which the sequence does not produce new data. `v` enables Aetherling to (1) match input and output time lengths and (2) express schedules with underutilization 
1. An operator's input and output `TSeq`s must take the same amount of time. The empty clocks allow matching the input and output time lengths. 
    1. Multi-rate operators demonstrate the need for the empty clocks. `Up_1d_t` takes in one input and then repeats it multiple times. While the output sequence is busy emitting data, the input cannot accept the next input. Otherwise, the `Up_1d_t` will bottleneck
1. Underutilized hardware is hardware that is unused on some clock cycles.
An operator with an input or output `TSeq` that has a non-zero `v` will receive or produce no input on those clocks. The operator may do nothing during those clocks, and be underutilized, depending on the operator. 
    1. For example, if `Map_t 1 Add` had any empty clocks, the `Add` would be underutilized.

        
### Single-Rate Space-Time Operators
2. `Map_s n f :: (t -> t') -> SSeq n t -> SSeq n t'`
2. `Map_t n f :: (t -> t') -> TSeq n v t -> TSeq n v t'`

## Multi-Rate Pipelines
A **multi-rate pipeline** is a pipeline of operators in which all input and output throughputs are not equal. 
If two functions are composed (such as `g . f`), the output throughput of the producer function `f` must equal the input of the consumer function `g`.
This requirement is known as **producer-consumer rate matching**.

We require producer-consumer rate matching to ensure all pipelines compile to efficient hardware accelerators. 
Hardware accelerators are efficient if they use minimal compute and storage resources. Matching rates ensures enables minimizes these resources. 
1. **Compute** - matching rates ensures all nodes run at the exact rate required by their upstream producers and downstream consumers. 
Thus, all operators are implemented using the minimal parallelism necessary to achieve the target throughput. 
(**Note:** this assumes that higher throughput operators requires more resources and lower throughput ones requires less resources.)
1. **Storage** - matching rates ensure that nodes can perform streaming computation. 
As soon as a producer emits data, the consumer can start operating on it without buffering. 
No buffering between operators means minimal storage resources. 

### Mutli-Rate Space-Time Types
Multi-rate modules are expressed in the type system using the `v` parameter of `TSeq n v t`. 
As a reminder:
- `n` is number of utilized periods.
- `v` is number of empty periods. 
- A `TSeq` materializes `n` values of type `t` over `(n+v) * periods to process one t` periods.

An empty period is one in which the sequence does not process new data. `v` enables Aetherling to (1) match input and output time lengths and (2) express schedules with underutilization 
1. An operator's input and output `TSeq`s must take the same amount of time. The empty clocks allow matching the input and output time lengths. 
    1. For example, `Up_1d_t` takes in one input on one clock cycle and then repeatedly outputs it for multiple clock cycles. 
    While the output is busy emitting data, the input cannot accept the next value. 
    The empty clocks indicate this waiting period so that the input and output `TSeq`s take the same amount of time.
1. Underutilized hardware is hardware that is unused on some clock cycles.
An operator with an input or output `TSeq` that has a non-zero `v` will receive or produce no input on those clocks. 
The operator may do nothing during those clocks, and be underutilized, depending on the operator. 
    1. If `Map_t 1 Add` had any empty clocks, it would be underutilized. 
    This is unlike `Up_1d_t`. 
    It is operator specific whether empty clocks mean underutilization or waiting while processing occurs.
    1. Underutilization is necessary to compose operators in multi-rate pipelines. 
    Consider `Up_1d_t 4 . Map_t 1 Add`.
    `Map_t` must emit an output every fourth clock so that its output throughput matches `Up_1d_t`'s input throughput.
    To accomplish this rate matching, `Map_t` must be underutilized by adding empty clocks to its `v` parameter.

### Multi-Rate Space-Time Operators
3. `Up_1d_s n :: SSeq 1 t -> SSeq n t`
3. `Up_1d_t n :: TSeq 1 (n+v-1) t -> TSeq n v t`
4. `Down_1d_s n :: SSeq n t -> SSeq 1 t`
4. `Down_1d_t n :: TSeq n v t -> TSeq 1 (n+v-1) t`
5. `Partition n m :: TSeq 1 (n + v - 1) (SSeq (n*m) t) -> TSeq n v (SSeq m t)`
5. `Unpartition n m :: TSeq n v (SSeq m t) -> TSeq 1 (n + v - 1) (SSeq (n*m) t)`


## Rewrite Rules
### Map
1. Sequence To Space - `Map n f -> Map_t 1 (Map_s n f)`
    1. `Map n f :: Seq n t -> Seq n t'`
    1. `Map_t 1 (Map_s n f) :: TSeq 1 0 (SSeq n t) -> TSeq 1 0 (SSeq n t')'`
1. Slowdown - `Map_t 1 (Map_s (n*m) f) -> Unpartition n m . Map_t n (Map_s m f) . Partition n m`
    1. `Map_t 1 (Map_s (n*m) f) :: TSeq 1 _ (SSeq (n*m) t) -> TSeq 1 _ (SSeq (n*m) t)'`
    1. `Map_t n (Map_s m f) :: TSeq n v (SSeq m t) -> TSeq n v (SSeq m t')`
    1. `Unpartition n m . Map_t n (Map_s m f) . Partition n m :: TSeq 1 _ (SSeq (n*m) t) -> TSeq 1 _ (SSeq (n*m) t)'`
    
Note: I dropped the underutilization computation from `TSeq` where it became onerous.

### Upsample
1. Sequence To Space - `Up_1d n -> Map_t 1 (Up_1d_s n)`
    1. `Up_1d n :: Seq 1 t -> Seq n t`
    1. `Map_t 1 (Up_1d_s n) :: TSeq 1 0 (SSeq 1 t) -> TSeq 1 0 (SSeq n t)`
1. Slowdown - `Map_t 1 (Up_1d_s (n*m)) -> Unpartition n m . Map_t n (Up_1d_s m) . Up_1d_t n . Partition 1 1`
    1. `Map_t 1 (Up_1d_s (n*m)) :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (n*m) t)`
    1. `Map_t n (Up_1d_s m) :: TSeq n (SSeq 1 t) -> TSeq n (SSeq m t)`
    1. `Up_1d_t n :: (TSeq 1 (SSeq 1 t)) -> (TSeq n (SSeq 1 t))`
    1. `Unpartition n m . Map_t n (Up_1d_s m) . Up_1d_t n . Partition 1 1 :: TSeq 1 _ (SSeq 1 t) -> TSeq 1 _ (SSeq (n*m) t)`

### Downsample
1. Sequence To Space - `Down_1d n -> Map_t 1 (Down_1d_s n)`
    1. `Down_1d n :: Seq n t -> Seq 1 t`
    1. `Map_t 1 (Down_1d_s n) :: TSeq 1 0 (SSeq n t) -> TSeq 1 0 (SSeq 1 t)`
1. Slowdown - `Map_t 1 (Down_1d_s (n*m)) -> Unpartition 1 1 . (Map_t 1 (Down_1d_s m)) . Down_1d_t n . Partition n m`
    1. `Map_t 1 (Down_1d_s (n*m)) :: TSeq 1 _ (SSeq n t) -> TSeq 1 _ (SSeq 1 t)`
    1. `Map_t 1 (Down_1d_s m) :: TSeq 1 (SSeq m t) -> TSeq 1 (SSeq 1 t)`
    1. `Down_1d_t n :: (TSeq n (SSeq m t)) -> (TSeq 1 (SSeq m t))`
    1. `Unpartition 1 1 . (Map_t 1 (Down_1d_s m)) . Down_1d_t n . Partition n m :: TSeq 1 _ (SSeq n t) -> TSeq 1 _ (SSeq 1 t)`

### Unpartition/Partition Removal
1. `Partition n m . Unpartition n m = Id`
**Danger: `Partition . Unpartition` is not really Id in Space-Time. There will be underutilized clocks here. The partitioning and unpartitioning takes n clocks. However, the interface to both of these functions is just an `SSeq`. The `SSeq` doesn't account for time.**
2. `Unpartition n m . Partition n m = Id`

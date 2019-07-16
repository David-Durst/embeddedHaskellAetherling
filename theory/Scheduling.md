# Scheduling
The goal of this document is:
1. Define scheduling
1. List the motivating examples for the scheduling algorithm
1. Define the scheduling algorithm
   
# Scheduling Definition
Scheduling is converting a program from the sequence language to the space-time IR.
Scheduling is performed to target a specific `input_throughput` and `output_throughput`
as defined in [the basic theory document's throughput section.](Basic.md#throughput).
The target is specified using a **slowdown factor s**.
Scheduling with factor **s** means produce a pipeline with `input_throughput` and
`output_throughput` that are **s** times smaller than the fully parallel pipeline's
`input_throughput` and `output_throughput`.

# Motivating Examples

## Basic Example
This example shows the simplest pipeline that can be scheduled.

Attainable s are `s = 1, 2,4`
```
Map 4 Abs
```

## Nested Multi-Rate
**This example demonstrates the first issue the scheduler faces: where to distribute invalid clocks when connecting to a nested, multi-rate operator.**

### Upsample Outer
The first example is a multi-rate where the `Up_1d` is on the outer seq.
For this example, the scheduler should know to slow down the outer `Map`.
Attainable s are `1, 2, 4`
```
Map 1 (Map 4 Abs) >>> Up_1d 4
```

Slowing down the outer `Map` produces 
```
Map_t 1 (Map_s 4 Abs) >>> Up_1d_t 4
```
which is much more efficient than slowing down the inner `Map`
```
Map_s 1 (Map_t 4 Abs) >>> Up_1d_s 4
```

### Upsample Inner
The first example is a multi-rate where the `Up_1d` is on the inner seq.
For this example, the scheduler should know to slow down the inner `Map`.
```
Map 4 (Map 1 Abs) >>> Map 4 (Up_1d 4)
```

Slowing down the inner `Map` produces 
```
Map_s 4 (Map_t 1 Abs) >>> Map_s 4 (Up_1d_t 4)
```
which is much more efficient than slowing down the outer `Map`
```
Map_t 4 (Map_s 1 Abs) >>> Map_t 4 (Up_1d_s 4)
```

### Solution:
This problem is solved by computing the number of invalid clocks for each operator
in a pipeline in it's "slowest" implementation.

For the **Upsample Outer** example, the outer `Map` can have 3 invalid clocks while the inner 
`Map` can have 0 invalid clocks. Thus, the outer `Map` will be slowed.

For the **Upsample Inner** example, the inner `Map` can have 3 invalid clocks while the outer
`Map` can have 0 invalid clocks. Thus, the inner `Map` will be slowed.

## Partition
**This example demonstrates the second issue the scheduler faces: how to maintain appropriate nesting when scheduling a `Partition` or `Unpartition`**

### Single Nesting
The first example is a single `Partition`.
Attainable s are `1, 2, 3, 5, 6, 10, 15, 30`
```
Partition 3 10
```

Slowing down the output by `s=5` yields:
```
Map_s 3 Id :: SSeq 3 (TSeq 5 0 (SSeq 2 a)) -> SSeq 3 (TSeq 5 0 (SSeq 2 a))
```
This means that the input is nested twice from `Seq 30 a` to `SSeq 3 (TSeq 5 0 (SSeq 2 a))`
and the output is nested once from `Seq 3 (Seq 10 a)` to `SSeq 3 (TSeq 5 0 (SSeq 2 a))`.

This will create problems when slowing down earlier parts of the pipeline as now the algorithm has to nest each operator not just once, but n+1 times where n is the number `Partition`s down pipeline from an operator.

I couldn't produce a space-time expression with two levels of nesting on the input and three levels of nesting on the output without a new operator as:
1. If I had chosen the operator `Map_s 3 (Partition_t_tt 5 2 >>> Deserialize 5 2)`, that would have prevented the 
upstream operators from being appropriately partially parallel.
The input to that operator is `SSeq 3 (TSeq 10 0 a)`, which is slowdown `s=10`, not `s=5`.
2. If I had chosen the operator `Partition_s_ss 3 2 :: SSeq 6 (TSeq 5 a) -> SSeq 3 (SSeq 2 (TSeq 5 a))`,
That would have been a non-canonical form as `SSeq` wraps `TSeq`.

The second approach won't work as a standard, canonical form-following algorithm won't
be able to produce it for examples such as:

```
Partition 3 10 >>> Map 3 (Map 10 Abs)
```

For this example, `s=5` scheduling will first rewrite the `Map` to `Map_s 3 (Map_t 5 (Map_s 2 Abs))`.
Then, the `Partition_s_ss 3 2` can't be connected as the types mismatch
```
INVALID: Partition_s_ss 3 2 >>> Map_s 3 (Map_t 5 (Map_s Abs))
```

**Answer:** I flip the `TSeq` and inner `SSeq` with a new operator:
```
Partition_s_ss 3 2 >>> Map_s 3 (Flip_ts_to_st 5 2) >>> Map_s 3 (Map_t 5 (Map_s Abs))
```

So I need a rewrite rule that, if I need to nest the inner `Seq` produced by `Partition`, need to append `Flip_ts_to_st` to `Partition_s_ss`

Note: `Flip` is not transpose. It doesn't change the order or elements. It changes nesting. Therefore, it compiles only to wires in hardware. 

### Multi-Layer Nesting
The second examples are repeated multiple `Partition`s.
Attainable s include `1, 2, 3, 5, 6, 10, 15, 30`
```
Partition 7 30 >>> Map 7 (Partition 3 10)
```

Using the `Flip_xx` operators, slowing down the output by `s=5` yields:
```

Flip_st_to_ts 42 5
Partition_s_ss 7 6 >>> 
Map_s 7 (Flip_ts_to_st 5 6) >>>
Map_s 7 ( 
    Flip_st_to_ts 6 5 >>>
    Partition_s_ss 3 2 >>> 
    Map_s 3 (Flip_ts_to_st 5 2))
```

### Multi-Layer Nesting With Multiple Nests
The third example is repeated multiple `Partition`s with multiple splits
Attainable s include `35`
```
Partition 77 30 >>> Map 77 (Partition 3 10)
```

Using the `Flip_xx` operators, slowing down the output by `s=35` yields:
```
Partition_t_tt 7 5 >>>
Map_t 7 (Flip_st_to_ts 42 5)
Map_t 7 (Partition_s_ss 11 6) >>> 
Map_t 7 (Map_s 11 (Flip_ts_to_st 5 6)) >>>
Map_t 7 ( Map_s 11 (
    Flip_st_to_ts 6 5 >>>
    Partition_s_ss 3 2 >>> 
    Map_s 3 (Flip_ts_to_st 5 2)))
```
The extra `Partition_t_tt` ensures that the input to the `Partition` is split once for the `TSeq` outer and `SSeq` inner, not twice.

### Unpartition Equivalents
These examples repeat the above ones with `Unpartition`.
They show that replacing `Partition` with it's symmetric operator doesn't introduce new problems.
Attainable s are `1, 2, 3, 5, 6, 10, 15, 30`
```
Unpartition 3 10 >>> Map 30 Abs
```

Slowing down the output with `s=5` yields
```
Unparition_s_ss 3 2 >>> Flip_ts_to_st 5 6 >>> 
Map_t 5 (Map_s 6 Abs)
```

This requires a rewrite rule that if using `Unparition` where the inputted `TSeq` is not adjacent to it's `SSeq`, I must keep the split factors adjacent by applying a `Flip_ts_to_st`

This is necessary in this example as upstream operators will be depending on dealing with an outer `Seq 3` and an inner `Seq 10`.

For example:
```
Map 3 (Map 10 Abs) >>> Unpartition 3 10 >>> Map 30 Abs
```

Without the `Flip_ts_to_st 5 6`, I would have been required to perform the following, 
more complicated rewrite where I nest the `Map 10 Abs` to `Map 5 (Map 2 Abs)` and then lift the `Map 5` around the surrounding `Map 3`:
```
Map_t 5 (Map_s 3 (Map_s 2 Abs)) >>>
Map_t 5 (Unparition_s_ss 3 2) >>> 
Map_t 5 (Map_s 6 Abs)
```

# Scheduling Algorithm
The algorithm for scheduling a program P with a throughput factor s is:
1. Let T_O be the output type of P
1. Let T_OT be the output type of P if it is scheduled fully in time - each operator is made as temporal as possible while ensuring that the bottleneck is fully utilized.
1. T\_OT will be T\_O where each `Seq n t` is replaced by `TSeq n i t`
1. Compute the scheduled version of T\_O, T\_OS, using the below algorithm:
```
s_remaining_factors = prime_factorization(s)
T_OS = []
for (TSeq n i) in layers(T_OT):
   n_factors = prime_factorization(n)
   n_i_factors = prime_factorization(n+i)
   if S.is_subset_of n_i_factors s_remaining_factors == 0:
       s_remaining_factors = Set.difference s_remaining_factor n_i_factors
       T_OS += TSeq n i
   else if Set.intersect s_remaining_factors n_factors != Set.empty:
       cur_layer_slowdown_factors = Set.intersect s_remaining_factors n_factors 
       cur_layer_slowdown = product cur_layer_slowdown_factors
       cur_layer_parallel_factors = Set.difference n_factors cur_layer_slowdown_factors
       cur_layer_parallel = product cur_layer_parallel_factors
       s_remaining_factors = Set.difference s_remaining_factors cur_layer_slowdown_factors
       T_OS += Split(TSeq cur_layer_slowdown 0, SSeq cur_layer_parallel)
   else 
       T_OS += SSeq n
```
1. Next, feed this output backwards through the graph. Each operator gets T\_OS and is nested according the Sequence To Space-Time rewrite rules.
    1. We require that each operator accept and emit each layer split at most once.
    1. T\_IS is the same data structure as T\_OS, but it is produced from the rewritten operators and passed back
```
T_OS
T_IS = apply_rewrite_rules(T_OS, f)

apply_rewrite_rules(T_OS, f) =
   if T_OS[0] == SSeq n:
       sequence_to_fully_parallel(f)
   else if T_OS[0] == TSeq n i:
       sequence_to_fully_sequential(f)
   else:
       sequence_to_partially_parallel(f, T_OS[0])
   if f is nested:
     f_inner = get_inner(f)
     apply_rewrite_rules(T_OS[1:], f_inner)

```

#  Garbage Below

## Distributive Property
I require that `schedule(g . f, s) === schedule(g, s) . schedule(f, s)`.
The benefit of the distributive property is that it simplifies the scheduler. 
The scheduler only needs to consider a single operator at a time.

The downside of the distribute property is that it prevents `schedule` from accepting standard sequence language programs as input.
The `Seq` types contain too little information for `schedule` to satisfy the distributive property.
For example:
1. Let `f = Map 1 (Map 1 Abs) :: Seq 1 (Seq 1 Int) -> Seq 1 (Seq 1 Int)`. 
1. Let `g = Up_1d 4 :: Seq 1 (Seq 1 Int) -> Seq 4 (Seq 1 Int)`
1. The goal is `schedule()`
1. `schdule(f, 4) = Up_1d_t 4`
1. There are multiple options for `schedule(g, 4)`. 
Both the inner and outer `Map` must become `Map_t`. 
However, it is not obvious whether 



# Scheduling Algorithm

The algorithm for scheduling a program P with a throughput factor s is:
1. Let O be the set of sequence operators in P.
1. For each o in O:
    1. If o is an atomic operator
        1. If `s == 1` - return
        1. Else - fail
    1. If o is not a higher-order operator like `Map` or `Reduce` and not `Partition` or `Unpartition`:
        1. Let `n` be the configuration parameter passed to o
        1. Let `t` be the `t` from o's type signature
        1. If `s == 1` - 
            1. Apply the Sequence To Space rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = 1`
        1. Else if `s == n` -
            1. Apply the Sequence to Time rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = 1`
        1. Else if `(n > s) && (n % s == 0)` - 
            1. Apply the Sequence To Space-Time With Throughput `s` Less Than Fully Parallel rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = 1`
        1. Else if `(s > n) && (s % n == 0)` - 
            1. Apply the Sequence to Time rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = s / n`
        1. Else - fail
    1. If o is either `Partition` or `Unpartition`
        1. Let `no` and `ni` be the configuration parameters passed to o
        1. If `s == 1` - 
            1. Apply the Sequence To Space rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = 1`
        1. Else if `s == no*ni` - 
            1. Apply the Sequence to Time rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = 1`
        1. Else if `(no > s) && (no % s == 0)` - 
            1. Apply the Outer Sequence To Space-Time With Throughput `s` Less than Fully Parallel rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = 1`
        1. Else if `(s >= no) && (s % no == 0) && (ni > s) && (ni % s == 0)` - 
            1. Apply the Inner Sequence To Space-Time With Throughput `s` Less than Fully Parallel rewrite rule
            1. Convert `t` from the sequence language the space-time IR with `s' = 1`
        1. Else if `(s > (no*ni)) && (s % (no*ni) == 0)` - 
            1. Apply the Sequence to Time rewrite rule to o
            1. Convert `t` from the sequence language the space-time IR with `s' = s / (no*ni)`
        1. Else - fail
    1. If o is a higher-order operator:
        1. Let `n` be the configuration parameter passed to o
        1. Let `f` be function or composition of functions that is being mapped over.
        1. If `s == 1` -
            1. Apply the Sequence To Space rewrite rule to the higher-order operator to o
            1. Schedule `f` with throughput factor 1.
        1. Else if `(n > s) && (n % s == 0)` -
            1. Apply the Sequence To Space-Time With Throughput `s` Less Than Fully Parallel rewrite rule to the higher-order operator to o
            1. Schedule `f` with throughput factor 1.
        1. Else if `(s > n) && (s % n == 0)` -
            1. Apply the Sequence To Time rewrite operator to o.
            1. Schedule `f` with throughput factor `s / n`.
        1. Else - fail

The algorithm for converting a type `t` from the sequence language to the space-time IR with a throughput factor s:
1. If `t` is an atomic type
    1. If `s == 1` - return
    1. Else - fail
1. If `t = Seq n t'`
    1. If `s == 1`
        1. Let `t'' =` the result of converting `t'` from the sequence language to the space-time IR with `s' = 1`
        1. return `SSeq n t''`
    1. If `s == n`
        1. Let `t'' =` the result of converting `t'` from the sequence language to the space-time IR with `s' = 1`
        1. return `TSeq n 0 t''`
    1. Else if `(n > s) && (n % s == 0)` - 
        1. Let `t'' =` the result of converting `t'` from the sequence language to the space-time IR with `s' = 1`
        1. return `TSeq s 0 (SSeq (n / s) t'')`
    1. Else if `(s > n) && (s % n == 0)` - 
        1. Let `t'' =` the result of converting `t'` from the sequence language to the space-time IR with `s' = s / n`
        1. return `TSeq n 0 t''`
    1. Else - fail

# Properties Of Scheduler
## Types Produced By Scheduling
The scheduling algorithm impacts the `Seq`s in the types of each sequence operator o in one of three ways:
1. Converts the `Seq` to an `SSeq` if the Sequence To Space rewrite rule is applied
1. Converts the `Seq` to an `TSeq` if the Sequence To Time rewrite rule is applied
1. Splits the `Seq` into an outer `TSeq` and an inner `SSeq` if the Sequence to Space-Time rewrite rule is applied

### Scheduling An Operator Splits At Most One Of The `Seq` in its Input And Output Types
The scheduling algorithm splits at most one `Seq` on an operator's input and output types.
We prove this by structural induction on the operators.
1. Base Case: o is an atomic operator
    1. o is not modified, so none of its types are split.
1. Base Case: Non-higher-order operators other than `Partition` and `Unpartition`
    1. Subcase: `(n > s) && (n % s == 0)` - 
        1. The Sequence To Space-Time rewrite rule is applied to o, splitting it's outermost `Seq` into a `TSeq` and `SSeq`
        1. By Lemma No\_Splits\_Types, since `t'` is converted with `s == 1`, none of the `Seq`s in `t'` are split.
        1. Thus, one `Seq` on the input and output types are split
    1. Subcase: `s` has any other value.
        1. The Sequence To Space-Time rewrite rule not is applied to o, so it's outermost `Seq` is not split.
        1. By Lemma One\_Split\_Types, since the `t'` has at most one of its `Seq`s split
        1. Thus, at most one of the `Seq` on the input and output types are split
1. Base Case: `Partition` and `Unpartition`
   1. Proof is same as for other non-higher-order operators, with 2 subcases where a rewrite rule can be applied that splits `Seq`s
1. Inductive Case: Higher-order operators
    1. Subcase: `(n > s) && (n % s == 0)` - 
        1. The Sequence To Space-Time rewrite rule is applied to o, splitting it's outermost `Seq` into a `TSeq` and `SSeq`
        1. By Lemma No\_Splits\_Operators, since `f` is scheduled with `s == 1`, none of the nested `Seq`s are split.
        1. Thus, one `Seq` on the input and output types are split
    1. Subcase: `s` has any other value.
        1. The Sequence To Space-Time rewrite rule not is applied to o, so it's outermost `Seq` is not split.
        1. By the inductive hypothesis, at most one of the nested `Seq`s in `f`'s input and output are split.
        1. Thus, at most one of the `Seq` on the input and output types are split

### Lemma No\_Splits\_Operators: An Operator Scheduled With `s == 1` Has None Of It's Input And Output `Seq` Split
The scheduling algorithm does not split any input or output `Seq`s if `s == 1`.
We can prove this by structural induction on the operators, and then by invoking Lemma No\_Splits\_Types.
This proof follows the same structure as the one for No\_Splits\_Types.
It is left as an exercise to the reader.

### Lemma One\_Split\_Types: A Converted Type Has At Most One Of Its Nested `Seq`s Split
The type conversion algorithm splits at most one of the `Seq`s in a type `t`
We prove this by structural induction on the types.
1. Base Case: `t` is an atomic type - Either the algorithm fails or returns `t`. `t` is never split.
1. Inductive Case: `t = Seq n t'` and `s == 1` -
    1. By Lemma No\_Splits\_Types, none of the `Seq`s in t are split
1. Inductive Case: `t = Seq n t'` and `(n > s) && (n % s == 0)` - 
    1. `t`'s outermost `Seq` is split. 
    1. By Lemma No\_Splits\_Types, since `t'` is converted with `s == 1`, none of the `Seq`s in `t'` are split.
    1. Therefore, one of the `Seq`s in `t` are split
1. Inductive Case: `t = Seq n t'` and `s` has any other value
    1. The algorithm does not split the outermost `Seq`.
    1. By the inductive hypothesis, at most one of the `Seq` in `t'` are split.
    1. Therefore, at most one of the `Seq` in `t` are split

### Lemma No\_Splits\_Types: A Type Converted With `s == 1` Is Not Split During A Conversion
The type conversion algorithm does not split any `Seq`s in a type `t` if `s == 1`. 
We prove this by structural induction on the types.
1. Base Case: `t` is an atomic type - Either the algorithm fails or returns `t`. `t` is never split.
1. Inductive Case: `t = Seq n t'` - 
    1. By the inductive hypothesis, `t'` is converted to `t''` without any splits occurring.
    1. The result is `SSeq n t''`, no splits have occurred.

## Scheduling Preserves Well-Typeness
Applying the scheduling algorithm to a well-typed program in the sequence language produces a well-typed program in the space-time IR.
Sketch of proof:
1. Input is a well-typed program in the sequence language. A program is well typed if:
    1. For each composed operators `g . f`, `input_type(g) == output_type(f)`
1. `Seq`s are converted to `TSeq`s and `SSeq`s the same way for each operator
    1. Shown by structural induction on the types of operators with throughput factor `s`
    1. Subcases per structural induction case are:
        1. If `s != 1` and `n > s`, top `Seq` are converted to `TSeq` or fail, then inner `Seq`s are converted with `s' = 1` 
        1. If `s != 1` and `s > n`, top `Seq` are converted to `TSeq` or fail, then inner `Seq`s are converted with `s' = s / n` 
        1. If `s = 1`, all `Seq` are converted to `SSeq`

**In order to prove this property, I need to define rewrite rules for `Partition` and `Unpartition` that can support the scheduling algorithm working in this way**

# Auto-Scheduler 
**Please IGNORE THE REST FOR NOW. I NEED TO FIGURE OUT SCHEDULING BEFORE I DO THE AUTO-SCHEDULER***
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

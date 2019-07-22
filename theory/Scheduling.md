# Scheduling
The goal of this document is:
1. Define auto-scheduling and scheduling
1. List the motivating examples for the scheduling algorithm
1. Define the scheduling algorithm
   
# Auto-Scheduling and Scheduling Definitions
For a program `pseq` in the sequence language, the auto-scheduler searches for the highest throughput program in the space-time IR that fits within the target chip's constraints.
The auto-scheduler's algorithm is:
1. Compile `pseq` to the program in the space-time IR with the greatest throughput. I will refer to this program as `pspace`
    1. This is determined by rewriting every operator in `pseq` to it's space version in the space-time IR.
    1. Once every operator produces its entire output in one clock cycle, you cannot increase throughput any further without increasing the `Seq` sizes.
1. Compile `pseq` to the program in the space-time IR that is: the greatest throughput of the minimum area programs. I will refer to this program as `ptime`
    1. This is partially determined by rewriting every operator in `pseq` to it's time version in the space-time IR.
    1. There are an infinite number of least area programs because all operators can be arbitrarily underutilized with the same hardware resources.
        1. For example, `Map_t 2 0 Abs :: TSeq 2 0 Int -> TSeq 2 0` requires the same hardware and is three times higher throughput than `Map_t 2 4 Abs :: TSeq 2 4 Int -> TSeq 2 4`
    1. This step requires solving a non-linear, integer optimization problem. 
        1. Each time operator in the space-time IR has a relationship between it's input and output number of invalid clocks.
        1. Each composition of two time operators creates an equality between the producer's output valid and invalid clocks and the consumer's input valid and invalid clocks.
        1. Producing a space-time schedule with time operators requires finding a solution for all time operators' number of invalid clocks that satisfies these equations.
            1. For example, compiling `Down_1d 3 Int >>> Map 1 Int` to `Down_1d_t 3 0 Int >>> Map_t 1 2 Int` requires finding that the `Map_t` must be invalid for two clocks to match the type signature of the `Down_1d_t`.
        1. Operators such as `partition no ni io ii Int :: TSeq (no*ni) (no*ii + io*(ni+ii)) Int -> TSeq no io (TSeq ni ii Int)` create non-linear equations.
1. Let `max_slowdown = floor(throughput(Pspace) / throughput(Ptime))`. For each integer **s** from 1 to `max_slowdown`, schedule `pseq` with slowdown factor **s**. Stop at the first **s** that fits on the target chip.
    1. Scheduling with a slowdown factor is converting a program from the sequence language to one in the space-time IR that has an output throughput that is **s** times less than `pspace`.

The below image is a visualization of the auto-scheduler. 
The blue line is the auto-scheduler's search space: the set of program's in the space-time IR that `Pseq` can be converted into. 
The red line is the maximum amount of area on the target chip.
The green line is the auto-scheduler's search process from `Pspace` to `Ptime`.
The goal is the find the right-most point on the blue line that is below the red line.
The auto-scheduler accomplishes this goal by walking along the blue line in the direction indicated by the green line. 

![Auto-Scheduler Search Process](other_diagrams/area_throughput_tradeoff/area_throughput_tradeoff.png "Auto-Scheduler Search Process")

The code for the auto-scheduler is:
```
autoscheduler :: Area -> Seq_Expr -> Space_Time_Expr
autoscheduler max_area pseq = 
    pspace = sequence_to_space_operators(pseq)

    # assume automatically solving non-linear integer programming problem
    ptime = sequence_to_time_operators(pseq)

    max_slowdown = floor(throughput(pspace) / throughput(ptime))
    for s in [1 .. max_slowdown]:
        pspace_time = schedule pseq pspace ptime s
        if area(pspace_time) <= max_area:
            return pspace_time
    
    fail "Unable to fit sequence program on target chip."
```

The following sections will work through the implementation of the scheduling algorithm. 

# Naive Scheduler
The naive auto-scheduler is, for each operator, apply the slowdown factor if possible by applying the appropriate rewrite rules.
If not possible or slowing down the operator is insufficient to reach the desired throughput, recur on nested operators. 

```
naive_schedule :: Seq_Expr -> Int -> Space_Time_Expr
naive_schedule pseq s =
    for op in (operators pseq):
        naive_schedule_op op s

naive_schedule_op op s =
    n = max (input_seq_len op) (output_seq_len op)
    if (s % n) == 0:
        sequence_to_time op
        remaining_s = s / n
    if (n % s) == 0:
        sequence_to_nested_time_space op s
        remaining_s = 1
    # higher order op's include Map, Map2, and Reduce
    if is_higher_order op:
        inner = inner_op op 
        naive_schedule_op inner remaining_s
    # other operators, such as Shift, can operator on nested types
    # Need to convert those nested Seq types to TSeqs or SSeqs
    else:
       inner = inner_type op
       naive_schedule_type inner remaining_s
    
```

The [motivating examples](#motivating_examples) show that this auto-scheduler does not correctly schedule programs that a user can be expected to write. 


# Motivating Examples
There are four main issues that the scheduler will have to handle:
1. **Individual Operator Rewrites** - scheduling individual, sequence operators by rewriting them to space-time operators with the desired throughput
1. **Composition** - scheduling composed operators so that the produced space-time operators have matching type signatures 
1. **Multi-Rate** - scheduling operators that accept and emit different numbers of outputs, such as `Up_1d` and `Down_1d`
1. **Nesting Manipulation** - scheduling operators that change that change the nesting of `Seq`s, such as `Partition` and `Unpartition`

## Individual Operator
This example shows the simplest pipeline that can be scheduled.

Attainable s are `s = 1, 2,4`
```
Map 4 Abs
```

## Multi-Rate
**This example demonstrates the issue of how to parallelize a multi-rate operator where invalid clocks are necessary to understand throughput.**
Attainable s are `1, 2, 4`
```
Down_1d 4
```

Speeding up the output by two means converting it from `TSeq 1 1 (SSeq 1 Int)` to `SSeq 1 Int`

## Nested Multi-Rate
**This example demonstrates the first issue of where to distribute invalid clocks when connecting to a nested, multi-rate operator.**

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
**This example demonstrates the another issue the scheduler faces: how to maintain appropriate nesting when scheduling a `Partition` or `Unpartition`**

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

## Partition With Multi-Rates
**This example demonstrates the issue of how to parallelize a multi-rate pipeline where some operators must always be underutilized.**
Attainable s are `1, 2, 4`.
```
Map 2 (Down 2) >>> Unpartition 2 1 >>> Map 2 Abs
```
One would not know that `s=4` is attainable just by looking at `Map 2 Abs`. 
It is necessary to look at the whole pipeline. 
By examining `Map 2 (Down 2)`, the bottleneck, the correct downstream type can be determined: `Map_t 2 Abs :: TSeq 2 2 Int`

## Differently Nested Multi-Rates
**This example demonstrates the issue of how to distribute underutilization in a pipeline multiple, differntly nested downsamples.**
```
Map 2 (Down 3) >>> Unpartition 2 1 >>> Down 2
```
The output fully sequential type is `TSeq 1 5 Int`.

To make this example speedup with `s = 2` is 
```
Map_s 2 (Down_t 3) >>> Flip_ts_to_st >>> Down_t 2 >>> Map_t 1 (Down_s 2)
```


**Another issue to address is when a downsample is fed a SplitR, how to decide how much underutilization is for the downsample and howmuch is to be passed backwards?**
# Scheduling Algorithm
## Divisibility Constraints
```
input type - Seq n i
result type - TSeq no io (SSeq ni)

ASSERT:
no * ni = n
no + io = (n+i) / speedup
speedup = common factors of s and (n+i)
time_after_speedup = (n+i) / speedup

from the above 3 equations, know that no has to be a factor of n

no = factors(n) union factors ((n+i) / speedup) 

This ensures that can compute io >= 0 as no has to be less than (n+i) / speedup.
This ensures that can compute ni as an natural number as no is only factors of n

-- wrong below, if n = 1, i = 3, then speed up by 2 with no = 1, ni = 1, io = 2
ni = speedup (parallel component)
```

## Algorithm

The algorithm for scheduling a program P with a throughput factor s is:
1. Find an output type at the desired throughput
  1. Let T_O be the output type of P
  1. Let T_OT be the output type of P if it is scheduled fully in time - each operator is made as temporal as possible while ensuring that the bottleneck is fully utilized.
  1. Let T_OS be the output type of P if it is scheduled fully in space - each operator is made fully parallel.
  1. T\_OT will be T\_O where each `Seq n t` is replaced by `TSeq n i t`
  1. Compute the scheduled version of T\_O, T\_OC, using the below algorithm:
    1. Iteration 1: if `n` and `s` share common factors, then slow down by that amount
        1. This will never produce invalid clocks. Slowing down this way just is extra, valid clocks
    1. Iteration 2: If don't use up all of s, walk down tree again. If can combine the slowdown applied to that layer with remaining `s` to produce `TSeq n i (SSeq 1 t)`, then do so
```
s_remaining_factors = prime_factorization(s)
T_OC
T_OC_temp = []
for (TSeq n i) in (T_OT):
   n_factors = prime_factorization n
   -- if there are slowdown factors that match current seq length
   -- without counting i, make a TSeq slowdown_amount 0 (SSeq (n / slowdown amount) Int)
   -- this will never produce invalid clocks. Slowing down is just using extra clocks
   -- of valid with less per clock.
   -- this will only explore partial parallelism slowdowns that don't create
   -- invalid clocks would rather go slower than add more invalids
   if ae_factors_intersect n_factors s_remaining_factors != S.empty:
       slowdown_factors = ae_factors_intersect n_factors s_remaining_factors
       s_remaining_factors = Set.difference s_remaining_factors slowdown_factors 
       slowdown = ae_factors_product slowdown_factors
       no = slowdown
       ni = n / no
       io = 0
       s_remaining_factors = ae_factors_difference s_remaining_factors slowdown_factors
       T_OC_temp += Split(TSeq no io, SSeq ni) 
  else :
       T_OC_temp += SSeq ni

-- if there is still slowdown remaining, see if can add invalids
-- Maximum slowdown is (n+i / time pass1_result)
for (TSeq n i, pass1_result) in (zip T_OT T_OC_temp)
   max_slowdown = (n+i / time pass1_result)
   max_slowdown_factors = prime_factorization max_slowdown
   if ae_factors_intersect max_slowdown_factors s_remaining_factors != S.empty:
       slowdown_factors = ae_factors_intersect max_slowdown_factors s_remaining_factors
       slowdown = ae_factors_product slowdown_factors
       s_remaining_factors = Set.difference s_remaining_factor slowdown_factors
       T_OC += add_invalid_clocks pass1_result slowdown
   -- if there are common factors between total runtime and speedup
   -- use them to do speedup
   else 
       T_OC += pass1_result

-- special case: if slowdown by amount that is co-prime with number of elements
-- the prior steps will create a TSeq 1 (i-1) (SSeq n) where it should be TSeq n (i-n). 
-- That is also addressed in add_invalid_clocks

Need second pass to handle Down_1d 4
For Seq 4 4 Int, need the second pass to get from TSeq 4 0 (SSeq 1 Int) to TSeq 4 4 (SSeq 1 Int)
For Seq 1 3 Int, need the second pass to get any slowdown including TSeq 1 1 (SSeq 1 Int) and TSeq 1 3 Int
Handles Seq 1 2 (Seq 1 3 Int) correclty also due to second pass

potential issue with this algorithm: 
If could produce a Seq n i where n was not a factor of (n+i), a complete slow down will yield TSeq 1 (i + (n-1)) (SSeq n)
can't come up with an example in Aetherling where this will occur, so not handling it for now
This will come up - Down_1d_t 5 0 >>> Up_1d_t 4 1 - here Up_1d_t's 4 is not a factor of (4+1)
```
  1. Compute the scheduled version of T\_O, T\_OC, using the below algorithm:
    1. goal 1: if `n` and `s` share common factors, then slow down by that amount
    1. goal 2: if `n` and `s` don't share common factors, see is `n+i` and `s` share common factors. If they do, 
```
s_remaining_factors = prime_factorization(s)
T_OC = []
for (TSeq n i) in layers(T_OT):
   n_factors = prime_factorization(n)
   n_i_s_factors = ae_factors_intersect s_remaining_factors n_i_factors
   -- if there are slowdown factors that match current seq length
   -- without counting i, make a TSeq slowdown_amount 0 (SSeq (n / slowdown amount) Int)
   -- this will never produce invalid clocks. Slowing down is just using extra clocks
   -- of valid with less per clock.
   -- this will only explore partial parallelism slowdowns that don't create
   -- invalid clocks would rather go slower than add more invalids
   if ae_factors_intersect n_factors s_remaining_factors != S.empty:
       slowdown_factors = ae_factors_intersect n_factors s_remaining_factors
       s_remaining_factors = Set.difference s_remaining_factors slowdown_factors 
       slowdown = ae_factors_product slowdown_factors
       no = slowdown
       ni = n / no
       io = 0
       s_remaining_factors = ae_factors_difference s_remaining_factors speedup_factors
       T_OC += Split(TSeq no io, SSeq ni) 
   -- once you are less than 1 px per clock, all possible scheudles expressibel by
   -- TSeq n (total_clocks - n), no need for nesting
   -- speedup if amount of output to produce divides into speedup amount
   -- this explores slowdowns s.t. s > n, (n+i) % s == 0
   else if S.is_subset_of n_i_factors s_remaining_factors == 0:
       slowdown_factors = ae_factors_intersect n_factors s_remaining_factors
       slowdown = ae_factors_product slowdown_factors
       s_remaining_factors = Set.difference s_remaining_factor n_i_factors
       T_OC += SSeq n i
   -- if there are common factors between total runtime and speedup
   -- use them to do speedup
   else 
       T_OC += TSeq n i
```
1. Compute the scheduled version of T\_O, T\_OC, using the below algorithm:
```
s_remaining_factors = prime_factorization(s)
T_OC = []
for (TSeq n i) in layers(T_OT):
   n_factors = prime_factorization(n)
   n_i_factors = prime_factorization(n+i)
   n_i_s_factors = ae_factors_intersect s_remaining_factors n_i_factors
   -- speedup if amount of output to produce divides into speedup amount
   if S.is_subset_of n_i_factors s_remaining_factors == 0:
       s_remaining_factors = Set.difference s_remaining_factor n_i_factors
       T_OC += SSeq n i
   -- if there are common factors between total runtime and speedup
   -- use them to do speedup
   else if n_i_s_factors != Set.empty:
       speedup_factors = n_i_s_factors
       speedup = ae_factors_product speedup_factors
       no_factors = ae_factors_intersect n_factors n_i_s_factors
       no = ae_factors_product no_factors
       ni = n / no
       io = ((n + i) / speedup) - no
       s_remaining_factors = ae_factors_difference s_remaining_factors speedup_factors
       T_OC += Split(TSeq no io, SSeq ni) 
   else 
       T_OC += TSeq n i
This algorithm bad for - 
1. Seq 4 4 Int with s = 2 - it will produce TSeq 2 2 (SSeq 2 Int) when should produce TSeq 4 0 (SSeq 1 Int)
    1. For any speedup where speedup is less than no, will decrease no and add to ni where should be decreasing io and increasing no.
1. Seq 4 4 Int with s = 2 - it will produce TSeq 4 (-2) (SSeq 1 Int) when should produce TSeq 2 0 (SSeq 2 Int)
    1. This is wrong for 2 reasons - 
        1. Can't have a negative number of invalids
        1. This is only a 2x speedup at most, even if i was 0
    1. It's producing a negative number of invalids as it thinks the speedup is 4, so it thinks 2 total clocks are necessary. But, since no=4, this takes at most 4 clocks. Thus, ((n+i) / speedup) = -2, which is number of clocks necessary to make the TSeq 4 (-2) take 2 clocks.

```
1. Lower P to a program in the Space-Time IR at the desired throughput
  1. Next, feed this output backwards through the graph. Each operator gets T\_OS and is nested according the Sequence To Space-Time rewrite rules.
      1. We require that each operator accept and emit each layer split at most once.
      1. T\_IS is the same data structure as T\_OS, but it is produced from the rewritten operators and passed back
```
T_OC
T_IS = apply_rewrite_rules(T_OC, f)

apply_rewrite_rules(T_OC, f) =
   if T_OC[0] == SSeq n:
       sequence_to_fully_parallel(f)
   else if T_OC[0] == TSeq n i:
       sequence_to_fully_sequential(f)
   else:
       sequence_to_partially_parallel(f, T_OC[0])
   if f is nested:
     f_inner = get_inner(f)
     apply_rewrite_rules(T_OC[1:], f_inner)

```

#  Garbage Below


Scheduling is converting a program from the sequence language to the space-time IR.
Scheduling is performed to target a specific `input_throughput` and `output_throughput`
as defined in [the basic theory document's throughput section.](Basic.md#throughput).
The target is specified using a **slowdown factor s**.
Scheduling with factor **s** means produce a pipeline with `input_throughput` and
`output_throughput` that are **s** times smaller than the fully parallel pipeline's
`input_throughput` and `output_throughput`.

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

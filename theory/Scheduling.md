# Scheduling
The goal of this document is:
1. Define scheduling
1. Define how scheduling occurs
1. Define properties of the scheduler
1. Enumerate the rewrite rules that each operator in the sequence language must
   support in order to enable scheduling
1. Define the relationship between scheduling and the auto-scheduler
1. Explain the auto-scheduling algorithm
1. Prove optimality of the algorithm
   
# Scheduling Definition
Scheduling is converting all the operators in a program from sequence language
to space-time IR.
Scheduling is performed to target a specific `input_throughput` and `output_throughput`
as defined in [the basic theory document's throughput section.](Basic.md#throughput).
The target is specified using a **throughput factor s**.
Scheduling with factor **s** means produce a pipeline with `input_throughput` and
`output_throughput` that are **s** times smaller than the fully parallel pipeline's
`input_throughput` and `output_throughput`.

The algorithm for scheduling a program P with a throughput factor s is:
1. Let O be the set of sequence operators in P.
1. For each o in O:
    1. If o is not a higher-order operator like `Map` or `Reduce` and not `Partition` or `Unpartition`:
        1. Let `n` be the configuration parameter passed to o
        1. If `s == 1` - Apply the Sequence To Space rewrite rule
        1. Else if `s == n` - Apply the Sequence to Time rewrite rule
        1. Else if `(n > s) && (n % s == 0)` - Apply the Sequence To Space-Time With Throughput `s` Less Than Fully Parallel rewrite rule
        1. Else - fail
    1. If o is either `Partition` or `Unpartition`
        1. Let `no` and `ni` be the configuration parameters passed to o
        1. If `s == 1` - Apply the Sequence To Space rewrite rule
        1. Else if `s == no*ni` - Apply the Sequence to Time rewrite rule
        1. Else if `(no > s) && (no % s == 0)` - Apply the **NEED TO FIGURE OUT RULE HERE**
        1. Else if `(ni <= s) && (s % no == 0) && (ni > s) && (ni % s == 0)` - Apply the **NEED TO FIGURE OUT RULE HERE**
        1. Else - fail
    1. If o is a higher-order operator:
        1. Let `n` be the configuration parameter passed to o
        1. Let `f` be function or composition of functions that is being mapped over.
        1. If `s == 1` -
            1. Apply the Sequence To Space rewrite rule to the higher-order operator. 
            1. Schedule `f` with throughput factor 1.
        1. Else if `(n > s) && (n % s == 0)` -
            1. Apply the Sequence To Space-Time With Throughput `s` Less Than Fully Parallel rewrite rule to the higher-order operator
            1. Schedule `f` with throughput factor 1.
        1. Else if `(s > n) && (s % n == 0)` -
            1. Apply the Sequence To Time rewrite operator
            1. Schedule `f` with throughput factor `s / n`.
        1. Else - fail

# Properties Of Scheduler
## Types Produced By Scheduling
The scheduling algorithm impacts the `Seq`s in the types of each sequence operator o in one of three ways:
1. Converts the `Seq` to an `SSeq` if the Sequence To Space rewrite rule is applied
1. Converts the `Seq` to an `TSeq` if the Sequence To Time rewrite rule is applied
1. Splits the `Seq` into an outer `TSeq` and an inner `SSeq` if the Sequence to Space-Time rewrite rule is applied

### Proof The Only One `Seq` Is Split
The scheduling algorithm splits at most 1 `Seq`. We prove this by induction on
the nesting of operators. We show that the Sequence To Space-Time rewrite rule
is applied only once per operator in P. Therefore, at most 1 `Seq` in each
operator's type may be split.
1. Base Case: For all non-higher-order operators, the Sequence To Space-Time rewrite rule is applied at most once.
    1. This is true for all relevant cases in the scheduling algorithm
1. Inductive Case: For the nested higher order operators, the Sequence To Space-Time rewrite rule is applied at most once
    1. If the higher order operator has the Sequence To Space-Time rewrite rule
    applied to it, f is scheduled with `s == 1`. When `s == 1**, all nested operators
    will be scheduled using the Sequence To Space rewrite rule.
    Therefore, Sequence To Space-Time is applied only once.
    1. If the higher order operator doesn't have the Sequence To Space-Time
    rewrite rule applied to it, the rule may be applied to f. By the inductive
    hypothesis, the Sequence To Space-Time operator may be applied at most once
    to f.
    

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

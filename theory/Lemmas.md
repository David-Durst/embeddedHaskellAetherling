# Lemmas About Structure of Aetherling Programs
## Diamond Input Type Relation
**Lemma - for any diamond in the space-time IR, time(t1') == time(t1), length(t1) == length(t1'), and throughput(t1) == throuhgput(t1')**

![General Diamond Form](other_diagrams/lemmas/diamond_input/diamond_input.png "General Diamond Form")

What restrictions do I have:
1.	`TSeq/SSeq` components of t2 and t3 must be the same – 
    1. The only binary operations in the space-time IR on sequences are `Map2_s` and `Map2_t`.
    1. The type signatures of these operators are `Map2_s n :: (a -> b -> c) -> SSeq n a -> SSeq n b -> SSeq n c` and `Map2_t n i :: (a -> b -> c) -> TSeq n i a -> TSeq n i b -> TSeq n i c`
    1. This type signatures enforce this condition.
1.	`Seq` components of t1 and t1’ must be the same – 
    1. The only binary operation in the sequence language on sequences is `Map2` 
    1. The type signature is `Map2 n :: (a -> b -> c) -> Seq n a -> Seq n b -> Seq n c` 

This means: 
1.	t1’ time must be same as t3 time - can’t have a producer with different time than a consumer
2.	t2 time must be same as t3 time – the definitions of `Map2_s` and `Map2_t` ensure their `TSeq` and `SSeq` components are the same. Therefore, their times must be the same.
3.	t1 time must be same as t2 time – same reason as t1’ and t3 time
4.	Thus t1’ time must be same as t1 time
5.	t1 length must equal t1’ length by `Map2` property
6.	Thus, `throughput(t1) == length(t1) / time(t1) == length(t1') / time(t1') == throughput(t1')` 

## Diamond Without `Partition/Unpartition/Seq_To_Tuple/Tuple_To_Seq` Lemma
**Lemma - if i have a pipeline without `Partition`, `Unpartition`, `Seq_To_Tuple`, and `Tuple_To_Seq`, then I can lower the pipeline's output type to space-time IR, push that type back through the pipeline, and if I encounter any diamonds, the input types to both branches of the diamonds will be the same.**


![General Diamond Form](other_diagrams/lemmas/diamond_input/diamond_input.png "General Diamond Form")

1. As shown in the [diamond input type relation lemma](#diamond-input-type-relation), the `TSeq/SSeq` components of t2 and t3 must be the same.
1. All other operators process one or zero layers of `Seq`. 
1. Therefore, rewriting all other operators based on output types must apply the slowdown to the same nesting
1. Since the nesting of slowdown doesn't change and `t1` and `t1'` have the same seq structure and lengths, they must become the same types in the space-time IR.

## Partition Moving
**Lemma - for any structure-preserving operator f, I can find a semantics preserving rewrite such that `f >>> Partition no ni t === Partition no ni t >>> f'` and `Unpartition no ni t >>> f === f >>> Unpartition no ni t`**

1. All my structure preserving operations support a rewrite rule `f === Partition no ni t >>> g >>> Unpartition no ni t`
1. Therefore, any structure preserving operation, I can do:
    1. `f >>> Partition no ni t === Partition no ni t >>> g >>> Unpartition no ni t >>> Partition no ni === Partition no ni t >>> g`
    1. `Unpartition no ni t >>> f === Unpartition no ni t >>> Partition no ni t >>> g >>> Unpartition no ni t >>> Partition no ni === g >>> Unpartition no ni t`
1. This can be extended to a DAG by repeating the nesting rewrite rule and `Partition`/`Unpartition` cancelling for each branch of the DAG.

## Minimum Underutilization Computation
**Given a DAG such as the one below, find the minimum necessary underutiliziation for a fully sequential operator.**

![General Diamond Form](other_diagrams/lemmas/diamond_input/diamond_input.png "General Diamond Form")

Approach: 
1. Treat each path of the DAG independently by searching the DAG as if it was a tree.
1. Walk each path in the tree, find the minimum necessary underutilization, propagate that back to output
1. When merging two paths in the DAG, take the larger of the underutilizations
1. Issue - partition - if partitioning, underutilization may be divided between two layers. This is addressed by tracking how much utilization is required at each layer or divdied between multiple layers.


1. For a program with a graph structure `G={N,E}`, start with the output edge.
    1. Let the edge's output type have form `[n_0/d_0, ..., n_i/d_i]`.
    1. Initialize the per layer underutilization data structure as a list of length i of `0`.
    1. Initialize the shared underutilization between layers data structure as an empty list.
1. For the current node at depth i:
     1. If higher-order: 
          1. If `Reduce n`: increment the underutilization data structure with index i by `n-1`
          1. For all higher order nodes: recur on the output edge of the sub-graph with depth (i+1)
      1. If `Partition`:
          1. Replace element i of the per layer underutilization data structure two elements, both 0's, and add a triple to the shared underutilziation data structure of `{i, i+1, u}`, where `u` was the value stored in location i of the per layer underutilization data structure
      1. If `Unpartition`
          1. Replace element i and i+1 of the per layer underutilization data structure with one element:
              1. `max(u, (no+ni)**per_layer[i]*per_layer[i+1])` if `{i, i+1, u}` exists
                  1. This needs to actually use the partition invalid formula
              1. `per_layer[i]*per_layer[i+1]` otherwise
          1. For any shared underutilization data structures with `i+1`, replace that with `i`
      1. If `Seq_to_Tuple`:
          1. Replace element i and i+1 of the per layer underutilization data structure with one element:
              1. `max(u, per_layer[i]*per_layer[i+1])` if `{i, i+1, u}` exists
              1. `per_layer[i]*per_layer[i+1]` otherwise


### Structure Changing Operations Issue
The issue with structure changing operations is that underutilization is assigned per layer of the nesting.
However, when a layer is split, it is unclear how to split undertuilization.
The following examples show this:

```
Select_1d 4 0 (Seq 4 Int) >>> Unpartition 1 4 Int
Map 1 (Select_1d 4 0 Int) >>> Unpartition 1 1 Int
Select 4 0 (Seq 4 Int) >>> Map 1 (Select_1d 4 0 Int) >>> Unpartition 1 1 Int
```

#### `Partition` and `Unpartition`

# Lemmas About Slowing Down Types
Structure of problem:
1. Have a set of `Seq`'s is: `Seq n i_max`
1. Each represents one `Seq` in the output type of an aetherling program
1. Can convert each of the `Seq`'s into either:
    1. `SSeq n`
    1. `Tseq n i` s.t. `i == i_max`
    1. `TSeq no io (SSeq ni)` s.t. `no*ni == n` and `io <= i_max`
1. Have a periods property defined in [basic document](Basic.md#space-time-types)
1. Need the product of the periods of the resulting `TSeq` and `SSeq` to equal slowdown factor `s`.

## Why `TSeq n i` must have `i == i_max`
Assume that `i` could be less than `i_max`.
I will show that this will produce a rewrite for an expression that cannot be solved.
The example program is `Down_1d 4 0 :: Seq 4 Int -> Seq 1 Int`.

`i_max` for this program's output is `3` since the highest throughput of the minimum area programs: `Down_1d_t 4 0 0 :: TSeq 4 0 Int -> TSeq 1 3 Int`.

If I rewrote the output type to `TSeq 1 1 Int`, I could not use the `Down_1d` rewrite rules to produce this type. The two options are
1. Fully Sequential - `Down_1d_t 4 0 0 :: TSeq 4 0 Int -> TSeq 1 3 Int`
1. Partially Parallel - `Map_t 1 (Down_1d_s 2 0 Int) . Down_1d_t 2 0 (Seq 2 Int) :: TSeq 2 0 (SSeq 2 Int) -> TSeq 1 1 (SSeq 1 Int)`

Therefore, if I produce an output type that is partially parallel, it must be `TSeq no io (SSeq ni)`.

## What Are The Options For Applying A Slowdown By A Prime
I will look at primes as they they are the smallest subproblem.
They can't be split into subfactors. 
Therefore, in order to slowdown by a prime, it must be applied entirely to one `Seq`.
I will first start by converting the `Seq n` to a `SSeq n` and then trying to slowdown the `SSeq n`.
The ways to apply a prime slowdown `s_p` to `SSeq n` are:
1. If `n == s_p`, then `TSeq n 0`
1. If `n % s_p == 0`, then `TSeq s_p 0 (SSeq (n / s_p))`
1. If `(n+i_max) % s_p == 0`, then need to slowdown so that takes `s_p` clocks. There are multiple possible choices for the resulting `TSeq no io (SSeq ni)`. To find the best answer (least underutilization):
    1. `no * ni == n`
    1. `no + io == s_p`
    1. `io <= i_max`
    1. min `io` as want minimum underutilization
    1. Solution
        1. `no = n / ni`
        1. `(n/ni) + io == s_p`
            1. solve this by - trying all the divisors of n from smallest to largest. 
            1. take smallest `ni` such that `io` is non-negative integer and `no` is a positive integer
            1. this will give least underutilization and area for the given throughput
        1. `n + ni * io == ni * s_p`
        1. `n == ni * s_p - ni * io`
        1. `ni * s_p - ni * io == n`
        1. `0*ni^2 - ni * io + 0 * io^2 + s_p * ni + 0 * io - n == 0`
        1. `ni * (s_p - io) == n`
        1. `ni * (-1 * io + s_p) == n`
        1. If the above equation is solved

## What Are The Options For Applying A Slowdown By A Non-Prime
### Greedy Algorithm For Sets of Primes
I propose a greedy algorithm that tries to apply a slowdown `s` to a sequence type `t = SSeq n_0 (SSeq n_1 (...))`. I refer to each `Seq`  as a layer of the type.
1. Let `{s_i}` be the set of prime factors of `s`. Let `r` be an initially empty set.
1. For each `s_j` in `{s_i}`:
    1. Try to slowdown the `SSeq n` or `TSeq no 0 (SSeq ni)` from outer to inner layers without underutilization by only trying options 1 and 2 above.
        1. How to slowdown a `TSeq no io (SSeq ni)` - 
            1. Let `t` be the amount that `SSeq n` is faster than `TSeq no io (SSeq ni)`down
            1. If can slowdown `SSeq n` using by `r*t` with options 2 or 3 above described for primes, return that. Otherwise, return `TSeq no io (SSeq ni)` and don't try to slow down this layer.
        1. Don't need to worry about slowing down a `TSeq n i` as it is already slowed down as much as possible.
    1. If not able to find a layer to apply the slowdown, add `s_j` to `r`
1. For each `r_j` in `r`
    1. Try to slowdown the `SSeq n` or `TSeq no io (SSeq ni)` from outer to inner layers with option 3.

### Will Greedy Approach Fail To Find Solutions?
Greedy approach will first try to slowdown using a set of factors `{s_i}` of slowdown `s` across `Seq`'s using just `no` and `ni` without `io`.
Greedy approach would miss potential solutions that use all factors in `{s_i}` if using a factor `s_j` from `{s_i}` for slowing down one layer means that later I cannot use the remaining factors of `{s_i}` to slow down another layer.
This won't be an issue because:
1. If I could slowdown `Seq n` and `i_max` with factors `{s_i}`, that means either:
    1. `n` is divisible by s - `n`'s factors `{f_i}` are a superset of the factors in `{s_i}`.
    1. `n+i_max` is divisible by s - `n+i_max`'s factors `{f_i}` are a superset of the factors in `{s_i}`.
1. The greedy algorithm could miss this solution by due to having removed one or more factors from `{s_i}` by using them for slowing down other layers. The greedy algorithm will instead try to slowdown `Seq n` and `i_max` with a subset `sub` of `{s_i}`. 
1. Since `sub` is a subset of `{s_i}` and `{s_i}` is a subset of `{f_i}`, then `sub` is a subset of `{f_i}`
1. Therefore, the greedy algorithm won't miss solutions. If a set of factors divides into `n+i_max` or `n`, the subset of factors used by the greedy appraoch will also divide into `n+i_max` or `n`.

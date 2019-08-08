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

## Max Underutilization Computation

Given a DAG such as the one below, find the maximum necessary underutilziation.
![General Diamond Form](other_diagrams/lemmas/diamond_input/diamond_input.png "General Diamond Form")

Approach: 
1. Treat each path of the DAG independently by searching the DAG as if it was a tree.
    1. In a tree structure, each producer to a consumer gets a different pth
    1. Therefore, in a DAG, the entire upstream for each path is independent.
1. Walk each path in the tree, find the maximum necessary underutilization.
1. Issue - partition - if partitioning, underutilization may be divided between two layers. This is addressed by tracking how much utilization is required at each layer or divdied between multiple layers.

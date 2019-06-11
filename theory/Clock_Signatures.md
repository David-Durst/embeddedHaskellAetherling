# Clock Signatures 
This document explains the **clock signature**, the per-clock-cycle timing, of each operator in Aetherling's space-time IR.
It adds:
1. a justification for why the space-time IR types must be supplemented with clock signatures when producing hardware
1. a justification for why the space-time IR types are sufficient for type checking
1. a justification for why the space-time IR types shouldn't be the same as the clock signatures
1. an explanation of the clock calculus notation used to define each clock signature
1. a definition of the clock signatures for each operator.

Aetherling's clock calculus is based on the clock calculus type system in [N-Synchronous Kahn Networks](https://dl.acm.org/citation.cfm?id=1111054).
I will refer to the N-Synchronous Kahn Networks as NKN.

# Why Clock Signatures Are Necessary To Produce Hardware
One of Aetherling's goals is to produce efficient hardware with minimal buffering.
Aetherling accomplishes this goal by compiling to synchronous, streaming hardware.
Synchronous, streaming hardware ensures that adjacent producer and consumer operators communicate on the same clock cycle to minimize buffering between operators.

The constraints imposed by the space-time IR types are insufficient to produce synchronous hardware.
The Aetherling space-time IR types specifies the [throughput](Basic.md#thoughput) and [total number of clock cycles](Basic.md#time) for each operator's input and output.
If two operators are composed, the producer's output throughput and consumer's input throughput must match along with their total numbers of clock cycles.
Synchronous hardware also requires that producer and consumer operators communicate on the same clock cycle.
Under the space-time IR types, the producer may be valid and emit output on a clock cycle where the consumer is invalid and not expecting data.
The emitted data on this clock cycle would be lost without a buffer between the producer and consumer to match clock cycles.

Adding a clock signature to each space-time IR operator enables Aetherling to determine the offset between valid clocks in composed operators.
With this information, Aetherling can insert minimally sized buffers necessary to store data from the producer until the consumer was ready to accept it.
The clock calculus provides a language that enables Aetherling to 
1. specify the clock cycles that operators accept and emit data on
1. compute the size of the retiming buffer necessary between two operators so that their clock cycles match

# Why The Space-Time IR Types Are Sufficient to Guarantee Efficient Hardware Can Be Generated
The goal of the space-time IR types is to ensure that operators can only be composed if they can be compiled to synchronous, streaming implementations.
The `TSeq`'s `n` and `v` parameters specify that an operator accepts or emits data on `n` valid clock cycles out of `n+v` total clock cycles.
If two operators with matching `TSeq` and `SSeq` types are composed, their throughputs and total number of clock cycles match. 
But, they may accept and emit data on different clocks as `TSeq n v` does not specify the order of valid and invalid cycles.
This ambiguity would seem to prevent the types from accomplishing its goal.
Synchronous, streaming hardware requires producer and consumer operators to accept and emit data on the same clock cycle.
However, as noted by the NKN paper, there are producer-consumer pairs which do not emit or accept data on the same clock cycle, but can be made to do so using a finite sized buffer.
These operators are known as **synchronizable**. 

The definition of **synchronizable** operators is: when placing an appropriately sized buffer between them, the result is valid in synchronous hardware as:
1. On every clock cycle where the producer emits data, the buffer is ready to accept input.
1. On every clock cycle where the consumer accepts data, the buffer has data to emit.

This section will show that `TSeq`'s `n` and `v` parameters are sufficiently specific so that, if two operators with matching `TSeq` and `SSeq` types are composed, they are synchronizable.

## Proof Of Synchronizability
**Theorem:** Any pair of producer-consumer operators are synchronizable if the corresponding output and input sequences contain the same number of valid and invalid clocks. This is similar to Propositions 6 and 7 from NKN, except for finite sequences.

**Proof:** 
1. Let the output sequence be `os :: TSeq n v t`
1. Let the input sequence be `is :: TSeq n v t` 
1. Let `is_valid` return `True` if the sequence is valid on this clock. Let it return `False` otherwise.
1. Run the following algorithm and start `os` before `is` by `max_clocks_is_ahead` clocks, the length of the longest contiguous sequence of cycles in which `is` ahead of `os`.
    1. This is acceptable since neither the theorem nor the definition of synchronizable has placed any restrictions on when the two sequences start relative to each other. 
```
valid_clocks_os = 0
valid_clocks_is = 0
is_ahead = False
max_clocks_is_ahead = 0
current_contiguous_region_is_ahead = 0
for i in len(os):
   if is_valid(os[i]):
       valid_clocks_os += 1 

   if is_valid(is[i]):
       valid_clocks_is += 1 
   
   if valid_clocks_is > valid_clocks_os:
       is_ahead = True 
       current_contiguous_region_is_ahead += 1
   else:
       is_ahead = False
       current_contiguous_region_is_ahead = 0

   if max_clocks_is_ahead < current_contiguous_region_is_ahead 
       max_clocks_is_ahead = current_contiguous_region_is_ahead
```
1. Run the following algorithm and set the buffer between `os` and `is` equal to `max_elements_os_ahead`, the maximum number of outputs `os` emits that must be bufferred at once.
```
valid_clocks_os = 0
valid_clocks_is = 0
is_ahead = False
max_elements_os_ahead = 0
clocks_is_ahead_of_corresopnding_os = 0
for i in len(os):
   if is_valid(os[i]):
      valid_clocks_os += 1 

   if max_clocks_is_ahead <= i && is_valid(is[i - max_clocks_is_ahead]):
      valid_clocks_is += 1 
   
   if max_elements_os_ahead < valid_clocks_os - valid_clocks_is:
      max_elements_os_ahead = valid_clocks_os - valid_clocks_is
```
1. Starting `is` `max_clocks_is_ahead` clocks after `os` and putting a buffer of size `max_elements_os_ahead` between them will synchronize the two sequences.
    1. A delay of `max_clocks_is_ahead` clocks ensures `is` will never expect an input before `os` has emitted it
    1. A buffer of size `max_elements_os_ahead` ensures that if `os` has emitted an element before `is` is ready for it, there will be room in the buffer to store it until `is` is ready.

## Why `TSq`'s '`n` and `v` Parameters Ensure Synchronizability Of Composed Operators
`TSeq`'s `n` and `v` parameters ensure that the sequences contain the same number of valid and invalid clocks. 
Therefore, by the synchronizability theorem, the `n` and `v` parameters are enough to ensure that Aetherling only allows operators to be composed if the inputs and outputs are synchronizable.

# Why Not Replace The Space-Time IR's `TSeq`s and `SSeq`s With Clock Signatures
Type systems should only include the detail necessary to prove the desired properties.
Adding additional information complicates type checking.
Clock signatures provide unnecessary detail in the type system that complicates type checking when composing synchronizable operators.
The `TSeq` and `SSeq` types are provide the correct level of detail so that synchronizable operators are composable using standard type checking rules.

For example, let `f` and `g` be two operators. Each operator's input and output is valid for two out of four clocks.
`f` and `g` should be composable because they are synchronizable.
Using the types from the [clock notation section](#clock_notation), let `f` and `g` have the following clock signatures:
```
f :: (1010)[1] -> (1010)[1]
g :: (0110)[1] -> (0110)[1]
```
`f . g` doesn't type check with standard, syntactic type equality rules as `(1010)[1]` and `(0110)[1]` are not equal. 

With the space-time IR types, `f` and `g` can be composed because they have the following type signatures
```
f :: TSeq 2 2 -> TSeq 2 2
g :: TSeq 2 2 -> TSeq 2 2
```

For the space-time IR's type system, the imprecision of the `TSeq`s and `SSeq`s make them preferable compared to clock signatures. 
The imprecision enables composing synchronizable functions using normal type equality.

It may be possible to extend the definition of type equality in Aetherling so that `(1010)[5]` and `(0101)[5]` are of equivalent types.
The NKN paper gives one example of how to do this with its relaxed clock calculus, subtyping rule, and type unification system.
However, in order to use that rule in a type system, they needed to do significant theory work.
It is much simpler to only use the `TSeq` and `SSeq` types and perform synchronization below the type system.

# Clock Signature Notation 
Aetherling's clock notation specifies the **clock signature**, the distribution of valid and invalid clocks, in an operator's input and output sequences. 
Clock signatures in Aetherling are a finite version of the infinite, periodic binary words in NKN. 
The signatures must be finite as each `TSeq` and `SSeq` in Aetherling describes a finite number of clocks.
If `TSeq`'s were infinite, nesting them would not have a clear meaning.
For example, `TSeq infinite (TSeq infinite Int)` is nonsensical. 
One cannot repeat an infinite length sequence.

The grammar for the notation is
```
ct ::= w | ct x ct | ct -> ct | x
w ::= 1 | 0 | w w' | (w)[d] s.t. d is a natural number
```

`1` indicates a valid clock cycle. 
`0` indicates an invalid clock cycle. 
`(w)[d]` repeats the clock signature `w` for `d` times.
`w w'` is a sequence of two different clock signatures where first `w` occurs and then `w'`.

`ct x ct` represents a tuple of two clock sigantures.
I allow tuples with different patterns.
`ct -> ct` represents an operator with input and output clock signatures.
`x` represents a free variable.
I will motivate the need for free variables below.

`|ct|` is the number of clock cycles in clock signature `ct`.

## Comparisons With NKN
As in NKN, a word `w` has a pattern of clock cycles. 
Unlike in NKN, the pattern repeats only a finite number of times `d`.

# Operator Clock Signatures 
Aetherling must assign a **clock signature** to each operator that specifies the order of valid and invalid clocks.
The judgement for an operator's clock signature is `op :: t -> t' :c: ct -> ct'` where `t` and `t'` are the space-time IR types and `ct` and `ct'` are of clock signatures.

## Closed Clock Type Signatures Attempt
A simple approach is to assign a clock signature to each space-time IR type `t` using the function `type_clock_signature(t)`. 
An operator's clock signature is then derived from its space-time IR types.
These clock signatures are **closed** as no free variables appear in them.
Later, I will change some operators' clock signatures from the default specified by `type_clock_signature` to perform optimizations.

1. `type_clock_signature(Int) = 1`
1. `type_clock_signature(t x t') = type_clock_signature(t)`
    1. Note: the [sequence types section](Basic.md#sequence_types) specifies that tuples of sequences must have the same type. 
    This ensures that a tuple's time and clock patterns are equivalent to the pattern of each element in the tuple.
1. `type_clock_signature(SSeq n t) = type_clock_signature(t)`
1. `type_clock_signature(TSeq n v t) = (type_clock_signature(t))[n] (0)[|type_clock_signature(t)| * v]`

The clock cycle pattern of each operator is derived from `type_clock_signature`.
For example, 
1. `Id :: t -> t :c: type_clock_signature(t) -> type_clock_signature(t)`
1. `Add :: (Int x Int) :c: type_clock_signature(Int x Int) -> type_clock_signature(Int)`
1. `Map_s n f :: SSeq n t -> SSeq n t' :c: type_clock_signature(SSeq n t) -> type_clock_signature(SSeq n t')`
2. `Map_t n f :: TSeq n v t -> TSeq n v t' :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq n v t')`


### Why `type_clock_signature` For All Clock Signatures Produces Suboptimal Hardware
The signatures using only `type_clock_signature` produce suboptimal hardware because they require operators to have inefficient implementations.
Consider `Unpartition_t_tt 2 1 :: TSeq 2 0 (TSeq 1 1 Int) -> TSeq 2 2 t :c: 1010 -> 1100`.
Implementing `Unpartition_t_tt` with this type signature would require it to buffer data unnecessarily.
It would need to delay the output by 1 clock cycle relative to the input. 
The first input would be buffered inside the `Unpartition_t_tt` during this clock cycle.
Alternatively, `Unpartition_t_tt 2 1 :: TSeq 2 0 (TSeq 1 1 Int) -> TSeq 2 2 t :c: 1010 -> 1010` can compile to a nop in hardware.
These performance problems are addressed with the special case, closed clock signatures in the [final operator clock signature.](#final_clock_signatures)

### Why The Closed Signatures Produce Suboptimal Hardware
The closed clock signatures produce suboptimal hardware because they are overly specific and thus introduce unnecessary synchronizing buffers.
The closed clock signatures are overly specific because they force an operator to have one clock signature when its hardware implementation supports multiple.
Some operators that produce combinational hardware, such as `Map_t 2 Abs :: TSeq 2 2 Int -> TSeq 2 2 Int`, can have multiple clock signatures with the same implementation.
The hardware implementation of `Map_t 2 Abs` supports both of the following are clock signatures:
1. `Map_t 2 Abs :: TSeq 2 2 Int -> TSeq 2 2 Int :c: 1100 -> 1100`
1. `Map_t 2 Abs :: TSeq 2 2 Int -> TSeq 2 2 Int :c: 1010 -> 1010`

While the same hardware supports both clock signatures of `Map_t 2 Abs`, the different signatures produce different hardware when composed with other operators, such as `Unpartition_tt 2 1`.
`Map_t 2 Abs . Unpartition_t_tt 2 1` requires a synchronizing buffer between `Map_t 2 Abs :c: 1100 -> 1100` and `Unpartition_t_tt 2 1 :c: 1010 -> 1010`. Conversely, no buffer is needed between`Map_t 2 Abs :c: 1010 -> 1010` and `Unpartition_t_tt 2 1 :c: 1010 -> 1010`.
Using the closed clock signatures crated using `type_clock_signature`, the compiler must add the synchronizing buffer.

**Open** clock signatures using free variables provide the flexibility necessary to produce efficient hardware.
I give operators the open clock signature `x -> x` if they can have multiple closed clock signatures.
When an operator with signature `x -> x` is composed with one with a closed clock signature, the `x`'s change to match the closed clock signature.

## Final Clock Signatures
The clock signatures with the above two optimizations are below. 
If an operator appears multiple times in the list, the first signature is a special case optimization. The later signature is a more general case that applies when the first is not applicable.

1. `Id :: x -> x`
1. `Add :: x -> x`
1. `Fst :: x -> x`
1. `Snd :: x -> x`
5. `Tuple :: x -> x`
1. `Map_s n (f :: t -> t' :c: x -> x) :: SSeq n t -> SSeq n t :c: x -> x`
1. `Map_s n f :: SSeq n t -> SSeq n t' :c: type_clock_signature(t) -> type_clock_signature(t')`
    1. We don't need to use `type_clock_signature(SSeq n t)` because nesting `t` in an `SSeq` doesn't change the pattern.
2. `Map_t n (f :: t -> t' :c: x -> x) :: TSeq n v t -> TSeq n v t' :c: x -> x`
2. `Map_t n f :: TSeq n v t -> TSeq n v t' :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq n v t')`
2. `Map2_s n (f :: t -> t' -> t'' :c: x -> x -> x) :: SSeq n t -> SSeq n t' -> SSeq n t'' :c: x -> x -> x`
2. `Map2_s n (f :: t -> t' -> t'' :c: w -> w' -> w'') :: SSeq n t -> SSeq n t' -> SSeq n t'' :c: w -> w' -> w''`
2. `Map2_t n (f :: t -> t' -> t'' :c: x -> x -> x) :: TSeq n v t -> SSeq n v t' -> SSeq n v t'' :c: x -> x -> x`
2. `Map2_t n (f :: t -> t' -> t'' :c: w -> w' -> w'') :: TSeq n v t -> SSeq n v t' -> SSeq n v t'' :c: (w)[n] (0)[v] -> (w')[n] (0)[v] -> (w'')[n] (0)[v]`
1. `Reduce_s n :: (t -> t -> t) -> SSeq n t -> SSeq 1 t :c: type_clock_signature(t) -> type_clock_signature(t)`
2. `Reduce_t n :: (t -> t -> t) -> TSeq n v t -> TSeq 1 (n+v-1) 1 :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq 1 (n+v-1) t)`
1. `Up_1d_s n :: SSeq 1 t -> SSeq n t :c: type_clock_signature(t) -> type_clock_signature(t)` 
3. `Up_1d_t n :: TSeq 1 (n+v-1) t -> TSeq n v t :c: type_clock_signature(TSeq 1 (n+v-1) t) -> type_clock_signature(TSeq n v t)`
4. `Select_1d_s n idx :: SSeq n t -> SSeq 1 t :c: type_clock_signature(t) -> type_clock_signature(t)`
1. `Select_1d_t n idx :: TSeq n v t -> TSeq 1 (n+v-1) t :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq 1 (n+v-1) t)`
1. `Tuple_To_SSeq n :: NTuple n t -> SSeq n t :c: type_clock_signature(t) -> type_clock_signature(t)`
1. `Serialize no ni :: TSeq no (vo+no*vi) (SSeq ni t) -> TSeq no vo (TSeq ni vi t) :c: type_clock_signature(TSeq no vo (TSeq 1 (ni+vi-1) t)) -> type_clock_signature(TSeq no vo (TSeq ni vi t))`
    1. Input clock pattern is get `SSeq ni t` on first clock, emit it over `ni` clocks, wait `vi`, then repeat.
1. `SSeq_To_Tuple n :: SSeq n t -> NTuple n t :c: type_clock_signature(t) -> type_clock_signature(t)`
1. `Deserialize no ni :: TSeq no vo (TSeq ni vi t) -> TSeq no (vo+no*vi) (SSeq ni t) :c: type_clock_signature(TSeq no vo (TSeq ni vi t)) -> type_clock_signature(TSeq no vo (TSeq 1 (ni+vi-1) t))`
    1. Output clock pattern is same as input pattern to `Serialize`. 
    Can do this by delaying the output of `Deserialize` relative to its input by `type_clock_signature(TSeq 1 (ni+vi-1) t) - 1` clocks.
1. `Partition_t_tt no ni :: TSeq (no*ni) (vo + no*vi) t -> TSeq no vo (TSeq ni vi t) :c: type_clock_signature(TSeq no vo (TSeq ni vi t)) -> type_clock_signature(TSeq no vo (TSeq ni vi t))`
    1. This clock signature enables `Partition_t_tt` to become a nop.
1. `Unpartition_t_tt no ni :: TSeq no vo (TSeq ni vi t) -> TSeq (no*ni) (vo + no*vi) t :c: type_clock_signature(TSeq no vo (TSeq ni vi t)) -> type_clock_signature(TSeq no vo (TSeq ni vi t))`
1. `Partition_s_ss no ni :: SSeq (no*ni) t -> SSeq no (SSeq ni t) :c: type_clock_signature(t) -> type_clock_signature(t)`
1. `Unpartition_s_ss no ni :: SSeq no (SSeq ni t) -> SSeq no (SSeq ni t) :c: type_clock_signature(t) -> type_clock_signature(t)`
1. `Shift_s n init :: SSeq n t -> SSeq n t :c: type_clock_signature(t) -> type_clock_signature(t)`
1. `Shift_t n init :: TSeq n v t -> TSeq n v t :c: type_clock_signature(TSeq n v t) -> type_clock_signature(TSeq n v t)`

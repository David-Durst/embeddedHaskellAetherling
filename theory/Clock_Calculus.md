# Clock Calculus For Aetherling
The document explains the clock-level timing information for Aetherling's space-time IR.
It adds:
1. a justification for why Aetherling needs the clock calculus in addition to the standard space-time IR types
1. a justification for why Aetherling's space-time IR types shouldn't be the same as the clock calculus
1. an explanation of the clock notation
1. a definition of the clock timing information for each operator.
1. an explanation of Aetherling's clock calculus relative to the fully clock calculus type system in [N-Synchronous Kahn Networks](https://dl.acm.org/citation.cfm?id=1111054)

I will refer to the N-Synchronous Kahn Networks as NKN.

# Why Clock Calculus
The Aetherling space-time IR specifies the throughput and the total number of clock cycles in an operator's output.
This is shown in the [throughput](Basic.md#thoughput) and [time](Basic.md#time) sections in the basic document.
However, matching throughputs is insufficient to connect consumer and producer operators in synchronous hardware.
The producer may be valid and emit output on a clock cycle where the consumer is invalid and not expecting data.
The emitted data on this clock cycle would be lost without a buffer between the producer and consumer to match clock cycles.
The buffer would store the data until the consumer was ready to accept it.
The clock calculus provides a language that enables Aetherling to 
1. specify the clock cycles that operators accept and emit data on
1. compute the size of the retiming buffer necessary between two operators so that their clock cycles match.

# Why The `n` and `v` Parameters Are The Correct Amount of Detail For Type Checking
The goal of the type `TSeq n v` is to ensure that operators can only be composed if they can compiled to synchronous, streaming implementations.
The `TSeq`'s `n` and `v` parameters specify that an operator accepts or emits data on `n` valid clock cycles out of `n+v` total clock cycles.
If two operators with matching `TSeq` and `SSeq` types are composed, their throughputs and total number of clock cycles match. 
But, they may accept and emit data on different clocks as `TSeq n v` does not specify the order of valid and invalid cycles.
This ambiguity would seem to prevent `TSeq n v` from accomplishing its goal.
Synchronous, streaming hardware requires producer and consumer operators to accept and emit data on the same clock cycle.
However, as noted by the NKN paper, there are producer-consumer pairs which do not emit or accept data on the same clock cycle, but can be made to do so using a finite sized buffer.
These operators are known as **synchronizable**. 

The definition of **synchronizable** operators is: when placing an appropriately sized buffer between them, the result is valid in synchronous hardware as:
1. On every clock cycle where the producer emits data, the buffer is ready to accept input.
1. On every clock cycle where the consumer accepts data, the buffer has data to emit.

This section will show that the `n` and `v` parameters are sufficiently specific so that, if two operators with matching `TSeq` and `SSeq` types are composed, they are synchronizable.

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
    1. `max_clocks_is_ahead` ensures `is` will never expect an input before `os` has emitted it
    1. `max_elements_os_ahead` ensures that if `os` has emitted an element before `is` is ready for it, there will be room in the buffer to store it until `is` is ready.

## Why `n` and `v` Ensure Synchronizability Of Composed Operators
`TSeq`'s `n` and `v` parameters ensure that the sequences contain the same number of valid and invalid clocks. 
Therefore, by the synchronizability theorem, the `n` and `v` parameters are enough to ensure that Aetherling only allows operators to be composed if the inputs and outputs are synchronizable.

## Why Not Replace `n` and `v` With A Complete Clock Calculus
Using the types from the [clock notation section](#clock_notation), let `f` and `g` have the following types:
```
f :: (1010)[1] -> (1010)[1]
g :: (0101)[1] -> (0101)[1]
```
`f . g` cannot be composed with standard, syntactic type equality rules as `(1010)[5]` and `(0101)[5]`. 

With the space-time IR types, `f` and `g` can be composed because they have the following type signatures
```
f :: TSeq 2 2 -> TSeq 2 2
g :: TSeq 2 2 -> TSeq 2 2
```

`f` and `g` should be composable because they are synchronizable.
Thus, I prefer using `n` and `v` for my types rather than a complete clock calculus as it enables composing synchronizable functions using normal type equality.

It may be possible to extend the definition of type equality in Aetherling so that `(1010)[5]` and `(0101)[5]` are of equivalent types.
The NKN paper gives one example of how to do this with its relaxed clock calculus, subtyping rule, and type unification system.
However, in order to use that rule in a type system, they needed to do significant theory work.
I find it much simpler to only use `n` and `v` in my types and do the synchronization below the type system.

# Clock Notation 
Aetherling's clock notation specifies the distribution of valid and invalid clocks in a `TSeq n v`'s period. 
A [period](Basic.md#Time) of 1 in the space-time IR corresponds to 1 clock cycle.

The clocks in Aetherling are a finite version of the infinite, periodic binary words in NKN. 
The clocks must be finite as each `TSeq` in Aetherling is a finite number of clocks.
If `TSeq`'s were infinite, nesting them would not have a clear meaning.
For example, `TSeq infinite (TSeq infinite Int)` is nonsensical. 
One cannot repeat an infinite length sequence an infinite number of times.

The grammar for the notation is
```
ct ::= w | ct x ct | ct -> ct | x
w ::= 1 | 0 | w w | (w)[d] s.t. d is a natural number
```

`1` indicates a valid clock cycle. 
`0` indicates an invalid clock cycle. 
`(w)[d]` repeats the clock pattern `w` for `d` times.
`w w'` is a sequence of clock patterns.

`ct x ct` represents a tuple of two clocks.
I allow tuples with different clocks.
`ct -> ct` represents an operator.
`x` represents a free variable.
I will motivate the need for free variables below.

## Comparisons With NKN
As in NKN, a word `w` has a pattern `v` that repeats. 
Unlike in NKN, the pattern repeats only a finite number of times `d`.
Unlike in the `TSeq n v` type signatures, there are no nested sequences.

# Operator Clock Patterns
Aetherling must assign a clock calculus signature to each operator. 
The type signature is of the form `op :: t -> t' :c: ct -> ct'` where `t` and `t'` are the space-time IR types and `ct` and `ct'` are of clock types.


## Space-Time IR Valid And Invalid Clock Count
Before giving the clock calculus signature of the space-time operators, I need to introduce `default_clock_pattern` function.
They are an extension of the [`type_time` function](Basic.md#time).
These are necessary because functions like `Up_1d_t` must know the total number of valid and invalid clocks when operating on a nested sequence.
For example, `Up_1d_t :: TSeq 5 5 (TSeq 2 1 Int) -> TSeq 5 5 (TSeq 2 1 Int)` needs to know the total number of valid and invalid clock cycles, not just 5 valid and 5 invalid periods.
`type_time_valid(t)` is the number of valid clock cycles needed for an operator to accept or emit one `t`.
`type_time_invalid(t)` is the number of invalid clock cycles needed for an operator to accept or emit one `t`.

1. `type_time_valid(Int) = 1`
1. `type_time_valid(t x t') = type_time_valid(t)`
1. `type_time_valid(SSeq n t) = type_time_valid(t)`
1. `type_time_valid(TSeq n v t) = n * type_time_valid(t)`

1. `type_time_invalid(Int) = 1`
1. `type_time_invalid(t x t') = type_time_invalid(t)`
1. `type_time_invalid(SSeq n t) = type_time_invalid(t)`
1. `type_time_invalid(TSeq n v t) = v * type_time_invalid(t)`

## Closed Form
The simplest approach is to assign a type signature to every operator that fully specifies each's input and output clock pattern.

1. `Id :: 1 -> 1`
1. `Add :: 1 -> 1`
1. `Fst :: 1 -> 1`
1. `Snd :: 1 -> 1`
5. `Tuple :: 1 -> 1`
1. `Map_s n (f :: t -> t' :c: w -> w') :: SSeq n t -> SSeq n t :c: w -> w'`
2. `Map_t n (f :: t -> t' :c: w -> w') :: TSeq n v t -> TSeq n v t' :c: (w)[n] (0)[v] -> (w)[n] (0)[v] `
2. `Map2_s n (f :: t -> t' -> t'' :c: w -> w' -> w'') :: SSeq n t -> SSeq n t' -> SSeq n t'' :c: w -> w' -> w''`
2. `Map2_t n (f :: t -> t' -> t'' :c: w -> w' -> w'') :: TSeq n v t -> SSeq n v t' -> SSeq n v t'' :c: (w)[n] (0)[v] -> (w')[n] (0)[v] -> (w'')[n] (0)[v]`
1. `Reduce_s n :: (t -> t -> t) -> SSeq n t -> SSeq 1 t`
2. `Reduce_t n :: (t -> t -> t) -> TSeq n v t -> TSeq 1 (n+v-1) 1`
1. `Up_1d_s n :: SSeq 1 t -> SSeq n t :c: (1)[type_time_valid(t)] (1)[type_time_valid(t)]` 
3. `Up_1d_t n :: TSeq 1 (n+v-1) t -> TSeq n v t`
4. `Select_1d_s n idx :: SSeq n t -> SSeq 1 t`
1. `Select_1d_t n idx :: TSeq n v t -> TSeq 1 (n+v-1) t`
1. `Tuple_To_SSeq n :: NTuple n t -> SSeq n t`
1. `Serialize no ni :: TSeq no (vo+no*vi) (SSeq ni t) -> TSeq no vo (TSeq ni vi t)`
1. `SSeq_To_Tuple n :: SSeq n t -> NTuple n t`
1. `Deserialize no ni :: TSeq no vo (TSeq ni vi t) -> TSeq no (vo+no*vi) (SSeq ni t)`

### Why The Closed Form Signatures Produce Suboptimal Hardware

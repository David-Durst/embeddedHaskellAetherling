# Aetherling Embedded In Haskell

This is a prototype of an intermediate representation (IR) for Aetherling. This prototype explores how a type system might ensure that all correctly typed dataflow programs can compile to statically scheduled, efficient implementations in hardware such as FPGAs. [Please see the main Aetherling repository for an overview of Aetherling.](https://github.com/David-Durst/aetherling) This IR is embedded in Haskell to take advantage of Haskell's types. In particular, it utilizes Haskell's dependent types, explicit modeling of category theory concepts, and function composition operators.

The goal of this IR is to represent a schedule of a dataflow program that the Aetherling auto-scheduler can compile to a statically-scheduled implementation in hardware.[*](https://github.com/David-Durst/embeddedHaskellAetherling#appendix) The IR's schedule specifies the average input and output rates of stages in the program. These rates are specified by data types that schedule computation over the data in parallel (aka in space) or in sequence (aka in time). The language does not specify all timing information in a static schedule for a data-flow pipeline in hardware. Such information includes latencies of nodes in the pipeline. Rather, this IR's type system is meant to ensure that a static schedule can be produced for any program expressed in the IR. It guarantees this as the rate-matching type checks are equivalent to an SDF solve. Both require matching average input and output rates of adjacent nodes in a dataflow graph. If all the rates match, then the auto-scheduler will be able to find a static schedule and compile the program to hardware.

The IR is a typed combinator language in which dataflow programs are expressed using point-free compositions of combinators. The dataflow programs operate on fixed length, ordered collections of data. This IR is broken down into five main components: 
1. Types for describing atoms and ordered, fixed length collections of data. The ordered collections schedule computation. 
    1. An atom is a unit of data that cannot be broken down further. In Aetherling, these are bits and ints.
    1. There are three types of ordered collections. The Space Time Independent Ordered Collection (STIOC) is one that doesn't schedule computation in space or time. The Array schedules compute in space as all it's elements must be processed in parallel. The Sequence schedules compute in time as all it's elements must be processed in sequence.
    2. For example, a Sequence of Arrays would mean that each of the arrays are processed sequentially, but that all the elements of each array are processed in parallel.
2. Operators on atoms and ordered collections
2. Combinators for composing the operators
3. Functors for lifting types and combinators to ordered collections of the types and combinators on those ordered collections. Since these are Haskell endofunctors on the category of types, they can lift any types and combinators. For example, the STIOC 3 combinator, which lifts types to a STIOC with 3 elements, can lift an Int to a STIOC 3 Int and a STIOC 3 Int to a STIOC 3 (STIOC 3 Int)
4. Isomorphisms between ordered collections for converting between schedules. This allow converting pipelines that are on STIOCs to pipelines on differently nested combinations of Arrays and Sequences. Thus, the isomorphisms enable scheduling in space and time.


The following are the important files in this repository. Each file has a few examples at the bottom to demonstrate how to use it components.

## [DataTypes.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/DataTypes.hs)
This file defines the atomic data types, the three types of ordered collections, and the functors for lifting to those collections.

## [SpaceTimeModules.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/SpaceTimeModules.hs) 
This file contains nicer interfaces for the functors.

## [AtomModules.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/AtomModules.hs)
This file defines the operators (aka modules) on atoms. Despite the name, it also has a few operators on STIOCs.

## [Isomorphism.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/Isomorphism.hs)
This file defines the isomorphisms for scheduling pipelines in space and time.

# Appendix
Note: This is a prototype. There is currently no work on actually making this IR compile to hardware. It's an experiment in a strongly-typed language like Haskell to enforce formality on my ideas. I will be reimplementing this language in Python so that it's easier to compile to Magma. Magma is a Python library that can compile to Verilog.


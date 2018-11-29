# Aetherling Embedded In Haskell

This is a prototype of an intermediate representation for Aetherling. [Please see the main Aetherling repository for an overview of Aetherling.](https://github.com/David-Durst/aetherling/tree/master/aetherling) This repository is a DSL embedded in Haskell in order to take advantage of Haskell's types. In particular, it utilizes Haskell's dependent types, explicit modeling of category theory concepts, and function composition operators.

This language is an intermediate representation (IR) in Aetherling's auto-scheduler. The language ensures that adjacent components in a pipeline have matching average rates of data so that there are no bottlenecks. These rates are specified by data types that schedule computation in parallel (in space) or in sequence (in time). The language does not specify all timing information necessary to statically schedule a data-flow pipeline in hardware such as FPGAs. Such information includes latencies of nodes in the pipeline. Rather, this language's type system is meant to ensure that any program expressed in the language **CAN** be statically scheduled to hardware. It guarantees this as the rate-matching type checks are equivalent to a Synchronous Dataflow (SDF) solve as both require matching average input and output rates of adjacent nodes in a dataflow graph. The lower levels of the auto-scheduler will find that schedule and compile the program to hardware.

NOTE: no auto-scheduler exists yet.

The IR is a typed combinator language in which programs are point-free compositions of combinators. This front-end language is broken down into four main components: 
1. Types for describing atoms or ordered, fixed length collections of data that flow through the system. These types just describe the amount of data inputted or outputed by a node in a data flow pipeline, not the rate or latency of the data.
  1. An atom is a unit of data that cannot be broken down further. In Aetherling, these are bits and ints.
2. Operators on atoms and ordered collections.
2. Combinators for composing the operators
3. Functors for lifting types and combinators to ordered collections of the types and combinators on those ordered collections. Since these are Haskell endofunctors on the category of types, they can lift any types and combinators. For example, they can lift Int to [Int] and [Int] to [[Int]]. ([] is not actually an ordered )
  1. There are three types of sequences. The Space Time Independent Ordered Collection (STIOC) is a sequence that doesn't schedule throughput. The Array schedules compute in space. The Sequence schedules compute in time.
  2. A Sequence of Arrays would mean that each of the arrays are processed sequentially, but that all the elements of one array are processed in parallel.
4. Isomorphisms for scheduling. This allow converting pipelines that are on STIOCs to pipelines on differently nested combinations of Arrays and Sequences. Thus, the isomorphisms enable scheduling in space and time.


The following are the important files in this repository. Each file has a few examples at the bottom to demonstrate how to use it components.

## [DataTypes.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/DataTypes.hs)
This file defines the atomic data types, the three types of ordered collections, and the functors for lifting to those collections.

## [SpaceTimeModules.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/SpaceTimeModules.hs)
This file contains nicer interfaces to the functors.

## [AtomModules.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/AtomModules.hs)
This file defines the operators (aka modules) on atoms. Despite the name, it also has a few operators on STIOCs.

## [Isomorphism.hs](https://github.com/David-Durst/embeddedHaskellAetherling/blob/master/src/Isomorphism.hs)
This file defines the isomorphisms for scheduling pipelines in space and time.


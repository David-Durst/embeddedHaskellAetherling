# Aetherling Language Theory
Aetherling is a system for compiling data flow pipelines to efficient implementations in hardware accelerators.
Aetherling programs are written in a **sequence language**, a standard functional programming language.
The sequence language is a high-level language that does not address parallelism. 
The absence of parallelism makes the language simpler for developers.
This abstraction also means programs cannot be interpreted as hardware accelerators.

Aetherling transforms these programs into a **space-time IR**. 
The IR specifies the parallelism of all operators.
This information enables programs in the IR to be interpreted as hardware accelerators.
The IR also models the throughput and resource requirements of the corresponding hardware implementations.
An auto-scheduler uses semantics-preserving transformations in the IR to find the highest throughput hardware implementation given resource constraints.

The transformations on programs are implemented using rewrite rules.
One set of rewrite rules convert programs in the sequence language to ones in the space-time IR.
Another set of the rewrite rules used by the auto-scheduler convert between programs in the space-time IR.

We define a minimal set of rewrite rules using isomorphisms to show that they preserve program semantics.
There are isomorphisms between data types in the sequence language.
There are also isomorphisms between sequence data types and ones in the space-time IR.
These isomorphisms mean that, for any function the sequence language, there are many semantically equivalent functions using the space-time IR.
The different functions in the space-time IR are different schedules with different amounts of parallelism.
The minimal set of rewrite rules, along with other derived ones, are the conversions between semantically equivalent functions.
Thus, the rewrite rules and auto-scheduler preserve semantics even while changing parallelism and resource requirements.

We also prove properties of the auto-scheduler by defining properties of the operators in the space-time IR.
We axiomatize the properties for time, throughput, and resource requirements of the IR's operators.
The properties enable us to prove that the auto-scheduler always produces programs in the space-time IR that are efficient and maximally parallel.

## Files To Read
### [Basic.md](Basic.md)
This document covers the basic parts of the sequence language and the space-time IR
1. Types
1. Standard Functional Programming and 1D Image Processing Operators
1. Operators' Properties
1. Isomorphisms

The document also shows the rewrite rules between operators.

### [Scheduling.md](Scheduling.md)
This document explains how to schedule sequence language programs. **Scheduling**
is the process of converting all operators in a program from the sequence
language to the space-time IR such that the resulting program has a target
parallelism.

This document also explains the auto-scheduler, which finds the space-time IR
version of a program with the maximum parallelism given resource constraints.

### [Partition.md](Partition.md)
This document adds the Partition operator to both the sequence language and the
space-time IR.

### [Stencil.md](Stencil.md)
This document adds the `Stencil_1d` and `Stencil_2d` operators to both the
sequence language and the space-time IR.

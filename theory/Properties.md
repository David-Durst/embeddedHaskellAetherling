# Properties Of Aetherling
1. Functional DSL input
    1. DSL does not specify throughput or resource requirements
    1. Type system only allows programs that can be lowered to throughput-aware IR
    1. Sequence language is the DSL
1. Throughput and resource aware IR 
    1. Resource requirement estimates of each operator
    1. Exactly one interpretation of each operator as hardware
    1. Type system only allows programs that can be lowered to efficient hardware
        1. "Efficient hardware" - synchronous, streaming hardware with minimal buffering between operators.
    1. Space-time IR is the IR
1. "Mechanical" rewrite rules: convert between operators in the sequence language and space-time IR while preserving semantics
    1. Mechanical - for an operator `f` in sequence language, the output of `example_rewrite_rule(f)` should be the same regardless of other operators composed with `f`
1. Scheduler that uses rewrite rules to perform following operation:
    1. Input: (sequence language program, throughput in range of fully parallel to fully sequential)
    1. Output: Either 
        1. Program in space-time IR that has same semantics as sequence language program with desired throughput
        1. Failure if cannot produce such a program
1. Auto-scheduler: 
    1. Input: (sequence language program, available resources)
    1. Output: Either
        1. Maximally parallel program that fits in available resources
        1. Failure if cannot produce such a program
1. Clock Calculus: Compute exact invalid and valid clock cycles in order to produce synchronous circuits with FIFOs between operators sized by compiler rather than developer.

# Philosophies Behind Properties
1. **Mechanical** - All transformations should be "mechanical"
    1. Mechanical - when transforming an operator, the transformation should be the same regardless of the context surrounding the operator
    1. Transformations here include: rewrite rules, scheduler, auto-scheduler
    1. **Why?** - Mechanical transformations are simpler to understand. If a transformation always behaves the same, it's easier to understand the relationship between input and output.
1. **Mental Model Of How To Map To Hardware** - At any point in the system, should be able to look at a program and understand what hardware it will produce
    1. Mental model becomes more precise as apply lowering passes from sequence language to space-time IR
    1. **Why?** - 
        1. I assume developers know what hardware they want to produce. I'm trying to help them produce that hardware, not guess what is best.
        1. If hardware matches mental model, it's easier for developers to understand and modify Aetherling's output.

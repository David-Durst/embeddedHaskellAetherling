# Properties Of Aetherling
1. Developer writes code in a "standard" functional programming language.
    1. Standard means that the language does not consider throughput or resource requirements
    1. This language is the sequence language.
1. Have an IR where know the throughput and resource requirements of each operator
    1. This IR is the space-time IR
1. Have exactly one way to convert each operator in space-time IR to "efficient" hardware.
    1. Efficient means synchronous, streaming hardware with minimal buffering between operators.
1. Have a mechanical set of rewrite rules for converting operators in sequence language to space-time IR depending on desired throughput
1. Sequence language type system restricts developer to only programs that can be lowered to space-time IR 
1. Space-Time IR type system restricts developer to only programs that can be lowered to efficient hardware
1. Have an auto-scheduler: a mechanical algorithm for converting programs in the sequence language to programs in the space-time IR with maximal throughput given resource constraints.

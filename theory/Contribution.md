# Aetherling: Predictable Space-Time Scheduling of Data Flow Pipelines To Synchronous, Streaming Hardware Accelerators 
## Contribution
Existing systems for creating hardware accelerators from high-level code, like Clash and Vivado HLS, compile large subsets of C and Haskell to hardware description languages (HDL) like Verilog. 
As part of the compilation process, these systems have scheduling algorithms that tradeoff between resource utilization and throughput. 
HLS has optimizations that parallelize for loops by unrolling them. 
Clash has similar rewrite rules for parallelizing folds and other functional programming operations.
However, these optimizations are challenging to use. 
The Vivado HLS compiler is unpredictable: it is free to ignore the optimizations in one part of the program depending on its analysis of the rest of the program.
Clash does not have an auto-scheduler to automatically apply its rewrite rules.

Other systems', such as RIPL, have scheduling algorithms that produce more performant hardware than HLS and other more general systems.
RIPL does so by limiting its input languages to specific application domains, such as data flow pipelines for image processing. 
However, these schedulers' optimizations are also unpredictable. 
Changing one part of a pipeline may cause the optimizations for other parts deactivate, yielding a large circuit with lower throughput.
Unpredictability makes efficient software development challenging because it requires the developer to understand not only their current module, but how it interfaces with the rest of the program and the compiler's global optimizations.

The challenge is how to balance supporting a wide array of applications, optimizations that transform the code into performant hardware, and a predictable system that enables the developer to actually use the languages to create performant hardware. 
Aetherling focuses on a limited set of applications and hardware design space so that it is predictable: it produces the same hardware for each operator in a pipeline regardless of the other operators in the pipeline.
Aetherling restricts it's supported applications through a developer-facing language that is a small, standard, functional dataflow languages based on prior image processing systems like RIPL and Rigel.
Aetherling restricts the hardware design space even more than RIPL and Rigel by only producing synchronous, streaming hardware that doesn't require dynamic communication between operators. 
Through this limited focus, Aetherling makes the following contributions:
1. A developer-facing language that is similar to standard dependently typed, functional programming language that runs on CPUs, but whose type system ensures that all expressible programs compile to synchronous, streaming hardware.
1. An IR for producing hardware whose operators have three properties:
    1. They are complete enough to represent tradeoffs in area and throughput.
    1. They are simple enough so that resource utilization can be approximated at compile time with XX% accuracy using a predictable analytical model.
    1. Their types specify the throughput of the resulting hardware.
1. A predictable, rewrite rule-based auto-scheduler from the developer-facing language to the hardware IR that explores the design space to increase throughput within resource constraints.

## Analogies Between Aetherling And Other Systems
These analogies are between [Aetherling's properties](https://github.com/David-Durst/embeddedHaskellAetherling/blob/rewrites/theory/Properties.md) and those of other systems.

### Summary 
[Summary is in this Excel document.](Analogy_Summary.xlsx)

### Detailed Analogies
1. Darkroom
    1. Somewhat analogous to sequence language - p. 3 of **Darkroom: Compiling High-Level Image Processing Code into Hardware Pipelines** - the darkroom programming model of image functions that are acessed like 2d arrays to produce new image functions. This is somewhat similar to sequence language as darkroom doesn't consider time here. However, it seems more natural to write in Darkroom's style as stencil operations are expressed as matrix coordinates rather than using a stencil operator to convert a 1D stream of pixels into a 2D stream
    1. No analogy to space-time IR - instead of an IR between the two, there is a direct mapping from programming model to hardware.
        1. p. 3 - "[the] pipeline processes input in time steps, one pixel at a time. During each time step, it consumes one pixel of input and produces on pixel of output" - since no parallelism, no space-time tradeoffs
            1. **Question 1** - since on p. 2 of Darkroom it says that Leiserson and Saxe show how to pipeline and parallelize these circuits to an arbitrary amount, why does darkroom only support pipelines that operator on one pixel per cycle?
            1. **Question 2** - Is Darkroom's novel technique is that it specifies the delays in each producer-consumer relationship as an integer linear program?
                1. **Answer** - Yes.
        1. p. 5-6 - Not worth having a space-time IR to make tradeoffs in between few choices for tradeoffs in memory sizes. This difficulty is due to Darkroom's FPGA target having "SRAMs and BRAMs that are only available in discrete sizes, each with different costs"
    1. Analogous to rewrite rules - p. 5 - Assign a delay between stages and change delay by solving linear equations. The global equation solving is instead of rewriting operators to trade off area. The solutions two goals are:
        1. preserve causality - ensure producer always emits before consumer requires it
        1. minimize number of delay registers 
    1. Analogous to clock calculus - p. 4-5 - finding the minimal buffering between stages using ILP so can have synchronous circuits.
        1. unlike my clock calculus algorithm - I'm doing a local solve for buffering between stages. Darkroom considers all edges to find minimal buffering between all stages
        1. Not like my scheduling - What I call scheduling is finding most parallel data flow graph that fits on chip. What Darkroom calls scheduling is finding minimal buffering, like my clock calculus work.
    1. See above why no analogy to scheduling
1. Rigel
    1. Analogous to sequence language - p. 2 - 
        1. Each of the operators in Rigel have a input and output rate - number of input and output tokens per firing.
        1. However, operators pre-scheduling do not know how frequently they will fire relative to each other.
        1. This is same as sequence language operators that state total amount of data but not time.
        1. Unlike sequence language, no type system forces operators to only compose if they operate on same total amount of data. Since Rigel input and output rates are only per firing, no need to match total rates as each operator can be repeated as many times as necessary
    1. Analogous to space-time IR - p. 2
        1. Firing rates determine how fast units run relative to each other so they have matching throuhgputs
        1. This is similar to TSeqs and SSeqs that ensure operators in space-time IR have matching throughputs
        1. p. 2 - use SDF to solve for firing rates, which show when running in a ready-valid circuit how long it will take module to complete a "firing" throughput
        1. Note that while SDF solves for rates, the solution isn't used for large classes of circuits
            1. p. 5 - For pipelines with upsamples or down samples, the rates occur from running the dynamic system of ready valids. The SDF only predicts what these rataes are going to be.
                1. For these circuits, the comiler doesn't know when the valids and invalid clocks occur in a firing period. The clocks are determined dynamically by ready valid signals
            1. Single-rate modules can have statically known patterns of valid and invalid in a firing periods, so SDF solve can produce information that is encoded into these circuits 
        1. p. 2 - Effective rate is a modules input/output rate multiplied by a firing rate.
    1. Analogous to clock calculus - p. 3 - variable-latency SDF allows kernels with matching throughputs and then uses FIFOs to "hide latency variation" by ensure matching on same clock cycle
        1. I do exactly this approach in my old "native linebuffer" for paper attempt in March 2019 - when my linebuffer downsamples in the Y dimension, I stick a delay_buffer afterwards to normalizing the pattern. This is the exact same exacmple as p. 3 of Rigel paper
        1. p. 5 - Rigel requires developer to manually size FIFOs as no clock calculus to determine when on a valid clock
        1. p. 5-6 - Variable Latency Hiding - Rigel uses a simulator to determine the FIFO sizes to normalize output from modules with variable latency. I know FIFO size due to clock calculus, so I know how big the FIFOs are
        1. p. 6 - FIFOs used to break up ready-valid chains. The user must manually add these as well. I might be able to automatically add these with a latency approximation
    1. No analogy to Aetherling's scheduling - p. 2-3 - There are no rewrite rules for making a pipeline more or less parallel. The Rigel SDF solves for relative firing rates that will happen regardless of scheduling when the dynamic hardware is produced.
    1. Why Rigel's programming language needs SDF to find invalid circuits:
        1. Rigel allows operators to be composed even if tokens per firing doesn't matching
        1. Rigel then uses SDF to ensure that a relative firing rate assignment makes the throughputs of producers and consumers match
        1. However, it is possible to compose graphs where matching throughputs for one producer-consumer pair prevents matching throughputs for another pair, see p.2 for an example of this
        1. Aetherling only allows operators in the Sequence language to be composed if total amount of data match. Then since all the operators must take the same amount of time when lowered to space-time IR, their throughputs must also match.
1. RIPL - 2018 - RIPL: A Parallel Image Processing Language For FPGAs
    1. Analogous to sequence language - p. 5 - skeletons are resource unaware image processing operations with dependent types that specify the sizes of the arguments
    1. Analogous to space-time IR - 
        1. p. 7 - dataflow actor with finite state machine that specifies how the actor behaves
        1. p. 6 - FSMs specified as cyclostatic dataflow actors 
        1. p. 10 - compiler actors to CAL dataflow language that compiles it to verilog
        1. p. 7 - different from space-time IR as no spatial parallelism by duplicating operators. Only spatial parallelism is by duplicating users code within an operator.
            1. p. 11 - unclear what it means that "code generation strategy maximizes spatial parallelism". P. 7 said only spatial parallelism inside operators. Stencils like their fold aren't parallelizable since it uses the foldl type signature with an initial value and no requirements that accumulator function is associative and commutative.
    1. Analogous to rewrite rules - p. 7 - compile each skeleton to a correspodning dataflow actor
        1. p. 22 - no space-time rewrite rules proposed in this paper
        1. p. 10 - they do have optimizations in the dataflow IR however
        1. **Profile Guided Dataflow Transformation for FPGAs and CPUs** - p. 7-8 - Perform rewrite rules on dataflow actors including 
            1. actor fusion - merge actors to save on communication costs as actors communicate through FIFOs and inside actors can have shared memory
            1. Actor fission - split actors and run them in parallel
            1. loop fission - requires analyzing code to make sure no loop-carry dependencies
            1. task parallelism - building parallel reduce trees
    1. Analogous to scheduling - instead of finding parallelism, mapping to CAL compiler that solves for firing rates and using FIFOs to match variable latency
    1. Analogous to clock calculus - p. 10 - the actors communicate asynchronously through FIFOs that are sized using the CAL compilre
        1. Not specified in paper, but very likely - CAL compiler looks at CSDF patterns and determines the right FIFO sizes
1. Spatial - 2016 – Generating Configurable Hardware from Parallel Patterns - Spatial has a very different focus. It doesn't have a basis in SDF. Its about creating a series of FSMs that communicate dynamically and allowing the user to explicitly size the memory buffers between the FSMs and the between the FPGA and the host's memory.
    1. No analogy to sequence language - p. 5 - operators are throughput aware as they have a counter parameter that specifies parallelism
    1. Analogous to space-time - p. 5 - operators like mapreduce that compile to hardware. They have parallelism parameters, though that doesn't specify throughput as don't know clock rate.
    1. Analogous to rewrite rules - p. 8 and 9 - loop unrolling according to parallelism parameters and register retiming
    1. Analogous to scheduling - DSE using optimizer that explores values for free variables left in code by user
    1. Analogous to clock calculus
    1. Spatial has a large focus on memories and the chip interface that Aetherling doesn't have.
    1. **Side Question** – when I do everything I need to support Halide, why won't I need some of their operators that do not fit in my system?
1. HLS - **Introduction to High-Level Synthesis with Vivado HLS** 
    1. Analogous to sequence language - p. 7 - User writes C
    1. Analogous to space-time IR - p. 7 - unclear from presentation, but looks like a sequence of FSMs where the FSMs change state on clock cycles
        1. p. 17 - example of unrolling, not sure where in the IR this unrolling is represented 
    1. Analogous to rewrite rules - p. 17 - have directives for doing optimizations like look unrolling
    1. Analogous to scheduling - p. 9 - 11 - their scheduling has two stages
        1. scheduling - assigning clock cycles to operations
        1. binding - picking which gates to place for each C command
    1. Analogous to clock calculus - p. 10 - Vivado's scheduling assigns clock cycles to each operation
1. Clash
    1. Analogous to mapping sequence language - p. 89 of **Digital Circuits in ClaSH** -  Map haskell to circuits using system FC normal form to netlist conversion
    1. Analogous to space-time operators - p. 223 of **Design Space Exploration of a Particle Filter using Higher-Order Functions** - fold operator in space and time that compiles to parallel and sequential hardware.
        1. Also - p. 59 of **A Transformation-Based Approach To Hardware Design Using Higher-Order Functions** - language with LstTime and LstSpace, which are analogous to my TSeq and SSeq.
            1. Note: not using dependent types, types don't specify how parallel operators must be. The thesis doesn't specify how it knows how parallel operators should be.
        1. p. 66 - implemented as components in which space-time rewrite rules have already been applied. The user, not compiler, has to rewrite themselves from resource agnosted to LstTime and LstSpace
        1. p. 81 - all transformations of data flow nodes are done by hand, rewrite rules not implemented in compiler
        1. p. 89-91 - implement stencil2d using parallelizable implementation that minimizes storage by using rewrite rules. 
    1. Analogous to rewrite rules - p. 223 of **Design Space Exploration of a Particle Filter using Higher-Order Functions** - rewrite fold to fold in space and time to achieve partially parallel implementation
        1. Note: p. 225 - this paper states that compiler doesn't implement rewrite rules, must be done by hand
    1. Not analogous to auto-scheduler - p. 225 of **Design Space Exploration of a Particle Filter using Higher-Order Functions** - must manually select rewrite rules.
    1. Analogous to clocks calculus - p. 223 of **Design Space Exploration** and p. 63 of **Transformation-Based** - use FIFOs between stages to match clock cycles, but don't discuss how to size FIFOs
1. Lift
    1. Analogous to sequence language - p. 207 of **Generating Performance Portable Code using Rewrite Rules** - map/zip/reduce, and other operators that don't consider parallelism, just dependently typed to know total size of input and output
    1. Analogous to space-time IR - p. 76 of **Lift: A Functional Data-Parallel IR for High-Performance GPU Code Generation** - implement map/reduce primitives that are fully parallel and sequential in OpenCL
        1. p. 78-9 - Use dependent types on operator's inputs and outputs to size memories. However, the types may not be used to compute throughput to ensure different krenels run at the same rate. It looks as if the amount of parallelism is not specified in the IR.
    1. Analogous to rewrite rules - p. 7 of **High Perofrmance Stencil Code Generation with Lift** - implement parallelizable 2d stencil using rewrite rules with primitive operators that are solely fully parallel or sequential. They call the parallelization "overlapped tiling".
        1. p. 209 of **Generating Performance Portable Code using Rewrite Rules** - rewrite map, reduce from resource agnostic to partially parallel implementations using fully sequential and parallel operators
    1. Analogous to auto-scheduler - p. 212 of **Generating Performance Portable Code using Rewrite rules** - random walk with monte-carlo simulation to understand how rewrite rules impact performance.
        1. Each step in random walk
            1. Start with high-level expression
            1. Check all valid rewrite rules
            1. Randomly walk down search tree
            1. Try different generated expressions, whichever one is fastest, use that for next step in random walk.
    1. No analogy to clock calculus as code runs on temporal processor, GPU, and don't need to count clock cycles

# Other Applications
1. FIR - an example in Spatial
1. Particle Filter - in Clash transformations thesis

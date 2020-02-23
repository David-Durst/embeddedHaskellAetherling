# Getting Started Guide 
To get started with the VM:
1. Use VirtualBox version 6.0.10 available at https://www.virtualbox.org/wiki/Download_Old_Builds_6_0
2. Login using user "pldi" and password "the_pldi".
3. Run Aetherling's test suite which will schedule 22 unit tests, the 4 applications in the paper, and 2 additional applications.
    a. Run the suite by executing the following commands in the VM
        i. Open a terminal
            1. Click the start menu (officially the "Whisker Menu" in XFCE) in the top, left corner of the screen
            2. Select "Terminal Emulator" from the options
        ii. Move to the directory containing Aetherling's Haskell implementation
            1. Type the following (without "") in the terminal: "cd /home/pldi/pldi/embeddedHaskellAetherling/"
        iii. Run the test suite
            1. Type the following (without "") in the terminal: "stack test --test-arguments '--num-threads 1'"
    b. The unit tests can be found in the file "/home/pldi/pldi/embeddedHaskellAetherling/test/Test_Slowdown.hs"
    c. The applications can be found in the file "/home/pldi/pldi/embeddedHaskellAetherling/test/Test_Apps.hs"
    d. Each unit and application test stresses the following components of the system:
        i. Sequence Language (section 3 of paper) - each is written shallow embedding of the sequence language in Haskell
            1. See section 7 of the paper for the discussion and references on shallow and deep embeddings
        ii. Space-Time IR (section 4 of paper) - each test has a _ppar variable which contains different Space-Time IR versions of the program at different throughputs.
        iii. Rewrite Rules (section 5 of paper) and Scheduling (section 6 of paper) - the _ppar variable produces the Space-Time IR versions by calling
        "compile_with_slowdown_to_expr". One such variable is "single_map_ppar" in Test_Slowdown.hs.
        This function implementes the scheduler using the rewrite rules. The slowdown argument (the "s" variable in each expression in the code)
        specifies the target output throughput by stating that it should be s times less than the throughput necessary to emit the entire output in a single clock cycle.
        iv. Implementation (section 7 of paper) - the prior points stress the Sequence Language and Space-Time IR implementations. 
        Additionally, each test has a _results variable, such as "single_map_results", which stresses the compiler that lowers from the Space-Time IR to Verilog by:
            1. Emitting an implementation of the Space-Time IR circuit in Magma, a Python HDL.
            2. Running the Magma file to generator Verilog.
            3. Simulating the Verilog with Verilator and ensuring that with the inputs specified by the _inputs variable, such as "single_map_inputs", the circuit produces output which has the correct Space-Time type and the values are the same as those specified by the _output variable, such as "single_map_output". 
            4. See "/home/pldi/pldi/embeddedHaskellAetherling/test/verilog_examples/aetherling_copies" for the resulting verilog files. While these files will exist before running the tests, the tests will overwrite them.
        v. Evaluation (section 8 of paper) - see Step-by-Step Instructions section
    e. To explore each of the variables discussed in 3.d
        i. Use the Haskell REPL
            1. Start the RPL by typing the following (without "") in the terminal: "stack ghci --test"
            2. The above command should be issued from the directory "/home/pldi/pldi/embeddedHaskellAetherling/" 
        ii. Some useful functions in the Haskell terminal are:
            1. "print_st" - This prints a string representation of a Space-Time IR program.
                1. "print_st (single_map_ppar !! 0)" - example of how to use each. Each _ppar variable is a list of Space-Time IR programs. 
                Use !! to access one element of the list.
                1. Note: these programs will not have the registers added for latency match. That is a later pass in the compiler after "compile_with_slowdown_to_expr".
            2. "print_st_input_types" - This prints a string representation of a Space-Time IR program's input types
                1. "print_st_input_types (single_map_ppar !! 0)" - example of how to use each.
            2. "print_st_output_type" - This prints a string representation of a Space-Time IR program's output type
                1. "print_st_output_type (single_map_ppar !! 0)" - example of how to use each.
        
            

# Step-by-Step Instructions
1. To reproduce the experiments in the Evaluation (section 8 of paper)
    a. Type the following (without "") in the terminal: "cd /home/pldi/pldi/embeddedHaskellAetherling/"
    b. Type the following (without "") in the terminal: "pnr/run.sh"
        i. NOTE: This will take between 1 and 4 hours to run. It is doing synthesis and implementation using Xilinx Vivado Design Suite 2018.2 for many designs.
        ii. This step runs synthesis on the verilog files in "/home/pldi/pldi/embeddedHaskellAetherling/test/verilog_examples". 
        iii. The top folders in that directory separate the Aetherling, Halide-HLS (titled halide_to_hardware), and Spatial verilog files. 
        iv. We have included the Halide-HLS and Spatial verilog files generated for the paper. The Aetherling verilog files are regenerated each time the tests are rerun.
        v. Within each of the aetherling_copies, halide_to_hardware, and spatial folders are the folders for each application in the Evaluation section. These are: map, conv2d, conv2d_b2b, and sharpen. The other apps within the aetherling_copies folder may work but are not part of the paper's results.
        vi. Within each of the app's folders are the verilog files for the app at a specific throughput specified by slowdown. For example, the file "/home/pldi/pldi/embeddedHaskellAetherling/test/verilog_examples/aetherling_copies/conv2d/conv2d_16.v" has a slowdown of 16, or emits the output at 16th the rate of a pipeline that emitted all output in 1 clock cycle.
        vii. To run fewer designs through Vivado and thus finish pnr/run.sh more quickly, delete some of these files. Note: doing so may break the chart generation code for visualizing the results. You may be required to edit "/home/pldi/pldi/aetherling/aetherling/helpers/pnr_graphs.py" to deal with less data.
    c. When the prior step finishes, the graphs which reproduce figures 11-13 in the paper will be in "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs". Additionally, stdout will contain the data from the graphs in text form.
        i. "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs/ae_results.pdf" - reproduces figure 11 
        ii. "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs/ae_versus_hth.pdf" - reproduces figure 12
        iii. "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs/ae_versus_sp.pdf" - reproduces figure 13
        iv. We use the following shorthands in the stdout:
            a. SP - Spatial
            b. HTH - Halide-To-Hardware, ie Halide-HLS
2. To explore the scheduler and rewrite rules code, look at "/home/pldi/pldi/embeddedHaskellAetherling/src/Core/Aetherling/Rewrites/Sequence_To_Partially_Parallel_Space_Time/Rewrite_Expr.hs". 
    a. The top function in this file is "rewrite_to_partially_parallel". It converts a Sequence Language expression into a Space-Time IR expression with a target throughput.
    b. The rewrite rules are implemented in the function "sequence_to_partially_parallel".
3. To explore the shallow and deep embeddings of the Sequence Language and Space-Time IR, look at the code contained within "/home/pldi/pldi/embeddedHaskellAetherling/src/Core/Aetherling/Languages".

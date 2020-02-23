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
            3. Simulating the Verilog with Verilator and ensuring that with the inputs specified by the _inputs variable, such as "single_map_inputs", the circuit produces output which has the correct Space-Time type and the values are the same as those specified by the _output variable, such aas "single_map_outpuot". 
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



Running the suite will test the key claims of the paper

Your README.txt should consist of two parts:

    a Getting Started Guide and
    Step-by-Step Instructions for how you propose to evaluate your artifact (with appropriate connections to the relevant sections of your paper);

The Getting Started Guide should contain setup instructions (including, for example, a pointer to the VM player software, its version, passwords if needed, etc.) and basic testing of your artifact that you expect a reviewer to be able to complete in 30 minutes. Reviewers will follow all the steps in the guide during an initial kick-the-tires phase. The Getting Started Guide should be as simple as possible, and yet it should stress the key elements of your artifact. Anyone who has followed the Getting Started Guide should have no technical difficulties with the rest of your artifact.

The Step by Step Instructions explain how to reproduce any experiments or other activities that support the conclusions in your paper. Write this for readers who have a deep interest in your work and are studying it to improve it or compare against it. If your artifact runs for more than a few minutes, point this out and explain how to run it on smaller inputs.

Where appropriate, include descriptions of and links to files (included in the archive) that represent expected outputs (e.g., the log files expected to be generated by your tool on the given inputs); if there are warnings that are safe to be ignored, explain which ones they are.

The artifact’s documentation should include the following:

    A list of claims from the paper supported by the artifact, and how/why.
    A list of claims from the paper not supported by the artifact, and how/why.

Example warnings: Performance claims cannot be accurately reproduced in a VM, authors are not allowed to redistribute specific benchmarks, etc. Artifact reviewers can then center their reviews / evaluation around these specific claims.

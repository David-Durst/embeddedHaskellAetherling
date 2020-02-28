# Getting Started Guide 
To get started with the VM:
1. Use VirtualBox version 6.0.10 available at https://www.virtualbox.org/wiki/Download_Old_Builds_6_0
    a. Import the downloaded .ova file using https://docs.oracle.com/cd/E26217_01/E26796/html/qs-import-vm.html
2. Login using user "pldi" and password "the_pldi".
3. Install Xilinx Vivado 2018.2.
Note: This step is not necessary to complete the rest of the Getting Started Guide.
The reviewers may stress parts of the artifact relating to the Lseq, Lst, Scheduler, and Rewrite Rules sections of the paper without this step.
However, it's required to complete the step-by-step instructions and reproduce the graphs in the Evaluation section.
We cannot redistribute the Xilinx Vivado tools with the VM due to their licensing agreement.
    a. Open a web browser
        i. Click the start menu (officially the "Whisker Menu" in XFCE) in the top, left corner of the screen.
        ii. Select "Web Browser" from the options.
    a. Go to https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Vivado_SDK_Web_2018.2_0614_1954_Lin64.bin in a browser in the VM.
    b. Create an account with Xilinx and download the Vivado HLx 2018.2: WebPACK and Editions - Linux Self Extracting Web Installer (the software in the above link).
    c. Open a terminal
        i. Click the start menu (officially the "Whisker Menu" in XFCE) in the top, left corner of the screen.
        ii. Select "Terminal Emulator" from the options.
    d. Move to the Download directory
        1. Type the following (without "") in the terminal: 
            i. "cd /home/pldi/Downloads/"
            ii. "chmod u+x *.bin"
            iii. "sudo ./X*"
                1. Reminder: the password is "the_pldi".
        2. Follow the GUI installer
            i. Click "Continue" when offered to download a newer version. "Continue" here means continue using the current version of the software rather than upgrading to a newer version.
            ii. On step "Select Edition To Install", select "Vivado HL WebPACK".
            iii. On the step "Vivado HL Webpack" where you are asked to select which components to install, use the default settings.
            iv. Click "Yes" when asked if the installer should create the "/opt/Xilinx" directory.
            iv. In our experience, the installer takes about 30 minutes to run. Proceed with the rest of the Getting Started Guide while it runs in the background.
4. Run Aetherling's test suite which will schedule 22 unit tests, the 4 applications in the paper, and 2 additional applications.
    a. Run the suite by executing the following commands in the VM
        i. Open a terminal
            1. Click the start menu (officially the "Whisker Menu" in XFCE) in the top, left corner of the screen.
            2. Select "Terminal Emulator" from the options.
        ii. Move to the directory containing Aetherling's Haskell implementation
            1. Type the following (without "") in the terminal: "cd /home/pldi/pldi/embeddedHaskellAetherling/"
        iii. Run the test suite
            1. Type the following (without "" but with '') in the terminal: "stack test --test-arguments '--num-threads 1'"
            2. Note: this command will take 5-10 minutes.
            3. Ignore any warnings about unimplemented methods.
    b. The unit tests can be found in the file "/home/pldi/pldi/embeddedHaskellAetherling/test/Test_Slowdown.hs"
    c. The applications can be found in the file "/home/pldi/pldi/embeddedHaskellAetherling/test/Test_Apps.hs"
    d. Each unit and application test stresses the following components of the system:
        i. Lseq (section 3 of paper) - each unit test is written in the shallow embedding of Lseq in Haskell.
            1. See section 7 of the paper for the discussion and references on shallow and deep embeddings.
            1. See "single_map" in Test_Slowdown.hs for an example Lseq program. Note that mapC is polymorphic over sequence length, so com_input_seq is used to specify the input sequence length. The rest of the sequence lengths are then inferred by Haskell's type checker.
        ii. Lst (section 4 of paper) - each test has a _ppar variable which contains different Lst versions of the program at different throughputs. The step-by-step instructions explain how to interact with these variables.
        iii. Rewrite Rules (section 5 of paper) and Scheduling (section 6 of paper) - the _ppar variable produces the Lst versions using the scheduler and rewrite rules.
        One such variable is "single_map_ppar" in Test_Slowdown.hs.
        iv. Implementation (section 7 of paper) - the prior points stress the Lseq and Lst implementations. 
        Additionally, each test has a _results variable, such as "single_map_results", which stresses the compiler that lowers from Lst to Verilog by:
            1. Emitting an implementation of the Lst circuit in Magma, a Python HDL.
            2. Running the Magma file to generate Verilog.
            3. Simulating the Verilog with Verilator and checking the checking the correctness of the resulting circuit. The simulation accepts the inputs specified by the _inputs variable, such as "single_map_inputs", and verifies that the output matches the values specified by the _output variable, such as "single_map_output". Additionally, the simulator verifies that the input and output match the specifications of the Lst types.
            4. See "/home/pldi/pldi/embeddedHaskellAetherling/test/verilog_examples/aetherling_copies" for the resulting Verilog files. While these files will exist before running the tests, the tests will overwrite them.
        v. Evaluation (section 8 of paper) - see Step-by-Step Instructions section
            

# Step-by-Step Instructions
Please evaluate this artifact based on its support for the following claims in the paper

## Lseq (Section 3 of Paper)
Claim: The input language (Lseq) is a functional language with standard data-parallel operations on finite length sequences.
Lseq is constrained so that Aetherling can transform all valid programs into hardware implementations. 

How supported: The examples in "Test_Slowdown.hs" and "Test_Apps.hs" demonstrate Lseq and that the programs can be compiled to hardware implementations.
Look at the type signatures of the operators "/home/pldi/pldi/embeddedHaskellAetherling/src/Core/Aetherling/Languages/Sequence/Shallow/Expr.hs" to see that they are on finite length sequences.

### Lst (Section 4 of Paper)
Claim: Programs in the intermediate language (Lst) correspond to statically scheduled, streaming hardware.
Operators in the language correspond to hardware modules with computable properties such as throughput, area, and delay.
The types of the operators encode the throughput of the hardware interfaces and the exact clock cycles when elements are consumed or produced.

How supported: The results of the evaluation section (see below) provide experimental evidence that the operators compile to statically scheduled, streaming hardware modules.
Additionally, the _ppar variables, discussed in section 4.d.iii of the Getting Started Guide, demonstrate the Lst programs and their types.
To explore each of the _ppar variables:
1. Use the Haskell REPL
    a. Open a terminal where the current working directory is "/home/pldi/pldi/embeddedHaskellAetherling/" 
    b. Start the REPL by typing the following (without "") in the terminal: "stack ghci --test"
2. Use the following functions in the REPL to explore the _ppar variables. 
    a. "print_st" - This prints a string representation of a Lst program.
        i. "print_st (single_map_ppar !! 0)" - This prints the single map Lst program scheduled at 1 pixel emitted per clock.
        Each _ppar variable is a list of Lst programs.
        For example, the programs in single_map_ppar have throughputs of 1, 2, and 4 Ints emitted per clock.
        Use !! to access one element of the list.
        Note that the FIFO operators represent the delay matching registers (Section 7 of paper) necessary for correctness and pipeline registers necessary for Vivado. 
    b. "get_area" - This prints the area approximation of a program. Note: in the paper's appendix we compute area as a tuple of storage and compute.
    We have found that a scalar value is a sufficient approximation.
    This function returns a scalar.
        i. "get_area (single_map_ppar !! 0)" - This prints a scalar value that approximates the area of the single map Lst program scheduled at 1 pixel emitted per clock.
    c. "compute_latency" - This prints the delay of a program.
        i. "compute_latency (single_map_ppar !! 0)" - This prints the delay of the single map Lst program scheduled at 1 pixel emitted per clock.
    d. "print_st_input_types" - This prints a string representation of a Lst program's input types. Throughput is computable from Lst types.
        i. "print_st_input_types (single_map_ppar !! 0)" - This prints the input type of the single map Lst program scheduled at 1 pixel outputted per clock. Types is plural in the function call because some programs may have multiple inputs.
    e. "print_st_output_type" - This prints a string representation of a Lst program's output type
        iii. "print_st_output_type (single_map_ppar !! 0)" - This prints the output type of the single map Lst program scheduled at 1 pixel outputted per clock.

## Rewrite Rules and Scheduling (Sections 5 and 6 of Paper)
Claim: The scheduling algorithm
1. accepts an Lseq program P and a desired throughput T
2. uses the rewrite rules
3. produces an efficient Lst program with throughput T that is equivalent up to isomorphism.

How supported:
1. Look at the _ppar variables discussed in section 4.d.iii of the Getting Started Guide.
These show the Lst programs that result from the scheduling algorithm.
2. Look at the _results variables in the same files as the _ppar variables.
These are the unit and application tests.
The tests schedule Lseq programs to Lst programs with different throughputs.
Then the tests experimentally verify that the rewrite rules and scheduler preserve semantics up to isomorphism by checking that the resulting Verilog circuits produce correct output for an input.
The inputs and output are specified in Lseq and converted into isomorphic Lst values for each Lst program.
3. Look at the results of the Evaluation section (see below) for experimental evidence that the scheduler and rewrite rules produce efficient hardware.

## Evaluation (Section 8 of Paper)
Claim: Aetherling can schedule basic image processing programs.
The resulting designs are more area efficient than those produced by recent systems that generate image processing hardware from high-level language descriptions.

How supported: To reproduce the experiments in the Evaluation (section 8 of paper):
1. Type the following (without "") in the terminal: "cd /home/pldi/pldi/embeddedHaskellAetherling/"
2. Type the following (without "") in the terminal: "pnr/run.sh"
    a. NOTE: This will take between 1 and 2 hours to run. It is doing synthesis and implementation using Xilinx Vivado Design Suite 2018.2 for many designs.
    b. This step runs synthesis on the Verilog files in "/home/pldi/pldi/embeddedHaskellAetherling/test/verilog_examples". 
    c. The top folders in that directory separate the Aetherling, Halide-HLS (titled halide_to_hardware), and Spatial Verilog files. 
    d. We have included the Halide-HLS and Spatial Verilog files generated for the paper. The Aetherling Verilog files are regenerated each time the tests are rerun.
    e. Within each of the aetherling_copies, halide_to_hardware, and spatial folders are the folders for each application in the Evaluation section. These are: map, conv2d, conv2d_b2b, and sharpen. The other apps within the aetherling_copies folder may work but are not part of the paper's results.
    f. Within each of the app's folders are the Verilog files for the app at a throughput specified by number of clock cycles. For example, the file "/home/pldi/pldi/embeddedHaskellAetherling/test/verilog_examples/aetherling_copies/conv2d/conv2d_16.v" emits the output over 16 clock cycles.
    g. To run fewer designs through Vivado and thus finish pnr/run.sh more quickly, delete some of these files. Note: doing so may break the chart generation code for visualizing the results. You may be required to edit "/home/pldi/pldi/aetherling/aetherling/helpers/pnr_graphs.py" to deal with less data.
3. When the prior step finishes, the graphs which reproduce figures 11-13 in the paper will be in "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs". Additionally, stdout will contain the data from the graphs in text form. Ignore warnings printed to stdout before the data.
    a. Open a file browser 
        i. Click the start menu (officially the "Whisker Menu" in XFCE) in the top, left corner of the screen
        ii. Select "File Manager" from the options
    a. "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs/ae_results.pdf" - reproduces figure 11 
    b. "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs/ae_versus_sp.pdf" - reproduces figure 12
    c. "/home/pldi/pldi/embeddedHaskellAetherling/pnr/figs/ae_versus_hth.pdf" - reproduces figure 13
    d. We use the following shorthands in the stdout:
        i. SP - Spatial
        ii. HTH - Halide-To-Hardware, ie Halide-HLS
4. Note: the graphs are slightly different from those in the paper. In the paper, Halide-HLS and Spatial used 2.3-9.1x more area. In these charts, Halide-HLS and Spatial use 2.2-8.6x more area. Additionally, in some cases Aetherling's advantage has improved. One example of this is the CONV example at throughput 1. These differences are due to the fact that the paper's measurements are on an older version of the code. Vivado's logs show that much of the difference results from variance in Vivado's optimization during the implementation step. 

## Claims Not Supported
All the major claims of the paper are supported.

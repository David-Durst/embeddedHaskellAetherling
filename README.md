# Aetherling Embedded In Haskell

This is the main repository for Aetherling.

The [supplementary materials for the paper](aetherling-supplementary.pdf) can be found here.

Please see [the theory section](theory/README.md) for an overview of this repo.

Please see [the python repo](https://github.com/David-Durst/aetherling) for the Magma
backend that compiles to CoreIR and Verilog.

# How To Run
To build this part of the project:
1. Install the latest version of [stack](https://docs.haskellstack.org/en/stable/README/)
2. Clone this repo: `git clone --recurse-submodules git@github.com:David-Durst/embeddedHaskellAetherling.git`
1. Copy `src/Core/Aetherling/Interpretations/Backend_Execute/Constants.hs.template` to `src/Core/Aetherling/Interpretations/Backend_Execute/Constants.hs` and update `root_dir` to point to the top folder of this repository on your system.
3. Build the repo:
```
stack build
```
3. Install the Rust intermediate layer
    1. Install Rust and Cargo:
    ```
    curl https://sh.rustup.rs -sSf | sh
    ```
    1. Install Aetherling's Rust code
    ```
    cd rustAetherling
    cargo install
    ```
3. Explore the IR by running the following command which starts a Haskell interpreter with all files loaded except thoses in `test/`:
```
stack ghci
```
4. Explore the tests by running the following command and selecting option 2:
```
stack ghci --test
```

Please be patient the first time `stack ghci` is run on a computer. 
It will install all the dependencies in a virtual environment just for this project.


# How To Run Tests
```
stack test --test-arguments '--num-threads 1'
```



rm -rf obj_dir/
verilator --cc --top-module top -Wno-lint -Wno-STMTDLY ./map_200.v --exe verilator_tb.cpp
make -C obj_dir/ -f Vtop.mk Vtop
./obj_dir/Vtop

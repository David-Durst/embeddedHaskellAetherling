import os

res = os.system('/cad/xilinx/vivado/2018.2/Vivado/2018.2/bin/vivado_hls -f run_hls.tcl')
assert(res == 0)

# res = os.system('/cad/xilinx/vivado/2018.2/Vivado/2018.2/bin/vivado -mode batch -source verilog_to_fpga.tcl')
# assert(res == 0)

# res = os.system('verilator --cc ./protocol_regions/protocol_regions/impl/verilog/region_experiment.v --exe cpp_tb.cpp -Wno-lint -CFLAGS -fPIC')
# assert(res == 0)

# res = os.system('make -j -C obj_dir -f Vregion_experiment.mk Vregion_experiment')
# assert(res == 0)

# res = os.system('./obj_dir/Vregion_experiment')
# assert(res == 0)

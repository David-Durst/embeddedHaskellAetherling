#!/bin/bash -x
#./compile_scripts/compile.sh compile_scripts/map_s_4_pipelined.v compile_scripts/constraints_1.xdc build

VERILOG_FILE=$1
CONSTRAINT_FILE=$2
BUILDDIR_INPUT=$3
CURRENT_TIME=$4
BUILDSUBDIR_INPUT=$5

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VERILOG_BUILD_COPY=$(basename $VERILOG_FILE)
CONSTRAINT_BUILD_COPY=$(basename $CONSTRAINT_FILE)
if [ -z "$CURRENT_TIME" ]; then
    CURRENT_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
fi
if [ -z "$BUILDSUBDIR_INPUT" ]; then
    BUILDDIR=$BUILDDIR_INPUT.$CURRENT_TIME/
else
    BUILDDIR=$BUILDDIR_INPUT.$CURRENT_TIME/$BUILDSUBDIR_INPUT/
fi


mkdir -p $BUILDDIR
cp $VERILOG_FILE $BUILDDIR
cp $CONSTRAINT_FILE $BUILDDIR
cd $BUILDDIR
echo "read_verilog $VERILOG_BUILD_COPY" > system.tcl
echo "read_xdc $CONSTRAINT_BUILD_COPY" >> system.tcl
echo "synth_design -top top -part xc7z020clg484-1 -mode out_of_context" >> system.tcl
#echo "set_property HD.CLK_SRC BUFGCTRL_X0Y16 [get_ports CLK]" >> system.tcl
echo "set_property SEVERITY {Warning} [get_drc_checks UCIO-1]" >> system.tcl
echo "set_property SEVERITY {Warning} [get_drc_checks NSTD-1]" >> system.tcl
echo "read_xdc $CONSTRAINT_BUILD_COPY" >> system.tcl
echo "opt_design" >> system.tcl
echo "place_design" >> system.tcl
echo "phys_opt_design -retime" >> system.tcl
echo "route_design" >> system.tcl
echo "write_checkpoint final.dcp" >> system.tcl
#echo "write_bitstream system.bit" >> system.tcl
echo "report_timing -file timing.txt" >> system.tcl
echo "report_timing_summary -file timing_summary.txt" >> system.tcl
echo "report_utilization -hierarchical -file utilization_h.txt" >> system.tcl
echo "report_utilization -file utilization.txt" >> system.tcl
vivado -mode batch -source 'system.tcl' -nojournal -log 'vivado.log' > /dev/null
echo $BUILDDIR"/vivado.log" 
echo $BUILDDIR > last_builddir.log
#bootgen -image $DIR/../axi/boot.bif -arch zynqmp -process_bitstream bin

#cp system.bit.bin $OUTFILE
                                          

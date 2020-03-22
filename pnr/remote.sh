#!/bin/bash -x

results_temp="results/results_temp.txt"
results="results/results.csv"
circuit_dir_path=$1
CURRENT_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
generate_muls_tcl=$(readlink -f generate_muls.tcl)

echo "System | Application | Parallelism | Total LUTs | Logic LUTs | LUTRAMs | SRLs | FFs | RAMB36 | RAMB18 | DSP48 Blocks | BRAM Tiles | Slices | SLICEL | SLICEM | Slack (VIOLATED) |" > ${results_temp}

for circuit_path in ${circuit_dir_path}/halide_to_hardware/big_*/*.v; do
	  echo "Processing ${circuit_path}"
    circuit_dir_path_length=$(expr length $circuit_dir_path)
    circuit_path_relative=${circuit_path:$circuit_dir_path_length}
    system=`cut -d "/" -f2 <<< $circuit_path_relative`
    circuit_basename=$(basename $circuit_path)
    circuit_name=`sed -n -E "s/(.*)_[^_]*/\1/p" <<< $circuit_basename`
    circuit_par=`sed -n -E "s/.*_([^_]*).v$/\1/p" <<< $circuit_basename`

    ./compile.sh $circuit_path constraints${system}.xdc build $CURRENT_TIME "${system}/${circuit_name}_${circuit_par}" ${generate_muls_tcl}
    last_build_dir=$(<last_builddir.log)
    
    echo -n "${system}" >> ${results_temp}
    echo -n "|${circuit_name}" >> ${results_temp}
    echo -n "|${circuit_par}" >> ${results_temp}
    hierarchical_results=$(sed -n -E "s/\|[^\(]top.*\(top\)\s*(.*)$/\1/pI" $last_build_dir/utilization_h.txt)
    bram_tiles_results=$(sed -n -E "s/\|\s+Block RAM Tile\s+\|([^\|]+\|).*$/\1/pI" $last_build_dir/utilization.txt)
    slices_results=$(sed -n -E "s/\|\s+Slice\s+\|([^\|]+\|).*$/\1/pI" $last_build_dir/utilization.txt)
    slicel_results=$(sed -n -E "s/\|\s+SLICEL\s+\|([^\|]+\|).*$/\1/pI" $last_build_dir/utilization.txt)
    slicem_results=$(sed -n -E "s/\|\s+SLICEM\s+\|([^\|]+\|).*$/\1/pI" $last_build_dir/utilization.txt)
    timing_results=$(sed -n -E "s/^Slack.*:\s*(-?.*ns).*/\1/pI" $last_build_dir/timing.txt)
    echo -n "$hierarchical_results" >> ${results_temp}
    echo -n "$bram_tiles_results" >> ${results_temp}
    echo -n "$slices_results" >> ${results_temp}
    echo -n "$slicel_results" >> ${results_temp}
    echo -n "$slicem_results" >> ${results_temp}
    echo -n "$timing_results" >> ${results_temp}
    echo "|" >> ${results_temp}
    tr -d [:blank:] < $results_temp >> $results
    sed -i -s 's/|/,/g' $results
    rm $results_temp
done

rm -rf $circuit_dir_path

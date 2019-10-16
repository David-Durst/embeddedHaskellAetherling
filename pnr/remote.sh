#!/bin/bash -x

results_temp="results/results_temp.txt"
results="results/results.csv"
circuit_path=$1
circuit_name=$2
circuit_par=$3

if [ ! -f "${results}" ]; then
    echo "| Circuit Name | Parallelism | Total LUTs | Logic LUTs | LUTRAMs | SRLs | FFs | RAMB36 | RAMB18 | DSP48 Blocks | Slices | SLICEL | SLICEM | Slack (VIOLATED) |" > ${results_temp}
fi

./compile.sh $circuit_path constraints.xdc build
last_build_dir=$(<last_builddir.log)

echo -n "|${circuit_name}" >> ${results_temp}
echo -n "|${circuit_par}" >> ${results_temp}
hierarchical_results=$(sed -n -E "s/\|[^\(]top.*\(top\)\s*(.*)$/\1/p" $last_build_dir/utilization_h.txt)
slices_results=$(sed -n -E "s/\|\s+Slice\s+\|([^\|]+\|).*$/\1/p" $last_build_dir/utilization.txt)
slicel_results=$(sed -n -E "s/\|\s+SLICEL\s+\|([^\|]+\|).*$/\1/p" $last_build_dir/utilization.txt)
slicem_results=$(sed -n -E "s/\|\s+SLICEM\s+\|([^\|]+\|).*$/\1/p" $last_build_dir/utilization.txt)
timing_results=$(sed -n -E "s/^Slack.*:\s*(-?.*ns).*/\1/p" $last_build_dir/timing.txt)
echo -n "$hierarchical_results" >> ${results_temp}
echo -n "$slices_results" >> ${results_temp}
echo -n "$slicel_results" >> ${results_temp}
echo -n "$slicem_results" >> ${results_temp}
echo -n "$timing_results" >> ${results_temp}
tr -d [:blank:] < $results_temp >> $results
sed -i -s 's/|/,/g' $results
rm $results_temp

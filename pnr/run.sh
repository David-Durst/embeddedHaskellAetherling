mkdir -p results
rm results/resources_temp.txt
rm results/timing_temp.txt
rm results/overall_results_temp.csv
rm results/resources.txt
rm results/timing.txt
rm results/overall_results.csv

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Circuit | Module                                 | Partition | Slices*       | Slice Reg     | LUTs          | LUTRAM        | BRAM/FIFO | DSP48E1 | BUFG  | BUFIO | BUFR  | MMCME2_AD | Full Hierarchical Name                                                                                                                                                                       |" > results/resources_temp.txt

echo "Circuit, Slack (VIOLATED)" > results/timing_temp.txt

last_build_dir=$(<last_builddir.log)

for circuitName in ${DIR}/../test/verilog_examples/*/*/*.v; do
	echo "Processing ${circuitName}"
	printf "${circuitName}" >> results/resources_temp.txt
  grep " top " build/utilization_h.txt >> results/resources_temp.txt
	printf "${circuitName}" >> results/timing_temp.txt
  gsed -n -E "s/^Slack.*:\s*(-?.*ns).*/\1/p" timing.txt >> results/timing_temp.txt
done
tr -d [:blank:] < results/resources_temp.txt > results/resources.txt
tr -d [:blank:] < results/timing_temp.txt > results/timing.txt
sed -i -s 's/|/,/g' results/resources.txt
sed -i -s 's/|/,/g' results/timing.txt
paste results/resources.txt results/timing.txt > results/overall_results_temp.csv
tr -d [:blank:] < results/overall_results_temp.csv > results/overall_results.csv
sed -ri -s 's/[0-9]+\/([0-9]+)/\1/g' results/overall_results.csv
rm results/resources_temp.txt
rm results/timing_temp.txt
rm results/overall_results_temp.csv


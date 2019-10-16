#!/bin/bash -x
user=$1

if [ -z "$user" ]; then
    user=durst
fi


dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ssh $user@kiwi "rm -rf results"
ssh $user@kiwi "mkdir -p results"
scp $dir/remote.sh $user@kiwi:
scp $dir/constraints.xdc $user@kiwi:
scp $dir/compile.sh $user@kiwi:


for circuit_path in ${dir}/../test/verilog_examples/*/*/*.v; do
	echo "Processing ${circuit_path}"
  scp $circuit_path $user@kiwi:
  circuit_basename=$(basename $circuit_path)
  circuit_name_=$(grep -Po ".*_" <<< $circuit_basename)
  circuit_name=${circuit_name_::-1}
  circuit_par=$(sed -n -E "s/.*_([^_]*).v$/\1/p" <<< $circuit_basename)
  ssh $user@kiwi "./remote.sh $(basename $circuit_path) ${circuit_name} ${circuit_par}"
  ssh $user@kiwi "rm $(basename $circuit_path)"
done

scp $user@kiwi:results/results.csv $dir/results.csv


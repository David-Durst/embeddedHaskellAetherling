#!/bin/bash -x
user=$1

if [ -z "$user" ]; then
    user=durst
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine_linux=true;;
    Darwin*)    machine_linux=false;;
esac
if $machine_linux; then
  sed_="sed"
else
  sed_="gsed"
  if ! hash gsed 2>/dev/null; then
    echo "gsed needs to be installed on mac" 1>&2
    exit 1
  fi
fi

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ssh $user@kiwi@stanford.edu "rm -rf results"
ssh $user@kiwi@stanford.edu "rm -rf verilog_examples"
ssh $user@kiwi@stanford.edu "rm -rf IP"
ssh $user@kiwi@stanford.edu "mkdir -p results"
scp $dir/remote.sh $user@kiwi@stanford.edu:
scp $dir/constraints*.xdc $user@kiwi@stanford.edu:
scp $dir/compile.sh $user@kiwi@stanford.edu:
scp $dir/../chiselAetherling/src/main/resources/verilogAetherling/generate_muls.tcl $user@kiwi@stanford.edu:

scp -r ${dir}/../test/verilog_examples $user@kiwi@stanford.edu:
ssh $user@kiwi@stanford.edu "tmux new -d -s pnr './remote.sh verilog_examples/ &> results/log.log'"


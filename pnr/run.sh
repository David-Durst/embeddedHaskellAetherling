#!/bin/bash -x
export PATH="/opt/Xilinx/Vivado/2018.2/bin:$PATH"
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
rm -rf $dir/results
mkdir -p $dir/results
cp $dir/remote.sh $dir/results/
scp $dir/constraints*.xdc $dir/results/
scp $dir/compile.sh $dir/results/

cp -r ${dir}/../test/verilog_examples $dir/results/
./remote.sh verilog_examples/ &> results/log.log


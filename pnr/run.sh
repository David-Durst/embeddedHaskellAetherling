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
ssh $user@kiwi "rm -rf results"
ssh $user@kiwi "mkdir -p results"
scp $dir/remote.sh $user@kiwi:
scp $dir/constraints.xdc $user@kiwi:
scp $dir/compile.sh $user@kiwi:

scp -r ${dir}/../test/verilog_examples $user@kiwi:
ssh $user@kiwi "tmux new -d -s pnr './remote.sh verilog_examples/'"


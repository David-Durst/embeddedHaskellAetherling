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
ssh $user@kiwi "rm -rf results_all"
ssh $user@kiwi "mkdir -p results_all"
scp $dir/remote_all.sh $user@kiwi:
scp $dir/constraints*.xdc $user@kiwi:
scp $dir/compile.sh $user@kiwi:

scp -r ${dir}/../experiments/verilog_examples $user@kiwi:all_verilog_examples
ssh $user@kiwi "tmux new -d -s pnr_all './remote_all.sh all_verilog_examples/ &> results_all/log.log'"

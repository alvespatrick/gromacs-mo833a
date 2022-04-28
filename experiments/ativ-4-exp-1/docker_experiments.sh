#!/bin/bash

data_path="data";
results_path="results"

trap "exit" INT
while getopts p:r: flag
do
    case "${flag}" in
        p) data_path=$OPTARG;;
        r) results_path=$OPTARG;;
    esac
done

mkdir -p $results_path
OLD_PATH=$PATH

# Perf
echo Starting Perf nt = default Profiling
docker run -it --privileged -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 perf record --call-graph lbr -o $results_path/perf.data.t8 gmx mdrun -v -deffnm $data_path/em
echo Perf Profiling nt = default ended

echo Starting Perf nt = 1 Profiling
docker run -it --privileged -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 perf record --call-graph lbr -o $results_path/perf.data.t1 gmx mdrun -nt 1 -v -deffnm $data_path/em
echo Perf Profiling nt = 1 ended

# Callgrind
echo Starting Callgrind Profiling
docker run -it --privileged -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 valgrind --tool=callgrind --callgrind-out-file=$results_path/callgrind.data gmx mdrun -v -deffnm $data_path/em
echo Perf Profiling ended

#!/bin/bash

samples=20;
data_path="data";
results_path="results"
rm -rf results data
mkdir results
mkdir data
cd data
cp ../run_simulation.sh .

wget https://www.ic.unicamp.br/~edson/disciplinas/mo833/2021-1s/anexos/6LVN.pdb
wget https://www.ic.unicamp.br/~edson/disciplinas/mo833/2021-1s/anexos/ions.mdp

docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs-ativ3-exp1:release ./run_simulation.sh

for counter in $(seq 1 $samples); do
    echo Starting Release Run $counter of $samples
	
	docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs-ativ3-exp1:release gmx mdrun -v -deffnm em | grep "MO833" | cut -d " " -f 5 >> ../results/docker_release.txt
    echo Release Runs: $counter/$samples
done

#docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs-ativ3-exp1:debug ./run_simulation.sh

for counter in $(seq 1 $samples); do
    echo Starting Debug Run $counter of $samples
    
    docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs-ativ3-exp1:debug gmx mdrun -v -deffnm em | grep "MO833" | cut -d " " -f 5 >> ../results/docker_debug.txt
    echo Release Runs: $counter/$samples
done

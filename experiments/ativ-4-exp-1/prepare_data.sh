#!/bin/bash

input_path="input"
data_path="data"

trap "exit" INT
while getopts cdi:p: flag
do
    case "${flag}" in
        i) input_path=$OPTARG;;
        p) data_path=$OPTARG;;

    esac
done

mkdir -p $data_path
rm $data_path/*
cp $input_path/* $data_path
cd $data_path
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 gmx pdb2gmx -f 6LVN.pdb -o 6LVN_processed.gro -water spce
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 echo "15"
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 gmx editconf -f 6LVN_processed.gro -o 6LVN_newbox.gro -c -d 1.0 -bt cubic
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 gmx solvate -cp 6LVN_newbox.gro -cs spc216.gro -o 6LVN_solv.gro -p topol.top
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 gmx grompp -f ions.mdp -c 6LVN_solv.gro -p topol.top -o ions.tpr
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 gmx genion -s ions.tpr -o 6LVN_solv_ions.gro -p topol.top -pname NA -nname CL -neutral
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 echo "13"
docker run -it -v ${PWD}:${PWD} -w ${PWD} --rm gromacs:ativ-4 gmx grompp -f ions.mdp -c 6LVN_solv_ions.gro -p topol.top -o em.tpr

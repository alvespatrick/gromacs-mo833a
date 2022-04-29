#!/bin/bash

#Create the images for release and debug 
sh docker_build.sh

cd experiments/ativ-3-exp-1
#Execute the experiments
sh docker_experiment.sh

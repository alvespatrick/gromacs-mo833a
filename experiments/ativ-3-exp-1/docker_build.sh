#!/bin/bash

cd ../..
trap "exit" INT

#Create docker images to execute experiments
docker build -t gromacs-ativ3-exp1:release --build-arg flags="-DGMX_BUILD_OWN_FFTW=ON -DCMAKE_BUILD_TYPE=Release" .
docker build -t gromacs-ativ3-exp1:debug --build-arg flags="-DGMX_BUILD_OWN_FFTW=ON -DCMAKE_BUILD_TYPE=Debug" .

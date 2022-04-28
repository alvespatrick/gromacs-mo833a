#!/bin/bash

release=true
trap "exit" INT
while getopts d flag
do
    case "${flag}" in
        d) release=true;;
    esac
done

if $release; then
    build_path="build_release"
    flags="-DGMX_BUILD_OWN_FFTW=ON"
else
    build_path="build_debug"
    flags="-DGMX_BUILD_OWN_FFTW=ON -DCMAKE_BUILD_TYPE=Debug"
fi

mkdir -p $build_path

cd $build_path

cmake ../../.. $flags

make -j 2

#!/bin/bash

# create dir if doesn't exist, move to it
[ -d $1 ] || mkdir -p $1
pushd $1

export OPTIM_NAMES=("no-lower-prims" "no-inline-caching" "no-inlining-control-structs" "no-global-caching" "no-quickening" "no-superinstructions" "no-supernodes")

# base versions
git clone https://github.com/OctaveLarose/TruffleSOM.git
pushd TruffleSOM; ant libs && ant compile; popd

git clone https://github.com/OctaveLarose/PySOM.git
pushd PySOM; ln -s $1/pypy2.7-v7.3.9-src pypy; popd 

# we should also checkout to the right commits here, as opposed to doing it in the rebench codespeed.conf. Not necessary, but would be cleaner
for opt in "${OPTIM_NAMES[@]}"; 
do 
    git clone https://github.com/OctaveLarose/TruffleSOM.git TruffleSOM-$opt
    pushd TruffleSOM-$opt && rm -rf libs && ln -sf $1/TruffleSOM/libs; popd

    git clone https://github.com/OctaveLarose/PySOM.git PySOM-$opt
    pushd PySOM-$opt && rm -rf pypy && ln -s $1/pypy2.7-v7.3.9-src pypy; popd
done

popd
#!/bin/bash
#AWFY_REF=`(cd awfy && git rev-parse HEAD)`
# CI_BUILD_REF=2cd905bd67a061705eaf8098832f49886d5c9de2
PARAMS=("-d" "--without-nice" "--commit-id=$CI_BUILD_REF" "--environment=Infinity Ubuntu" "--project=AWFY" "--branch=$CI_BUILD_REF_NAME")
git submodule update --recursive

# (cd awfy && ./implementations/setup.sh)

# rebench "${PARAMS[@]}" codespeed.conf all vm:Node
# rebench "${PARAMS[@]}" codespeed.conf all vm:NodeTurboFan
# rebench "${PARAMS[@]}" codespeed.conf steady-java
# rebench "${PARAMS[@]}" codespeed.conf steady-crystal

# rebench "${PARAMS[@]}" codespeed.conf lua

# rebench "${PARAMS[@]}" codespeed.conf all vm:GraalBasic vm:GraalC2 vm:SOMns
# rebench "${PARAMS[@]}" codespeed.conf all vm:SOMns-Enterprise vm:GraalEnterprise vm:JRubyTruffleEnterprise vm:GraalJS
# rebench "${PARAMS[@]}" codespeed.conf all vm:JRubyGraal vm:JRubyTruffle
# rebench "${PARAMS[@]}" codespeed.conf all vm:TruffleSOM vm:TruffleSOM-TOM
# rebench "${PARAMS[@]}" codespeed.conf all vm:SOMns
# rebench "${PARAMS[@]}" codespeed.conf all
# rebench "${PARAMS[@]}" codespeed.conf all vm:Crystal vm:Node vm:NodeTurboFan
# rebench "${PARAMS[@]}" codespeed.conf all vm:RSqueak
# rebench "${PARAMS[@]}" codespeed.conf all vm:SOMnsInt
# rebench "${PARAMS[@]}" codespeed.conf all vm:SOMns

rebench "${PARAMS[@]}" codespeed.conf all vm:SOMpp vm:SOMppOMR
# rebench "${PARAMS[@]}" codespeed.conf all vm:SOMpp
# rebench "${PARAMS[@]}" codespeed.conf all vm:Node vm:NodeTurboFan
# rebench "${PARAMS[@]}" codespeed.conf all vm:Java8U66  vm:JavaInt


DATA_ROOT=~/benchmark-results/are-we-fast-yet

REV=`git rev-parse HEAD | cut -c1-8`

NUM_PREV=`ls -l $DATA_ROOT | grep ^d | wc -l`
NUM_PREV=`printf "%03d" $NUM_PREV`

TARGET_PATH=$DATA_ROOT/$NUM_PREV-$REV
LATEST=$DATA_ROOT/latest

mkdir -p $TARGET_PATH
cp benchmark.data $TARGET_PATH/
rm $LATEST
ln -s $TARGET_PATH $LATEST

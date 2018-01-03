#!/bin/bash
#AWFY_REF=`(cd awfy && git rev-parse HEAD)`
# CI_BUILD_REF=2cd905bd67a061705eaf8098832f49886d5c9de2
PARAMS=("-d" "--without-nice" "--commit-id=$CI_BUILD_REF" "--environment=Infinity Ubuntu" "--project=AWFY" "--branch=$CI_BUILD_REF_NAME")
git submodule update --recursive

# (cd awfy && ./implementations/setup.sh)


VMS=(
  # "vm:GraalBasic"
  # "vm:GraalC2"
  # "vm:GraalEnterprise"
  # "vm:Java8U66"
  # "vm:JavaInt"
  
  # "vm:SOM"
  # "vm:SOMpp"
  # "vm:SOMppOMR"
  # "vm:TruffleSOM"
  # "vm:TruffleSOM-Enterprise"
  # "vm:TruffleSOM-TOM"
  # "vm:TruffleSOM-TOM-Enterprise"
  
  # "vm:RTruffleSOM"
  # "vm:RTruffleSOMInt"

  "vm:SOMns"
  "vm:SOMnsInt"
  "vm:SOMns-Enterprise"
  
  # "vm:JRubyTruffle"
  # "vm:JRubyTruffleEnterprise"
  # "vm:JRubyC2"
  # "vm:JRubyJ8"
  # "vm:JRubyGraal"

  # "vm:MRI23"
  # "vm:RBX314"
  # "vm:Topaz"

  # "vm:Crystal"

  # "vm:Node"

  # "vm:GraalJS"
  
  # "vm:Pharo"
  # "vm:Squeak"
  # "vm:RSqueak"

  # vm:LuaJIT2
  # vm:Lua53
)

rebench -f "${PARAMS[@]}" codespeed.conf all "${VMS[@]}"


## Archive Results

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

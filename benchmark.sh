#!/bin/bash
#AWFY_REF=`(cd awfy && git rev-parse HEAD)`
# CI_BUILD_REF=2cd905bd67a061705eaf8098832f49886d5c9de2
PARAMS=("--experiment=CI ID $CI_PIPELINE_ID" "--branch=$CI_COMMIT_REF_NAME")
git submodule update --recursive

# (cd awfy && ./implementations/setup.sh)


VMS=(
  # "e:GraalBasic"
  # "e:GraalC2"
  # "e:GraalEnterprise"
  "e:Java8U66"
  "e:JavaInt"
  
  "e:SOM"
  # "e:SOMpp"
  # "e:SOMppOMR"
  # "e:TruffleSOM"
  # "e:TruffleSOM-Enterprise"
  # "e:TruffleSOM-TOM"
  # "e:TruffleSOM-TOM-Enterprise"
  
  # "e:RTruffleSOM"
  # "e:RTruffleSOMInt"

  "e:SOMns"
  # "e:SOMnsInt"
  # "e:SOMns-Enterprise"
  
  # "e:JRubyTruffle"
  # "e:JRubyTruffleEnterprise"
  # "e:JRubyC2"
  # "e:JRubyJ8"
  # "e:JRubyGraal"

  "e:MRI23"
  # "e:RBX314"
  # "e:Topaz"

  # "e:Crystal"

  "e:Node"
  "e:Node-interp"

  # "e:GraalJS"
  
  # "e:Pharo"
  # "e:Squeak"
  # "e:RSqueak"

  # e:LuaJIT2
  e:Lua53
  
  e:PyPy-jit
  e:CPython-interp
)

rebench -f "${PARAMS[@]}" codespeed.conf all "${VMS[@]}"
#rebench -f --setup-only "${PARAMS[@]}" codespeed.conf all
REBENCH_EXIT=$?

# rebench --experiment="CI ID $CI_PIPELINE_ID" --report-completion codespeed.conf



## Archive Results

DATA_ROOT=~/benchmark-results/are-we-fast-yet

REV=`git rev-parse HEAD | cut -c1-8`

NUM_PREV=`ls -l $DATA_ROOT | grep ^d | wc -l`
NUM_PREV=`printf "%03d" $NUM_PREV`

TARGET_PATH=$DATA_ROOT/$NUM_PREV-$REV
LATEST=$DATA_ROOT/latest

mkdir -p $TARGET_PATH
bzip2 benchmark.data
cp benchmark.data.bz2 $TARGET_PATH/
rm $LATEST
ln -s $TARGET_PATH $LATEST

exit ${REBENCH_EXIT}

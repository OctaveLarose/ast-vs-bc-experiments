#!/bin/bash

# init base versions and their libs
init_baselines() {
    git clone https://github.com/OctaveLarose/TruffleSOM.git

    # some of these flags may be overkill
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/
    export PATH=/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
    export LANG=en_GB.UTF-8
    export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

    pushd TruffleSOM 
    git checkout 64ffec11a782d729ecfdf9c50c3b07f99e96349f
    ant libs && ant compile
    popd

    git clone https://github.com/OctaveLarose/PySOM.git
    pushd PySOM
    git checkout c98d42786fc5f769dbe9e508eb7af4b54a33a2c8
    ln -s $1/pypy2.7-v7.3.9-src pypy
    popd 
}

init_tsom() {
    ([ ! -d "TruffleSOM-$1" ] && git clone https://github.com/OctaveLarose/TruffleSOM.git TruffleSOM-$1) || true
    pushd TruffleSOM-$1
    git fetch --all && git checkout -f $2 && git submodule update -f --init --recursive
    rm -rf libs && ln -sf $3/TruffleSOM/libs
    popd
}

init_pysom() {
    ([ ! -d "PySOM-$1" ] && git clone https://github.com/OctaveLarose/PySOM.git PySOM-$1) || true
    pushd PySOM-$1
    git fetch --all && git checkout -f $2 && git submodule update -f --init --recursive
    rm -rf pypy && ln -s $3/pypy2.7-v7.3.9-src pypy
    popd
}

# create dir if doesn't exist, move to it
[ -d $1 ] || mkdir -p $1
pushd $1

init_baselines

init_tsom "no-lower-prims" "86c4856f1392bdda76162d97d19a2d8116d3631b" $1 &
init_tsom "no-inline-caching" "60ae3e508e68e87d358222102c3b2a8c67de11d0" $1 &
init_tsom "no-inlining-control-structs" "862fbf7cc26732fefd5b80f925eeb9933a0e6a05" $1 &
init_tsom "no-global-caching" "8f6e5fb5e5abc17fd68e28f8dc332fc0b560036c" $1 &
init_tsom "no-quickening" "cf0f4bb9b6601a6e8330ad68c3ea40ed4f269f57" $1 &
init_tsom "no-superinstructions" "1b8cebeaf920072f8583471f517c7a08421a0a9a" $1 &
init_tsom "no-supernodes" "a7a2bc985bc695b116a97dda79b5c92c873507cb" $1 &

init_pysom "no-lower-prims" "b5f7cc0d5d8e39455ed10a50b86e261e7f567902" $1 &
init_pysom "no-inline-caching" "2f87d6c1ac9c3b6895971ed24a6cda18c4240c0b" $1 &
init_pysom "no-inlining-control-structs" "fd8870af33af78eac87ddee4a49905cf0fcc3552" $1 &
init_pysom "no-global-caching" "6b4e7af2f66439761b4dd641a2121949e72933b7" $1 &
init_pysom "no-quickening" "1c64ed989f25a0e08c8bc2716a75f642f6348fe5" $1 &
init_pysom "no-superinstructions" "f0398a3d971dea12e287bec04f749159170e2ff1" $1 &

wait 

popd
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive # because dpkg is annoying

RUN apt update && apt-get install -y sudo python python3-pip git nodejs wget ant libasound2 \
      libasound2-data libc6-i386 libc6-x32 libfreetype6 libpng16-16 libxi6 libxrender1 libxtst6 x11-common
RUN pip install rebench

RUN mkdir -p /home/.local
RUN wget https://downloads.python.org/pypy/pypy2.7-v7.3.9-src.tar.bz2
RUN tar -xvf pypy2.7-v7.3.9-src.tar.bz2 -C /home/.local

# JDK20 stuff
# TODO instead use https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.1%2B9/OpenJDK20U-jdk_x64_linux_hotspot_20.0.1_9.tar.gz
RUN wget https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.deb
RUN dpkg -i jdk-20_linux-x64_bin.deb


RUN cd /home && git clone https://github.com/OctaveLarose/ast-vs-bc-experiments.git
RUN cd /home/ast-vs-bc-experiments && git submodule update --init

RUN cd /home/ast-vs-bc-experiments && ./build_executors.sh "/home/.local"  

#RUN export PARAMS="-f --without-building" 
RUN export PARAMS="-d -v -f --setup-only --disable-data-reporting"
RUN cd /home/ast-vs-bc-experiments && rebench $PARAMS --experiment="Every optim removed individually" codespeed.conf all
#RUN cat rebench.data
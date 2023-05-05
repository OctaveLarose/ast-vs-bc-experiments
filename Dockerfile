FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive # because dpkg is annoying

RUN apt update && apt-get install -y sudo python python3-pip git nodejs wget ant libasound2 \
      libasound2-data libc6-i386 libc6-x32 libfreetype6 libpng16-16 libxi6 libxrender1 libxtst6 x11-common openjdk-17-jdk
RUN pip install rebench

RUN mkdir -p /home/gitlab-runner/.local
RUN wget https://downloads.python.org/pypy/pypy2.7-v7.3.9-src.tar.bz2
RUN tar -xvf pypy2.7-v7.3.9-src.tar.bz2 -C /home/gitlab-runner/.local

# JDK20 stuff
RUN wget https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.1%2B9/OpenJDK20U-jdk_x64_linux_hotspot_20.0.1_9.tar.gz
RUN tar -xvf OpenJDK20U-jdk_x64_linux_hotspot_20.0.1_9.tar.gz
RUN cp -r jdk-20.0.1+9 /usr/lib/jvm/temurin-20-jdk-amd64


RUN cd /home && git clone https://github.com/OctaveLarose/ast-vs-bc-experiments.git
RUN cd /home/ast-vs-bc-experiments && git submodule update --init

RUN cd /home/ast-vs-bc-experiments && ./build_executors.sh "/home/gitlab-runner/.local"  

#RUN export PARAMS="-f --without-building" 
RUN export PARAMS="-d -v -f --setup-only --disable-data-reporting"
RUN cd /home/ast-vs-bc-experiments && rebench $PARAMS --experiment="Every optim removed individually" codespeed.conf all
#RUN cat rebench.data
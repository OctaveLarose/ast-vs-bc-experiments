FROM ubuntu:20.04

# because dpkg is annoying
ARG DEBIAN_FRONTEND=noninteractive 

# to use source for nvm
SHELL ["/bin/bash", "-c"]
ENV LANG=en_GB.UTF-8
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

RUN apt update && apt-get install -y sudo python python3-pip git curl wget ant libasound2 \
      libasound2-data libc6-i386 libc6-x32 libfreetype6 libpng16-16 libxi6 libxrender1 libxtst6 x11-common openjdk-17-jdk pkg-config libffi-dev
RUN pip install rebench

RUN mkdir -p /home/gitlab-runner/.local
RUN wget https://downloads.python.org/pypy/pypy2.7-v7.3.9-src.tar.bz2
RUN tar -xvf pypy2.7-v7.3.9-src.tar.bz2 -C /home/gitlab-runner/.local
# building pypy from source takes too long, so we get the prebuilt
RUN wget https://downloads.python.org/pypy/pypy2.7-v7.3.9-linux64.tar.bz2 
RUN tar -xvf pypy2.7-v7.3.9-linux64.tar.bz2 -C /home/gitlab-runner/.local
RUN ln -s /home/gitlab-runner/.local/pypy2.7-v7.3.9-linux64/bin/pypy /usr/local/bin/pypy

# JDK20 stuff
RUN wget https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.1%2B9/OpenJDK20U-jdk_x64_linux_hotspot_20.0.1_9.tar.gz
RUN tar -xvf OpenJDK20U-jdk_x64_linux_hotspot_20.0.1_9.tar.gz
RUN cp -r jdk-20.0.1+9 /usr/lib/jvm/temurin-20-jdk-amd64

# Node stuff
RUN (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash) && . ~/.nvm/nvm.sh && nvm install v17.9.0


RUN cd /home/gitlab-runner && git clone https://github.com/OctaveLarose/ast-vs-bc-experiments.git
RUN cd /home/gitlab-runner/ast-vs-bc-experiments && git submodule update --init
RUN cd /home/gitlab-runner/ast-vs-bc-experiments && ./build_executors.sh "/home/gitlab-runner/.local"  

#RUN cd /home/gitlab-runner/ast-vs-bc-experiments && rebench -d -v -f --setup-only --disable-data-reporting --experiment="Just building" codespeed.conf all s:*:List
#RUN cd /home/ast-vs-bc-experiments && rebench -f --without-building --experiment="Every optim removed individually" codespeed.conf all
# #RUN cat rebench.data
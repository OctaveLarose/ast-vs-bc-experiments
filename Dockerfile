FROM ubuntu:20.04

# because dpkg is annoying
ARG DEBIAN_FRONTEND=noninteractive 

# if running from git repo, make sure the AWFY submodule is initialized/updated before running the dockerfile.
# this is better for testing.
#ADD . /home/gitlab-runner/ast-vs-bc-experiments

RUN apt update && apt-get install -y sudo python python3-pip git curl wget ant libasound2 \
      libasound2-data libc6-i386 libc6-x32 libfreetype6 libpng16-16 libxi6 libxrender1 libxtst6 \
      libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
      x11-common openjdk-17-jdk pkg-config libffi-dev libfontconfig1-dev pandoc gfortran \
      time
RUN pip install git+https://github.com/smarr/rebench.git

# Installing R.
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/r-project.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" | sudo tee -a /etc/apt/sources.list.d/r-project.list
RUN apt update && apt-get install -y --no-install-recommends r-base

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
# to use "source" (aka ".") for nvm
SHELL ["/bin/bash", "-c"]
RUN (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash) && . ~/.nvm/nvm.sh && nvm install v17.9.0

RUN cd /home/gitlab-runner && git clone https://github.com/OctaveLarose/ast-vs-bc-experiments/

WORKDIR /home/gitlab-runner/ast-vs-bc-experiments
RUN git submodule update --init
RUN rm Dockerfile .dockerignore

# Set locale to C.UTF-8 to avoid issues with Java and R
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

RUN cd awfy/report/bc-vs-ast/scripts && Rscript libraries.R
RUN ./build/init_all_tsom_pysom_executors.sh "/home/gitlab-runner/.local"
RUN rebench -d -v -f --setup-only ast-vs-bc.conf everything s:*:List
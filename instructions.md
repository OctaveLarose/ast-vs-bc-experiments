---
title: "AST vs. Bytecode: Interpreters in the Age of Meta-Compilation (Artifact)"
output: html_document
header-includes: |
  <style>
  code, .sourceCode {
    background-color: #f5f5f5;
    padding: 3px;
  }
  .sourceCode .sourceCode {
    padding: 0;
  }
  </style>
---

## Introduction

This artifact accompanies our paper "AST vs. Bytecode: Interpreters in the Age of Meta-Compilation" to enable others to reuse our experimental setup and methodology, and verify our claims.

Specifically, the artifacts covers our three contributions:

1. It contains the implementation of our methodology to identify run-time performance and memory usage tradeoffs between AST and bytecode interpreters. Thus, it contains all benchmarks and experiments for reproduction of results, and reuse for new experiments, as well as the data we collected to verify our analysis.
2. It contains PySOM and TruffleSOM, which both come with an AST and a bytecode interpreter to enable their comparison. It further contains all the variants of PySOM and TruffleSOM that assess the impact of specific optimizations.
3. It allows to verify the key claim of our paper, that bytecode interpreters cannot be assumed to be faster than AST interpreters in the context of metacompilation systems.

To enable the reproduction of our results and the reuse of this artifact, it contains the full setup and scripts to reproduce our results in form of the figures in section 5:

- Section 5.2, Fig. 2: overview of the interpreter performance
- Section 5.3, Fig. 3: overview of the peak performance
- Section 5.4, Fig. 4 and Fig. 5: analysis of warmup behavior during JIT compilation
- Section 5.5, Fig. 6: analysis of memory usage
- Section 5.6, Fig. 7 and Fig. 8: analysis of impact of optimizations

We provide a Docker image which contains all dependencies to execute the experiments and analyze the results, as well as our raw data. Thus, it contains:

 - Java, Node.js, PySOM, and TruffleSOM to reproduce our experiments
 - [ReBench](https://github.com/smarr/rebench) as a tool to execute the experiments based on a customizable configuration file
 - R to reproduce all figures presented in the paper
 - the raw data produced by our full experiment

We provide both a complete setup to run all of our experiments, which may take 60+ hours, and a minimal setup to quickly get a basic set of results, which takes about 30 minutes.

## Getting Started Guide

### Step 1: Get the Artifact

1. Download the Docker image from [10.5281/zenodo.8147415](https://doi.org/10.5281/zenodo.8147415)
2. Load the image into docker:  
  `docker load < ast-vs-bc.tar.gz`
3. Run the container, starting a bash shell:  
   `docker run -it --name ast-vs-bc ast-vs-bc:latest bash`.


After executing `docker run` as given above, once one exits the bash shell, it can be accessed again with `docker start -i --attach ast-vs-bc`.

Artifact download details:

 - Primary Download: [10.5281/zenodo.8147415](https://doi.org/10.5281/zenodo.8147415)
 - Temporary Backup URL: [https://www.cs.kent.ac.uk/people/staff/sm951/tmp/ast-vs-bc.tar.gz](https://www.cs.kent.ac.uk/people/staff/sm951/tmp/ast-vs-bc.tar.gz)
 - MD5 Checksum: `684dfe92b814b53d06368ce008cf71be`
 - SHA256 Checksum: `dba60138aad0fd329dca546e909a6b90a0b746f633395c619b3fad07e2e17356`

### Step 2: Reproduce all Figures of the Paper

Before going into how to run the experiments, which will take time to complete, we start by reproducing all figures reported in the paper based on the data we obtained.

We assume that we are in the bash of the container started in step 1.

1. Change directory to `awfy/report/bc-vs-ast/for-prebuilt-data`
2. Run `./render-all.sh`, which will produce HTML files from all Rmd files in the folder
3. To access the files from outside the container, go outside the container and execute `docker cp ast-vs-bc:/home/gitlab-runner/ast-vs-bc-experiments/awfy/report/bc-vs-ast/for-prebuilt-data prebuilt-results`. This asks Docker to copy the files from the container named `ast-vs-bc` at the path to a local directory named `prebuilt-results`.
4. Inspect the generated .html files, which should show the figures of section 5. Each filename has the section number it represents and the figure labels match the ones used in the paper.

### Step 3: 30min Run: Collect Basic Data for the Performance Overview

To limit the amount of time benchmarking takes, we provide a minimal experiment that collects enough data points to get an impression of how the overall performance of AST and bytecode interpreters compares to Java and Node.js. The results will not be very reliable, but should roughly match what is reported in the paper in Section 5.2 and 5.3 as Figures 2 and 3.

1. Make sure to be in the main directory `/home/gitlab-runner/ast-vs-bc-experiments`.
2. To execute the experiments, run  
 `rebench --it 5 --in 1 -f --without-building -c ast-vs-bc.conf minimal`  
 This will take about 30min and run the key experiments once for 5 iterations each.
3. After execution finished, change the directory: `cd awfy/report/bc-vs-ast/`
3. Run `./scripts/knit.R overview_minimal.Rmd`.
4. To copy the resulting HTML file out of the container, run the following outside of Docker:  
  `docker cp ast-vs-bc:/home/gitlab-runner/ast-vs-bc-experiments/awfy/report/bc-vs-ast/overview_minimal.html overview_minimal.html`  
  This will copy the `overview_minimal.html` file to your current directory.

**Note**: The execution time of the experiments was tested on Intel/AMD64 processors. While testing the Docker image on macOS with a M2 processor, the execution time seemed about 6 times as long. It may help to adjust the number of iterations down to 3 with `--it 3` in the `rebench` command.

## Step-by-Step Instructions

To expand on the *Getting Started Guide*, in the following we will outline the steps needed to run a full experiment as we did for the final data in our paper. Furthermore, we outline the steps needed to add a new experiment to the setup. This will hopefully provide sufficient guidance for others to actively use our setup and expand upon it in future work.


### Full Run, Reproducing our Complete Data Set

For the full run, we assume the *Getting Started Guide* was followed.

1. Assuming the Docker image was used with the `docker run` command previously, one can start it again with `docker start -i --attach ast-vs-bc`
2. A full run can now be started with, which will take 65+ hours to complete:  
```bash
rebench --without-building ast-vs-bc.conf everything
rebench --without-building ast-vs-bc.conf progr-rep-mem
```

  - For a shorter run of 5+ hours, one can restrict the iterations per benchmark to 5 iterations, each only executed once with the `--it 5 --in 1` flags and select the minimal configuration for the experiment for sec. 5.5.2 on memory representation:  

```bash
rebench --it 5 --in 1 --without-building ast-vs-bc.conf everything
rebench --without-building ast-vs-bc.conf progr-rep-mem-minimal
```

  - This will result in fewer data points being collected, and the JIT compilers may not reach peak performance.
    For the experiment for sec. 5.2.2, we will only collect fewer increments,
    but the results should still be fairly similar.

3. Once finished, navigate to `awfy/report/bc-vs-ast/`
4. Run `./render-all.sh` to produce HTML with all plots in the paper. This will process the `.Rmd` files, which mix R and markdown to compute the statistics.
5. To copy the resulting `.html` files out of the container, run:  
   `docker cp ast-vs-bc:/home/gitlab-runner/ast-vs-bc-experiments/awfy/report/bc-vs-ast/ full_run_output`.
    - The generated plots should be very similar to ours and can be compared directly to the ones in the paper to verify our claims. The labelling in the HTML files matches what we use in the paper.



### Adding a New Experiment

Since we rely on [ReBench](https://rebench.readthedocs.io/en/latest/), one can modify the configuration we provide to add new experiments. For instance, we compare the impact of various optimizations in our paper, and one can imagine adding a new optimization to evaluate its effect compared to all the others.

To assess the impact of an optimization, we chose to compare to the fully optimized version. Thus, the different experiments each remove a specific optimization from one of the TruffleSOM or PySOM interpreters.

To demonstrate how to add a new experiment, we will remove an optimization from TruffleSOM's AST interpreter that distinguishes between *local* variable access and access to variables in *outer* lexical scopes.

A *local* variable is read from the current lexical scope, which is represented by a frame object, in which we read at a specific *slot index*. Access to variables in *outer* scopes requires us to travers a chain of frame objects, to get to the one that stores the variable we want to access. In the Truffle framework, this requires that frame objects are *materialized*. For performance, we would want all frame objects to be purely *virtual* objects. That means the JIT compiler can treat them as pure data dependencies. But materialized objects need to be treated and allocated as normal objects.

To assess the impact of enabling the distinction between local and outer scope access, we removed the corresponding optimization in the version of TruffleSOM at https://github.com/octavelarose/TruffleSOM/tree/optim_removed/no-local-nonlocal-vars2.

To add the new experiment, we'll follow the following steps:

1. First, navigate to the folder with all experiments:  
`cd /home/gitlab-runner/.local/`
2. Then, we clone the git repository with the desired branch:  
 `git clone -b optim_removed/no-local-nonlocal-vars2 https://github.com/octavelarose/TruffleSOM TruffleSOM-no-local-nonlocal`
3. Next, we change into the new folder:  
  `cd TruffleSOM-no-local-nonlocal`
4. Since TruffleSOM uses git submodules, which we need to initialize and download them:  
  `git submodule update --init --recursive`
5. To save a bit of space and build time, we will reuse the shared libraries:  
  `rm -rf libs && ln -sf ../TruffleSOM/libs`
6. Now we can build the natively compiled AST interpreter as well as the version to be used on HotSpot with JIT compilation:
  ```bash
  export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/
  ant compile native-ast -Dno.jit=true
  ```

With this, we have working versions of TruffleSOM's AST interpreter without optimization for accesses to outer lexical scopes.

In the next set of steps, we will add the experiment to the ReBench configuration so that we can collect data on the impact of the optimization.

To be able to modify the config file, one will need to install the editor of choice. The Docker image is based on Ubuntu. Thus, one can install for instance Vim with `apt install vim`.

1. First, we navigate back to our experiment folder:  
  `cd /home/gitlab-runner/ast-vs-bc-experiments`
2. Then, we edit `ast-vc-bc.conf` and add new executors for the optimization. We want to compare both interpreter and JIT performance of the AST interpreter and therefore add two new executors. Somewhere around line 205 in the file, we insert the following configuration for `TruffleSOM-ast-HotspotCE-jit-no-local-nonlocal` and `TruffleSOM-ast-NativeCE-int-no-local-nonlocal`. Note, this is in the `executors` section of the file, which does not need to be added.

```yaml
executors:
    # ...
    TruffleSOM-ast-HotspotCE-jit-no-local-nonlocal:
        path: /home/gitlab-runner/.local/TruffleSOM-no-local-nonlocal
        args: -Dsom.interp=AST
        <<: *TSOM_HOTSPOT_BUILD

    TruffleSOM-ast-NativeCE-int-no-local-nonlocal:
        path: /home/gitlab-runner/.local/TruffleSOM-no-local-nonlocal
        <<: *TSOM_NATIVE_AST_BUILD
``` 

The YAML short hands `TSOM_HOTSPOT_BUILD` and `TSOM_NATIVE_AST_BUILD` define the build instructions, and are the same for each TruffleSOM variant of the same type.

3. Since we will use the same benchmarks as for all other experiments, we only need to add the two new executors to the `everything` experiment and we are done. This would fit in the `experiments` section around line 492, where we add the last two lines below. When copy'n'pasting, the whitespace needs to align, since YAML is whitespace-sensitive:

```yaml
experiments:
    #...
    everything:
        executions:
            #...
            - TruffleSOM-ast-HotspotCE-jit-no-local-nonlocal:    {suites: [som-steady]}
            - TruffleSOM-ast-NativeCE-int-no-local-nonlocal:     {suites: [som-interp]}
```

4. Run the new experiment using:  
  `rebench --it 5 --in 1 --without-building ast-vs-bc.conf everything`
   - **Note**, this will simply add additional data to the benchmark.data file, a tab-separated columnar data format, i.e., a CSV file. Experiments previously executed will not be reexecuted, except if some data is missing.
   - If the `everything` experiment was executed previously, this
     should only take half an hour or so.
   - You may also run the full experiment using `rebench --without-building -c ast-vs-bc.conf everything`. However, it will take about 10 times as long.

4. Since an optimization was added, Fig. 7 and Fig. 8 (Section 5.6) need to be generated. 
    - going to `awfy/report/bc-vs-ast/`
    - running `./scripts/knit.R sec56-optimizations.Rmd`.
    - exporting them through executing, outside the container, the command `docker cp ast-vs-bc:/home/gitlab-runner/ast-vs-bc-experiments/awfy/report/bc-vs-ast/sec56-optimizations.html sec56-optimizations.html`.

# Various Notes

This section provides some additional details and notes on the tools we use, the artifact structure, the data quality to expect from this artifact, as well as notes on building the Docker image.

## Artifact Structure

Inside the Docker image, the following are the most relevant directories and files:

- `/home/gitlab-runner/.local`: this folder contains the PySOM and TruffleSOM implementations, and their different variations that we use in the experiments. The image also includes already the prebuilt binaries needed.
- `/home/gitlab-runner/ast-vs-bc-experiments/ast-vs-bc.conf`: the ReBench configuration file defining all our experiments.
- `/home/gitlab-runner/ast-vs-bc-experiments/awfy/report/bc-vs-ast`: the folder with the Rmd files that compute the statistics and render the plots based on the data produced in the steps as described earlier.
- `/home/gitlab-runner/ast-vs-bc-experiments/awfy/report/bc-vs-ast/for-prebuilt-data/`: variants of the Rmd files that use the raw data we based our paper on. Thus, these can be used to reproduce our results exactly, and the Rmd files can be inspected to for instance identify any issues in our analysis.

## ReBench

The ReBench tool we use for our experiments is designed to document the experimental setup with a configuration file, which contains as many of the details of the setup as feasible to reduce the effort of rerunning experiments.

The configuration files are in the YAML format and have three key elements, as can be seen in the `ast-vs-bc.conf` file:

  - `benchmark_suites`: Benchmark suites are a collection of benchmarks with a partial command line, and the benchmark parameters to be used for the experiments. This can also include settings of how many iterations of a benchmarks are to be executed, and how many executions, i.e., how often to run the process with the specified settings.
  - `executors`: Executors are essentially the executables that are used to run a benchmark. In our case, it is the various different variations of language implementations and interpreters.
  - `experiments`: Brings benchmarks suites and executors together to define what exactly is to be run. Our configuration has two, the `minimal` and the `everything` experiment.


The command line options of ReBench can be accessed with the `--help` flag.

The online documentation has the following relevant pages:

  - [Command line usage](https://rebench.readthedocs.io/en/latest/usage/)
  - [Configuration format](https://rebench.readthedocs.io/en/latest/config/)
  - [Glossary/Basic concepts](https://rebench.readthedocs.io/en/latest/concepts/)

In essence, ReBench is a tool to compose command lines, which are then executed and the output is parsed to extract the performance measurements.

To know the exact command line that are executed, ReBench supports `-p` flag, which asks it to print an execution plan. Thus, to see what our `minimal` experiment would execute, one can run:  
`rebench -p ast-vs-bc.conf`

## R-based Analysis Scripts

To produce the plots in the paper, we use R, ggplot, and RMarkdown.
These Rmd files in the artifact are markdown documents with embedded R fragments.
They are likely not very intuitive and easy to follow.
However, the basic structure is the same for all of them:

1. All Rmd files start with a R code block that loads data, such as the `benchmark.data` file produced by ReBench. The data file is then slightly processed, some other data is set up, and the various statistics are computed. In this setup block, you may also find the definition of plots to be used in the rest of the file.
2. Afterwards, there is typically a little bit of text giving sketching the context of the data.
3. There will be different sections, which produce the plots based using the statistic previously calculated and possibly the functions defined for producing plots.

## Data Quality

To make the setup as fast as possible, we provide a Docker image, which contains all experiments prebuilt. However, using Docker does not provide us with the same control over the machine as in our benchmarking environment. There we use [ReBench Denoise](https://rebench.readthedocs.io/en/latest/denoise/) to minimize noise induced by the operating system and hardware, which is not possible inside a container.
Thus, there will be variation in the actual results, although ideally, when running experiments for a long enough time, the effect of the noise should be fairly minor.

## Building the Docker image

While we do not support it as part of the artifact submission and evaluation process, research may want to rebuild the Docker image based on the sources available here:

https://github.com/OctaveLarose/ast-vs-bc-experiments

Building the Docker image from scratch is taking 3+ hours.

**Note:** We explicitly exclude the instructions of how to build the Docker image from the artifact and its evaluation.


# Troubleshooting

### No Space Left on Device

The provided Docker image is comparably large. This may cause issues with the standard settings of Docker, which may not allow one to load the complete image.

This can result in errors such as:

```
write /home/gitlab-runner/.local/TruffleSOM/libs/truffle/sdk/mxbuild/linux-amd64/graalvm-jimage/lib/src.zip: no space left on device
```

The Docker Desktop allows on to change the settings of the daemon from the preferences under Docker Engine, by adding:

```Json
"storage-opt" : [ "dm.basesize=50G" ]
```

When directly starting the Docker daemon, it would take the option like this:

```bash
sudo dockerd --storage-opt dm.basesize=50G
```

See for details:

  - [https://docs.docker.com/engine/reference/commandline/dockerd/](https://docs.docker.com/engine/reference/commandline/dockerd/)
  - [https://guide.blazemeter.com/hc/en-us/articles/13315147022481](https://guide.blazemeter.com/hc/en-us/articles/13315147022481)

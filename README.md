# AST vs. Bytecode: Interpreters in the Age of Meta-Compilation (Artifact)

This artifact accompanies our paper *AST vs. Bytecode: Interpreters in the Age of Meta-Compilation*
to enable others to reuse our experimental setup and methodology, and verify
our claims.

Specifically, the artifacts covers our three contributions:

1. It contains the implementation of our methodology to identify run-time
   performance and memory usage tradeoffs between AST and bytecode interpreters.
   Thus, it contains all benchmarks and experiments for reproduction of results,
   and reuse for new experiments, as well as the data we collected to verify our
   analysis.

2. It contains PySOM and TruffleSOM, which both come with an AST and a bytecode
   interpreter to enable their comparison. It further contains all the variants of
   PySOM and TruffleSOM that assess the impact of specific optimizations.

3. It allows to verify the key claim of our paper, that bytecode interpreters
   cannot be assumed to be faster than AST interpreters in the context of
   metacompilation systems.

### Paper Abstract

Thanks to partial evaluation and meta-tracing, it became practical to build
language implementations that reach state-of-the-art peak performance by
implementing only an interpreter. Systems such as RPython and the GraalVM
provide components such as a garbage collector and just-in-time compiler in a
language-agnostic manner, greatly reducing implementation effort. However,
meta-compilation-based language implementations still need to improve further
to reach the low memory use and fast warmup behavior that custom-built systems
provide. A key element in this endeavor is interpreter performance. Folklore
tells us that bytecode interpreters are superior to abstract-syntax-tree (AST)
interpreters both in terms of memory use and run-time performance.

This work assesses the trade-offs between AST and bytecode interpreters to
verify common assumptions and whether they hold in the context of
meta-compilation systems. We implemented four interpreters, an AST and a
bytecode one, based on RPython as well as GraalVM. We keep the difference
between the interpreters as small as feasible to be able to evaluate
interpreter performance, peak performance, warmup, memory use, and the impact
of individual optimizations.

Our results show that both systems indeed reach performance close to
Node.js/V8. Looking at interpreter-only performance, our AST interpreters are
on par with, or even slightly faster than their bytecode counterparts. After
just-in-time compilation, the results are roughly on par. This means bytecode
interpreters do not have their widely assumed performance advantage. However,
we can confirm that bytecodes are more compact in memory than ASTs, which
becomes relevant for larger applications. However, for smaller applications, we
noticed that bytecode interpreters allocate more memory because boxing
avoidance is not as applicable, and because the bytecode interpreter structure
requires memory, e.g., for a reified stack.

Our results show AST interpreters to be competitive on top of meta-compilation
systems. Together with possible engineering benefits, they should thus not be
discounted so easily in favor of bytecode interpreters.


## Artifact Instructions

For the *Getting Started Guide* and step-by-step instructions to run all 
experiments and add new ones, see [instructions.md](instructions.md).

## Build Instructions


For Docker

```
docker build . -f Dockerfile -t ast-vs-bc
```

For Docker on ARM CPUs

```
docker buildx build --platform=linux/amd64 . -f Dockerfile -t ast-vs-bc
```

For Podman

```
podman build . -f Dockerfile --format docker -t ast-vs-bc
```

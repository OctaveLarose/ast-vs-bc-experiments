# ast-vs-bc-experiments
Experiments comparing the impact of various optimizations on AST/BC interpreters in the context of metacompilation



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

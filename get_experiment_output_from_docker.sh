id=$(docker create ast-vs-bc-experiments)
docker cp $id:/home/gitlab-runner/ast-vs-bc-experiments/benchmark.data - > benchmark.data
docker rm -v $id
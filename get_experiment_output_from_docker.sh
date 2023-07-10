id=$(docker create ast-vs-bc-experiments)
docker cp $id:/home/gitlab-runner/ast-vs-bc-experiments/codespeed.data - > rebench.data
docker rm -v $id
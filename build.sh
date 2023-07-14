#!/bin/sh
echo "===Building the ast-vs-bc Docker image and exporting it to ast-vs-bc.tar.gz"

docker build . -f Dockerfile -t ast-vs-bc
docker save ast-vs-bc | gzip > ast-vs-bc.tar.gz

echo "===Image should now be available in ast-vs-bc.tar.gz"

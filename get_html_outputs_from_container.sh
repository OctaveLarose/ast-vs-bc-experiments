#!/bin/bash

container_id=$(docker inspect --format="{{.Id}}" ast-vs-bc-experiments-container)
html_files=$(docker exec $container_id find awfy/report -type f -name "*.html" -print)

for html_file in $html_files; do
    output_filename=$(basename "$html_file")
    docker cp $container_id:$html_file $output_filename
done
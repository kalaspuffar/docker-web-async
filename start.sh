#!/bin/bash
docker build --build-arg WORKDIR=/tmp -t docker_test .
docker run -d -p 8080:80 --mount type=bind,source="$(pwd)"/src,target=/var/www/html/ --env-file env.list --name docker_test docker_test 
read -p "Press any key to resume ..."
docker container rm --force docker_test 

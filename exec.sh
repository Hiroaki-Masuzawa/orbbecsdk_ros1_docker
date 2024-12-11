#!/bin/bash
cname=${DOCKER_CONTAINER:-"orbbecsdk_ros1_docker"} ## 
docker exec -it ${cname} bash
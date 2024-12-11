#!/bin/bash

iname=${DOCKER_IMAGE:-"orbbecsdk_ros1_docker"} ##
cname=${DOCKER_CONTAINER:-"orbbecsdk_ros1_docker"} ## 
rosip=${ROS_IP:-"localhost"} ## 
roshostname=${ROS_HOSTNAME:-${rosip}} ## 
rosmasteruri=${ROS_MASTER_URI:-http://localhost:11311} ## 
uid=`id -u`
gid=`id -g`
cdir=`pwd`
uname=`whoami`
set -x 
docker run --gpus 'all,"capabilities=compute,graphics,utility,display"' -it --rm --privileged --net host \
-u ${uid}:${gid} \
--group-add=110 \
--shm-size=16gb \
--env DISPLAY=$DISPLAY \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume=/etc/passwd:/etc/passwd:ro \
--volume=/etc/group:/etc/group:ro \
--volume=/dev:/dev \
--volume=${cdir}/homedir:/home/${uname} \
--env ROS_MASTER_URI=${rosmasteruri} \
--env ROS_IP=${rosip} \
--env ROS_HOSTNAME=${roshostname} \
--name ${cname} ${iname} roslaunch orbbec_camera femto_bolt.launch enable_colored_point_cloud:=true enable_point_cloud:=true depth_registration:=true enable_hardware_reset:=true 

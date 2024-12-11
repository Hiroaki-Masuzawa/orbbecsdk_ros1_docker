FROM nvidia/opengl:1.2-glvnd-devel-ubuntu20.04

### speedup download
# https://genzouw.com/entry/2019/09/04/085135/1718/
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt update && apt install -y lsb-release curl gnupg && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt update &&  DEBIAN_FRONTEND=noninteractive apt install -y ros-noetic-desktop-full \
    libgflags-dev ros-noetic-image-geometry ros-noetic-camera-info-manager \
    ros-noetic-image-transport ros-noetic-image-publisher libgoogle-glog-dev libusb-1.0-0-dev libeigen3-dev \
    ros-noetic-diagnostic-updater ros-noetic-diagnostic-msgs \
    libdw-dev git && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /ros_ws/src && \
    cd /ros_ws/src && \
    git clone https://github.com/orbbec/OrbbecSDK_ROS1.git && \
    cd OrbbecSDK_ROS1 && git checkout v2-main

RUN bash -c "source /opt/ros/noetic/setup.bash && cd /ros_ws && catkin_make"
COPY entrypoint.sh /.
ENTRYPOINT [ "/entrypoint.sh" ]
WORKDIR /ros_ws
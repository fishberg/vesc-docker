FROM ros:melodic
#FROM ros:noetic

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -q -y --no-install-recommends apt-utils
RUN apt-get install -q -y --no-install-recommends ros-melodic-desktop-full
RUN apt-get install -q -y --no-install-recommends net-tools iproute2 iputils-ping curl
RUN apt-get install -q -y --no-install-recommends git tmux vim apt-utils
RUN apt-get install -q -y --no-install-recommends ros-melodic-ackermann-msgs ros-melodic-serial ros-melodic-joy
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV ROS_DIR=/opt/ros/${ROS_DISTRO}
ENV WORKSPACE=/workspace
SHELL ["/bin/bash", "-c"]

# clone libraries
WORKDIR ${WORKSPACE}/src
RUN git clone https://github.com/mit-racecar/racecar.git
RUN git clone https://github.com/mit-racecar/vesc.git

# patch
WORKDIR ${WORKSPACE}/src/racecar/racecar/launch/includes
COPY "./copy/fix.patch" /root
RUN patch < ~/fix.patch
RUN rm /root/fix.patch

# build
WORKDIR ${WORKSPACE}
RUN . ${ROS_DIR}/setup.bash && catkin_make

# setup entrypoint
WORKDIR /root/bridge
COPY "./copy/entrypoint.bash" /
ENTRYPOINT ["/entrypoint.bash"]

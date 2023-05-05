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

# patches
# ------------------------------------------------------------------------------
# racecar-v2-teleop.patch
ENV PATCH="racecar-v2-teleop.patch"
WORKDIR ${WORKSPACE}/src/racecar/racecar/launch/includes
COPY "./copy/$PATCH" /root
RUN patch < ~/$PATCH
RUN rm /root/$PATCH

# joy_teleop.patch
ENV PATCH="joy_teleop.patch"
WORKDIR ${WORKSPACE}/src/racecar/racecar/config/racecar-v2
COPY "./copy/$PATCH" /root
RUN patch < ~/$PATCH
RUN rm /root/$PATCH

# vesc.patch
ENV PATCH="vesc.patch"
WORKDIR ${WORKSPACE}/src/racecar/racecar/config/racecar-v2
COPY "./copy/$PATCH" /root
RUN patch < ~/$PATCH
RUN rm /root/$PATCH
# ------------------------------------------------------------------------------

# build
WORKDIR ${WORKSPACE}
RUN . ${ROS_DIR}/setup.bash && catkin_make

# setup entrypoint
WORKDIR /root/bridge
COPY "./copy/entrypoint.bash" /
ENTRYPOINT ["/entrypoint.bash"]

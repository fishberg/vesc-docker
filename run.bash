#/usr/bin/env bash
#docker run -it vesc-docker

DEVICES="--device=/dev/input/js0 --device=/dev/ttyVESC -v /dev:/dev"

docker run -it --net=host --privileged $DEVICES -v $(pwd)/bridge:/root/bridge vesc-docker

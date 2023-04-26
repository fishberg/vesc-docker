#!/usr/bin/env bash

if [[ "" ==  "$@" ]]; then
    echo "error: no target(s)"
    exit 1
fi

# https://ostechnix.com/copy-files-change-ownership-permissions-time/
echo "installing udev rules..."
sudo install -v -C -m 644 -o root -g root $1 /etc/udev/rules.d
echo "done"

# https://unix.stackexchange.com/questions/39370/how-to-reload-udev-rules-without-reboot
echo "reload udev rules..."
sudo udevadm control --reload-rules && sudo udevadm trigger
echo "done"

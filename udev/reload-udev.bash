#!/usr/bin/env bash

# https://unix.stackexchange.com/questions/39370/how-to-reload-udev-rules-without-reboot

sudo udevadm control --reload-rules && sudo udevadm trigger

#!/bin/bash

export USER=${USER:-docker}
/usr/bin/vncserver -kill :1 > /dev/null 2>&1
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1
/usr/bin/vncserver :1 -geometry 1920x1080 -depth 24

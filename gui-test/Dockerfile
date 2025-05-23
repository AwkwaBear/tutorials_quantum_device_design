FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=docker
ENV HOME=/home/docker

# Install packages
RUN apt-get update && \
    apt-get install -y \
    xfce4 xfce4-goodies \
    tightvncserver \
    supervisor \
    wget \
    unzip \
    sudo \
    python3-pip && \
    pip3 install websockify && \
    apt-get clean

## Create a non-root user and give permissions
RUN useradd -m -s /bin/bash docker && \
    echo "docker:docker" | chpasswd && \
    usermod -aG sudo docker && \
    mkdir -p /home/docker && \
    chown -R docker:docker /home/docker


## Switch to docker user
USER docker
WORKDIR /home/docker


## Setup VNC server as docker user
RUN mkdir -p /home/docker/.vnc && \
    echo "docker" | vncpasswd -f > /home/docker/.vnc/passwd && \
    chmod 600 /home/docker/.vnc/passwd && \
    echo -e '#!/bin/sh\nxrdb $HOME/.Xresources\nstartxfce4 &' > /home/docker/.vnc/xstartup && \
    chmod +x /home/docker/.vnc/xstartup


## Switch back to root for rest of setup
USER root


# Install noVNC
RUN mkdir -p /opt/novnc /opt/websockify && \
    wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip -O /tmp/novnc.zip && \
    unzip /tmp/novnc.zip -d /opt && \
    mv /opt/noVNC-master/* /opt/novnc/ && \
    wget https://github.com/novnc/websockify/archive/refs/heads/master.zip -O /tmp/websockify.zip && \
    unzip /tmp/websockify.zip -d /opt && \
    mv /opt/websockify-master/* /opt/websockify/

## Copy startup and supervisor configs
COPY start-vnc.sh /usr/local/bin/start-vnc.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## Start VNC server and websockify
RUN chmod +x /usr/local/bin/start-vnc.sh

# Command to launch supervisor
CMD ["/usr/bin/supervisord"]

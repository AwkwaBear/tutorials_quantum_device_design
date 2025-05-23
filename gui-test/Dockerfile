FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install GUI + VNC + noVNC
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies tightvncserver wget supervisor python3-pip && \
    pip3 install websockify && \
    apt-get clean

# Set up a user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Switch to user
USER docker
WORKDIR /home/docker

# Set up VNC
RUN mkdir ~/.vnc && \
    echo "docker" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Start script
RUN echo '#!/bin/bash\nstartxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Switch back to root to install noVNC
USER root

# Get noVNC
RUN mkdir -p /opt/novnc /opt/websockify && \
    wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip -O /tmp/novnc.zip && \
    unzip /tmp/novnc.zip -d /opt && \
    mv /opt/noVNC-master/* /opt/novnc/ && \
    wget https://github.com/novnc/websockify/archive/refs/heads/master.zip -O /tmp/websockify.zip && \
    unzip /tmp/websockify.zip -d /opt && \
    mv /opt/websockify-master/* /opt/websockify/

# Supervisor to manage processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord"]

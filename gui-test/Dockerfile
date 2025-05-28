FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=docker
ENV HOME=/home/docker

# Install packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    gfortran \
    git \
    curl \
    wget \
    libopenblas-dev \
    liblapack-dev \
    libfftw3-dev \
    libhdf5-dev \
    libopenmpi-dev \
    openmpi-bin \
    pkg-config \
    python3 \
    xfce4 xfce4-goodies \
    tightvncserver \
    supervisor \
    wget \
    unzip \
    sudo \
    python3-pip && \
    pip3 install websockify && \
    apt-get clean

# Install Firefox without Snap 
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:mozillateam/ppa && \
    apt-get update && \
    apt-get install -y firefox-esr && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
   
## Create a non-root user and give permissions
RUN useradd -m -s /bin/bash docker && \
    echo "docker:docker" | chpasswd && \
    usermod -aG sudo docker && \
    mkdir -p /home/docker && \
    chown -R docker:docker /home/docker


## Switch to docker user
USER docker
WORKDIR /home/docker




## Install miniconda for the docker user
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p $HOME/miniconda && \
    rm miniconda.sh && \
    $HOME/miniconda/bin/conda init bash && \
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc

## Install Qiskit metal and set up qdws conda environment
RUN export PATH="$HOME/miniconda/bin:$PATH" && \
    conda create -y -n qdws python=3.10 && \
    mkdir -p ~/qdws_workshop && cd ~/qdws_workshop && \
    curl -O https://raw.githubusercontent.com/Qiskit/qiskit-metal/main/environment.yml && \
    conda run -n qdws conda env update -n qdws -f environment.yml && \
    conda run -n qdws python -m pip install --no-deps -e git+https://github.com/Qiskit/qiskit-metal.git#egg=qiskit-metal

## Install SQuADDS
RUN export PATH="$HOME/miniconda/bin:$PATH" && \
    conda run -n qdws pip install SQuADDS

## Install SQDMetal
RUN export PATH="$HOME/miniconda/bin:$PATH" && \
    cd ~/qdws_workshop && \
    git clone https://github.com/sqdlab/SQDMetal.git && \
    cd SQDMetal && \
    conda run -n qdws pip install -e .
    

RUN echo 'conda activate qdws' >> ~/.bashrc

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

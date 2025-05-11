FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential cmake git wget curl \
    python3 python3-dev python3-pip python3-venv \
    libopenmpi-dev openmpi-bin \
    libblas-dev liblapack-dev libhdf5-dev \
    libfftw3-dev libboost-all-dev \
    libmetis-dev libsuperlu-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install numpy scipy mpi4py matplotlib

# Clone and build Palace
RUN git clone --recursive https://github.com/awslabs/palace.git /palace
WORKDIR /palace

# Configure and build
RUN python3 scripts/configure.py --download-deps && \
    make -j$(nproc)

# Set environment variables for Palace
ENV PATH="/palace/build/bin:$PATH"
ENV PYTHONPATH="/palace/python:$PYTHONPATH"

# Set working directory for user sessions
WORKDIR /home/jovyan

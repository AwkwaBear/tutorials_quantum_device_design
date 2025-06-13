This forked toolkit is for an all-in-one docker container
 Setup instructions [here](#setup)
---
# Simulating **Qiskit Metal** Designs with **palace** and **SQDMetal**

This tutorial explores the simulation of [Qiskit Metal](https://github.com/qiskit-community/qiskit-metal)  `design` objects using `palace`, facilitated by `SQDMetal`. The design of quantum devices, the foundation of the quantum ecosystem, is a multi-step process. Qiskit Metal endeavors to simplify and organize this undertaking.

**About Qiskit Metal**

[Qiskit Metal](https://github.com/qiskit-community/qiskit-metal) 
 \( [docs here](https://qiskit-community.github.io/qiskit-metal/index.html), [tutorials here](https://qiskit-community.github.io/qiskit-metal/tut/index.html)  \)  aims to provide a community-driven platform for quantum chip development, from concept to layout to electromagentics to Hamiltonians and to fabrication, within an open framework. It aims to foster innovation and make the design of quantum devices more accessible.  By automating and building in best practices, testing on real devices, Metal aims to make quantum hardware modeling more straightforward, reduce errors, and improve design speed.  It was started and led by Zlatko Minev, developed with the IBM Qiskit Metal team and many open-source contributors. It employs the permissive Apache 2.0 license and is now a community-maintained open-source package.

 The [Qiskit Metal tutorials](https://qiskit-community.github.io/qiskit-metal/tut/index.html) and [20+ videos on YouTube](https://www.youtube.com/playlist?list=PLOFEBzvs-VvqHl5ZqVmhB_FcSqmLufsjb) offer a good starting point for exploration.

**Contributing to the Future of Device Design**

The continued development of Qiskit Metal relies on its community. If you have an interest in quantum hardware and wish to contribute, consider becoming a maintainer or exploring funding opportunities. We invite you to the **Quantum Metal and device design session**. This will be a discussion with Zlatko Minev, Eli Levinson Falk, and other key figures in the Metal community about its future, the formation of a board of directors, and a maintainer group. If contributing to this effort interests you, we encourage you to connect at this workshop and **join the Thursday workshop on the future of Metal.** 


**What This Tutorial Covers**

Here, we will walk through electrostatic and eigenmode simulations of a qubit-cavity system. We will use `palace`, an open-source finite element analysis tool, through the `SQDMetal` interface. While Qiskit Metal also supports other tools like Elmer, this guide focuses on the `palace` integration.

We will learn to:
1.  Define a qubit-cavity system in Qiskit Metal.
2.  Prepare this design for simulation with `SQDMetal`.
3.  Run electrostatic simulations in `palace` to examine charge distributions and capacitances.
4.  Conduct eigenmode simulations in `palace` to find resonant frequencies and mode profiles.

This tutorial aims to provide a working knowledge of how these open-source tools can be combined for the analysis of superconducting quantum circuits, helping to reveal the underlying physics at play.

~~**Requirements:**~~

~~* [ ] Ensure that [`SQDMetal`](https://github.com/sqdlab/SQDMetal) is installed in your environment. This package includes installation of Qiskit Metal.~~

~~* [ ] Ensure that [`palace`](https://github.com/sqdlab/palace) is installed in your environment. Instructions are [here](https://lfl-lab.github.io/SQuADDS/source/resources/palace.html).~~

Let us begin the exploration.

# Setup

This toolkit will setup all-in-one docker container that will automatically install the following tools
- [Qiskit Metal](https://github.com/qiskit-community/qiskit-metal) 
- [SQuADDS](https://github.com/LFL-Lab/SQuADDS)
- [SQDMetal](https://github.com/sqdlab/SQDMetal)
- [AWS Palace](https://github.com/sqdlab/palace)

Once you install Docker and build the toolkit it will run a virtualized ubuntu desktop environment where the tools are available. You can access this via your browser at `http://localhost:6080/vnc.html` and connecting with password `docker` this will work for running the toolkits simulations without GUI (Graphical User Interface) elements. (when loading UI elements you will get errors about qt being unable to render, this is currently expected)

**NOTE: This container is currently just a test case work-in-progress with the following features to be implemented before a v0.1 release**

- Local volume storage setup
  - current iteration does not have data persist when shutdown, this is on purpose for testing
- Jupyterlab headless implementation
  - Will allow access to container's jupyterlab directly through the host browser without need for the whole XFCE desktop (GUI elements are still not compatible)
- An Xserver implementation to allow GUI elements for Qiskit Metal and hardware acceleration
  - Will provide optional cases to use either browser or local Xserver on startup




# Installation guide:
**Note: Instructions for Linux and Mac are incomplete**
1.  **Download and install **Docker** for your operating system:**
   
      - [All platforms (Linux)](https://docs.docker.com/engine/install/)
      - [Windows10/11](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)
        - Follow the instructions [here](https://docs.docker.com/desktop/setup/install/windows-install/) to set up docker with `WSL 2 backend x86_64` 
      - [Mac with Intel Chip](https://desktop.docker.com/mac/main/amd64/Docker.dmg)
      - [Mac with Apple Chip](https://desktop.docker.com/mac/main/arm64/Docker.dmg)
  - Note for Linux: Do not run docker commands or the start scripts as root (`sudo`)! Follow the instructions in [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)

2. **Clone this repo to a location on your desktop:**
   - At the top of [this Github Repo](https://github.com/AwkwaBear/tutorials_quantum_device_design), click the green `<> Code` button -> `Download ZIP`
   - Unzip the folder in a desired location

3. **Compose Docker container:**

   - Windows:
     - Navigate to the inside the unzipped `tutorials_quantum_device_design/docker/` folder from step 2 using windows `File Explorer`
     - Click the navigation bar at the top of the file explorer window and and type `powershell` then press `enter`
       - ![alt text](docs\images\fileExplorerNavBar.png)
     - This will open a command prompt, Ensure the current line says you are in the `tutorials_quantum_device_design/docker/` folder, then run:
       - `docker compose build`
         -  Docker will download and install the container, (This will take a long time (~45min - 1 hr depending on your computer)
     - Then run `docker compose up` in the same command prompt location:
         - This will start the container and automatically set up a VNC stream for your browser to access
         - **Note: If you have issues with the above steps you may need to run the commands with `sudo` in front to run then with admin permissions. For example,  `sudo docker compose build` and `sudo docker compose up`**

4. **Connect to Container with browser:**
   - Open a web browser and navigate to `http://localhost:6080/vnc.html`
   - Click `Connect`
   - Enter the password `docker`

5. **Test for installed files**
- You should have access to the ubuntu desktop environment and can test whether the required packages are all installed by opening the terminal in the environment and running the following commands:

   - Open a terminal:
     - Run `palace` and verify it says something like `Usage: palace [OPTIONS] CONFIG_FILE` then lists some options and no error shows
     - Run `python` then run the following commands
```
>>> import qiskit_metal
>>> import squadds
>>> import SQDMetal
>>> exit()
```
  - if no errors show up everything is installed correctly
- You can also open jupyterlab by opening a terminal and running `jupyter lab` and it should open a mozilla browser

- To close the docker container you can use the docker dashboard GUI to navigate to `Containers` then click `Stop`
- You can restart it with the GUI by navigating back and clicking start



# Credit Disclaimer:
This toolkit's implementation docker implementation was heavily inspired and some instructions directly copied from incredible open-source work on [IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS), an all-in-one Docker image for SKY130/GF180/IHP130-based analog and digital chip design. Specifically the docker installation instructions, VNC interfacing, and Xserver implementations for different OSes.
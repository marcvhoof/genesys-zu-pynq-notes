###### Notes on Genesys ZU 3EG with PYNQ and DPU IP


## Why? 
The ease of use of [Pavel Demin's way of working](http://pavel-demin.github.io/red-pitaya-notes/) with building the FPGA sources and embedded Linux is in my opinion unmatched. It is straightforward and the code is easy to maintain over time. It allows a beginner to catch on, and an expert to focus on a a straightforward implementation of their FPGA project. The clarity of the source code tree allows for (partial) re-use and easy spread. Initially this was a ported fork, due to extensive changes and a crucial difference in target platform (mpsoc vs. zynq 7000), a new repository for this PYNQ/DPU enabled version was more appropriate to make it easier to work from for other Xilinx MPSoC projects. 

## What's included?
In this repository, I included **Ubuntu 22.04 LTS (instead of Petalinux), PYNQ (3.0) and a DPU example** (from IP to the compilation of a neural network). The latter includes the creation of model zoo neural network using Vitis 2.5 in a Docker. Everything is there for you the implement your own custom, neural networks on the DPU. Making the DPU requires a lot of space - > 100GB.

## Getting started
These commands should be the only ones you need to build your image. You do need to install [Xilinx Vitis 2022.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html) and [XRT 2022.1](https://www.xilinx.com/bin/public/openDownload?filename=xrt_202210.2.13.466_20.04-amd64-xrt.deb). 

As a **host - Ubuntu 20.04 LTS is requiered**, newer versions are not supported and will give you problems with installing XRT, which is necessary for building the DPU (see compatibility matrix below). If your machine is running a different version, I would consider using a Cloud or Vagrant install. However - if you plan to use CUDA or extensive training for your neural network in Vitis AI, probably a local setup (e.g. with Docker) is more efficient. 

<details>
  <summary>Optional Cloud, Docker or Vagrant instructions - when starting from scratch</summary>
  
  ### Instructions for a Droplet on DigitalOcean
  Select a Droplet with an additional volume (my settings Ubuntu 20.04 LTS / 160 GB / 8 GB ram / NVME SSD / + volume 200GB). DigitalOcean somehow blocks port 3389 sometimes - I changed it to 3388 afterwards to fix this problem. 
  
  ### For Cloud applications, create a remote desktop server
  ```
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install xrdp -y
  sudo systemctl enable xrdp
  sudo ufw allow 3389/tcp
  sudo apt-get install ubuntu-desktop -y
  adduser xilinx
  ```
  ```
  usermod -aG sudo xilinx
  swapoff -a
  fallocate -l 16G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt-get install -y ./google*
  reboot
  ```
  ### Find your IP and connect with your Remote Desktop Client
  On Windows use the standard RDP app. 
  
  ### Instructions for Vagrant
  Find yourself a 22.04 Ubuntu LTS Vagrant file (e.g. [here](https://app.vagrantup.com/generic/boxes/ubuntu2204), and use 16GB of virtual ram, 2 to 4 CPUs and I recommend 200GB+ disk size.  
  
  ### Install Vitis 2022.1 and XRT
  1. Start chrome, download the [XRT(2022.1)](https://www.xilinx.com/bin/public/openDownload?filename=xrt_202210.2.13.466_20.04-amd64-xrt.deb)
  2. Go to the download folder in the terminal and execute
  ```
  sudo apt install -y ./xrt*
  ```
  3. Install Vitis 2022.1
</details>

# 1. Install the prerequisites
```
sudo apt-get update -y
```
```
sudo apt-get--no-install-recommends install \
  build-essential bison flex git curl ca-certificates sudo cmake \
  xvfb fontconfig libxrender1 libxtst6 libxi6 gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi \
  bc u-boot-tools device-tree-compiler libncurses5-dev \
  libssl-dev qemu-user-static binfmt-support zip ca-certificates curl gnupg \
  squashfs-tools dosfstools parted debootstrap zerofree gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu 
```
```
sudo ln -s make /usr/bin/gmake
```
```
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
```
 echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
```
sudo apt-get update -y 
```
```
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
# 2. Set up your environment
```
source /tools/Xilinx/Vitis/2022.1/settings64.sh
source /opt/xilinx/xrt/setup.sh
```

# 3. Clone the code repository
```
git clone https://github.com/marcvhoof/genesys-zu-pynq-notes
cd genesys-zu-pynq-notes
```
# 4. Build your project
```
make NAME=led_blinker all
```
# 5. Create a Linux image containing everything, including Pynq 3.0.
```
sudo sh scripts/image.sh scripts/ubuntu.sh genesys-zu-ubuntu-pynq-arm64.img 8096
```
# 6. Burn to a fast SD Card
Use your favourite image maker. For example Ubuntu's start up image maker. You can change the image size in step 5 or use gparted afterwards to extend the filesystem to the size of your card. The Genesys ZU supports the UHS-I 104MB/s mode. 
# 7. Finish installing PYNQ on target
Login via Putty on the USB-UART, the standard password for root is changeme. The current setup only supports an Ethernet connection - which is autoconfigured with DHCP.
```
# Load XRT library module
insmod /lib/modules/*/kernel/zocl.ko

# Fix keyserver
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 \
	        --verbose 803DDF595EA7B6644F9B96B752150A179A9E84C9
echo "deb http://ppa.launchpad.net/ubuntu-xilinx/updates/ubuntu jammy main" > /etc/apt/sources.list.d/xilinx-gstreamer.list
apt update 

#Install PYNQ-HelloWorld
python3 -m pip install pynq_helloworld --no-build-isolation 

# Install DPU-PYNQ
yes Y | apt remove --purge vitis-ai-runtime
python3 -m pip install pynq-dpu==2.5 --no-build-isolation

# Install Pynq Peripherals
python3 -m pip install git+https://github.com/Xilinx/PYNQ_Peripherals.git

# Deliver all notebooks
yes Y | pynq-get-notebooks -p $PYNQ_JUPYTER_NOTEBOOKS -f
cp pynq/pynq/notebooks/common/ -r $PYNQ_JUPYTER_NOTEBOOKS
```
Connect to the Jupyter (IPGENESYSZU:9090, password: xilinx) in your browser and start creating your project. To get the IP address:
```
ifconfig
```
# 8. [optional] Create the DPU Overlay and start working with Vitis-AI 2.5
In the genesys-zu-pynq-notes directory execute the following command. 
```
make DPU
```
Afterwards, copy the relevant files (.hwh, .bit, .tcl, .xmodel, zocl.ko) to your DPU working folder on the target device. Install the DPU overlay on PYNQ and get the relevant notebooks.
```
cd $PYNQ_JUPYTER_NOTEBOOKS
pynq get-notebooks pynq-dpu -p .
python3 -m pytest --pyargs pynq_dpu
```
The [script patches/docker/docker_script.sh](https://github.com/marcvhoof/genesys-zu-pynq-notes/blob/main/patches/docker/docker_script.sh) can be used to instruct Vitis to compile your neural network and produce a .xmodel, without further interaction. This file can be found in the shared host/Docker directory (tmp/DPU-PYNQ/host/). However, for custom models, interactivity is probably necessary and changing the content of this file gives you a terminal inside the Vitis Docker.  

# 9. [optional] Rebuild the XRT library
This cannot yet be build succesfully in a chroot. So on the target device execute the following. 
```
# build and install
cd /root
mkdir xrt-git
git clone https://github.com/Xilinx/XRT xrt-git
cd xrt-git
git checkout -b temp tags/202210.2.13.466
# An incorrect format specifier causes a crash on armhf
sed -i 's:%ld bytes):%lld bytes):' src/runtime_src/tools/xclbinutil/XclBinClass.cxx
cd build
chmod 755 build.sh
XRT_NATIVE_BUILD=no ./build.sh -dbg -noctest
cd Debug
make install
```
```
# Build and install xclbinutil
cd ../../
mkdir xclbinutil_build
sed -i 's/xdp_hw_emu_device_offload_plugin xdp_core xrt_coreutil xrt_hwemu/xdp_core xrt_coreutil/g' ./src/runtime_src/xdp/CMakeLists.txt
cd xclbinutil_build/
cmake ../src/
make install -C runtime_src/tools/xclbinutil
mv /opt/xilinx/xrt/bin/unwrapped/xclbinutil /usr/local/bin/xclbinutil
rm -rf /opt/xilinx/xrt

# cleanup
cd /root
rm -rf xrt-git
```

# Relevant background & progress
## Current state
* Ubuntu 22.04 LTS runs well and can connect using DHCP over Ethernet
* A Samsung NVME SSD reaches around 300 MB/s read/write on the X1 port
* A .xmodel has been compiled in Vitis 2.5 and has been run using Jupyter on the board using a B800 configuration (resulting in 13 FPS)
* The SYZYGY ADC/DAC can be used either over the native ZMOD port (only 1 available) or over the FMC-2-ZMOD adapter

## Current progress and known problems
This repository has not yet been synced! Final files are expected before 2.7.2023

error: /usr/lib/libxrt_core.so: cannot open shared object file: No such file or directory / ln waarschijnlijk niet mee gedownload om XRT te builden moet /usr/bin/grep: /proc/cpuinfo: No such file or directory

* The WIFI - WILC1500 is recognised but fails to start the firmware and is not yet useable. I suspect it is a problem with the WILC1500 on-flash firmware or GPIO.
* The audio chip is not yet included.
* Only a selection of Pynq libraries is included (and/or tested)
* The MIPI/PMOD and board specific IO have not been completely implemented or tested. But should be very straightforward by using the Digilent sources.
* The Displayport has not been tested

## Important to consider for future upgrades
[This compatibility matrix](https://xilinx.github.io/Vitis-AI/3.5/html/docs/reference/version_compatibility.html#version-compatibility) shows you which combinations have been tested to work. An overview of kernels available for Ubuntu + the Vitis releases can be found [here](https://github.com/Xilinx/linux-xlnx/tags). The XRT packages (.deb) which can be installed directly starting from 2022.2 (for [2022.1](https://www.xilinx.com/bin/public/openDownload?filename=xrt_202210.2.13.466_20.04-amd64-xrt.deb) can be found [here](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-platforms/2022-2.html) under the respective version. 

## Porting this repository to your own (custom) Xilinx MPSoC board
Here is an overview to get you started. This is not an exhaustive list, it mentions the changes you probably at least need to make because these are Genesys ZU 3EG specific. Probably only minor changes have to be made in these files to use these files for the Genesys ZU 5EV.

### Board and FPGA Part files (/cfg dir):
* genesyszu.dts
* genesyszu.dtsi
* ports.tcl
* ports.xdc
* essentials.tcl
### Board specific patches (/patches dir):
Some of these patches were necessary for the Genesys ZU to succesfully boot and might be disruptive to your own setup. I recommend starting by disabling all patches in the Makefile and deleting/adding them one by one in the patch files afterwards.  

### General:
* Makefile, specifically the BOARD and PART definitions and the application of the patches
* DPU files (especially dpu_conf.vh - the 'B800' DPU definition depends on the size of your FPGA part). In general you can easily port your own board by mirroring a similar board which is available in the board directory of the [Xilinx DPU repository](https://github.com/Xilinx/DPU-PYNQ).

## Port of Pavel Demin's work and other sources
Notes on the Genesys ZU, following the methodology of Pavel Demin's Red Pitaya implementation:
* http://pavel-demin.github.io/red-pitaya-notes/ 

Other important sources were the Digilent's Genesys ZU sources
* https://github.com/Digilent/Genesys-ZU-OOB-os 
* https://github.com/Digilent/Genesys-ZU-HW 
* https://github.com/Digilent/vivado-boards/tree/master/new/board_files/genesys-zu-3eg 

And the OSF flow tutorial for a Zynq UltraScale+ MPSoC board (ZCU102)
* https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841722/ZCU102+Image+creation+in+OSL+flow

And the Xilinx DPU, (Kria-)Pynq github
* https://github.com/Xilinx/PYNQ
* https://github.com/Xilinx/DPU-PYNQ
* https://github.com/Xilinx/Kria-PYNQ



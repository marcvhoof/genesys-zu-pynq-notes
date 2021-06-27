###### Genesys ZU Notes


## Why? 
Current Genesys ZU sources are meant for the Vivado 2019 suite. No updates were provided, while interesting new IP became available over the years. Just upgrading the version did not work out of the box. The Petalinux implementation is complete. However, the ease of use of Pavel Demin's way of working with building FPGA sources and Linux is in my opinion unmatched. It is straightforward and the code is easy to maintain over time. It allows a beginner to catch on, and an expert to focus on a a straightforward implementation of their FPGA project. The clarity of the source code tree allows for (partial) re-use and easy spread.   

## Getting started
These commands should be the only ones you need to build your image. You do need to install [Xilinx Vitis](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html).

# 1. Install the prerequisites
```
sudo apt-get update

sudo apt-get --no-install-recommends install \
  build-essential bison flex git curl ca-certificates sudo \
  xvfb fontconfig libxrender1 libxtst6 libxi6 lib32ncurses5 \
  bc u-boot-tools device-tree-compiler libncurses5-dev \
  libssl-dev qemu-user-static binfmt-support zip \
  squashfs-tools dosfstools parted debootstrap zerofree

sudo ln -s make /usr/bin/gmake
```

# 2. First set up your environment
```
source /opt/Xilinx/Vitis/2020.2/settings64.sh
```

# 3. Clone the code repository
```
git clone https://github.com/marcvhoof/genesys-zu-notes
cd genesys-zu-notes
```
# 4. Build your project
```
make NAME=led_blinker all
```
# 5. Create a Linux image containing everything
```
sudo sh scripts/image.sh scripts/debian.sh genesys-zu-debian-arm64.img 1024
```
# 6. Burn to a big enough SD Card
Use your favourite image maker. For example Ubuntu's start up image maker. 

## Port of Pavel Demin's work and other sources
Notes on the Genesys ZU, following the methodology of Pavel Demin's Red Pitaya implementation:
* http://pavel-demin.github.io/red-pitaya-notes/ 

Other important sources were the Digilent's Genesys ZU sources
* https://github.com/Digilent/Genesys-ZU-OOB-os 
* https://github.com/Digilent/Genesys-ZU-HW 
* https://github.com/Digilent/vivado-boards/tree/master/new/board_files/genesys-zu-3eg 

And the OSF flow tutorial for a Zynq UltraScale+ MPSoC board (ZCU102)
* https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841722/ZCU102+Image+creation+in+OSL+flow 

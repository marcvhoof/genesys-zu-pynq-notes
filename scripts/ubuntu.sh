LINUX_TAG=xlnx_rebase_v5.15_LTS_2022.1
device=$1

boot_dir=`mktemp -d /tmp/BOOT.XXXXXXXXXX`
root_dir=`mktemp -d /tmp/ROOT.XXXXXXXXXX`

linux_dir=tmp/linux-$LINUX_TAG
linux_ver=5.15

distro=jammy
arch=arm64


root_tar=ubuntu-base-22.04-base-arm64.tar.gz
root_url=http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/$root_tar
passwd=changeme
timezone=Europe/Brussels

ARCH=aarch64
HOME=/root
PYNQ_JUPYTER_NOTEBOOKS=/home/$LOGNAME/jupyter_notebooks
BOARD=genesyszu
PYNQ_VENV=/usr/local/share/pynq-venv

# Create partitions

parted -s $device mklabel msdos
parted -s $device mkpart primary fat16 4MiB 64MiB
parted -s $device mkpart primary ext4 64MiB 100%

boot_dev=/dev/`lsblk -ln -o NAME -x NAME $device | sed '2!d'`
root_dev=/dev/`lsblk -ln -o NAME -x NAME $device | sed '3!d'`

# Create file systems

mkfs.vfat -v $boot_dev
mkfs.ext4 -F -j $root_dev

# Mount file systems

mount $boot_dev $boot_dir
mount $root_dev $root_dir

# Copy files to the boot file system

cp boot.bin devicetree.dtb Image $boot_dir
cp cfg/uEnv-ext4.txt $boot_dir/uEnv.txt

# Allow getting the packages insecure
mkdir -p $root_dir/etc/apt/apt.conf.d/
echo 'Acquire::AllowInsecureRepositories "1";' > $root_dir/etc/apt/apt.conf.d/allowinsecure

# Copy Ubuntu Core to the root file system

test -f $root_tar || curl -L $root_url -o $root_tar

tar -zxf $root_tar --directory=$root_dir

# Install Linux modules

modules_dir=$root_dir/lib/modules/$linux_ver

mkdir -p $modules_dir/kernel
mkdir -p $root_dir/lib/firmware/
mkdir -p $root_dir/lib/firmware/mchp
cp patches/wilcfirmware/wilc*.bin $root_dir/lib/firmware/mchp

cp tmp/xrt*/zocl.ko $linux_dir/

find $linux_dir -name \*.ko -printf '%P\0' | tar --directory=$linux_dir --owner=0 --group=0 --null --files-from=- -zcf - | tar -zxf - --directory=$modules_dir/kernel

cp $linux_dir/modules.order $linux_dir/modules.builtin $modules_dir/

depmod -a -b $root_dir $linux_ver

# Add missing configuration files and packages

cp /etc/resolv.conf $root_dir/etc/
cp /usr/bin/qemu-arm-static $root_dir/usr/bin/

mkdir -p $root_dir/usr/xrt/patches
cp -r patches/xrt/* $root_dir/usr/xrt/patches

sudo chroot $root_dir <<- EOF_CHROOT
export LANG=C
export LC_ALL=C

cat <<- EOF_CAT > proc/stat
cpu  1190 0 780 14104 680 0 4 0 0 0
cpu0 563 0 354 2932 207 0 1 0 0 0
cpu1 245 0 103 3763 126 0 0 0 0 0
cpu2 89 0 215 3825 88 0 0 0 0 0
cpu3 292 0 107 3583 257 0 1 0 0 0
intr 45475 0 353 14252 0 0 0 0 0 0 0 0 14126 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7098 0 0 0 0 0 0 0 0 88 0 0 9157 2 304 0 0 0 0 0 32 0 0 0 0 0 12 43 1 0 0 0 0
ctxt 55298
btime 1686299604
processes 384
procs_running 1
procs_blocked 0
softirq 28782 5 4046 0 0 4272 0 82 7267 0 13110
EOF_CAT

cat <<- EOF_CAT > proc/cpuinfo
processor       : 0
BogoMIPS        : 60.00
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 4

processor       : 1
BogoMIPS        : 60.00
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 4

processor       : 2
BogoMIPS        : 60.00
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 4

processor       : 3
BogoMIPS        : 60.00
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 4

EOF_CAT

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cat <<- EOF_CAT > etc/apt/apt.conf.d/99norecommends
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF_CAT

cat <<- EOF_CAT > etc/fstab
# /etc/fstab: static file system information.
# <file system> <mount point>   <type>  <options>           <dump>  <pass>
/dev/mmcblk0p2  /               ext4    errors=remount-ro   0       1
/dev/mmcblk0p1  /boot           vfat    defaults            0       2
EOF_CAT

cat <<- EOF_CAT >> etc/securetty

# Serial Console for Xilinx MPSoC
ttyPS0
EOF_CAT

mkdir -p etc/init/
touch etc/init/ttyPS0.conf
touch etc/init/tty1.conf
sed 's/tty1/ttyPS0/g; s/115200/115200/' etc/init/tty1.conf > etc/init/ttyPS0.conf

cat <<- EOF_CAT > /etc/hosts
127.0.0.1 genesyszu
127.0.0.1 localhost
EOF_CAT

mkdir -p etc/netplan/
cat <<- EOF_CAT > etc/netplan/00-install-config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      nameservers:
        search: [mydomain, otherdomain]
        addresses: [8.8.8.8, 1.1.1.1]
EOF_CAT

mkdir -p etc/systemd/system/
cat <<- EOF_CAT > etc/systemd/system/netfix.service
[Unit]
After=network.target

[Service]
ExecStart=/etc/init.d/eth0fix.sh

[Install]
WantedBy=default.target
EOF_CAT
chmod +x /etc/systemd/system/netfix.service

mkdir -p etc/init.d/
cat <<- EOF_CAT > etc/init.d/eth0fix.sh
#!/bin/bash

ip link set eth0 down
ip link set eth0 up
EOF_CAT
chmod +x /etc/init.d/eth0fix.sh

chmod 744 /etc/init.d/eth0fix.sh
chmod 664 /etc/systemd/system/netfix.service

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

apt-get --allow-unauthenticated update
apt-get --allow-unauthenticated -y upgrade
apt-get --allow-unauthenticated -y install locales tzdata

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

echo $timezone > etc/timezone
dpkg-reconfigure --frontend=noninteractive tzdata
apt-get --allow-unauthenticated -y upgrade

apt-get --allow-unauthenticated -y install openssh-server ca-certificates ntp usbutils psmisc lsof \
  parted curl less vim man-db iw wpasupplicant linux-firmware ntfs-3g gpgv dialog apt-utils sudo wget \
  psmisc lsof isc-dhcp-server isc-dhcp-client pv lshw mmc-utils net-tools ntpdate fake-hwclock git \
  iptables ifplugd ntfs-3g build-essential pciutils nano resolvconf gpiod \
  python3-cffi libssl-dev libcurl4-openssl-dev iputils-ping netplan.io 

sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' etc/ssh/sshd_config

apt-get --allow-unauthenticated update
apt-get --allow-unauthenticated -y upgrade

#PYNQ prerequistes
apt-get --allow-unauthenticated -y install portaudio19-dev libcairo2-dev libopencv-dev python3-opencv graphviz i2c-tools \
  fswebcam ffmpeg libsm6 libxext6 debhelper dh-python python3-all python3-setuptools python3-dev cmake kmod \
  python3-gnupg python3.10-venv devscripts lintian lsb-release python3-debian python3-pytest libboost-atomic-dev \
  libboost-serialization-dev libboost-system-dev libboost-test-dev libboost-thread-dev libboost-dev\
  libboost-thread-dev libboost-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-program-options-dev

apt-get --allow-unauthenticated update

#Add Xilinx repo
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 \
	        --verbose 803DDF595EA7B6644F9B96B752150A179A9E84C9
echo "deb http://ppa.launchpad.net/ubuntu-xilinx/updates/ubuntu jammy main" > /etc/apt/sources.list.d/xilinx-gstreamer.list
apt-get -o DPkg::Lock::Timeout=10 update

apt-get --allow-unauthenticated update
apt-get --allow-unauthenticated -y upgrade

apt-get --allow-unauthenticated -y install libdrm-xlnx-dev 

<<<<<<< HEAD
=======
#Install XRT - building in QEMU fails at this point
>>>>>>> be7a67d6c1de760cfd9f96d4af7dca996db16d1b
cp -f -r usr/xrt/patches/bin/* usr/bin
cp -n -r usr/xrt/patches/lib/* usr/lib

touch etc/udev/rules.d/75-persistent-net-generator.rules

apt-get clean

ldconfig 

echo root:$passwd | chpasswd

usermod -aG sudo root

# Get the pynq binaries
wget https://www.xilinx.com/bin/public/openDownload?filename=pynq-v3.0-binaries.tar.gz -O /tmp/pynq-v3.0-binaries.tar.gz
pushd /tmp
tar -xvf pynq-v3.0-binaries.tar.gz
popd

# Get PYNQ SDbuild Packages
git config --global --add safe.directory $(pwd)
git config --global --add safe.directory $(pwd)/pynq
if [ -d ".git/" ]
then
  git submodule init && git submodule update
else
  rm -rf pynq/
  git clone https://github.com/Xilinx/PYNQ.git --branch v3.0.1 --depth 1 pynq
fi

pushd pynq/sdbuild/packages/python_packages_jammy
mkdir -p $PYNQ_VENV
cat > $PYNQ_VENV/pip.conf <<EOT
[install]
no-build-isolation = yes
EOT

##pre.sh
set -x
target=$1
target_dir=root/.cache/pip
cp requirements.txt $target/root/
./qemu.sh
popd

# PYNQ VENV Activate Updates
echo "export PYNQ_JUPYTER_NOTEBOOKS=${PYNQ_JUPYTER_NOTEBOOKS}" >> /etc/profile.d/pynq_venv.sh
echo "export BOARD=$BOARD" >> /etc/profile.d/pynq_venv.sh
echo "export XILINX_XRT=/usr" >> /etc/profile.d/pynq_venv.sh
source /etc/profile.d/pynq_venv.sh

# Installing PYNQ-Metadata
python3 -m pip install pynqmetadata==0.1.2 

# Install PYNQ-Utils
python3 -m pip install pynqutils==0.1.1 

# PYNQ JUPYTER
pushd pynq/sdbuild/packages/jupyter

##pre.sh

target=$1
cp start_jupyter.sh $target/usr/local/bin
cp jupyter.service $target/lib/systemd/system
cp redirect_server $target/usr/local/bi
./qemu.sh
popd

# PYNQ Allocator
pushd pynq/sdbuild/packages/libsds
##pre.sh
target=$1
cp -r libcma $target/root/
./qemu.sh
popd

# Install PYNQ-3.0.1
python3 -m pip install pynq==3.0.1

## GCC-MB and XCLBINUTILS
pushd /tmp

cp -r -f /tmp/pynq-v3.0-binaries/gcc-mb/microblazeel-xilinx-elf /usr/local/share/pynq-venv/bin/
echo "export PATH=\$PATH:/usr/local/share/pynq-venv/bin/microblazeel-xilinx-elf/bin/" >> /etc/profile.d/pynq_venv.sh

cp /tmp/pynq-v3.0-binaries/xrt/xclbinutil /usr/local/share/pynq-venv/bin/
chmod +x /usr/local/share/pynq-venv/bin/xclbinutil
popd

# define the name of the platform
echo "$BOARD" > /etc/xocl.txt

#removed pynq device tree

source /etc/profile.d/pynq_venv.sh
popd

# Installing wheel
pip3 install wheel

# Patch microblaze to use virtualenv libraries
sed -i "s/opt\/microblaze/usr\/local\/share\/pynq-venv\/bin/g" /usr/local/share/pynq-venv/lib/#python3.10/site-packages/pynq/lib/pynqmicroblaze/rpc.py

# Start Jupyter services 
systemctl enable jupyter.service

# Install selftest
python3 -m pip install pytest
echo "#!/bin/bash" > selftest.sh
echo "source /etc/profile.d/pynq_venv.sh" >> selftest.sh
echo "python3 -m pytest /usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq_dpu/tests" >> selftest.sh
chmod a+x ./selftest.sh

# Change notebooks folder ownership and permissions
chown $LOGNAME:$LOGNAME -R $PYNQ_JUPYTER_NOTEBOOKS
chmod ugo+rw -R $PYNQ_JUPYTER_NOTEBOOKS

# Start the service for clearing the statefile on boot
cp pynq/sdbuild/packages/clear_pl_statefile/clear_pl_statefile.sh /usr/local/bin
cp pynq/sdbuild/packages/clear_pl_statefile/clear_pl_statefile.service /lib/systemd/system
systemctl enable clear_pl_statefile

# OpenCV
python3 -m pip install opencv-python
apt-get --allow-unauthenticated install ffmpeg libsm6 libxext6 -y

cat <<- EOF_CAT > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 4.2.2.4
EOF_CAT

systemctl daemon-reload
systemctl enable netfix.service

service ntp stop
service ssh stop

history -c

sync
EOF_CHROOT

rm $root_dir/proc/stat
rm $root_dir/proc/cpuinfo
rm $root_dir/usr/bin/qemu-arm-static

# Unmount file systems

umount $boot_dir $root_dir

rmdir $boot_dir $root_dir
zerofree $root_dev

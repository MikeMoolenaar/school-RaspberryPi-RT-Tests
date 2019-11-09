set -e
DIRECTORY=$1
LINUXBRANCH=$2

mkdir -p $DIRECTORY
cd $DIRECTORY

# Clone linux kernel and tools
apt install git flex bison -y
git clone https://github.com/raspberrypi/linux.git -b $LINUXBRANCH
git clone https://github.com/raspberrypi/tools.git

export ARCH=arm
export CROSS_COMPILE=$DIRECTORY/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-
export INSTALL_MOD_PATH=$DIRECTORY/kernel
export INSTALL_DTBS_PATH=$DIRECTORY/kernel

# This depends on the raspbery pi, we'll use the config for Pi 2 and 3B+
cd $DIRECTORY/linux/
export KERNEL=kernel7
make bcm2709_defconfig

# Make files, 4 is the number of cores in your system.
make -j4 zImage 
make -j4 modules 
make -j4 dtbs 
make -j4 modules_install 
make -j4 dtbs_install

# Move boot file into an tgz file
mkdir $INSTALL_MOD_PATH/boot
./scripts/mkknlimg ./arch/arm/boot/zImage $INSTALL_MOD_PATH/boot/$KERNEL.img
cd $INSTALL_MOD_PATH
tar czf ../kernel.tgz *

echo "Done, copy the '$DIRECTORY/kernel.tgz' file to your pi!"
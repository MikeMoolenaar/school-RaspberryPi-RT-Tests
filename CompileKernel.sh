set -e # Stop script on error
DIRECTORY=$1
LINUXBRANCH=$2
RASPBERRYPI_OPTION=$3

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

cd $DIRECTORY/linux/
# This depends on the raspbery pi
if [ $RASPBERRYPI_OPTION = "1" ] # Pi 1, Pi Zero, Pi Zero W
then
    export KERNEL=kernel
    make bcmrpi_defconfig
elif [ $RASPBERRYPI_OPTION = "2" ] # Pi 2, Pi 3, Pi 3B+
then
    export KERNEL=kernel7
    make bcm2709_defconfig
else # Pi 4
    export KERNEL=kernel7l
    make bcm2711_defconfig
fi

# Make files, 4 is the number of cores in your system.
make -j4 zImage 
make -j4 modules 
make -j4 dtbs 
make -j4 modules_install 
make -j4 dtbs_install

# Move boot files into a tgz file
mkdir $INSTALL_MOD_PATH/boot
./scripts/mkknlimg ./arch/arm/boot/zImage $INSTALL_MOD_PATH/boot/$KERNEL.img
cd $INSTALL_MOD_PATH
tar czf ../kernel.tgz *

echo "Done, copy the '$DIRECTORY/kernel.tgz' file to your pi!"
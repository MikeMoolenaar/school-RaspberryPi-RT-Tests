tar xzf kernel.tgz
cd boot
sudo cp -rd * /boot/
cd ../lib
sudo cp -dr * /lib/
cd ../overlays
sudo cp -d * /boot/overlays
cd ..
sudo cp -d bcm* /boot/
# Raspberry pi RT tests
This repo contains tools to compile and test the realtime linux kernel for the raspberry pi.
The following instructions assume that you have the following:
- A linux system to clone and compile the kernel
- The raspberry pi with Raspbian Buster Lite installed, you can reach the pi via SSH.

Make a folder `~/rpi-kernel` and copy the CompileKernel.sh file there.
Thene xecute the script, this will build the kernel and put it into the `rt-kernel.tgz` file.
```
sh CompileKernel.sh
```

Move the rt-kernel.tgz and the CompileOnPi.sh to the pi's `/tmp` folder, login in via the pi and execute the following.
This step assumes you have an existng pi with Raspbarian installed and SSH enabled.
```
cd /tmp/
sudo sh CompileOnPi.sh
```

Then to configure the boot loader, edit these files (this doesn't have to be done on the pi):
- In `/boot/config.txt` add: `kernel=kernel7_rt.img`.
- In `/boot/cmdline.txt` add `dwc_otg.fiq_fsm_enable=0 dwc_otg.fiq_enable=0 dwc_otg.nak_holdoff=0` to the end of the line. You can also add `ip=192.168.0.1` for example here to configure a static ip.
- Also add an empty `ssh` file to the `/boot` folder if you want to enable SSH.
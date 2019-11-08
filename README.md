# Raspberry pi RT tests
This repo contains tools to compile and test the realtime linux kernel for the raspberry pi.
The following instructions assume that you have the following:
- A linux system to clone and compile the kernel
- The raspberry pi with Raspbian Buster Lite installed, you can reach the pi via SSH.

Execute the script, this will build the kernel and put it into the `kernel.tgz` file in the specified folder.
```shell
sh CompileKernel.sh ~/rt-kernel rpi-4.19.y-rt # Remove '-rt' if you don't want the realtime kernel
```

Move the kernel.tgz and the InstallKernel.sh to the pi's `/tmp` folder, login in via the pi and execute the following.
This step assumes you have an existng pi with Raspbarian installed and SSH enabled.
```shell
cd /tmp/
sudo sh InstallKernel.sh
```

Then to configure the boot loader, edit these files (this doesn't have to be done on the pi):
- In `/boot/config.txt` add: `kernel=kernel7.img`.
- In `/boot/cmdline.txt` add `dwc_otg.fiq_fsm_enable=0 dwc_otg.fiq_enable=0 dwc_otg.nak_holdoff=0` to the end of the line. You can also add `ip=192.168.0.1` for example here to configure a static ip.
- Also add an empty `ssh` file to the `/boot` folder if you want to enable SSH.

Restart your pi and the new kernel should be installed!
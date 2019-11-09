# Raspberry Pi RT tests
This repo is meant as a resource for my report on the linux real time kernel (for the course Real Time Operating Systems). It contains tools to compile and test the realtime linux kernel for the raspberry pi.  
My report in dutch can be found here: TODO.

The following instructions assume that you have the following:
- A linux system to clone and compile the kernel
- The raspberry pi with Raspbian Buster Lite installed, you can reach the pi via SSH.

## Compiling the kernel
Execute the script, this will build the kernel and put it into the `kernel.tgz` file in the specified folder. The last argument is the Raspberry Pi option and depends on what version you have:

| Version | Option | Kernelname |
| ------ | ------ | ------ | 
| Raspberry Pi 1, Pi Zero, Pi Zero W | 1 | kernel |
| Raspberry Pi 2, Pi 3, Pi 3+ | 2 | kernel7 |
| Raspberry Pi 4 | 3 | kerne7l |

```shell
sh CompileKernel.sh ~/rt-kernel rpi-4.19.y-rt 2 # Remove '-rt' if you don't want the realtime kernel
```

Move the kernel.tgz and the InstallKernel.sh to the pi's `/tmp` folder, login in via the pi and execute the following.
This step assumes you have an existng pi with Raspbarian installed and SSH enabled.
```shell
cd /tmp/
sudo sh InstallKernel.sh
```

Then to configure the boot loader, edit these files (this doesn't have to be done on the pi):
- In `/boot/config.txt` add: `kernel=<Kernelname>.img` (see the above table for the correct name). 
- In `/boot/cmdline.txt` add `dwc_otg.fiq_fsm_enable=0 dwc_otg.fiq_enable=0 dwc_otg.nak_holdoff=0` to the end of the line. You can also add `ip=192.168.0.1` for example here to configure a static ip.
- Also add an empty `ssh` file to the `/boot` folder if you want to enable SSH.

Restart your pi and the new kernel should be installed!

## Executing tests
Software and hardware tests can be found in `Latency tests`, more information can be found in the report.
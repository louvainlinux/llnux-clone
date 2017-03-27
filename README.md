# LLnux-clone

This set of scripts provides a way to clone an install of a linux distribution.

**Warning: these scripts have not been tested thoroughly. They are very fragile and there are a lot of hardcoded paths. Expect this to ruin your data.**
**All commands are dangerous !**

## Required conditions to work

+ There should be only two storage devices in the machine: the disk with the install, as `/dev/sda`, with the partition that will be cloned as `/dev/sda1`. The other one should be the USB stick on which the clone is made (**content of it will be wiped**).
+ The linux distro should use GRUB.
+ Tested on Ubuntu x86_64 (adapt tinycore files for 32bits, untested).
+ USB stick should be big enough (5GB for a basic ubuntu install).
+ The USB stick should be recognized as `/dev/sdb`.
+ The hardware of both machine should be the same (or at least similar).

## Usecase (and design goals) for these scripts

+ clone a manually customized OS
+ ease (and speed) of usage
+ simplicity
+ require few to no maintenance
+ be usable without network infrastructure

## Process

### Naming

+ Host system: system that will be cloned.
+ Portable system: a system installed on the USB stick
+ Destination system: the system installed on the other computer, will be identical to the host system.

## Overview
+ The scripts are added on the host
+ Tiny core linux (TCL) is installed on the USB stick
+ Boot TCL
+ From TCL, copy content of the host's `/` partition on the USB stick (as a .tar.lz4)
+ Boot TCL on the destination system, format and copy content from USB stick to HDD (there is then a chroot step for fixing GRUB and hostname).

### Steps

+ On the host: Add some files to the host system (files of tinycore linux), by running the following commands **as root** (!! there are some commands to edit).
```sh
# Set BASE_DIR to the root of this git repo
BASE_DIR=THE_ROOT_OF_THIS_REPO # EDIT THIS LINE
# Create files for tinycore linux
mkdir -p /opt/tcl/boot/grub
cp $BASE_DIR/vmlinuz64 /opt/tcl/boot/
cp $BASE_DIR/corepure64.gz /opt/tcl/boot/
cp -r $BASE_DIR/tce /opt/tcl
cat > /opt/tcl/boot/grub/grub.cfg <<EOF
search --no-floppy --label --set=root "TCLROOT"
menuentry "Core" {
linux /boot/vmlinuz64 quiet waitusb=5
initrd /boot/corepure64.gz
}
EOF
# copy scripts for use in TCL
mkdir -p /opt/tcl/scripts
for i in $(ls $BASE_DIR/tcl_scripts); do cp $BASE_DIR/tcl_scripts/$i /opt/tcl/scripts/$i; done
for i in $(ls /opt/tcl/scripts); do chmod 755 /opt/tcl/scripts/$i; done

# copy script to prepare usb drive
cp $BASE_DIR/tclusb.sh /usr/local/bin/
chmod 700 /usr/local/bin/tclusb.sh
```
+ Plug the USB stick
+ On the host: run a script to install the portable system on a USB stick: execute the following command

**YOUR ENTER SUPER-DANGER ZONE**

```sh
sudo /usr/local/bin/tclusb.sh
```
+ Boot on the USB stick, connected to the host machine.
+ Run, it will copy the host system to the USB stick.
```sh
sudo /mnt/sdb1/scripts/load-install.sh
```
+ Boot the portable system on the destination machine, and run, it will install the copy of the host system to the destination machine.
```sh
sudo /mnt/sdb1/scripts/write-install.sh
```

## License

These scripts are under license Apache 2.0. See LICENSE.



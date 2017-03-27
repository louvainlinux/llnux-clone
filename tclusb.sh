#!/bin/sh
# Assume only 1 HDD (/dev/sda) and 1 USB drive (/dev/sdb1)
umount /dev/sdb*
swapoff --all
# erase MBR & partitions
dd if=/dev/zero of=/dev/sdb bs=4M count=20
# new paritions
fdisk /dev/sdb <<EOF
n
p
1

+40M
n
p
2


w
EOF
mkfs.ext4 /dev/sdb1 -L TCLROOT -F
mkfs.ext4 /dev/sdb2 -L TCLDATA -F
# copy tcl files
umount /mnt > /dev/null 2>&1 # just in case...
mount /dev/sdb1 /mnt
cp -r /opt/tcl/* /mnt
# install grub on that machine
grub-install --boot-directory=/mnt/boot --target=i386-pc /dev/sdb
umount /mnt
sync

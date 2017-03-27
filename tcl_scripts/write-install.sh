#!/bin/sh
echo "This will DESTROY all the content of your HDD (/dev/sda)!"
while true; do
    read -p "Do you whish to continue ?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
mkdir -p /mnt/usbdrive
mount -t ext4 /dev/sdb2 /mnt/usbdrive

swapoff --all
umount /dev/sda*
# erase MBR & partition table & partition headers
dd if=/dev/zero of=/dev/sda bs=4M count=10

# new partitions
fdisk /dev/sda <<EOF
n
p
1

+1G
t
82
n
p
2


w
EOF

mkswap /dev/sda1 -L SWAP
mkfs.ext4 /dev/sda2 -L ROOT -F

mkdir -p /mnt/root
mount -t ext4 /dev/sda2 /mnt/root
cd /mnt/root
lz4 -v -dc --no-sparse /mnt/usbdrive/root.tar.lz4 | tar xf -

for i in /dev /dev/pts /proc /sys /run; do sudo mount --bind $i /mnt/root$i; done
chroot /mnt/root/ /opt/tcl/scripts/chroot.sh





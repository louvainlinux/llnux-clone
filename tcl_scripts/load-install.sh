#!/bin/sh
mkdir -p /mnt/root
mount -t ext4 /dev/sda1 /mnt/root
mkdir -p /mnt/usbdrive
mount -t ext4 /dev/sdb2 /mnt/usbdrive
DEST_TAR=/mnt/usbdrive/root.tar.lz4
[ -f $DEST_TAR ] && rm -f $DEST_TAR
tar c -C /mnt/root . | lz4 -z - $DEST_TAR


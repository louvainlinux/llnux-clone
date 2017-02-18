#!/bin/sh
# install grub on that machine
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
OLD_HOSTNAME=$(cat /etc/hostname)
NEW_HOSTNAME=faccopy-$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
echo $NEW_HOSTNAME > /etc/hostname
sed -r -i -e "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts

#!/bin/bash

timedatectl set-ntp true

rm /mnt/etc/pacman.conf
cp configs/pacman.conf /mnt/etc/pacman.conf

genfstab -U /mnt >> /mnt/etc/fstab

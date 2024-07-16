#!/bin/bash

timedatectl set-ntp true

pacman-key --init
pacman-key --populate archlinux

rm /mnt/etc/pacman.conf
cp ./configs/pacman.conf /mnt/etc/pacman.conf

genfstab -U /mnt >> /mnt/etc/fstab

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cp -R "$dir" /mnt/archinstall

#!/bin/bash

timedatectl set-ntp true

pacman-key --init
pacman-key --populate archlinux

genfstab -U /mnt >> /mnt/etc/fstab

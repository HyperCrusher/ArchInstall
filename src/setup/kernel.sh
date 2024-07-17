#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No Kernel provided."
  echo "Usage: $0 <kernel>"
  exit 1
fi

kernel="$1"
lqxGpg='9AE4078033F8024D'
keyServer='hkps://keyserver.ubuntu.com'

if [ "$kernel" = "default" ]; then
  pacstrap /mnt linux linux-headers
fi

if [ "$kernel" = "zen" ]; then
  pacstrap /mnt linux-zen linux-zen-headers
fi

if [ "$kernel" = "lqx" ]; then
    pacman-key --keyserver $keyServer --recv-keys $lqxGpg
    pacman-key --lsign-key $lqxGpg
    pacmanLqx="
[liquorix]
Server = https://liquorix.net/archlinux/\$repo/\$arch"
    echo "$pacmanLqx" | sudo tee -a /mnt/etc/pacman.conf 
    pacstrap /mnt linux-lqx linux-lqx-headers
fi

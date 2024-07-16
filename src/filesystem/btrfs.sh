#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No block device provided."
  echo "Usage: $0 <blockdevice>"
  exit 1
fi

blockdevice="$1"

mount "$blockdevice" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@varlog
btrfs subvolume create /mnt/@snapshots
umount /mnt

mountOpts="noatime,compress=lzo,space_cache=v2"

mount -o "$mountOpts,subvol=@" "$blockdevice" /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o "$mountOpts,subvol=@home" "$blockdevice" /mnt/home
mount -o "$mountOpts,subvol=@varlog" "$blockdevice" /mnt/var/log
mount -o "$mountOpts,subvol=@snapshots" "$blockdevice" /mnt/.snapshots

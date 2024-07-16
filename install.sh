#! /bin/bash
pacman -Sy
yes | pacman -S git gum

if ! gum confirm "Are all drives formatted, filesystems made, and mounted?"; then
  clear
  echo "Drives must be formatted, filesystems made, and drives mounted to continue"
  exit 1
fi

filesystem=$(gum choose --header "Filesystem" "ext4" "btrfs")

if [ "$filesystem" = "btrfs" ]; then
  blockdevice=$(gum input --prompt.foreground "#0FF" --prompt "Btrfs block device:   " --placeholder "/dev/sda")
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
fi

timedatectl set-ntp true

pacman-key --init
pacman-key --populate archlinux

rm /mnt/etc/pacman.conf
cp ./configs/pacman.conf /mnt/etc/pacman.conf

kernel=$(gum choose --header "Linux Kernel" "default" "zen" "lqx")
pacstrap /mnt base linux-firmware sof-firmware base-devel refind efibootmgr neovim

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
    pacmanLqx="[liquorix]\nServer = htttps://liquorix.net/archlinux/\$repo/\$arch"
    echo "$pacmanLqx" | sudo tee -a /mnt/etc/pacman.conf 
    pacstrap /mnt linux-lqx linux-lqx-headers
fi

genfstab -U /mnt >> /mnt/etc/fstab

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cp -R "$dir" /mnt/archinstall

arch-chroot /mnt /archinstall/src/root.sh

#! /bin/bash
pacman -Sy
yes | pacman -S git gum
clear

if ! gum confirm "Are all drives formatted, filesystems made, and mounted?"; then
  clear
  echo "Drives must be formatted, filesystems made, and drives mounted to continue"
  exit 1
fi

filesystem=$(gum choose --header "Filesystem" "ext4" "btrfs")
kernel=$(gum choose --header "Linux Kernel" "default" "zen" "lqx")

if [ "$filesystem" = "btrfs" ]; then
  blockdevice=$(gum input --prompt.foreground "#0FF" --prompt "Btrfs block device:   " --placeholder "/dev/sda")
  gum spin --title "Setting up btrfs..." -- ./src/filesystem/btrfs.sh "$blockdevice"
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

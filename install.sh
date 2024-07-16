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

gum spin --title "Initial Setup..." -- ./src/setup/initial.sh

gum spin --title "Installing Linux..." -- pacstrap /mnt base linux-firmware sof-firmware base-devel refind efibootmgr neovim

gum spin --title "Installing Kernel..." -- ./src/setup/kernel.sh "$kernel"

arch-chroot /mnt /archinstall/src/root.sh

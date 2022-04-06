#!/bin/bash

# Turn ntp on
timedatectl set-ntp true

# Refresh keys, takes time remove if short on time
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# Base Install
pacstrap /mnt base linux linux-headers linux-firmware sof-firmware base-devel 

# Install microcode updates
pacstrap /mnt intel-ucode

# Install libvirt so user can inherit libvirt group
pacstrap /mnt virt-install 

# My preffered extras
pacstrap /mnt grub efibootmgr neovim networkmanager zsh 

genfstab -U /mnt >> /mnt/etc/fstab

curl -sL https://raw.githubusercontent.com/timothycates/dotfiles/main/ArchInstall/root-setup.sh -o /mnt/root-setup.sh
chmod a+x /mnt/root-setup.sh

arch-chroot /mnt /bin/bash

#!/bin/bash

# Include confirm prompt
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/scripts/utils/confirm.sh"

TIMEZONE="America/Pheonix"
LOCALE="en_US.UTF-8"
KEYMAP="us"

# Setup timezone and sync hwclock
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

source "$DIR/scripts/essentials/locale.sh"

echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf

# Setup hosts 
clear
echo "Hostname:"
read HOSTNAME

echo $HOSTNAME >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Setup Root Password
clear
echo "Root Password:"
passwd

# Setup user
clear
echo "Username:"
read USERNAME

useradd --badname -m -g users -G libvirt,wheel $USERNAME

clear
echo "Password:"
passwd $USERNAME

# Allow sudoers to access wheel
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers

# pacman
source "$DIR/scripts/essentials/pacman.sh"

# bootloader
source "$DIR/scripts/essentials/refind.sh"

# nvidia
if confirm "Using nvidia gpu?"
then
  source "$DIR/scripts/essentials/nvidia.sh"
fi

USERHOME="/home/$USERNAME/"


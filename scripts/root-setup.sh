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

source "$DIR/scripts/essentials/hosts.sh"

source "$DIR/scripts/essentials/users.sh"

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


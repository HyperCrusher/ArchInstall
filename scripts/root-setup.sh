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

# locales
source "$DIR/scripts/essentials/locale.sh"

# hosts
source "$DIR/scripts/essentials/hosts.sh"

# user setup
source "$DIR/scripts/essentials/users.sh"

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


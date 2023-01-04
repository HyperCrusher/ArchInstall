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

#reflector
source "$DIR/scripts/essentials/reflector.sh"

# network
source "$DIR/scripts/essentials/network.sh"

# shell tools 
source "$DIR/scripts/essentials/terminal.sh"

# bootloader
source "$DIR/scripts/essentials/refind.sh"

# nvidia
if confirm "Using nvidia gpu?"
then
  source "$DIR/scripts/essentials/nvidia.sh"
fi

# fonts
source "$DIR/scripts/extras/fonts.sh"

# Important drivers/software
source "$DIR/scripts/extras/audio.sh"
source "$DIR/scripts/extras/printers.sh"

# User preferences

## browsers
source "$DIR/scripts/extras/browsers.sh"

## Extra desktop things like folders torrent client ect
source "$DIR/scripts/extras/desktop.sh"

## File browsers
source "$DIR/scripts/extras/filebrowser.sh"

## Neovim plugin dependencies
source "$DIR/scripts/extras/neovim.sh"

## Social platforms
source "$DIR/scripts/extras/social.sh"

## Terminal and terminal apps I like
source "$DIR/scripts/extras/terminal.sh"

# Optional User preferences
if confirm "Do you want to install neomutt for email?"
then
  source "$DIR/scripts/extras/email.sh"
fi

if confirm "Do you want bluetooth?"
then
  source "$DIR/scripts/extras/bluetooth.sh"
fi

if confirm "Do you want to run virtual machines?"
then
  source "$DIR/scripts/extras/virtualmachines.sh"
fi

# Aur helper
source "$DIR/scripts/extras/paru.sh"


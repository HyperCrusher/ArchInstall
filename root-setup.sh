#!/bin/bash

# Include confirm prompt and config
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/scripts/utils/confirm.sh"
source "$DIR/config.sh"

# Basic Every System tasks
source "$DIR/scripts/core-setup.sh"

## bootloader
source "$DIR/scripts/essentials/refind.sh"

## nvidia
if confirm "Using nvidia gpu?"
then
  source "$DIR/scripts/essentials/nvidia.sh"
fi

## pacman
source "$DIR/scripts/essentials/pacman.sh"

## network
source "$DIR/scripts/essentials/network.sh"

## shell tools 
source "$DIR/scripts/essentials/terminal.sh"

# Install all /extras under user space passing -m if multilib was installed
FLAGS="-u $USERNAME"
if [ $MULTILIB -eq 1 ]
then
  FLAGS="${FLAGS} -m"
fi
/bin/su -c "$DIR/scripts/user-setup.sh $FLAGS" -s /bin/bash $USERNAME

# Window Manager (must be below applications)
# Requires paru to be setup 
source "$DIR/scripts/wms/xorg.sh"
source "$DIR/scripts/wms/awesome.sh"

reboot

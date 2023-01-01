#!/bin/bash

# Include confirm prompt
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/scripts/utils/confirm.sh"

REPO="https://raw.githubusercontent.com/timothycates/ArchInstall/main/"

clear
if confirm "Have you formatted and mounted your drives?"
then
 curl -SL $REPO/scripts/prechroot.sh -o prechroot.sh
 chmod +x prechroot.sh
else
  clear
  echo "This script requires drvies to be pre-formated and mounted to /mnt to continue"
  echo "If you need help follow the wiki"
  exit
fi

echo $REPO




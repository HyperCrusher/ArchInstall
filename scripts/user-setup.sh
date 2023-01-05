# All the /extra packages are sourced here

# Include our config and confirm 'dialogue'
source "$DIR/utils/confirm.sh"
source "$DIR/../config.sh"

while getopts :u:m flag
do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
        m) MULTILIB=${OPTARG};;
    esac
done

# Aur helper
source "$DIR/scripts/extras/paru.sh"

# fonts
source "$DIR/scripts/extras/fonts.sh"

# audio
source "$DIR/scripts/extras/audio.sh"

#printers
source "$DIR/scripts/extras/printers.sh"

# browsers
source "$DIR/scripts/extras/browsers.sh"

# Extra desktop things like folders torrent client ect
source "$DIR/scripts/extras/desktop.sh"

# File browsers
source "$DIR/scripts/extras/filebrowser.sh"

# Neovim plugin dependencies
source "$DIR/scripts/extras/neovim.sh"

# Social platforms
source "$DIR/scripts/extras/social.sh"

# Terminal and terminal apps I like
source "$DIR/scripts/extras/terminal.sh"

source "$DIR/scripts/extras/email.sh"

source "$DIR/scripts/extras/bluetooth.sh"

source "$DIR/scripts/extras/virtualmachines.sh"

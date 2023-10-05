# Get yay because i like it
sudo -S pacman -S --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save
cd ~
sudo rm -r yay

# Setup default rust toolchain
rustup default stable

cd ../
sudo rm -r nerd-fonts

fonts="adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-otc-fonts adobe-source-sans-fonts cantarell-fonts nerd-fonts-git noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-baekmuk ttf-bitstream-vera ttf-comic-mono-git ttf-dejavu ttf-joypixels ttf-liberation ttf-ms-fonts ttf-opensans"
passwordManager="bitwarden rbw rofi-rbw"
art="blender godot krita obs-studio"
office="ffmpegthumbnailer ffmpegthumbs foliate galculator obsidian onlyoffice-bin protonpvn thunar vlc"
games="gamemode heroic-games-launcher proton-ge-custom-bin steam"
social="discord-screenaudio"
util="coursera-dl-git diffutils downgrade jq jql mkinitcpio-colors-git mkinitcpio-numlock monolith nitch openssh p7zip-gui reflector-simple yt-dlp"

yay -S --noconfirm $fonts $passwordManager $art $office $games $social $util

# Desktop Environment

#qogir-icon-theme
git clone https://github.com/vinceliuice/Qogir-icon-theme/
cd Qogir-icon-theme
cd src/cursors
chmod +x install.sh
sudo ./install.sh
cd ~
sudo rm -r Qogir-icon-theme

themes="breeze-icons gnome-themes-extra gtk-engine-murrine papirus-icon-theme qt5ct qt6ct"
wm_utils="dunst flameshot"
wm="picom-git xdo xclip xorg-server xsettingsd xorg-xsetroot xorg-xinit xorg-xinput numlockx   xdotool awesome"

yay -S --noconfirm $themes $wm_utils $wm

# Get lemmeknow because its useful
git clone https://github.com/swanandx/lemmeknow
cd lemmeknow
cargo build --release
cd target/release
sudo mv ./lemmeknow /bin/lemmeknow
cd ~
sudo rm -r lemmeknow

# Add color 
sudo sed -i '/^HOOKS=/ s/udev/& colors/' /etc/mkinitcpio.conf
# Enable numlock
sudo sed -i '/^HOOKS=/ s/consolefont/& numlock/' /etc/mkinitcpio.conf
# Build
sudo mkinitcpio -P

# Dot file management
mkdir -p Documents/Repos
cd Documents/Repos
git clone https://github.com/timothycates/dotfiles
cd dotfiles

# use stow to create symlinks
stow -t ~/ */

chsh -s /bin/zsh
sudo rm .bash_history .bash_profile .bash_logout .bashrc .histfile
# cleanup
sudo rm ~/user.sh 

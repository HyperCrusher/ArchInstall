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

# Install nerd-fonts
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
git sparse-checkout add patched-fonts/NerdFontsSymbolsOnly
git sparse-checkout add patched-fonts/JetBrainsMono
./install.sh

cd ../
sudo rm -r nerd-fonts

fonts = "adobe-source-han-sans-otc-fonts adobe-source-sans-fonts noto-fonts noto-fonts-cjk ttf-baekmuk ttf-comic-mono-git ttf-liberation ttf-ms-fonts ttf-opensans"
passwordManager = "bitwarden rbw rofi-rbw"
art = "blender krita obs-studio"
office = "foliate mpv mpv-url mpv-sponsorblock-git obsidian onlyoffice-bin thunar zathura zathura-pdf-mupdf"
games = "gamemode"
social = "slack-desktop telegram-desktop webcord-bin"
util = "coursera-dl-git nitch ty-dlp"

yay -S --noconfirm $fonts $passwordManager $art $office $games $social $util

# Desktop Environment

#qogir-icon-theme
git clone https://github.com/vinceliuice/Qogir-icon-theme/
cd Qogir-icon-theme
cd src/cursors
chmod +x install.sh
sudo ./install.sh

themes = "breeze-icons gnome-themes-extra gtk-engine-murrine papirus-icon-theme qt5-wayland qt5ct wt6-wayland qt6ct"
wm_utils = "dunst grim-git slurp-git swaybg wl-clipboard wofi wtype"
wm = "hyprland-nvidia-git hyprland-relative-workspace-bin waybar-hyprland-git xdg-desktop-portal-hyprland-git"

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

# Dot file managment
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

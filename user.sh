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

fonts="adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-otc-fonts adobe-source-sans-fonts cantarell-fonts ttf-sourcecodepro-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-baekmuk ttf-bitstream-vera ttf-comic-mono-git ttf-dejavu ttf-joypixels ttf-liberation ttf-ms-fonts ttf-opensans"
art="blender godot krita"
office="wps-office-bin firejail ttf-wps-fonts"
games="gamemode proton-ge-custom-bin steam"
social="vesktop-bin"
util="downgrade jq jql mkinitcpio-colors-git mkinitcpio-numlock monolith openssh"

yay -S --noconfirm $fonts $art $office $games $social $util

# Desktop Environment

#qogir-icon-theme
git clone https://github.com/vinceliuice/Qogir-icon-theme/
cd Qogir-icon-theme
cd src/cursors
chmod +x install.sh
sudo ./install.sh
cd ~
sudo rm -r Qogir-icon-theme

themes="breeze-icons gnome-themes-extra gtk-engine-murrine papirus-icon-theme mpv"
wm_utils="egl-wayland"
wm="mako qt5-wayland qt6-wayland rofi-wayland hyprland xdg-desktop-portal-hyprland"

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

hyprpm update
hyprpm add https://github.com/shezdy/hyprsplit
hyprpm enable hyprsplit

chsh -s /bin/zsh

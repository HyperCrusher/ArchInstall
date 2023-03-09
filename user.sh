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

# Get lemmeknow because its useful
git clone https://github.com/swanandx/lemmeknow
cd lemmeknow
cargo build --release
cd target/release
sudo mv ./lemmeknow /bin/lemmeknow
cd ~
sudo rm -r lemmeknow


# Install nerd-fonts
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
git sparse-checkout add patched-fonts/NerdFontsSymbolsOnly
./install.sh

cd ../
sudo rm -r nerd-fonts

yay -S --noconfirm ttf-ms-fonts ttf-jetbrains-mono noto-fonts ttf-comic-mono-git

# Some nice packages
yay -S --noconfirm shellcheck fend ouch monolith 
yay -S --noconfirm pass pam-gnupg 
yay -S --noconfirm github-cli stow nitch lazygit jql flameshot
yay -S --noconfirm picom-git nitrogen
yay -S --noconfirm mkinitcpio-colors-git mkinitcpio-numlock
yay -S --noconfirm steam-native-runtime proton-ge-custom-bin protonvpn
yay -S --noconfirm discord betterdiscord-installer
yay -S --noconfirm krita mpv mpv-url mpv-sponsorblock-git mpv-thumbfast-git yt-dlp
yay -S --noconfirm spicetify-cli spotify eww

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

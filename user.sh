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
yay -S --noconfirm ly mkinitcpio-colors-git
yay -S --noconfirm steam-native-runtime proton-ge-custom-bin
yay -S --noconfirm discord betterdiscord-installer

# Add color to hooks and build
sudo sed -i 's/HOOKS=(base udev/HOOKS=(base udev colors/' /etc/mkinitcpio.conf
sudo mkinitcpio -P

sudo systemctl enable ly

# Dot file managment
mkdir -p Documents/Repos
cd Documents/Repos
git clone https://github.com/timothycates/dotfiles
cd dotfiles

# use stow to create symlinks
stow -t ~/ */

# cleanup
sudo rm ~/user.sh 

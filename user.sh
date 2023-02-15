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
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install.sh

cd ../
sudo rm -r nerd-fonts

yay -S --noconfirm ttf-ms-fonts

# Some nice packages
yay -S --noconfirm shellcheck fend ouch monolith 
yay -S --noconfirm abook neomutt isync msmtp pass pam-gnupg notmuch urlview
yay -S --noconfirm github-cli stow nitch lazygit jql
yay -S --noconfirm picom-pijulius-git
yay -S --noconfirm ly mkinitcpio-colors-git
yay -S --noconfirm steam-native-runtime
yay -S --noconfirm discord betterdiscord-installer
# Add colors to vconsole
colors=(
  "1e1e2e"
  "f38ba8"
  "a6e3a1"
  "fab387"
  "89b4fa"
  "cba6f7"
  "89dceb"
  "cdd6f4"
  "1e1e2e"
  "f38ba8"
  "a6e3a1"
  "fab387"
  "89b4fa"
  "cba6f7"
  "89dceb"
  "cdd6f4"
)

for i in {0..15}; do
 sudo echo "COLOR_$i=${colors[i]}" >> /etc/vconsole.conf
done

# Add color to hooks and build
sudo sed -i 's/HOOKS=(base udev/HOOKS=(base udev colors/' /etc/mkinitcpio.conf
sudo mkinitcpio -P

sudo systemctl enable ly

# cleanup
sudo rm ~/user.sh 

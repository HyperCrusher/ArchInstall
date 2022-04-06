# Get yay
cd ~
sudo pacman -S --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

# Update our Mirrors
yay -S --noconfirm reflector
sudo reflector --latest 50 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist
yay -Syy --noconfirm

# Install Nvidia
yay -S --noconfirm nvidia nvidia-utils nvidia-settings git

# Install Fonts
yay -S --noconfirm adobe-source-code-pro-fonts contarell-fonts ttf-ms-fonts ttf-opensans

## Korean Fonts
yay -S --noconfirm ttf-baekmuk

## Nerd Fonts
cd ~
git clone --depth 1 https://www.github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install.sh

# Install Essentials
yay -S --noconfirm alsa-utils arandr avahi bluez bluez-libs bluez-utils bridge-utils ca-certificates ca-certificates-mozilla ca-certificates-utils curl exaffmpeg fontconfig git hidapi iptables-nft iputils nfs-utils ntfs-3g openssh openssl pacman-contrib pacman-mirrorlist pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-media-session python-virtualenv xdg-user-dirs xdg-utils xorg-server xorg-xsetroot xorg-xinit

## My preferred apps
yay -S alacritty discord obs-studio github-cli ranger vivaldi vivalid-ffmpeg-codecs scrot pfetch-btw tty-clock-git

## Virtual machines
yay -S --noconfirm qemu qemu-arch-extra virt-manager

## Printers
yay -S --noconfirm hplip 

## Desktop Environment
yay -S --noconfirm bspwm cairo nitrogen paper-icon-theme picom-ibhagwan-git polybar rofi sxhkd tmux dunst

# Remove yay and nerd font folders
echo "removing build packages"
cd ~
sudo rm -r yay nerd-fonts

# Enable services
sudo systemctl enable bluetooth 
sudo systemctl enable cups.service
sudo systemctl enable sshd
sudo systemctl enable avahi-daemon
sudo systemctl enable tlp
sudo systemctl enable reflector.timer
sudo systemctl enable libvirtd

# Cleanup install script
sudo rm user-setup.sh
sudo rm /root-setup.sh

# Done
clear
echo "Done! Exit the chroot, umount -a and reboot. :)"

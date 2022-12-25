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
yay -S --noconfirm adobe-source-code-pro-fonts cantarell-fonts ttf-ms-fonts ttf-opensans

## Korean Fonts
yay -S --noconfirm ttf-baekmuk

## Nerd Fonts
cd ~
git clone --depth 1 https://www.github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install.sh

#jj


# Install Essentials
yay -S abook alsa-utils alsa-firmware alsa-plugins arandr avahi bat bluez bluez-utils bridge-utils curl downgrade exa ffmpeg ffmpegthumbnailer fontconfig git hidapi iptables-nft iputils jq man nfs-utils ntfs-3g numlockx openssh openssl pacman-contrib pacman-mirrorlist pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-media-session python-virtualenv rebuild-detector ripgrep reflector unzip xclip xdg-user-dirs xdg-utils xorg-xinput xorg-server xorg-xsetroot xorg-xinit

## My preferred apps
yay -S --noconfirm alacritty discord obs-studio github-cli ranger stow vivaldi vivaldi-ffmpeg-codecs scrot nitch lazygit lynx qbittorrent

## Virtual machines
yay -S --noconfirm qemu-full virt-manager

## Printers
yay -S --noconfirm hplip 

## Email shit
yay -S --noconfirm neomutt isync

## Desktop Environment
yay -S --noconfirm sddm awesome nitrogen picom-git tmux 

# Remove yay and nerd font folders
echo "removing build packages"
cd ~
sudo rm -r yay nerd-fonts

# Enable services
sudo systemctl enable bluetooth 
sudo systemctl enable sshd
sudo systemctl enable avahi-daemon
sudo systemctl enable reflector.timer
sudo systemctl enable libvirtd

# Cleanup install script
sudo rm user-setup.sh
sudo rm /root-setup.sh

# Done
clear
echo "Done! Exit the chroot, umount -a and reboot. :)"

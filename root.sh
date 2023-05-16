# Setup timezone and sync clock
ln -sf "/usr/share/zoneinfo/America/Phoenix" /etc/localtime
hwclock --systohc

# Setup desired locales
sed -i "/en_US.UTF-8/s/^#//g" /etc/locale.gen
sed -i "/ja_JP.UTF-8/s/^#//g" /etc/locale.gen

locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Keymap
echo "KEYMAP=us" >> /etc/vconsole.conf

# Add colors to vconsole
colors=(
  "16161e"
  "db4b4b"
  "9ece6a"
  "ff9e64"
  "7aa2f7"
  "bb9af7"
  "2ac3de"
  "c0caf5"
  "a9b1d6"
  "db4b4b"
  "9ece6a"
  "ff9e64"
  "7aa2f7"
  "bb9af7"
  "2ac3de"
  "c0caf5"
)

for i in {0..15}; do
 sudo echo "COLOR_$i=${colors[i]}" >> /etc/vconsole.conf
done

# Hosts
echo "arch" >> /etc/hostname

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   arch.localdomain arch" >> /etc/hosts

# Root Password
clear
echo "root Pass:"
passwd

# User
clear
echo "Username:"
read username
useradd --badname -m -g users -G wheel $username

clear
echo "Password:"
passwd $username

# Give wheel group sudo access
sed -i "s/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/" /etc/sudoers

# Pacman config
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i "/#Color/s/^#//" /etc/pacman.conf
sed -i "/#ParallelDownloads/s/^#//" /etc/pacman.conf
mkdir -p /etc/pacman.d/hooks
pacman -Sy

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" 

# Nvidia
read -p "Using Nvidia GPU?" usingNvidia
if [[ "$usingNvidia" == "y" || "$usingNvidia" == "yes" || "$usingNvidia" == "Y" ]]; then
  yes | pacman -S nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils
fi
# add early loading modules
sed -i 's/^MODULES=(\(.*\))/MODULES=(\1 btrfs)/' /etc/mkinitcpio.conf


if [[ "$usingNvidia" == "y" || "$usingNvidia" == "yes" || "$usingNvidia" == "Y" ]]; then
  sed -i 's/^MODULES=(\(.*\))/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  mkdir -p /etc/modprobe.d/
  touch /etc/modprobe.d/nvidia.conf
  echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia.conf
fi

mkinitcpio -P

########################################################
# Install software (through pacman)
########################################################

audio="alsa-plugins alsa-utils pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber"
console_utils="bat bottom codespell exa fd fzf git github-cli ripgrep stow unzip"
device_utils="android-file-transfer cups bluez"
filesystem="btrfs-progs nfs-utils"
network="dnsmasq iptables-nft networkmanager qbittorrent vivaldi vivaldi-ffmpeg-codecs"
programming="jdk-openjdk lazygit lua-language-server npm python-virtualenv shellcheck rustup"
system="efibootmgr kitty kitty-shell-integration polkit-kde-agent qemu-full rebuild-detector refind reflector virt-manager xdg-user-dirs xdg-utils zsh"

yes | pacman --noconfirm -S $audio $console_utils $device_utils $filesystem $network $programming $system

# Setup default rust toolchain
rustup default stable

# Enable libvirt group to access Unix docket ownership
sed -i "/#unix_sock_group/s/^#//" /etc/libvirt/libvirtd.conf
sed -i "/#unix_sock_rw_perms/s/^#//" /etc/libvirt/libvirtd.conf

mkdir -p /etc/xdg
cp $dir/configs/xdg/user-dirs.defaults /etc/xdg/user-dirs.defaults

mkdir -p /etc/xdg/reflector
rm /etc/xdg/reflector/reflector.conf
cp $dir/configs/pacman/reflector.conf /etc/xdg/reflector/reflector.conf

mkdir -p /etc/pacman.d/hooks
cp $dir/configs/pacman/*.hook /etc/pacman.d/hooks/

# Remove nvidia hook if not using
if [[ "$usingNvidia" != "y" && "$usingNvidia" != "yes" && "$usingNvidia" != "Y" ]]; then
  rm /etc/pacman.d/hooks/nvidia.hook
fi


########################################################
# Add user to groups
########################################################
usermod -aG libvirt $username
usermod -aG lp $username

########################################################
# Enable systemd services
########################################################

systemctl enable libvirtd
systemctl enable NetworkManager
systemctl enable avahi-daemon
systemctl enable sshd
systemctl enable reflector.timer

# Bootloader
clear
source "$dir/refind.sh"

# Run the user script
cp "$dir/user.sh" "/home/$username/user.sh"
echo "Switching user to $username, run './user.sh'"
read ignored

# Remove the directory
rm /archinstall -r

cd /home/$username
su $username

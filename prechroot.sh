dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#Turn on ntp
timedatectl set-ntp true

# Setup pacman keys
pacman-key --init
pacman-key --populate archlinux

read -p "Refresh keyring? (not always needed) " answer
if [[ "$answer" == "y" || "$answer" == "yes" || "$answer" == "Y" ]]; then
    pacman-key --refresh-keys
fi

#Base install
pacstrap /mnt base linux linux-headers linux-firmware sof-firmware base-devel

#Basics
pacstrap /mnt refind efibootmgr neovim

#setup fstab
genfstab -U /mnt >> /mnt/etc/fstab

#copy repo over to /mnt
cp -R "$dir" "/mnt/archinstall"

#Chroot and continue installation
arch-chroot /mnt /archinstall/root.sh

# Turn on ntp
timedatectl set-ntp true

# Setup pacman keys
pacman-key --init
pacman-key --populate archlinux

if confirm "Refresh keyring? (almost never needed)"
then
  pacman-key --refresh-keys
fi

#Base install
pacstrap /mnt base linux linux-headers linux-firmware sof-firmware base-devel

#Ucode?
if confirm "Install intel micro-code updates?"
then
  pacstrap /mnt intel-ucode
fi

#Basics
pacstrap /mnt refind efibootmgr neovim

#setup fstab
genfstab -U /mnt >> /mnt/etc/fstab

#copy repo over to /mnt
cp -R "$DIR" "/mnt/archinstall"

#Chroot and continue installation
arch-chroot /mnt /archinstall/root-setup.sh

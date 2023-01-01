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
if

#Basics
pacstrap /mnt refind efibootmgr neovim

#setup fstab
genfstab -U /mnt >> /mnt/etc/fstab

#download next script
curl -sL $REPO/scripts/root-setup.sh -o /mnt/root-setup.sh
chmod +x /mnt/root-setup.sh

clear
read -p "You will be chrooted into the new system. The script you need to run is already ready, just ./root-setup.sh to continue"


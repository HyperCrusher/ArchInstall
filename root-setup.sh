# Setup timezone and sync hwclock
ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime
hwclock --systohc

# Set Locale to us english and japanese
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
sed -i '/ja_JP.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen

# Setup keymap
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf

# Setup hostname and hosts
echo "Input a hostname:"
read hostname
echo $hostname >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts

# Setup Root Password
echo "Input a root password:"
passwd

# Setup a admin user
echo "Input an admin username:"
read adminuser
useradd -m -g users -G libvirt,wheel $adminuser
echo "Input a password for $adminuser"
passwd $adminuser

# Edit sudoers file
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers

# Enable multilib for pacman
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Syyu

# Install bootloader
echo "Input efi block device (eg. /dev/sda1)"
read efiblock

refind-install --usedefault $efiblock --alldrivers
mkrlconf

echo "Opening refind_linux.conf. Remove all archiso entries from the file (enter to continue)"
read ignored

nvim /boot/refind_linux.conf


echo "Opening refind.conf. replace options uuid with $efiblock under 'menuentry \"Arch Linux\""
read ignored

nvim /boot/EFI/BOOT/refind.conf


# Install nvidia drivers
pacman -S nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils
echo "Opening refind_linux.conf. add nvidia_drm.modeset=1 to end of entry inside the \"s (go ahead and add quiet too)"
read ignored
nvim /boot/refind_linux.conf

# Add nvidia early-loading modules to initramfs
sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' /etc/mkinitcpio.conf
mkinitcpio -P

echo "options nvidia-drm modeset=1" >> /etc/modprove.d/nvidia.conf

# Create a pacman hook to update initramfs after a nvidia upgrade
curl -sL https://raw.githubusercontent.com/timothycates/ArchInstaller/main/nvidia.hook -o /etc/pacman.d/hooks/nvidia.hook

# Enable network manager
systemctl enable NetworkManager

# Download and place the user-setup in user home
curl -sL https://raw.githubusercontent.com/timothycates/ArchInstall/main/user-setup.sh -o /home/$adminuser/user-setup.sh
chmod a+x /home/$adminuser/user-setup.sh
cd /home/$adminuser/

# Finished
echo "Base system installed"
echo "Logging into $adminuser, once logged in run ./user-setup.sh"
su $adminuser

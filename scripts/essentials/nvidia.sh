# Sets up nvidia-dkms
# We use it because Nouveau's performance is lacking
# and wayland currently requires dkms


REFIND_LINUX="/boot/refind_linux.conf"

# Do needed installations
pacman -S nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils

# Add nvidia_drm to boot 
sed -i '/"$/s/"$/ nvidia_drm.modeset=1"/' $REFIND_LINUX     

# Add nvidia early-loading modules to initramfs
sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' /etc/mkinitcpio.conf
mkinitcpio -P

# Setup modprobe
touch /etc/modprobe.d/nvidia.conf
echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia.conf

# Copy pacman hook to update initramfs after nvidia upgrade
cp ./configs/pacman/nvidia.hook /etc/pacman.d/hooks/nvidia.hook

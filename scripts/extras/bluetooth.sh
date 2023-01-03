# Install bluez
pacman -S --noconfirm bluez bluez-utils

# Enable service
systemctl enable bluetooth

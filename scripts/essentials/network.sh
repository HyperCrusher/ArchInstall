# Install network manager
pacman -S --noconfirm network-manager

pacman -S --noconfirm avahi iptables-nft openssh

# Enable network-manager service
systemctl enable NetworkManager

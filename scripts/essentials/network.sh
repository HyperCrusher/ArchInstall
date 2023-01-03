# Install network manager
pacman -S --noconfirm network-manager

# Network nice-to-haves
pacman -S --noconfirm avahi iptables-nft openssh dnsmasq

# Network attached storage
pacman -S --noconfirm nfs-utils

# Enable network-manager service
systemctl enable NetworkManager

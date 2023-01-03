# Install network manager
pacman -S --noconfirm network-manager

# Network nice-to-haves
pacman -S --noconfirm avahi iptables-nft openssh dnsmasq

# Network attached storage
pacman -S --noconfirm nfs-utils

# Enable network services
systemctl enable NetworkManager
systemctl enable avahi-daemon
systemctl enable sshd

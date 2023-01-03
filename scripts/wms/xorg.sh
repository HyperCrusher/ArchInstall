# Install xorg related packages for any wm that needs them
pacman -S --noconfirm xclip xorg-server xorg-xsetroot xorg-xinit xorg-xinput numlockx

# Screenshot utility
pacman -S --noconfirm scrot

# DisplayManager
pacman -S --noconfirm sddm

# Enable SDDM
systemctl enable sddm

# Update our Mirrors
pacman -S --noconfirm reflector
reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy --noconfirm

#start reflector service
systemctl enable reflector.timer

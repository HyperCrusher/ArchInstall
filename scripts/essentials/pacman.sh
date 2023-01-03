# Setup Pacman

# multilib
if confirm "Do you want to use multilib libraries?"
then
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
  pacman -Syyu
fi

# Color
sed -i "/#Color/s/^#//" /etc/pacman.conf

# Tools to aid in using pacman / updating system
pacman -S --noconfirm downgrade rebuild-detector

# Add rebuild hook
cp ./configs/pacman/rebuild.hook /etc/pacman.d/hooks/rebuild.hook

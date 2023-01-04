# Setup Pacman

# multilib
if confirm "Do you want to use multilib libraries?"
then
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
  pacman -Syyu --noconfirm
fi

# Color
sed -i "/#Color/s/^#//" /etc/pacman.conf

# Tools to aid in using pacman / updating system
pacman -S --noconfirm downgrade rebuild-detector

# Add rebuild hook
cp "$DIR/configs/pacman/rebuild.hook" /etc/pacman.d/hooks/rebuild.hook

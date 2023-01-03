# Setup Pacman

# multilib
if confirm "Do you want to use multilib libraries?"
then
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
  pacman -Syyu
fi

# Color
sed -i "/#Color/s/^#//" /etc/pacman.conf

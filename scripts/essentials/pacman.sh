# Setup Pacman

# Tools to aid in using pacman / updating system
pacman -S --noconfirm rebuild-detector reflector

# Make the reflector folder if it doesnt exist
mkdir -p /etc/xdg/reflector

# Copy our conf over
cp "$DIR/configs/pacman/reflector.conf" /etc/xdg/reflector/reflector.conf

# Add our country filter
echo "--country $REFLECTOR_COUNTRY" >> /etc/xdg/reflector/reflector.conf

# Update mirrorlist right now
reflector --country "$REFLECTOR_COUNTRY" --latest 100 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Enable Color
sed -i "/#Color/s/^#//" /etc/pacman.conf

# multilib
if confirm "Do you want to use multilib libraries?"
then
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
  MULTILIB=1
fi

# Useful since we changed mirrorlist and may have enabled multilib
pacman -Syyu --noconfirm

# Make a hooks folder
mkdir -p /etc/pacman.d/hooks

# Add rebuild hook
cp "$DIR/configs/pacman/rebuild.hook" /etc/pacman.d/hooks/rebuild.hook

#start reflector service
systemctl enable reflector.timer

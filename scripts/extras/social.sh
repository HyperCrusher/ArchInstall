# Install chat apps
sudo pacman -S --noconfirm discord

# Install steam
if [ ! -z "$MULTILIB" ]
then
  sudo pacman -S --noconfirm steam
fi

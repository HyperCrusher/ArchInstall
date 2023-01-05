
# Install 'base' fonts
sudo pacman -S --noconfirm adobe-source-code-pro-fonts cantarell-fonts ttf-ms-fonts ttf-opensans

# So steam doesn't look like ass
sudo pacman -S --noconfirm ttf-liberation

# Korean Font(s)
clear
if confirm "Install Korean Fonts?"
then
  sudo pacman -S --noconfirm ttf-baekmuk
fi

# Nerd fonts
git clone --depth 1 https://www.github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install.sh

# Cleanup nerd-fonts
cd ../
sudo rm -r nerd-fonts

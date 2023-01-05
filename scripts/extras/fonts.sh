
# Install 'base' fonts
pacman -S --noconfirm adobe-source-code-pro-fonts cantarell-fonts ttf-ms-fonts ttf-opensans

# Korean Font(s)
clear
if confirm "Install Korean Fonts?"
then
  pacman -S --noconfirm ttf-baekmuk
fi

# Nerd fonts
git clone --depth 1 https://www.github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install.sh

# Cleanup nerd-fonts
cd ../
sudo rm -r nerd-fonts

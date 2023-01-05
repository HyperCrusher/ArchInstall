# install cups
sudo pacman -S --noconfirm cups 

# enable cups
sudo systemctl enable cups

# add user to the lp group
sudo usermod -aG lp $USERNAME

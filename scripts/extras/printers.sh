# install cups
pacman -S --noconfirm cups 

# enable cups
systemctl enable cups

# add user to the lp group
usermod -aG lp $USERNAME

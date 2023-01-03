# install cups
pacman -S cups 

# enable cups
systemctl enable cups

# add user to the lp group
usermod -aG lp $USERNAME

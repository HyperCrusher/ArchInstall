# Setup Root Password
clear
echo "Root Password:"
passwd

# Setup user
clear
echo "Username:"
read USERNAME

useradd --badname -m -g users -G wheel,ftp,http $USERNAME

clear
echo "Password:"
passwd $USERNAME

# give wheel group memebers access to sudo 
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers


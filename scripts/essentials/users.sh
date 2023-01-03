# Setup Root Password
clear
echo "Root Password:"
passwd

# Setup user
clear
echo "Username:"
read USERNAME

useradd --badname -m -g users -G libvirt,wheel $USERNAME

clear
echo "Password:"
passwd $USERNAME

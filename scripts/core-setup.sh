# Setup timezone and sync hwclock
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

# Set Locales
for LOCALE in ${LOCALES[@]} do
  sed -i "/$LOCALE UTF-8/s/^#//g" /etc/locale.gen
done

locale-gen
echo "LANG=${LOCALES[0]}" >> /etc/locale.conf

# Setup keymap
echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf

echo $HOSTNAME >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# setup root
clear
echo "Changing root Password:"
passwd

# setup admin (add them to wheel for managment)
clear
echo "Admin Username:"
read USERNAME
useradd --badname -m -g users -G wheel $USERNAME

clear
echo "Set Password:"
passwd $USERNAME

# Give members of wheel sudo access
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers


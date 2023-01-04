# Setup paru
cd /
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# cp our config to the correct place
cp "$DIR/configs/paru/paru.conf" /etc/paru.conf

# clean up
cd /
rm -r paru


# move to user home
cd ~

read "enter root password"
read -s password
# Get yay because i like it
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save
cd ../
echo "$password" | sudo -S rm -r yay

# Get lemmeknow because its useful
git clone https://github.com/swanandx/lemmeknow
cd lemmeknow
cargo build --release
cd target/release
echo "$password" | sudo -S mv ./lemmeknow /bin/lemmeknow
cd ~
echo "$password" | sudo -S rm -r lemmeknow


# Install nerd-fonts
yay -S --noconfirm nerd-fonts-git 

yay -S --noconfirm ttf-ms-fonts

# Some nice packages
yay -S --noconfirm shellcheck fend ouch monolith 
yay -S --noconfirm abook neomutt isync msmtp pass pam-gnupg notmuch urlview
yay -S --noconfirm github-cli stow nitch lazygit jql
yay -S --noconfirm picom-pijulius-git

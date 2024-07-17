#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No Kernel provided."
  echo "Usage: $0 <kernel>"
  exit 1
fi

kernel="$1"
lqxGpg='9AE4078033F8024D'
keyServer='hkps://keyserver.ubuntu.com'

# Prevent blank inputs
ask() {
    local prompt_text="$1"
    local placeholder_text="$2"
    local is_password="$3"
    local input=""

    while [ -z "$input" ]; do
        if [ "$is_password" = true ]; then
            input=$(gum input --prompt.foreground "#0FF" --prompt "$prompt_text" --password)
        else
            input=$(gum input --prompt.foreground "#0FF" --prompt "$prompt_text" --placeholder "$placeholder_text")
        fi
    done

    echo "$input"
}

list_timezones() {
    find /usr/share/zoneinfo -type f | grep -vE 'posix/|right/' | sed 's|/usr/share/zoneinfo/||'
}
timezones=()

while IFS= read -r timezone; do
    timezones+=("$timezone")
done < <(list_timezones)

userTimezone=$(gum choose --limit 1 --header "Choose your timezone (use / to search)" "${timezones[@]}")

locales=$(awk '/^#[^ ]/ { print substr($1, 2) }' /etc/locale.gen)

IFS=$'\n' read -r -d '' -a localeArr <<<"$locales"

userLocales=$(gum choose --no-limit --header "Choose Languages" "${localeArr[@]}")
IFS=$'\n' read -r -d '' -a userLocales <<<"$userLocales"

primaryLocale=$(gum choose --limit 1 --header "Primary Language" "${userLocales[@]}")

userKeymap=$(ask "Keymap: " "us" false)
hostname=$(ask "Hostname: " "arch" false)
rootPass=$(ask "Root Password: " "" true)
username=$(ask "Username: " "Hyper" false)
userPass=$(ask "$username's Password: " "" true)


gum confirm "Using a Nvidia gpu?" && usingNvidia=1

chosenCategories=$(gum choose --no-limit --header "System Software Categories" --selected "Audio,Git,Console_Utils,Extra_Filesystems,Networking" "Audio" "Bluetooth" "Printing" "Git" "Console_Utils" "Extra_Filesystems" "Networking")
IFS=$'\n' read -r -d '' -a chosenCategories <<<"$chosenCategories"

packageList=""
for category in "${chosenCategories[@]}"; do
    file_name=$(echo "$category" | tr '[:upper:]' '[:lower:]').txt
    if [[ -f "archinstall/src/packages/$file_name" ]]; then
        packageList+=$(<"archinstall/src/packages/$file_name")
        packageList+=$' '
    fi
done

packageList+=$(<"archinstall/src/packages/system.txt")

gum spin --title "Setting up timezone..." -- ln -sf "/usr/share/zoneinfo/$userTimezone" /etc/localtime
hwclock --systohc

for locale in "${userLocales[@]}"; do
    sed -i "/$locale/s/^#//g" /etc/locale.gen
done

cat <<EOF >> /etc/locale.conf
LANG=$primaryLocale
LC_COLLATE=C
LC_CTYPE=$primaryLocale
LC_MESSAGES=$primaryLocale
LC_MONETARY=$primaryLocale
LC_NUMERIC=$primaryLocale
LC_TIME=$primaryLocale
EOF

echo "KEYMAP=$userKeymap" >> /etc/vconsole.conf

gum spin --title "Setting up languages..." -- locale-gen

# Add colors to vconsole
colors=(
  "16161e"
  "db4b4b"
  "9ece6a"
  "ff9e64"
  "7aa2f7"
  "bb9af7"
  "2ac3de"
  "c0caf5"
  "a9b1d6"
  "db4b4b"
  "9ece6a"
  "ff9e64"
  "7aa2f7"
  "bb9af7"
  "2ac3de"
  "c0caf5"
)

for i in {0..15}; do
 echo "COLOR_$i=${colors[i]}" >> /etc/vconsole.conf
done

gum spin --title "Setting host up..." -- bash -c '
    echo "$1" >> /etc/hostname
    echo "127.0.0.1 localhost" >> /etc/hosts
    echo "::1 localhost" >> /etc/hosts
    echo "127.0.1.1 $1.localdomain $1" >> /etc/hosts
' -- "$hostname"

gum spin --title "Setting Users up..." -- bash -c '
    echo -e "$1\n$1" | passwd
    useradd --badname -m -g users -G wheel "$2"
    echo -e "$3\n$3" | passwd "$2"
    sed -i "s/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/" /etc/sudoers
' -- "$rootPass" "$username" "$userPass"

mkdir -p /etc/pacman.d/hooks

if [[ $kernel = "lqx" ]]; then
    gum spin --title "Setting up lqx..." -- pacman-key --keyserver $keyServer --recv-keys $lqxGpg
    gum spin --title "Setting up lqx..." -- pacman-key --lsign-key $lqxGpg
    gum spin --title "Setting up lqx..." -- pacmanLqx="
[liquorix]
Server = https://liquorix.net/archlinux/\$repo/\$arch"
    gum spin --title "Setting up lqx..." -- echo "$pacmanLqx" | sudo tee -a /etc/pacman.conf 
fi

gum spin --title "Updating pacman db..." -- pacman -Sy

if [[ $usingNvidia ]]; then
  gum spin --title "Setting up nvidia..." -- bash -c '
    yes | pacman -S nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils
    sed -i "s/^MODULES=(\(.*\))/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf
    mkdir -p /etc/modprobe.d/
    touch /etc/modprobe.d/nvidia.conf
    echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia.conf
  '
fi

sed -i 's/^MODULES=(\(.*\))/MODULES=(\1 btrfs)/' /etc/mkinitcpio.conf

gum spin --title "Creating initramfs..." -- mkinitcpio -P

gum spin --title "Installing packages" -- yes | pacman -S $packageList
gum spin --title "Installing packages" -- rustup default stable

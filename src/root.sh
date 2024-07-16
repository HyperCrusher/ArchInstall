#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No Kernel provided."
  echo "Usage: $0 <kernel>"
  exit 1
fi

kernel="$1"
lqxGpg='9AE4078033F8024D'
keyServer='hkps://keyserver.ubuntu.com'

list_timezones() {
    find /usr/share/zoneinfo -type f | sed 's|/usr/share/zoneinfo/||'
}
timezones=()

while IFS= read -r timezone; do
    timezones+=("$timezone")
done < <(list_timezones)

Usertimezone=$(gum choose --limit 1 --header "Choose your timezone (use / to search)" "${timezones[@]}")

locales=$(awk '/^#[^ ]/ { print substr($0, 2) }' /etc/locale.gen)

IFS=$'\n' read -r -d '' -a localeArr <<<"$locales"

userLocales=$(gum choose --no-limit --header "Choose Languages" "${localeArr[@]}")
IFS=$'\n' read -r -d '' -a userLocales <<<"$userLocales"

primaryLocale=$(gum choose --limit 1 --header "Primary Language" "${userLocales[@]}")

hostname=$(gum input --prompt.foreground "#0FF" --prompt "Hostname:" --placeholder "arch")
rootPass=$(gum input --prompt.foreground "#0FF" --prompt "Root Password: " --password)
username=$(gum input --prompt.foreground "#0FF" --prompt "Username: " --placeholder "Hyper")
userPass=$(gum input --prompt.foreground "#0FF" --prompt "$username's Password: " --password)

gum confirm "Using a Nvidia gpu?" && usingNvidia=1

chosenCategories=$(gum choose --no-limit --header "System Software Categories" --selected "Audio,Git,Console_Utils,Extra_Filesystems,Networking" "Audio" "Bluetooth" "Printing""Git" "Console_Utils" "Extra_Filesystems" "Networking")
IFS=$'\n' read -r -d '' -a chosenCategories <<<"$chosenCategories"

packageList=""
for category in "${chosenCategories[@]}"; do
    file_name=$(echo "$category" | tr '[:upper:]' '[:lower:]').txt
    if [[ -f "apps/$file_name" ]]; then
        packageList+=$' '
        packageList+=$(<"../src/packages/$file_name")
    fi
done

packageList+=$' '
packageList+=$(<"../src/packages/system.txt")
echo "$packageList"

# Arch Install
My personal collection of install scripts for installing the software and configs I prefer on Arch.
This is mainly for me to use since I have an obsession with customizing my system and re-installing arch somewhat regularly. You're free to use it if you want.

## Scripts

#### Btrfs
I hate having to type in all the mount options for btrfs when making all of the subvolumes. So I have put them all into a script. It asks for a blockdevice that is formatted as btrfs. It will then create a boot, home, .snapshots, and var/log subvolumes.
The mount options I use are:
- noatime
- compress=lzo
- space_cache=v2

#### prechroot
This script takes care of setting up:
- Timedatectl
- Populating keyring
- Base linux install
- Installs refind and neovim
- Genfstab
- Chrooting into the system and running stage2

#### root
Is automatically ran by prechroot, this takes care of
- Locales, Keymaps, and Timezone
- Vconsole colors
- Hosts
- Root password
- Admin user creation
- Pacman config
- Nvidia dkms and related software
- Mkinitcpio configuration
- Bootloader config
- Installation and setup of system-critical software
- Su's into the admin user and navigates to their hom directory

#### user
This is for things I consider "user-space" problems
- Install an aur helper (yay)
- Install fonts
- Install all other software
- Downloads my dotfiles
- Symlinks my dotfiles for me

## Long term goals
Eventually I'd like to take the time to turn this into my personal arch-install thats more than just a collection of scripts. I'd like it to walk the user through the installation from formatting drives,to installing and selecting software. Mainly as a pet-project and for more practice working with bash or maybe to learn another language.

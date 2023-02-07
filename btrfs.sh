# My preffered btrfs layout
read -p "What is the block device for the btrfs system? " blockDevice

mount "$blockDevice" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@varlog
umount /mnt

mount -o noatime,compress=lzo,space_cache=v2,subvol=@ "$blockDevice" /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home "$blockDevice" /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots "$blockDevice" /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@varlog "$blockDevice" /mnt/var/log

#Setup refind
#Does not delete example stanzas
#Refind Files
REFIND_LINUX="/boot/refind_linux.conf"

#Get the efiBlock
echo "Input efi block device (eg. /dev/sda1)"
read EFI_BLOCK

#run refind install commands
refind-install --usedefault $EFI_BLOCK --alldrivers
mkrlconf

#Remove archiso entries
sed -i /archiso/d $REFIND_LINUX   

# Add quiet flag
sed -i '/"$/s/"$/ quiet"/' $REFIND_LINUX     

# Add rw flag
sed -i '/"$/s/"$/ rw"/' $REFIND_LINUX 

# Set default subvol
sed -i '/"$/s/"$/ rootflags=subvol=@"/' $REFIND_LINUX     

# Trim File
sed -i -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' $REFIND_LINUX

# Replace refind config
rm /boot/EFI/BOOT/refind.conf
cp "$dir/configs/refind/refind.conf" /boot/EFI/BOOT/refind.conf

# Replace the UUID with the correct one
uuid=$(grep -Po '(?<=UUID=)[^ ]*' $REFIND_LINUX)
sed -i "s/UUID=uuid/UUID=$uuid/g" /boot/EFI/BOOT/refind.conf

# Theme setup
echo "scanfor external,manual" >> boot/EFI/BOOT/refind.conf
echo "include themes/rEFInd-minimal-themes/rEFInd-minimal-nord/theme.conf" >> /boot/EFI/BOOT/refind.conf

mkdir -p /boot/EFI/BOOT/themes
git clone https://github.com/quantrancse/rEFInd-minimal-themes /boot/EFI/BOOT/themes/rEFInd-minimal-themes

# Remove opinionated parts of config
sed -i '/# Custom menu entires/,$d' /boot/EFI/BOOT/themes/rEFInd-minimal-themes/rEFInd-minimal-nord/theme.conf
sed -i '/showtools.*/d' /boot/EFI/BOOT/themes/rEFInd-minimal-themes/rEFInd-minimal-nord/theme.conf


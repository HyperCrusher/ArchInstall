# Install required packages
pacman -S --noconfirm qemu-full virt-manager 

# Enable libvirt group to access Unix docket ownership
sed -i "/#unix_sock_group/s/^#//" /etc/libvirt/libvirtd.conf
sed -i "/#unix_sock_rw_perms/s/^#//" /etc/libvirt/libvirtd.conf

usermod -aG libvirt $USERNAME

# Enable libvirt service
systemctl libvirtd

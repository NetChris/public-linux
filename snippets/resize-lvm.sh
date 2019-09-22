# Resize LVM "home" on VG "protectli-20190819-vg" to 10GB
sudo lvresize -L 10G /dev/protectli-20190819-vg/home

# Resize the filesystem (requires ext4)
sudo resize2fs /dev/mapper/protectli--20190819--vg-home

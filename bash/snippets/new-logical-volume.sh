# Create a new 100 GB volume for widget
sudo lvcreate -L 100G -n widget01 vg01
sudo mkfs -t ext4 /dev/vg01/widget01

# This usually then entails creating a permanent mount point
# Get the UUID using:
sudo lvdisplay vg01/widget01

# Example output:
# chris@nuc-20190313:~$ lsblk -o +UUID
# NAME               MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT                   UUID
# sda                  8:0    0 931.5G  0 disk
# sdb                  8:16   0 931.5G  0 disk
# ├─sdb1               8:17   0   512M  0 part /boot/efi                    1095-169D
# ├─sdb2               8:18   0     1G  0 part /boot                        61f98a43-3b68-48fd-bfb2-4a8462ea4188
# └─sdb3               8:19   0   930G  0 part                              JRJmac-rzTi-RwxZ-BOHh-Y9ML-8d9J-3MoPWB
#   ├─vg01-lv01      253:0    0    10G  0 lvm  /                            31475a3e-a8fc-4811-addc-0aa0bdb312f8
#   ├─vg01-widget01  253:1    0   100G  0 lvm                               3604e654-f872-4dba-9f1e-70bd7c5d972d
#   └─vg01-consul01  253:4    0    10G  0 lvm                               4a51a170-61ea-4431-b340-92b4ef188392
#
# Then add a line like so to /etc/fstab
# UUID=3604e654-f872-4dba-9f1e-70bd7c5d972d /netchris/fsmounts/widget01 ext4 defaults 0 0

# Create, then set minimial permissions on the mount point
sudo mkdir -p /netchris/fsmounts/widget01 && sudo chmod 0000 /netchris/fsmounts/widget01

# Then mount
sudo mount /netchris/fsmounts/widget01
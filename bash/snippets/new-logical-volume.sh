# Create a new 100 GB volume for widget
sudo lvcreate -L 100G -n widget01 vg01
sudo mkfs -t ext4 /dev/vg01/widget01

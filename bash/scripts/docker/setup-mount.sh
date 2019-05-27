#!/bin/bash
# Creates the /netchris/fsmounts/docker01 mount
# An existing volume group is assumed.  root required.
# Usage:
# SCRIPT.sh volume_group_name size_in_123G_format
# Example (creates /netchris/fsmounts/docker01 on vg02 with a size of 200 GB):
# sudo SCRIPT.sh vg02 200G
#
# To run from curl:
# curl -sSL 'https://gitlab.com/NetChris/public/linux/raw/master/bash/scripts/docker/setup-mount.sh' | sudo bash

die () {
    echo >&2 "$@"
    exit 1
}

[ "$EUID" -eq 0 ] || die "Please run as root"

[ "$#" -eq 2 ] || die "2 arguments required, $# provided"

DATE_STAMP=$(date '+%Y%m%d%H%M%S')
BACKUP_EXTENSION="orig.$DATE_STAMP"
VG=$1
VG_SIZE=$2
echo Submitted "$VG" for volume group name
echo Submitted "$VG_SIZE" for size

# Skip first line of vgs output, get first column, and succeed only if the whole word $VG is found
if vgs | awk 'FNR > 1 {print $1}' | grep -qw "$VG"; then
  echo Volume group "$VG" FOUND!
else
  echo Volume group "$VG" not found
  exit 1
fi

echo Creating LV ...
lvcreate -L $VG_SIZE -n docker01 $VG

echo Creating file system ...
mkfs -t ext4 /dev/$VG/docker01

MOUNT_POINT=/netchris/fsmounts/docker01

echo Creating mount point /netchris/fsmounts/docker01
mkdir -p $MOUNT_POINT && sudo chmod 0000 $MOUNT_POINT

echo Getting UUID of LV ...
UUID=$(blkid -o value -s UUID /dev/mapper/$VG-docker01)

echo Found UUID: $UUID

ETC_FSTAB_BACKUP="/etc/fstab.before-docker01.$BACKUP_EXTENSION"
echo Backing up /etc/fstab to "$ETC_FSTAB_BACKUP"
cp /etc/fstab $ETC_FSTAB_BACKUP

echo Removing "$MOUNT_POINT" mount point from /etc/fstab if it exists ...
MOUNT_POINT_ESCAPED=${MOUNT_POINT//\//\\/}
sed -i "/$MOUNT_POINT_ESCAPED/d" /etc/fstab

echo Adding new partition to /etc/fstab
echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 0" >> /etc/fstab

echo Mounting "$MOUNT_POINT" ...
mount $MOUNT_POINT

echo docker01 LV of size $VG_SIZE created and mounted.
echo It is recommended to compare the before and after content of /etc/fstab:
echo "  diff $ETC_FSTAB_BACKUP /etc/fstab"

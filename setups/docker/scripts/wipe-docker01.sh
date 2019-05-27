#!/bin/bash
# DANGER!
# Wipes the /netchris/fsmounts/docker01 mount from the system
# Assumptions:
# - Run as root
# - Existence of "/netchris/fsmounts/docker01"
#
# To run from curl:
# curl -sSL 'https://gitlab.com/NetChris/public/linux/raw/master/setups/docker/scripts/wipe-docker01.sh' | sudo bash

die () {
    echo >&2 "$@"
    exit 1
}

[ "$EUID" -eq 0 ] || die "Please run as root"

MOUNT_POINT=/netchris/fsmounts/docker01

[ ! -f $MOUNT_POINT ] || die "$MOUNT_POINT does not exist in the filesystem"

echo Getting LV path for mount point "$MOUNT_POINT" ...
LV_PATH=`df | grep "$MOUNT_POINT" | awk '{print $1}'`

[ ! -z ${ LV_PATH + x } ] || die "Could not find LV path for mount point $MOUNT_POINT"

if mount | grep $MOUNT_POINT > /dev/null; then
  echo Unmounting $MOUNT_POINT
  umount $MOUNT_POINT
fi

DATE_STAMP=$(date '+%Y%m%d%H%M%S')
BACKUP_EXTENSION="orig.$DATE_STAMP"

ETC_FSTAB_BACKUP="/etc/fstab.before-wipe-docker01.$BACKUP_EXTENSION"
echo Backing up /etc/fstab to "$ETC_FSTAB_BACKUP"
cp /etc/fstab $ETC_FSTAB_BACKUP

echo Removing "$MOUNT_POINT" mount point from /etc/fstab if it exists ...
MOUNT_POINT_ESCAPED=${MOUNT_POINT//\//\\/}
sed -i "/$MOUNT_POINT_ESCAPED/d" /etc/fstab

echo Found LV path: "$LV_PATH"

lvremove $LV_PATH -y

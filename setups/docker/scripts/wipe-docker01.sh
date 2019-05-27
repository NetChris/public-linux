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

[ ! -f $MOUNT_POINT ] || die "$MOUNT_POINT does not exist"

if mount | grep $MOUNT_POINT > /dev/null; then
    echo "yay"
else
    echo "nay"
fi

exit 

echo Unmounting $MOUNT_POINT
mount $MOUNT_POINT

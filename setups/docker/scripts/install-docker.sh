#!/bin/bash
# Performs the main Docker installation phase.
# Assumptions:
# - Run as root
# - Existence of "/netchris/fsmounts/docker01"
#
# To run from curl:
# curl -sSL 'https://gitlab.com/NetChris/public/linux/raw/master/setups/docker/scripts/install-docker.sh' | sudo bash

die () {
    echo >&2 "$@"
    exit 1
}

[ "$EUID" -eq 0 ] || die "Please run as root"

MOUNT_POINT=/netchris/fsmounts/docker01

[ ! -f $MOUNT_POINT ] || die "\"$MOUNT_POINT\" does not exist in the filesystem"

exit

# Install Docker
# Distilled from https://docs.docker.com/install/linux/docker-ce/ubuntu/
echo Uninstall old versions
apt-get remove docker docker-engine docker.io containerd runc -y

echo Updating APT ...
apt-get update -y

echo Installing required support tools ...
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y

echo Adding Docker official GPG key ...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo Setting up Docker APT repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo Updating APT ...
apt-get update -y

echo Installing Docker components ...
apt-get install docker-ce docker-ce-cli containerd.io -y

echo Shutting down Docker to configure ...
service docker stop

vi /etc/docker/daemon.json

# Modify to general config - https://gitlab.com/NetChris/docker/reference/wikis/configuration/daemon-json
# Remove /var/lib/docker
rm -rf /var/lib/docker
# Restart Docker
sudo service docker start
# Verify that new docker data root is being used
sudo ls -lac /netchris/fsmounts/docker01/docker
# Add chris to docker group
sudo usermod -a -G docker chris

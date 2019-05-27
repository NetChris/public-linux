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

[ -d $MOUNT_POINT ] || die "\"$MOUNT_POINT\" does not exist in the filesystem.  This is required before we install Docker."

echo Installing Docker ...

# Install Docker
# Distilled from https://docs.docker.com/install/linux/docker-ce/ubuntu/
echo Uninstall old versions
apt-get remove docker docker-engine docker.io containerd runc -y

echo Updating APT ...
apt-get update -y

echo Installing required support tools ...
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y

echo Adding Docker official GPG key ...
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | sudo apt-key add -

echo Setting up Docker APT repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo Updating APT ...
apt-get update -y

echo Installing Docker components ...
apt-get install docker-ce docker-ce-cli containerd.io -y

echo Shutting down Docker to configure ...
service docker stop

echo Removing default Docker data directory "/var/lib/docker"
rm -rf /var/lib/docker

echo Pulling NetChris baseline Docker daemon configuration to /etc/docker/daemon.json
curl -sSL 'https://gitlab.com/NetChris/public/linux/raw/master/setups/docker/etc/docker/daemon.json' \
  -o /etc/docker/daemon.json

echo Making cert directories ...
mkdir -p -m 755 /netchris/fsmounts/docker01/certs
mkdir -p -m 750 /netchris/fsmounts/docker01/certs/keys

echo Pulling down certificates ...
curl -sSL 'https://gitlab.com/NetChris/public/key-certificates/raw/master/docker/ca-cert-15909179367545147508.pem' \
  -o /netchris/fsmounts/docker01/certs/ca-cert.pem
curl -sSL 'https://gitlab.com/NetChris/public/key-certificates/raw/master/docker/wildcard.loc.network/server-cert.pem' \
  -o /netchris/fsmounts/docker01/certs/server-cert.pem

echo Updating Docker service registration override ("/etc/systemd/system/docker.service.d/override.conf") ...
curl -sSL 'https://gitlab.com/NetChris/public/linux/raw/master/setups/docker/etc/systemd/system/docker.service.d/override.conf' \
  -o /etc/systemd/system/docker.service.d/override.conf

echo Adding chris to docker group
sudo usermod -a -G docker chris

# TODO - Verify mounted path?

echo You will need to finish the rest:
echo "  1. Pull down Docker wildcard.loc.network server key to \"/netchris/fsmounts/docker01/certs/keys/server-key.pem\""
echo "  2. Start Docker - sudo service docker start"
echo "  3. Verify that Docker data directory is filled in: \"sudo ls -lac /netchris/fsmounts/docker01/docker\""
echo "  4. Verify remote Docker connectivity.  From a remote machine:"
echo "    docker --tlsverify --tlscacert=/path/to/ca-cert.pem --tlscert=/path/to/client-cert.pem \\"
echo "      --tlskey=/path/to/client-key.pem -H=\"THIS_MACHINE.servers.dhcp.loc.network:2376\" info"

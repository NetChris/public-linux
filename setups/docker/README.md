# Docker setup

- `scripts/install-docker.sh` - Installs Docker as prescribed for NetChris
  - Assumes the presence of a `/netchris/fsmounts/docker01` mount
  - Run `/bash/scripts/setup-lv-fsmount.sh` first if it doesn't
- `etc/docker/daemon.json`
  - Typical Docker daemon configuration to go into `/etc/docker/daemon.json`

#!/bin/bash
# Places the keys for a given GitLab username in ~/.ssh/authorized_keys
# Execute this with:
# curl -sSL https://gitlab.com/NetChris/public/linux/raw/master/bash/scripts/get-gitlab-keys.sh | bash -s

if [ -z "$GITLAB_USERNAME" ]
then
      echo "GITLAB_USERNAME envar must be defined"
      exit -1
else
  echo Pulling the contents of https://gitlab.com/$GITLAB_USERNAME.keys to ~/.ssh/authorized_keys
fi

mkdir -p ~/.ssh
chmod 700 ~/.ssh

if ! [[ -f ~/.ssh/authorized_keys ]]; then
  echo "Creating new ~/.ssh/authorized_keys"
  touch ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/authorized_keys
fi

curl https://gitlab.com/$GITLAB_USERNAME.keys -w "\n" >> ~/.ssh/authorized_keys

#!/bin/bash
# Places the keys for a given GitLab username
# in ~/.ssh/authorized_keys

if [ -z "$GITLAB_USERNAME" ]
then
      echo "\$GITLAB_USERNAME must be defined"
      exit -1
else
  echo Pulling the contents of https://gitlab.com/$GITLAB_USERNAME.keys to ~/.ssh/authorized_keys
fi

exit 0

mkdir -p ~/.ssh

if ! [[ -f ~/.ssh/authorized_keys ]]; then
  echo "Creating new ~/.ssh/authorized_keys"
  touch ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/authorized_keys
fi

curl https://gitlab.com/$GITLAB_USERNAME.keys -w "\n" >> ~/.ssh/authorized_keys

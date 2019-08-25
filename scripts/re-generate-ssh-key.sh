#!/bin/bash
# Re-generate the SSH key
#   curl -sSL https://gitlab.com/cssl/NetChris/public/linux/raw/master/scripts/re-generate-ssh-key.sh | bash -s

SSH_KEY_TITLE="$USER@$HOSTNAME (`date +%s`)"
rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
ssh-keygen -t rsa -P "" -C "$SSH_KEY_TITLE" -f ~/.ssh/id_rsa

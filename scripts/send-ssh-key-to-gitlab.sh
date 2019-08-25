#!/bin/bash
# Send SSH public key to GitLab.
# Assumptions:
# - SSH key has been generated (use generate-ssh-key.sh to (re-)generate the SSH key)
# - Envar GITLAB_PAT is defined and contains a valid GitLab personal access token with API scope.
#   - Go to https://gitlab.com/profile/personal_access_tokens to create one.
#
#  curl -sSL GET https://gitlab.com/cssl/NetChris/public/linux/raw/master/scripts/send-ssh-key-to-gitlab.sh | bash

if [[ -z "$GITLAB_PAT" ]]; then
    echo "Must provide GITLAB_PAT (GitLab personal access token) in environment" 1>&2
    echo "Go to https://gitlab.com/profile/personal_access_tokens to create one" 1>&2
    exit 1
fi

if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
    echo "You must generate an RSA key first. (i.e. the file ~/.ssh/id_rsa.pub must exist.)" 1>&2
    echo "See re-generate-ssh-key.sh in the same folder as this script. Or simply:" 1>&2
    echo "  curl -sSL https://gitlab.com/cssl/NetChris/public/linux/raw/master/scripts/re-generate-ssh-key.sh | bash" 1>&2
    exit 1
fi

SSH_KEY_TITLE="$USER@$HOSTNAME (`date +%s`)"
SSH_KEY=`cat ~/.ssh/id_rsa.pub`
JSON=`jq -c -n --arg title "$SSH_KEY_TITLE" --arg key "$SSH_KEY" '{title: $title, key: $key}'`

echo "Uploading to GitLab:"

echo $JSON | curl \
  -X POST \
  -i \
  -H "Content-Type: application/json" \
  -H "PRIVATE-TOKEN: ${GITLAB_PAT}" \
  -d @- \
  https://gitlab.com/api/v4/user/keys

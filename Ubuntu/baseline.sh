#!/bin/bash
# Baseline Ubuntu script, post install
# This script should be run after EVERY Ubuntu install
# Before running this script, update and get the following packages:
#  sudo apt update
#  sudo apt upgrade
#  sudo apt install jq
# TEMP
# curl -X GET https://gitlab.com/cssl/NetChris/public/linux/raw/UbuntuBaseline/Ubuntu/baseline.sh | sudo bash -E

if [[ -z "$GITLAB_PAT" ]]; then
    echo "Must provide GITLAB_PAT (GitLab personal access token) in environment" 1>&2
    exit 1
fi

# TODO - ensure no swap

# We want curl to output endline after running
echo '-w "\n"' >> ~/.curlrc

# Generate an SSH key and send to GitLab
SSH_KEY_TITLE="$USER@$HOSTNAME (`date +%s`)"
rm -f ~/.ssh/id_rsa
ssh-keygen -t rsa -P "" -C "$SSH_KEY_TITLE" -f ~/.ssh/id_rsa
SSH_KEY=`cat ~/.ssh/id_rsa.pub`
JSON=`jq -c -n --arg title "$SSH_KEY_TITLE" --arg key "$SSH_KEY" '{title: $title, key: $key}'`
echo $JSON | curl \
  -X POST \
  -H "Content-Type: application/json" \
  -H "PRIVATE-TOKEN: ${GITLAB_PAT}" \
  -d @- \
  https://gitlab.com/api/v4/user/keys

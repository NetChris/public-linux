#!/bin/bash
# Baseline Ubuntu script, post install
# This script should be run after EVERY Ubuntu install
# Before running this script, update and get the following packages:
#  sudo apt update
#  sudo apt upgrade
#  sudo apt install jq
# TEMP:
#   curl -X GET https://gitlab.com/cssl/NetChris/public/linux/raw/UbuntuBaseline/Ubuntu/baseline.sh | bash

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

echo "Uploading to GitLab:"

echo $JSON | curl \
  -X POST \
  -i \
  -H "Content-Type: application/json" \
  -H "PRIVATE-TOKEN: ${GITLAB_PAT}" \
  -d @- \
  https://gitlab.com/api/v4/user/keys

# git stuff (for Chris)
git config --global user.email "chris.dev@netchris.com"
git config --global user.name "Chris Simmons"
git config --global core.editor "vi"

# Pull down the Standards repo
git clone git@gitlab.com:cssl/NetChris/Standards/linux.git \
  ~/src/cssl/NetChris/Standards/linux

# This provides the real baseline setup for an Ubuntu system
cat ~/src/cssl/NetChris/Standards/linux/linux/Ubuntu/standard-setup.sh

# TODO - Make this a script
# # Split up ~/.bashrc into ~/.bashrc.d/
# mkdir ~/.bashrc.d
# chmod 700 ~/.bashrc.d
# mv ~/.bashrc ~/.bashrc.d/

# cat <<EOT >> ~/.bashrc
# for file in ~/.bashrc.d/*.bashrc;
# do
# source "$file"
# done
# EOT
# chmod --reference=".bashrc.d/.bashrc" ~/.bashrc

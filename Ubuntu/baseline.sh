#!/bin/bash
# Baseline Ubuntu script, post install
# This script should be run after EVERY Ubuntu install
# Before running this script, update and get the following packages:
#  sudo apt update
#  sudo apt upgrade
#  sudo apt install jq
# TEMP:
#   curl -X GET https://gitlab.com/cssl/NetChris/public/linux/raw/master/Ubuntu/baseline.sh | bash

if [[ -z "$GITLAB_PAT" ]]; then
    echo "Must provide GITLAB_PAT (GitLab personal access token) in environment" 1>&2
    exit 1
fi

# TODO - ensure no swap

# Pull down the Standards repo
git clone git@gitlab.com:cssl/NetChris/Standards/linux.git \
   ~/src/standard-scripts

# This provides the real baseline setup for an Ubuntu system
cat ~/src/standard-scripts/linux/Ubuntu/standard-setup.sh

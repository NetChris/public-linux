#!/bin/bash
# Allows the current user to sudo without a password
# Execute this with:
# curl -sSL https://gitlab.com/NetChris/public/linux/raw/master/bash/scripts/allow-user-sudoers-nopassword.sh | bash -s

# Configure to allow $USER to sudo without password
export SUDOERS_NO_PASSWORD=/etc/sudoers.d/050_$USER-nopasswd
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee $SUDOERS_NO_PASSWORD
sudo chmod 0440 $SUDOERS_NO_PASSWORD

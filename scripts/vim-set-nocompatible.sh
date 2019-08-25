#!/bin/bash
# Sets vim to "nocompatible" for the current user
# This is necessary for those systems (like RPi) which keep vi compatibility, especially with a "vim.tiny" installation.
# Run this normally.
# If you are a sudoer, run it as sudo as well to ensure root gets the setting.
#
# TODO - Use the new Linux configuration repo for this.  Scripting is dumb!
# TODO - switch to master once released:
#   curl -sSL https://gitlab.com/cssl/NetChris/public/linux/raw/UbuntuBaseline/bash/scripts/vim-set-nocompatible.sh | bash -s
#   curl -sSL https://gitlab.com/cssl/NetChris/public/linux/raw/UbuntuBaseline/bash/scripts/vim-set-nocompatible.sh | sudo -E bash -s
#   

VIM_CONFIG=.vimrc
USER_HOME=`getent passwd $USER | cut -d: -f6`
VIMRC=$USER_HOME/$VIM_CONFIG

echo "Placing \"set nocompatible\" in $VIM_CONFIG for user \"$USER\" ($VIMRC)"

touch $VIMRC

# Remove any "set compatible" or "set nocompatible" lines 
sed -i -r "/set[[:space:]]+(no)?compatible/d" $VIMRC

# Add a single "set nocompatible" to the end of the configuration file
echo "set nocompatible" >> $VIMRC
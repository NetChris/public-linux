# Configure to allow $USER to sudo without password
export SUDOERS_NO_PASSWORD=/etc/sudoers.d/050_$USER-nopasswd
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee $SUDOERS_NO_PASSWORD
sudo chmod 0440 $SUDOERS_NO_PASSWORD

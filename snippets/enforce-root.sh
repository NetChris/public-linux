# This will exit if the user is not currently root (UID 0)
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

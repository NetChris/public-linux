# This gives the chmod octal permissions for a file
#  $ ls -lac /etc/fstab
#  -rw-r--r-- 1 root root 503 Apr  7 21:59 /etc/fstab
#  $ stat -c %a /etc/fstab
#  644

stat -c %a /the/path

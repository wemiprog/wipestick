#!/bin/bash
# This script resets the repo to prepare for rebuild

git clean -df
git reset --hard HEAD
git pull
git reset --hard HEAD
chmod +x start.sh

cat << SCRIPT >> ../renewPermissions
#!/bin/bash
chmod +x wipestick/reset.sh
SCRIPT

chmod +x ../renewPermissions
pacman -S at --noconfirm >> /dev/null
at -f ../renewPermissions -t now +1 second

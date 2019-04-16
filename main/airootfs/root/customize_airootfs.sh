#!/bin/bash

set -e -u

sed -i 's/#\(de_CH\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

# Create service file
# - Autostarts the script wipe-sda
# - Enables in- and output on tty2
cat << EOF >> /etc/systemd/system/wipe-sda.service
[Unit]
Description=Wipe /dev/sda after user clicked OK
After=getty@tty2.service

[Service]
Type=oneshot
ExecStart=/usr/bin/wipe-sda
StandardInput=tty
TTYPath=/dev/tty2
TTYReset=yes
TTYVHangup=yes

[Install]
WantedBy=default.target
EOF

# Create wipe-script itself
cat << EOF >> /usr/bin/wipe-sda
#!/bin/bash
echo "Start script in 2s"           # Ensures booted up system
sleep 2
# Read system Info and prepare messages
mac="\$(cat /sys/class/net/*/address)" # Find all MACs
uuid="\$(dmidecode | grep UUID)"     # Read UUID
chvt 2                              # Change userview to tty2
reboot --help
time
dialog --msgbox "Click OK to wipe the internal SSD \n(/dev/sda/)" 20 60
hdparm -I /dev/sda                  # Execute wipetool once before suspending
rtcwake -m mem -s 1                 # Suspend with auto wakeup after one second
sleep 1                             # Wait a second after suspend wakeup
# Set user password (necessary by specification)
hdparm --user-master u --security-set-pass wipe /dev/sda
# Execute wipe itself
time hdparm --user-master u --security-erase wipe /dev/sda
# Inform user
dialog --title "Wipe successful" --msgbox " Device wipe is successful! \n\n Please take a screenshot and send it to your system administrator \n\n MAC:  \$mac \n\$uuid \n\n\n Now click OK to reboot your device" 30 90
reboot
EOF

# Give execution permission and enable as startup service
chmod 777 /usr/bin/wipe-sda
systemctl enable wipe-sda.service

# Wipestick
A simple archbased liveboot stick which wipes /dev/sda SSDs

## HOW TO
### Prepare system
First, you need an installed Arch Linux. If you haven't already, read [Install Script](PREPARE.md) to install\
Now, install archiso package from official repo:
```bash
pacman -S archiso
```

Important: Work as root!

### Create ISO
Now go to your home and clone this repo:
```sh
cd
git clone https://github.com/wemiprog/wipestick
cd wipestick
```

To create the iso, execute start.sh. But because permissions are needed, I recommend following:
```sh
chmod +x reset.sh
./reset.sh
./start.sh
```

The reset script ensures, that you are using the latest version of the repo and cleans all other files you've added to this folder.

If your internet connection is working, you should have a .iso file in this folder within 5-10 minutes.

#### Problem
If the script breaks and tells "cp *.iso" failed, try  executing the following commands 3-5 times:
```sh
./reset.sh
./start.sh
```

### Flash ISO
You should still be in the folder "wipestick".
Now put the following command:
```sh
lsblk       # Find out which /dev/... your USB device is and use it for of= in the command below
dd bs=4M if=wipestick-2019.04.03-x86_64.iso of=/dev/sdb oflag=sync status=progress
```
For the if= parameter, use tab to complete your current date ;)

### Wipe
The wipe process should be self-explaining. But important.
The stick is secure boot capable. But the first time booting you need to use the hashtool.
It will start automatically, then you have to select "Enroll hash".
Now select "vmlinuz.efi", and confirm. Then do it again with "loader.efi".
Now exit the tool and it should boot. Else reboot and try again.

## Customize
If you need to wipe another disk than /dev/sda, look at main/airootfs/root/customize_airootfs.sh

## Sources
The files in this repo in the subfolder are described in Source.md

Other sources are here:
Secure Erase
https://www.thomas-krenn.com/de/wiki/SSD_Secure_Erase

Systemd Service interaktiv
https://alan-mushi.github.io/2014/10/26/execute-an-interactive-script-at-boot-with-systemd.html
https://arashmilani.com/post?id=86

Arch UEFI Install
https://www.tecmint.com/arch-linux-installation-and-configuration-guide/

Bash Dialog
https://wiki.ubuntuusers.de/Howto/Dialog-Optionen/
https://linuxgazette.net/101/sunil.html

Secure Boot
https://bentley.link/secureboot/

Log Disable
https://bbs.archlinux.org/viewtopic.php?id=184678

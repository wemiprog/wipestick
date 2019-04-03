# Wipestick
A simple archbased liveboot stick which wipes /dev/sda SSDs

## Prepare system
First, you need an installed arch. If you haven't already, read [Install Script](PREPARE.md) to install
Now, install archiso package from official repo:
```bash
pacman -S archiso
```

Important: Work as root!

## Create ISO

## Flash ISO
You should still be in the folder "wipestick".
Now put the following command:
```bash
lsblk       # Find out which /dev/... your USB device is and use it for of=
dd bs=4M if=wipestick-2019.04.03-x86_64.iso of=/dev/sdb oflag=sync status=progress
```
For the if= parameter, use tab to complete your current date ;)
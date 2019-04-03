# Wipestick
A simple archbased liveboot stick which wipes /dev/sda SSDs

## Prepare system
First, you need an installed arch. If you haven't already, read PREPARE.md
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
dd bs=4M if=wipestick- .iso of=/dev/sdb oflag=sync status=progress
```

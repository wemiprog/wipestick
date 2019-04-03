# Wipestick
A simple archbased liveboot stick which wipes /dev/sda SSDs

## HOW TO
### Prepare system
First, you need an installed arch. If you haven't already, read [Install Script](PREPARE.md) to install\
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

### Flash ISO
You should still be in the folder "wipestick".
Now put the following command:
```sh
lsblk       # Find out which /dev/... your USB device is and use it for of= in the command below
dd bs=4M if=wipestick-2019.04.03-x86_64.iso of=/dev/sdb oflag=sync status=progress
```
For the if= parameter, use tab to complete your current date ;)

## Customize
If you need to wipe another disk than /dev/sda, look at main/airootfs/root/customize_airootfs.sh

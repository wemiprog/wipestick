# Install Archlinux

## Prepare
Download an arch ISO:\
[archlinux.de](https://www.archlinux.de/download)

Download and install Etcher:\
[balena.io/etcher](https://www.balena.io/etcher/)

Flash the ISO to an USB disk and boot PC from it.\
You have to **disable secureboot** for installing arch!
But leave UEFI enabled!

## Install system
### Attach network and load your keys
Plugin a network cable, ex. USB-tethering and start the dhcp client.\
When connection works, load your keys.
```sh
dhcpcd                  # Service is disabled by default
ping google.com         # Test connection until it works ;)
loadkeys de_CH-latin1   # Load swiss keyboard
```

### Partitioning
```sh
cfdisk /dev/sda         # Assuming your disk is named /dev/sda
lsblk                   # If it's not /dev/sda or to check partitioning
```
Within cfdisk do following
- If there's a popup, choose "gpt"
- Delete all partitions with ←↑→↓ and \[enter\]
- Create following partitions
  1. EFI partition\
    Size: 300M\
    Type: EFI System
  2. Swap partition\
    Size: 8G\
    Type: Linux swap
  3. System partition\
    Size: default\
    Type: default
- Select write command and type "yes"
- Quit the tool

### Create and mount filesystems
Now we initialize previously created partitions:
```sh
mkfs.fat -F32 /dev/sda1     # Create EFI compatible FAT filesystem
mkswap /dev/sda2            # Create swap filesystem
mkfs.ext4 /dev/sda3         # Create main linux filesystem

swapon /dev/sda2            # Enable swap
mount /dev/sda3 /mnt        # Mount partition to access it
```

### Install base system
Now let's install the most important packages:
```sh
pacman -Sy                          # Update packet lists
pacstrap /mnt base base-devel vim   # Install to /mnt
```

### Configure system
First we need a mounting script, to let the system know which disks it should use.
```sh
genfstab -U -p /mnt >> /mnt/etc/fstab  
```

Now we login into our new system:
```sh
arch-chroot /mnt            # Mount necessary things and login
```

Now lets start with the real configuration:
```sh
echo "machine" > /etc/hostname  # Set your hostname
vim /etc/locale.gen             # -> Uncomment all you need
locale-gen                      # Generate the selected locales
echo LANG=de_CH.UTF-8 > /etc/locale.conf
# Set time zone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
hwclock --systohc --utc         # Set hardware clock
# Set default keyboard
cat << EOF >> /etc/vconsole.conf
KEYMAP=de_CH-latin1
EOF
```

Now lets make a few user settings:
```sh
passwd [enter]                  # Set your password and remember

# Add a non-root user
useradd -mg users -G wheel,storage,power -s /bin/bash install
passwd install [enter]          # Set a user password
# Configure sudo
vim /etc/sudoers                
# -> Duplicate line with "root" and exchange root with "install"
# To exit this file, enter :wq!
```

### Install bootloader
Because we want our system to boot, we'll install a bootloader:
```sh
pacman -S grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI       # If not working go to "Problem"
# Install efi-grub
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Problem
If it does not work, follow the steps at Reboot.\
Then boot again to USB and put those commands:
```sh
mount /dev/sda3 /mnt
arch-chroot /mnt
mount /dev/sda1 /boot/EFI
```
And go on ...

### Reboot
We can't directly leave our system, first we should do following:
```sh
exit                            # Leave the chroot
umount -a                       # Automatically unmount everything
telinit 6                       # Reboot
```

### BIOS fail workaround
If after the reboot our arch can't boot (grub doesn't appear), do that:
- Open BIOS Settings (F2 or similar during boot)
- Go to boot sequence > Boot List option -> Add Boot Option
- Select File > Go to EFI > grub_uefi > bootx64.efi
- Save all that and try again

### In the new system
First we activate the dhcp service:
```sh
systemctl start dhcpcd
systemctl enable dhcpcd
ping google.com                 # And wait 'till it works
```

Now you can do whatever you want. I recommend to install a few packages of your choice, at least this:
```sh
pacman -Sy git
```

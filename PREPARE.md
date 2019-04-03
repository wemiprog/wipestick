# Install Archlinux

## Prepare
Download an arch ISO:\
[archlinux.de](https://www.archlinux.de/download)

Download and install Etcher:\
[balena.io/etcher](https://www.balena.io/etcher/)

Flash the ISO to an USB disk and boot PC from it.
You have to **disable secureboot** for installing arch!

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
ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localetime
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
# Install and configure sudo
pacman -S sudo
vim /etc/sudoers                
# -> Duplicate line with "root" and exchange root with "install"
```

### Install bootloader
Because we want our system to boot, we'll install a bootloader:
```sh

```
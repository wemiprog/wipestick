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
dhcpcd
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
  1. EFI partition
    Size: 300M
    Type: EFI System
  2. Swap partition
    Size: 8G
    Type: Linux swap
  3. System partition
    Size: default
    Type: default
- Select write command and type "yes"
- Quit the tool
# Arch Linux Full-Disk Encryption Installation Guide -> [Original post](https://gist.github.com/huntrar/e42aee630bee3295b2c671d098c81268)
## Pre-installation
### Connect to the internet
Plug in your Ethernet and go, or for wireless consult the all-knowing [Arch Wiki](https://wiki.archlinux.org/index.php/installation_guide#Connect_to_the_internet).

### Update the system clock
```
timedatectl set-ntp true
```

### Preparing the disk
#### Create EFI System and Linux LUKS partitions
##### Create a 1MiB BIOS boot partition at start just in case it is ever needed in the future

Number | Start (sector) | End (sector) |    Size    | Code |        Name         |
-------|----------------|--------------|------------|------|---------------------|
   1   |   2048         |   4095       | 1024.0 KiB | EF02 | BIOS boot partition |
   2   |   4096         |   1130495    | 550.0 MiB  | EF00 | EFI System          |
   3   |   1130496      |   976773134  | 465.2 GiB  | 8309 | Linux LUKS          |

```gdisk /dev/nvme0n1```
```
o
n
[Enter]
0
+1M
ef02
n
[Enter]
[Enter]
+550M
ef00
n
[Enter]
[Enter]
[Enter]
8309
w
```

#### Create the LUKS1 encrypted container on the Linux LUKS partition (GRUB does not support LUKS2 as of May 2019)
```cryptsetup luksFormat --type luks1 --use-random -S 1 -s 512 -h sha512 -i 5000 /dev/nvme0n1p3```

#### Open the container (decrypt it and make available at /dev/mapper/cryptlvm)
```
cryptsetup open /dev/nvme0n1p3 cryptlvm
```

### Preparing the logical volumes
#### Create physical volume on top of the opened LUKS container
```
pvcreate /dev/mapper/cryptlvm
```

#### Create the volume group and add physical volume to it
```
vgcreate vg /dev/mapper/cryptlvm
```

#### Create logical volumes on the volume group for swap, root, and home
```
lvcreate -L 8G vg -n swap
lvcreate -L 32G vg -n root
lvcreate -l 100%FREE vg -n home
```

The size of the swap and root partitions are a matter of personal preference.

#### Format filesystems on each logical volume
```
mkfs.ext4 /dev/vg/root
mkfs.ext4 /dev/vg/home
mkswap /dev/vg/swap
```

#### Mount filesystems
```
mount /dev/vg/root /mnt
mkdir /mnt/home
mount /dev/vg/home /mnt/home
swapon /dev/vg/swap
```

### Preparing the EFI partition
#### Create FAT32 filesystem on the EFI system partition
```
mkfs.fat -F32 /dev/nvme0n1p2
```

#### Create mountpoint for EFI system partition at /efi for compatibility with grub-install and mount it
```
mkdir /mnt/efi
mount /dev/nvme0n1p2 /mnt/efi
```

## Installation
### Install necessary packages
```
pacstrap /mnt base linux linux-firmware mkinitcpio lvm2 vi dhcpcd wpa_supplicant
```

## Configure the system
### Generate an fstab file
```
genfstab -U /mnt >> /mnt/etc/fstab
```

### Enter new system chroot
```
arch-chroot /mnt
```

#### At this point you should have the following partitions and logical volumes:
```lsblk```

NAME           | MAJ:MIN | RM  |  SIZE  | RO  | TYPE  | MOUNTPOINT |
---------------|---------|-----|--------|-----|-------|------------|
nvme0n1        |  259:0  |  0  | 465.8G |  0  | disk  |            |
├─nvme0n1p1    |  259:4  |  0  |     1M |  0  | part  |            |
├─nvme0n1p2    |  259:5  |  0  |   550M |  0  | part  | /efi       |
├─nvme0n1p3    |  259:6  |  0  | 465.2G |  0  | part  |            |
..└─cryptlvm   |  254:0  |  0  | 465.2G |  0  | crypt |            |
....├─vg-swap  |  254:1  |  0  |     8G |  0  | lvm   | [SWAP]     |
....├─vg-root  |  254:2  |  0  |    32G |  0  | lvm   | /          |
....└─vg-home  |  254:3  |  0  | 425.2G |  0  | lvm   | /home      |

### Time zone
#### Set the time zone
Replace `America/Los_Angeles` with your respective timezone found in `/usr/share/zoneinfo`
```
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
```

#### Run `hwclock` to generate ```/etc/adjtime```
Assumes hardware clock is set to UTC
```
hwclock --systohc
```

### Localization
#### Uncomment ```en_US.UTF-8 UTF-8``` in ```/etc/locale.gen``` and generate locale
```
locale-gen
```

#### Create ```locale.conf``` and set the ```LANG``` variable
```/etc/locale.conf```
```
LANG=en_US.UTF-8
```

### Network configuration
#### Create the hostname file
```/etc/hostname```
```
myhostname
```

This is a unique name for identifying your machine on a network.

#### Add matching entries to hosts
```/etc/hosts```
```
127.0.0.1 localhost
::1 localhost
127.0.1.1 myhostname.localdomain myhostname
```

### Initramfs
#### Add the ```keyboard```, ```encrypt```, and ```lvm2``` hooks to ```/etc/mkinitcpio.conf```
*Note:* ordering matters.
```
HOOKS=(base udev autodetect keyboard modconf block encrypt lvm2 filesystems fsck)
```

#### Recreate the initramfs image
```
mkinitcpio -p linux
```

### Root password
#### Set the root password
```
passwd
```

### Boot loader
#### Install GRUB
```
pacman -S grub
```

#### Configure GRUB to allow booting from /boot on a LUKS1 encrypted partition
```/etc/default/grub```
```
GRUB_ENABLE_CRYPTODISK=y
```

#### Set kernel parameter to unlock the LVM physical volume at boot using ```encrypt``` hook
##### UUID is the partition containing the LUKS container
```blkid```
```
/dev/nvme0n1p3: UUID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" TYPE="crypto_LUKS" PARTLABEL="Linux LUKS" PARTUUID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

```/etc/default/grub```
```
GRUB_CMDLINE_LINUX="... cryptdevice=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:cryptlvm root=/dev/vg/root ..."
```

#### Install GRUB to the mounted ESP for UEFI booting
```
pacman -S efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi
```

#### Enable microcode updates
##### grub-mkconfig will automatically detect microcode updates and configure appropriately
```
pacman -S intel-ucode
```

Use intel-ucode for Intel CPUs and amd-ucode for AMD CPUs.

#### Generate GRUB's configuration file
```
grub-mkconfig -o /boot/grub/grub.cfg
```

### (recommended) Embed a keyfile in initramfs

This is done to avoid having to enter the encryption passphrase twice (once for GRUB, once for initramfs.)

#### Create a keyfile and add it as LUKS key
```
mkdir /root/secrets && chmod 700 /root/secrets
head -c 64 /dev/urandom > /root/secrets/crypto_keyfile.bin && chmod 600 /root/secrets/crypto_keyfile.bin
cryptsetup -v luksAddKey -i 1 /dev/nvme0n1p3 /root/secrets/crypto_keyfile.bin
```

#### Add the keyfile to the initramfs image
```/etc/mkinitcpio.conf```
```
FILES=(/root/secrets/crypto_keyfile.bin)
```

#### Recreate the initramfs image
```
mkinitcpio -p linux
```

#### Set kernel parameters to unlock the LUKS partition with the keyfile using ```encrypt``` hook
```/etc/default/grub```
```
GRUB_CMDLINE_LINUX="... cryptkey=rootfs:/root/secrets/crypto_keyfile.bin"
```

#### Regenerate GRUB's configuration file
```
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Restrict ```/boot``` permissions
```
chmod 700 /boot
```

The installation is now complete. Exit the chroot and reboot.
```
exit
reboot
```

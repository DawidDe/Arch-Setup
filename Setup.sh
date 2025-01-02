#!/bin/bash
loadkeys de-latin1
timedatectl
mkfs.fat -F 32 /dev/nvme0n1p5
mkswap /dev/nvme0n1p6
mkfs.ext4 /dev/nvme0n1p7
mount /dev/nvme0n1p7 /mnt
mount --mkdir /dev/nvme0n1p5 /mnt/boot
swapon /dev/nvme0n1p6
pacstrap -K /mnt base linux linux-firmware amd-ucode networkmanager nano gdm gnome grub efibootmgr
genfstab -U /mnt >> /etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=de_DE.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
passwd
dawid
dawid
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
reboot now

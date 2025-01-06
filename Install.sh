#!/bin/bash
mkfs.ext4 /dev/nvme0n1p7
mkswap /dev/nvme0n1p6
mkfs.fat -F 32 /dev/nvme0n1p5
mount /dev/nvme0n1p7 /mnt
mount --mkdir /dev/nvme0n1p5 /mnt/boot
swapon /dev/nvme0n1p6
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt bash << EOF
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=de_DE.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
passwd
pacman -Syu grub efibootmgr sudo
useradd -m -G wheel -s /bin/bash dawid
passwd dawid
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
grub-install --target=x86_64-efi --efi-directory =/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
exit
EOF
umount -a
reboot now

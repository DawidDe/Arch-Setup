#!/bin/bash
echo "Setze die Tastaturbelegung auf Deutsch (de-latin1)..."
loadkeys de-latin1
echo "Zeige die aktuelle Zeit und Zeitzone..."
timedatectl
read -n 1 -s
echo "Formatiere /dev/nvme0n1p5 mit FAT32..."
mkfs.fat -F 32 /dev/sda1
echo "Erstelle Swap auf /dev/nvme0n1p6..."
mkswap /dev/sda2
echo "Formatiere /dev/nvme0n1p7 mit ext4..."
mkfs.ext4 /dev/sda3
echo "Mounten von /dev/nvme0n1p7 nach /mnt..."
mount /dev/sda3 /mnt
echo "Mounten von /dev/nvme0n1p5 nach /mnt/boot..."
mount --mkdir /dev/sda1 /mnt/boot
echo "Aktiviere Swap auf /dev/nvme0n1p6..."
swapon /dev/sda2
read -n 1 -s
echo "Installiere Base-System und wichtige Pakete..."
pacstrap -K /mnt base linux linux-firmware amd-ucode networkmanager nano gdm gnome grub efibootmgr
read -n 1 -s
echo "Generiere /etc/fstab..."
genfstab -U /mnt >> /etc/fstab
echo "Wechsle in das chroot-Umgebung..."
arch-chroot /mnt
read -n 1 -s
echo "Setze Zeitzone auf Europa/Berlin..."
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "Synchronisiere Hardware-Uhrzeit mit System-Uhrzeit..."
hwclock --systohc
echo "Aktiviere deutsche Lokalisierung..."
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "Setze Sprachumgebung auf de_DE.UTF-8..."
echo "LANG=de_DE.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
echo "Setze Hostnamen auf 'arch'..."
echo "arch" >> /etc/hostname
echo "Setze Root-Passwort..."
passwd
echo "Installiere GRUB Bootloader..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
echo "System wird jetzt neu gestartet..."
reboot now

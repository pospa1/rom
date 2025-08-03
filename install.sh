#!/bin/bash
set -e

MOUNTPOINT="/mnt/usb"

echo "=== Hledám USB disk se zálohou... ==="
lsblk

read -p "Zadej zařízení USB (např. sdb1): " USBDEV

echo "=== Připojuji USB ==="
mkdir -p $MOUNTPOINT
mount /dev/$USBDEV $MOUNTPOINT

echo "=== Kontroluji dostupné zařízení eMMC ==="
lsblk | grep mmcblk

read -p "Zadej zařízení eMMC (standartně: mmcblk2): " EMMCDEV

cd $MOUNTPOINT

echo "=== Zapisuji boot0 ==="
dd if=emmc-boot0.img of=/dev/${EMMCDEV}boot0 bs=1M

echo "=== Zapisuji boot1 ==="
dd if=emmc-boot1.img of=/dev/${EMMCDEV}boot1 bs=1M

echo "=== Zapisuji hlavní oblast eMMC ==="
dd if=emmc-backup.img of=/dev/$EMMCDEV bs=4M status=progress
read -p "eMMC zapsán, zmáčkni Enter pro Dokončení..."

echo "✅ Zápis dokončen! Můžeš Restartovat box a poté odpojit USB/SD!"

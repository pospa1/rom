#!/bin/bash
set -e

# ID souboru z Google Disku
FILE_ID="1_AbYVDeSIKpIizRHaXTb-XjlsQlHSR3u"
ZIP_FILE="/tmp/data.zip"
EXTRACT_DIR="/tmp/data"
EMMCDEV="mmcblk2"  # pokud chceš, můžeš změnit na jiné zařízení

# Kontrola, jestli je nainstalovaný gdown
if ! command -v gdown &> /dev/null; then
    echo "gdown není nainstalován. Instaluji..."
    pip install gdown || pip3 install gdown
fi

echo "=== Stahuji ZIP ==="
gdown --fuzzy "https://drive.google.com/file/d/$FILE_ID/view?usp=sharing" -O "$ZIP_FILE"

echo "=== Rozbaluji ZIP ==="
rm -rf "$EXTRACT_DIR"
unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"

cd "$EXTRACT_DIR"

echo "=== Zapisují boot0 ==="
dd if=emmc-boot0.img of=/dev/${EMMCDEV}boot0 bs=1M

echo "=== Zapisují boot1 ==="
dd if=emmc-boot1.img of=/dev/${EMMCDEV}boot1 bs=1M

echo "=== Zapisují hlavní oblast eMMC ==="
dd if=emmc-backup.img of=/dev/$EMMCDEV bs=4M status=progress

echo "=== Hotovo! eMMC úspěšně zapsáno. ==="
echo "!!! PO REBOOTU NUTNÝ FACTORY RESET !!!"

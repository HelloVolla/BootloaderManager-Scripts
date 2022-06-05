#!/system/bin/sh
export TMPDIR="/data/data/org.androidbootmanager.app/cache"

# Script for installing other OSes. Parameters: ROM folder name, ROM name in menu, boot path

TK="/data/data/org.androidbootmanager.app/assets/Toolkit"
PATH="$TK:$PATH"
cd "$TK" || exit 24

# Create working dir
mkdir -p /data/abm/tmp/boot

# Create folder for new OS
mkdir -p "/data/abm/bootset/$1"

# Copy boot
mv "$3" /data/abm/tmp/boot/boot.img

# Unpack boot
unpackbootimg -i /data/abm/tmp/boot/boot.img -o /data/abm/tmp/boot/

#Copy dtb
cp /data/abm/tmp/boot/boot.img-dtb "/data/abm/bootset/$1/dtb.dtb"

# Copy kernel
cp /data/abm/tmp/boot/boot.img-zImage "/data/abm/bootset/$1/zImage"

# Copy rd
cp /data/abm/tmp/boot/boot.img-ramdisk.gz "/data/abm/bootset/$1/initrd.cpio.gz"

# Create entry
cat << EOF >> "/data/abm/bootset/db/entries/$1.conf"
  title      $2
  linux      $1/zImage
  initrd     $1/initrd.cpio.gz
  dtb        $1/dtb.dtb
  options    bootopt=64S3,32N2,64N2
  logo       NULL
EOF

# Clean up
rm -r /data/abm/tmp

echo "Installation done."

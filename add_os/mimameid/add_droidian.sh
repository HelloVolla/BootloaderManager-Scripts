#!/system/bin/sh

# Script for installing Droidian for ABM. Parameters: ROM folder name, ROM name in menu, Droidian LVM partition number, Droidian ZIP-release path

TK="/data/data/com.volla.bootmanager/assets/Toolkit"
PATH="$TK:$PATH"
cd "$TK" || exit 24

# Create working dir
mkdir -p /data/abm/tmp/boot/rd

# Create folder for new OS
mkdir -p "/data/abm/bootset/$1"

# Copy logo
cp /data/data/com.volla.bootmanager/assets/Logos/Droidian.bin "/data/abm/bootset/$1/logo.bin"

# Create the entry
cat << EOF >> "/data/abm/bootset/db/entries/$1.conf"
  title      $2
  linux      $1/zImage
  initrd     $1/initrd.cpio.gz
  dtb        $1/dtb.dtb
  options    bootopt=64S3,32N2,64N2 droidian.lvm.prefer droidian.lvm.vg=droidian-mmcblk1p$3
  logo       $1/logo.bin
  xsystem    $3
  xtype      Droidian
EOF


# Unzip the release archive
(cd /data/abm/tmp/boot && /system/bin/unzip "$4")

# Copy boot
cp "/data/abm/tmp/boot/data/boot.img" /data/abm/tmp/boot/boot.img

# Unpack boot
unpackbootimg -i /data/abm/tmp/boot/boot.img -o /data/abm/tmp/boot/

# Copy kernel
cp /data/abm/tmp/boot/boot.img-zImage "/data/abm/bootset/$1/zImage"
cp /data/abm/tmp/boot/boot.img-ramdisk.gz "/data/abm/bootset/$1/initrd.cpio.gz"
cp /data/abm/tmp/boot/boot.img-dtb "/data/abm/bootset/$1/dtb.dtb"

# Flash rootfs
simg2img "/data/abm/tmp/boot/data/userdata.img" "/data/abm/tmp/boot/data/userdata.raw"
dd if="/data/abm/tmp/boot/data/userdata.raw" of=/dev/block/mmcblk1p$3

mkdir -p /data/abm/tmp/lvm/lock
export LVM_SYSTEM_DIR=/data/abm/tmp/lvm
cat >$LVM_SYSTEM_DIR/lvm.conf <<EOF
global { locking_dir = "$LVM_SYSTEM_DIR/lock" }
devices { filter=[ "a|^/dev/block/mmcblk1p$3$|", "r/.*/" ] }
EOF

# Rename and resize the LVM
lvm.static pvresize /dev/block/mmcblk1p$3
lvm.static pvchange --uuid /dev/block/mmcblk1p$3
lvm.static vgscan
lvm.static vgrename droidian droidian-mmcblk1p$3
lvm.static vgchange --uuid droidian-mmcblk1p$3
lvm.static vgchange -ay droidian-mmcblk1p$3
lvm.static lvextend -l +100%FREE /dev/droidian-mmcblk1p$3/droidian-rootfs

# Resize the rootfs
e2fsck -fy /dev/droidian-mmcblk1p$3/droidian-rootfs
resize2fs /dev/droidian-mmcblk1p$3/droidian-rootfs

# Clean up
rm -rf /data/abm/tmp
echo "Installation done."

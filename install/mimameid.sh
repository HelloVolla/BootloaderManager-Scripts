#!/system/bin/sh
export TMPDIR="/data/data/com.volla.bootmanager/cache"

# Mount
/data/data/com.volla.bootmanager/assets/Scripts/config/mount/mimameid.sh

# Create folder for new OS
mkdir -p "/data/abm/bootset/VollaOS"

# Copy logo
cp /data/data/com.volla.bootmanager/assets/Logos/VollaOS.bin "/data/abm/bootset/VollaOS/logo.bin"

# Create entry
cat << EOF >> /data/abm/bootset/db/db.conf
   default    Entry 01
   timeout    5
EOF
cat << EOF >> "/data/abm/bootset/db/entries/VollaOS.conf"
  title      VollaOS
  linux      null
  initrd     null
  dtb        null
  options    null
  logo       VollaOS/logo.bin
  xtype      droid
  xsystem    real
  xdata      real
EOF

/data/data/com.volla.bootmanager/assets/Scripts/config/umount/mimameid.sh

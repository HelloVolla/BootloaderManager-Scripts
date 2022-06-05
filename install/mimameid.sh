#!/system/bin/sh
export TMPDIR="/data/data/org.androidbootmanager.app/cache"

# Mount
/data/data/org.androidbootmanager.app/assets/Scripts/config/mount/mimameid.sh

# Create folder for new OS
mkdir -p "/data/abm/bootset/VollaOS"

# Copy logo
cp /data/data/org.androidbootmanager.app/assets/Logos/VollaOS.bin "/data/abm/bootset/VollaOS/logo.bin"

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

/data/data/org.androidbootmanager.app/assets/Scripts/config/umount/mimameid.sh

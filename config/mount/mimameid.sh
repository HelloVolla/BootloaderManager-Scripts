#!/system/bin/sh

setprop sys.volla.abm_mount 1

NEXT_WAIT_TIME=0
until [ $NEXT_WAIT_TIME -eq 2 ] || mountpoint -q -- /data/abm/bootset; do
    sleep $(( NEXT_WAIT_TIME++ ))
done
if ! mountpoint -q -- /data/abm/bootset; then
    echo "Failed to mount"
    exit 1
fi

if [ ! -d /data/abm/bootset/db ]; then
    mkdir -p /data/abm/bootset/db
    chmod 0770 /data/abm/bootset/db
fi

if [ ! -d /data/abm/bootset/db/entries ]; then
    mkdir -p /data/abm/bootset/db/entries
    chmod 0770 /data/abm/bootset/db/entries
fi

if [ ! -L /data/abm/bootset/lk2nd ]; then
   ln -s /data/abm/bootset/db /data/abm/bootset/lk2nd
fi

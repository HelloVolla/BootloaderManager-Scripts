#!/system/bin/sh

sdcard=`sm list-volumes public`
if [ ! -z "$sdcard" ]; then
    sm unmount $sdcard
fi

sleep 2

setprop sys.volla.rereadpt 1

NEXT_WAIT_TIME=0
until [ $NEXT_WAIT_TIME -eq 2 ] || [ `getprop sys.volla.rereadpt` == "0" ]; do
    sleep $(( NEXT_WAIT_TIME++ ))
done

if [ ! -z "$1" ]; then
    NEXT_WAIT_TIME=0
    until [ $NEXT_WAIT_TIME -eq 2 ] || [ -e "$1" ]; do
        sleep $(( NEXT_WAIT_TIME++ ))
    done
    if [ ! -e "$1" ]; then
        echo "Update Blocks failed: $1 Not found"
        exit 1
    fi
fi

echo "Blocks Updated successfully"

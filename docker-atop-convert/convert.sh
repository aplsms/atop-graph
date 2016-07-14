#!/bin/bash

if [ x$TASK = xCONVERT ] ; then
    for i in `find $SRC_PATH -type f -name \* ` ; do
        filename=$(basename "$i")
        UUID=$(cat /proc/sys/kernel/random/uuid)
        echo -n "Processing $filename..."
        atop -r $i -P ALL |grep -v '^PR' |awk -f /parse.awk >$DST_PATH/atop-$UUID.txt;
        echo " Done. Result saved to atop-$UUID.txt"
    done
elif [ x$TASK = xPUSH ] ; then
    for i in `find $DST_PATH -type f -name atop\*.txt ` ; do
        echo "Importing $i to influxdb.."
        influx -import -path=$i -precision=s -host $IP || echo "Error importing $i"
    done
else
    echo "TASK definition Error: $TASK"
fi
#!/bin/bash

NAME=$(basename $0)
PID=$$
PIDFILE=/tmp/$NAME.pid
MAXSEC=2

trap "rm -f $PIDFILE" EXIT

if pidof -o %PPID -x $NAME >/dev/null; then
    echo $PID > $PIDFILE
    sleep $MAXSEC
    exit 0
fi

while [ $SECONDS -lt $MAXSEC ]; do
    if [ -f "$PIDFILE" ]; then 
        OTHERPID=`cat $PIDFILE`
        kill $OTHERPID
        systemctl poweroff
        exit 0
    fi
done

systemctl suspend
exit 0

#!/bin/bash

BATTINFO=`acpi -b`

if [[ `echo $BATTINFO | grep Discharging` && `acpi -b | cut -f 5 -d " "` =~ "01:00" ]] ; then
    DISPLAY=:0.0 /usr/bin/notify-send "one hour left" "$BATTINFO"
fi

if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 5 -d " "` =~ "00:30:" ]] ; then
    DISPLAY=:0.0 /usr/bin/notify-send "half hour left" "$BATTINFO"
fi

if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 5 -d " "` =~ "00:15" ]] ; then
    DISPLAY=:0.0 /usr/bin/notify-send "low battery" "$BATTINFO"
fi

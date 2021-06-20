#!/bin/bash

# Brightness Up script
[ -z "$DISPLAY" ] && export DISPLAY=:0

! [ -f "/tmp/brcf" ] && echo 100 > /tmp/brcf
curbr=$(cat /tmp/brcf)
newbr=$(( curbr + 10 ))
[[ $newbr -gt 100 ]] && newbr=100
echo "$newbr"  > /tmp/brcf
for brfile in /sys/class/backlight/*/brightness
do
 brmax=$(cat "$(dirname "$brfile" )/max_brightness")
 brnew=$(( newbr * brmax / 100 ))
 echo "$brnew" | sudo tee "$brfile"
done
for xoutput in $(xrandr | grep connected | awk '{print $1}')
do
 xrandr --output $xoutput --brightness $(awk 'BEGIN{printf "%.2f",'$newbr'/100}')
done

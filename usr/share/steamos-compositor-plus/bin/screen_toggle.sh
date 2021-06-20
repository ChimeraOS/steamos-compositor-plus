#!/bin/bash

# Screen Toogle script
[ -z "$DISPLAY" ] && export DISPLAY=:0

active_o=""
current_r="zzz"
current_m=""
list_o=""
mirror=false
ready=false

while read line
do
 fline=$(echo "$line" | awk '/'"$current_r"'/{print $0" M"} ; / connected/{print $1" "$3" O"} ; / disconnected/{print $1" "$3" D"} ; /Screen/{print $8$9$10",R"}')
 if [[ "$fline" =~ "R"$ ]]
 then
  current_r="$(echo "$fline" | awk -F, '{print $1}')"
 elif [[ "$fline" =~ "O"$ ]]
 then
  read connected_o connected_m <<<"$(echo "$fline" | awk '{print $1" "$2}')"
 elif [[ "$fline" =~ "D"$ ]]
 then
  connected_o=""
  connected_m=""
 elif [[ "$fline" =~ "M"$ ]]
 then
  #output has mode, but only proceed if the monitor is connected
  if [ -n "$connected_o" ]
  then
   #only add to list if it hasn't been already added
   ! [[ "$list_o" =~ ",$connected_o"$ ]] && list_o="$list_o,$connected_o"
   selected_m="$(echo "$fline" | awk '/*/{print $1}')"
   if [ -n "$selected_m" ]
   then
    current_m="$selected_m"
    [ -n "$active_o" ] && mirror=true && active_o=M || active_o="$connected_o"
   fi
  fi
 fi
done<<<$(xrandr)

[ -n "$current_m" ] && [ -n "$active_o" ] && ready=true
if $ready
then
 if $mirror
 then
  #is mirrored, go for the first option and turn off all others
  next_o="$(echo "$list_o" | awk -F, '{print $2}')"
  for output in ${list_o//,/ }
  do
   ! [ "$output" = "$next_o" ] && xrandr --output "$output" --off
  done
 else
  #is single active_o
  next_o="$(echo "$list_o" | awk -F",$active_o" '{print $2}' | awk -F, '{print $2}')"
  if [ -n "$next_o" ]
  then
   #moving to next_o
   xrandr --output "$next_o" --mode "$current_m" --same-as "$active_o"
   xrandr --output "$active_o" --off
  else
   #moving to mirror
   for output in ${list_o//,/ }
   do
    ! [ "$output" = "$active_o" ] && xrandr --output "$output" --mode "$current_m" --same-as "$active_o"
   done
  fi
 fi
elif ! [ "$current_r" = "zzz" ]
then
 #try to fallback to first available output if there's a valid current_r
 next_o="$(echo "$list_o" | awk -F, '{print $2}')"
 [ -n "$next_o" ] && xrandr --output "$next_o" --mode "$current_r"
fi

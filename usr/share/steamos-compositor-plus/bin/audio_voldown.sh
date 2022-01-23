#!/bin/bash

STEP=10
MINVOLUME=0

volume=$(pamixer --get-volume)

if [[ "$volume" -gt $MINVOLUME ]]
then
 pamixer -d $STEP
 aplay $HOME/.local/share/Steam/tenfoot/resource/sounds/volume_change.wav &>/dev/null
else
 aplay $HOME/.local/share/Steam/tenfoot/resource/sounds/activation_change_fail.wav &>/dev/null
fi

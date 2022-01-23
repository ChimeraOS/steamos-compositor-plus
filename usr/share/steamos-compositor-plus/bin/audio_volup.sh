#!/bin/bash

STEP=10
MAXVOLUME=100

volume=$(pamixer --get-volume)

if [[ "$volume" -lt $MAXVOLUME ]]
then
 pamixer -i $STEP
 aplay $HOME/.local/share/Steam/tenfoot/resource/sounds/volume_change.wav &>/dev/null
else
 aplay $HOME/.local/share/Steam/tenfoot/resource/sounds/activation_change_fail.wav &>/dev/null
fi

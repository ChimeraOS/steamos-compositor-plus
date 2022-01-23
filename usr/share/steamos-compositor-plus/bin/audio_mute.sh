#!/bin/bash

# Volume Mute script
pamixer --toggle-mute
aplay $HOME/.local/share/Steam/tenfoot/resource/sounds/volume_change.wav &>/dev/null

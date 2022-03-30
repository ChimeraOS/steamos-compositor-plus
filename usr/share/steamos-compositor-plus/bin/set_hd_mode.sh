#!/bin/bash

# This script attempts to set a known-good mode on a good output

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

# Devices with incorrect EDID readings need to have modes added before the compositor loads for it to work correctly

if [ "$(cat /sys/devices/virtual/dmi/id/product_name)" == "ONE XPLAYER" ]; then
    xrandr --newmode "400x640"   20.25  400 424 456 512  640 643 653 665 -hsync +vsync
    xrandr --addmode eDP1 400x640

    xrandr --newmode "600x960"   47.25  600 640 696 792  960 963 973 996 -hsync +vsync
    xrandr --addmode eDP1 600x960

    xrandr --newmode "800x1280"  85.25  800 856 936 1072 1280 1283 1293 1327 -hsync +vsync
    xrandr --addmode eDP1 800x1280

    xrandr --newmode "900x1440"   109.50  904 968 1064 1224  1440 1443 1453 1493 -hsync +vsync
    xrandr --addmode eDP1 900x1440

    xrandr --newmode "1050x1680"   150.25  1056 1136 1248 1440  1680 1683 1693 1741 -hsync +vsync
    xrandr --addmode eDP1 1050x1680

    xrandr --newmode "1200x1920"   196.50  1200 1296 1424 1648  1920 1923 1933 1989 -hsync +vsync
    xrandr --addmode eDP1 1200x1920

    xrandr --newmode "1600x2560"   353.50  1600 1736 1912 2224  2560 2563 2573 2651 -hsync +vsync
    xrandr --addmode eDP1 1600x2560
fi

# This function echoes the first element from first argument array, matching a
# prefix in the order given by second argument array.
function first_by_prefix_order() {
    local values=${!1}
    local prefix_order=${!2}
    for prefix in ${prefix_order[@]} ; do
        for val in ${values[@]} ; do
            if [[ $val =~ ^$prefix ]] ; then echo $val ; return ; fi
        done
    done
}

GOODMODES=("3840x2160" "2560x1600" "2560x1440" "1920x1200" "1920x1080" "1280x800" "1280x720")
GOODRATES=("60.0" "59.9") # CEA modes guarantee or one the other, but not both?
ROTATION=

# hardware specific defaults
if [ "$(cat /sys/devices/virtual/dmi/id/product_name)" == "ONE XPLAYER" ]; then
    ROTATION=left
    GOODMODES=("1280x800")
fi

CONFIG_PATH=${XDG_CONFIG_HOME:-$HOME/.config}
CONFIG_FILE="$CONFIG_PATH/steamos-compositor-plus"

# Override the defaults from the user config
echo "Debug: USER: $USER"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo '#GOODMODES=("3840x2160" "2560x1600" "2560x1440" "1920x1200" "1920x1080" "1280x800" "1280x720")' > "$CONFIG_FILE"
    echo '#GOODRATES=("60.0" "59.9")' >> "$CONFIG_FILE"
    echo '#ROTATION=' >> "$CONFIG_FILE"
fi

# First, some logging
date
xrandr --verbose

# List connected outputs
ALL_OUTPUT_NAMES=$(xrandr | grep ' connected' | cut -f1 -d' ')
# Default to first connected output
OUTPUT_NAME=$(echo $ALL_OUTPUT_NAMES | cut -f1 -d' ')
echo "Debug: ALL_OUTPUT_NAMES: $ALL_OUTPUT_NAMES"
echo "Debug: OUTPUT_NAME: $OUTPUT_NAME"
# If any is connected, give priority to HDMI then DP
OUTPUT_PRIORITY="HDMI DisplayPort DP LVDS"
PREFERRED_OUTPUT=$(first_by_prefix_order ALL_OUTPUT_NAMES[@] OUTPUT_PRIORITY[@])
if [[ -n "$PREFERRED_OUTPUT" ]] ; then
    OUTPUT_NAME=$PREFERRED_OUTPUT
fi
# Set an initial value to test against
xrandr --output $OUTPUT_NAME --auto
# Disable everything but the selected output
for i in $ALL_OUTPUT_NAMES; do
	if [ "$i" != "$OUTPUT_NAME" ]; then
		xrandr --output "$i" --off
	fi
done


CURRENT_MODELINE=`xrandr | grep \* | tr -s ' ' | head -n1`
printf "Debug: CURRENT_MODELINE: $CURRENT_MODELINE \nxrandr | grep \* | tr -s ' ' | head -n1"

CURRENT_MODE=`echo "$CURRENT_MODELINE" | cut -d' ' -f2`
CURRENT_RATE=`echo "$CURRENT_MODELINE" | tr ' ' '\n' | grep \* | tr -d \* | tr -d +`

# If the current mode is already deemed good, we're good, exit
if [ $(contains "${GOODMODES[@]}" "$CURRENT_MODE") == "y" ]; then
	if [ $(contains "${GOODRATES[@]}" "$CURRENT_RATE") == "y" ]; then
	exit 0
	fi
fi

w=`echo $CURRENT_MODE | cut -dx -f1`
h=`echo $CURRENT_MODE | cut -dx -f2`
echo "Debug: CURRENT_MODE: $CURRENT_MODE, WxH: $w $h"
if [ "$h" -gt "$w" ]; then
	TRANSPOSED=true
fi

if [ -z "$ROTATION" ] && [ "$TRANSPOSED" = true ]; then
	ROTATION=right
fi

if [ -z "$ROTATION" ]; then
	ROTATION=normal
fi

# detect and rotate touch screen
TOUCHSCREEN=$(udevadm info --export-db | sed 's/^$/;;/' | tr '\n' '%%' | tr ';;' '\n' | grep ID_INPUT_TOUCHSCREEN=1 | tr '%%' '\n' | grep "E: NAME=" | head -1 | cut -d\" -f 2)
TOUCHSCREEN_DISPLAYS=("eDP" "LVDS")
TOUCH_IDS=$(xinput --list | egrep -o "$TOUCHSCREEN.+id=[0-9]+" | egrep -o "[0-9]+")
if [ -n "$TOUCHSCREEN" ] && [[ "${TOUCHSCREEN_DISPLAYS[*]}" =~ $OUTPUT_NAME ]]; then
	for ID in $TOUCH_IDS; do
		xinput enable $ID
	done
	MATRIX="1 0 0 0 1 0 0 0 1"
	if [ "$ROTATION" = "right" ]; then
		MATRIX="0 1 0 -1 0 1 0 0 1"
	elif [ "$ROTATION" = "left" ]; then
		MATRIX="0 -1 1 1 0 0 0 0 1"
	elif [ "$ROTATION" = "normal" ]; then
		MATRIX="1 0 0 0 1 0 0 0 1"
	elif [ "$ROTATION" = "inverted" ]; then
		MATRIX="-1 0 1 0 -1 1 0 0 1"
	fi

	xinput set-prop "pointer:$TOUCHSCREEN" --type=float "Coordinate Transformation Matrix" $MATRIX

# disable touch screen if using external display
elif [ -n "$TOUCHSCREEN" ] && [[ ! "${TOUCHSCREEN_DISPLAYS[*]}" =~ $OUTPUT_NAME ]]; then
	for ID in $TOUCH_IDS; do
		xinput disable $ID
	done
fi

# Otherwise try to set combinations of good modes/rates until it works
for goodmode in "${GOODMODES[@]}"; do
	if [ "$TRANSPOSED" = true ]; then
		w=`echo $goodmode | cut -dx -f1`
		h=`echo $goodmode | cut -dx -f2`
		goodmode=${h}x${w}
	fi

	for goodrate in "${GOODRATES[@]}"; do
		xrandr --output "$OUTPUT_NAME" --mode "$goodmode" --refresh "$goodrate" --rotate "$ROTATION"
		# If good return, we're done
		if [[ $? -eq 0 ]]; then
			exit 0
		fi
	done
done

exit 1

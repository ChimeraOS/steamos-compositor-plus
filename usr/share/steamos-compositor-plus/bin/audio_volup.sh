#!/bin/bash

# Volume Up script
STEP="5000"
MAXVOLUME=100 #as a percentage

defindex=""
volumel=
volumer=
ready=false

# retrieve volume for default output
while read line
do
 if [ -z "$defindex" ]
 then
  defindex="$(echo "$line" | awk '/* index:/{print $3}')"
 elif [ -z "$volume" ]
 then
  read volumel volumer <<<$(echo "$line" | awk '/volume:/{print $5" "$12}')
  if [[ "$volumer" =~ "%"$ ]] && [[ "$volumel" =~ "%"$ ]]
  then
    volumer=${volumer%\%}
    volumel=${volumel%\%}
    ready=true
    break
  else
    volumer=
    volumel=
  fi
 fi
done<<<$(pacmd list-sinks | grep -e "index:" -e "volume:")

# execute only if volume is lesser than MAXVOLUME for both channels
if $ready && [[ "$volumer" -lt $MAXVOLUME ]] && [[ "$volumel" -lt $MAXVOLUME ]]
then
 pactl set-sink-volume @DEFAULT_SINK@ +$STEP
 aplay $HOME/.local/share/Steam/tenfoot/resource/sounds/volume_change.wav &>/dev/null
else
 aplay $HOME/.local/share/Steam/tenfoot/resource/sounds/activation_change_fail.wav &>/dev/null
fi

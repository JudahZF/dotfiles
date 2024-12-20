#!/bin/sh

IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
IS_WIFI=$(ifconfig en0 | awk '/status:/{print $2}')

if [[ $IP_ADDRESS != "" ]]; then
	if [[ $IS_WIFI == "active" ]]; then
	   #COLOR=$BLUE
	   ICON=
	else
	   #COLOR=$CYAN
	   ICON=
	fi
	LABEL=$IP_ADDRESS
else
	#COLOR=$WHITE
	ICON=
	LABEL="N/A"
fi

sketchybar --set $NAME icon="$ICON" label="$LABEL"

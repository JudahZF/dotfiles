#!/bin/sh
sketchybar --add item network right \
           --set network script="$PLUGIN_DIR/network.sh" \
                 update_freq=30 \
           --subscribe network wifi_change \

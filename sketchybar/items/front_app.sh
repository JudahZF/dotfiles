#!/bin/sh

sketchybar --add item front_app e \
           --set front_app   \
                            script="$PLUGIN_DIR/front_app.sh"            \
           --subscribe front_app front_app_switched

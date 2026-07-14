#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle yabai
# @raycast.mode compact
# @raycast.icon 🪟
# @raycast.packageName Dotfiles
# @raycast.description Stop or start the yabai window manager (login auto-start unaffected)

# yabai --start/--stop/--restart-service target com.asmvik.yabai (from
# `yabai --install-service`). Drive launchctl against the nix-darwin agent.

set -euo pipefail

LABEL=com.koekeishiya.yabai
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
DOMAIN="gui/$(id -u)"

start() {
  launchctl bootstrap "$DOMAIN" "$PLIST"
  echo "yabai started"
}

stop() {
  launchctl bootout "$DOMAIN/$LABEL"
  echo "yabai stopped"
}

case "${1:-toggle}" in
  start) start ;;
  stop) stop ;;
  restart)
    launchctl kickstart -k "$DOMAIN/$LABEL"
    echo "yabai restarted"
    ;;
  toggle)
    if pgrep -xq yabai; then stop; else start; fi
    ;;
  *)
    echo "usage: $(basename "$0") [start|stop|restart|toggle]" >&2
    exit 1
    ;;
esac

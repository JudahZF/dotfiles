#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Rebuild macOS
# @raycast.mode fullOutput
# @raycast.icon 🤖
# @raycast.packageName NixDarwin
# @raycast.needsConfirmation true

osascript -e 'do shell script "~/dotfiles/rebuild.sh" with administrator privileges'
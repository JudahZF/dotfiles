#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Update macOS
# @raycast.mode fullOutput
# @raycast.icon 🤖
# @raycast.packageName NixDarwin
# @raycast.needsConfirmation true

osascript -e 'do shell script "~/dotfiles/update.sh" with administrator privileges'
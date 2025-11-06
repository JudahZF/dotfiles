#!/bin/sh
set -euo pipefail

# Logging functions
log_info() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $1"
}

log_error() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [ERROR] $1" >&2
}

log_info "Starting update process..."

# Run internal update script
if sh ~/dotfiles/*/_internal_update.sh; then
  log_info "Internal update completed successfully."
else
  log_error "Internal update failed."
  exit 1
fi

log_info "Update process completed successfully. Please rebuild."

exit 0

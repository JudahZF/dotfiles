#!/bin/bash
set -euo pipefail

# Logging functions
log_info() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $1"
}

log_error() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [ERROR] $1" >&2
}

log_info "Starting cleanup process..."

# Run internal update script
if sudo bash ~/dotfiles/*/_internal_clean.sh; then
  log_info "Internal cleanup completed successfully."
else
  log_error "Internal cleanup failed."
  exit 1
fi

log_info "Cleanup  process completed successfully."

exit 0

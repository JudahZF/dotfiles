#!/bin/bash
set -euo pipefail

# Logging functions
log_info() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $1"
}

log_error() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [ERROR] $1" >&2
}

log_info "Starting rebuild process..."

# Attempt to run the internal rebuild script without sudo first.
if bash ~/dotfiles/*/_internal_rebuild.sh; then
  log_info "Internal rebuild executed successfully."
else
  log_info "Internal rebuild failed"
  exit 1
fi

# Execute additional commands that require sudo explicitly.
log_info "Loading yabai system administration..."
if sudo yabai --load-sa; then
  log_info "yabai system administration loaded."
else
  log_error "Failed to load yabai system administration."
  exit 1
fi

log_info "Restarting yabai service..."
if yabai --restart-service; then
  log_info "yabai service restarted successfully."
else
  log_error "Failed to restart yabai service."
  exit 1
fi

log_info "Running fastfetch..."
if fastfetch; then
  log_info "fastfetch executed successfully."
else
  log_error "fastfetch encountered an error."
  # Proceeding despite non-critical fastfetch failure.
fi

log_info "Rebuild script completed successfully."
exit 0

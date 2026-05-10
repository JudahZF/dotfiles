#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Logging functions
log_info() {
  printf '%s [INFO] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

log_error() {
  printf '%s [ERROR] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

log_info "Starting rebuild process..."

# Detect OS
OS=$(uname -s)

# Attempt to run the internal rebuild script without sudo first.
if bash "$SCRIPT_DIR/nix/_internal_rebuild.sh"; then
  log_info "Internal rebuild executed successfully."
else
  log_info "Internal rebuild failed"
  exit 1
fi

# Execute macOS-specific commands
if [[ "$OS" == "Darwin" ]]; then
  log_info "Loading yabai system administration..."
  if sudo yabai --load-sa; then
    log_info "yabai system administration loaded."
  else
    log_error "Failed to load yabai system administration."
  fi

  log_info "Restarting yabai service..."
  if yabai --restart-service; then
    log_info "yabai service restarted successfully."
  else
    log_error "Failed to restart yabai service."
  fi
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

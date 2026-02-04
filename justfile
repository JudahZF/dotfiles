# Dotfiles management commands
# Run `just` or `just --list` to see available recipes

# Default recipe: list available commands
default:
    @just --list

# ─────────────────────────────────────────────────────────────
# Basic Operations
# ─────────────────────────────────────────────────────────────

# Rebuild and switch to new configuration
rebuild:
    ./rebuild.sh

# Alias for rebuild
switch: rebuild

# Update flake inputs
update:
    ./update.sh

# Clean up old generations (7+ days)
clean:
    ./clean.sh

# ─────────────────────────────────────────────────────────────
# Building
# ─────────────────────────────────────────────────────────────

# Build a specific host configuration
build host:
    nix build ./nix#nixosConfigurations.{{host}}.config.system.build.toplevel

# Build Darwin configuration
build-darwin host="gale":
    nix build ./nix#darwinConfigurations.{{host}}.config.system.build.toplevel

# Build all configurations (runs flake check)
build-all: check

# Run flake check to validate all configurations
check:
    nix flake check ./nix

# Build Raspberry Pi SD card image
build-pi-image:
    nix build ./nix#images.jfpi

# ─────────────────────────────────────────────────────────────
# Server Deployment (Colmena)
# ─────────────────────────────────────────────────────────────

# Deploy to a specific server
deploy host:
    colmena apply --on {{host}}

# Deploy to all servers
deploy-all:
    colmena apply

# ─────────────────────────────────────────────────────────────
# macOS (Yabai)
# ─────────────────────────────────────────────────────────────

# Restart yabai window manager
[macos]
yabai-restart:
    yabai --restart-service

# Load yabai scripting addition (requires sudo)
[macos]
yabai-load:
    sudo yabai --load-sa

# ─────────────────────────────────────────────────────────────
# Utilities
# ─────────────────────────────────────────────────────────────

# Garbage collect generations older than specified days
gc days="7":
    nix-collect-garbage --delete-older-than {{days}}d

# Optimize nix store
optimize:
    nix store optimise

# Show flake metadata
flake-info:
    nix flake metadata ./nix

# Show flake outputs
flake-outputs:
    nix flake show ./nix

# List available host configurations
list-hosts:
    @echo "Darwin (macOS):"
    @echo "  - gale"
    @echo ""
    @echo "NixOS:"
    @echo "  - popper"
    @echo "  - zevlor"
    @echo "  - gitlab"
    @echo "  - clawdbot"
    @echo "  - jfpi"

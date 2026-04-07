# Dotfiles management commands
# Run `just` or `just --list` to see available recipes

set shell := ["bash", "-euo", "pipefail", "-c"]

flake_dir := "./nix"

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

# Build a specific NixOS host configuration
build host:
    nix build {{flake_dir}}#nixosConfigurations.{{host}}.config.system.build.toplevel

# Build a specific Darwin host configuration
build-darwin host="gale":
    nix build {{flake_dir}}#darwinConfigurations.{{host}}.config.system.build.toplevel

# Build any host by name, dispatching to the correct flake output
build-host host:
    case "{{host}}" in \
      gale) nix build {{flake_dir}}#darwinConfigurations.{{host}}.config.system.build.toplevel ;; \
      popper|zevlor|gitlab|clawdbot|jfpi) nix build {{flake_dir}}#nixosConfigurations.{{host}}.config.system.build.toplevel ;; \
      *) echo "Unknown host: {{host}}" >&2; exit 1 ;; \
    esac

# Build all configurations (runs flake check)
build-all: check

# Run flake check to validate all configurations
check:
    nix flake check {{flake_dir}}

# Build Raspberry Pi SD card image
build-pi-image:
    nix build {{flake_dir}}#images.jfpi

# Build the wrapped Neovim package for the current system
build-neovim:
    nix build {{flake_dir}}#judah-neovim

# Build a specific flake check output
build-check system check_name:
    nix build {{flake_dir}}#checks.{{system}}.{{check_name}}

# ─────────────────────────────────────────────────────────────
# Server Deployment (Colmena)
# ─────────────────────────────────────────────────────────────

# Deploy to a specific server
deploy host:
    colmena apply --config {{flake_dir}} --on {{host}}

# Deploy to all servers
deploy-all:
    colmena apply --config {{flake_dir}}

# Preview deployment changes for a specific server
deploy-dry-run host:
    colmena apply --config {{flake_dir}} --on {{host}} --dry-activate

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
    nix flake metadata {{flake_dir}}

# Show flake outputs
flake-outputs:
    nix flake show {{flake_dir}} --no-write-lock-file

# Format the Nix flake tree
fmt:
    nix fmt {{flake_dir}}

# Evaluate a host without building it
eval-host host:
    case "{{host}}" in \
      gale) nix eval {{flake_dir}}#darwinConfigurations.{{host}}.config.system.name ;; \
      popper|zevlor|gitlab|clawdbot|jfpi) nix eval {{flake_dir}}#nixosConfigurations.{{host}}.config.system.name ;; \
      *) echo "Unknown host: {{host}}" >&2; exit 1 ;; \
    esac

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

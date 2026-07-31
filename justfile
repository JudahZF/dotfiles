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

# Rebuild and switch, then clean up old generations and caches
rebuild:
    #!/usr/bin/env bash
    set -euo pipefail
    old_system=$(readlink -f /run/current-system 2>/dev/null || true)
    case "$(uname -s)" in
      Darwin)
        # yabai --install-service writes com.asmvik.yabai; nix-darwin manages
        # com.koekeishiya.yabai. Remove legacy agents so only one runs at login.
        domain="gui/$(id -u)"
        for label in com.koekeishiya.skhd com.asmvik.yabai; do
          plist="$HOME/Library/LaunchAgents/$label.plist"
          if [[ -f "$plist" ]]; then
            echo "Removing legacy $label launch agent..."
            launchctl bootout "$domain/$label" >/dev/null 2>&1 || true
            rm -f "$plist"
          fi
        done
        sudo -H darwin-rebuild switch --flake {{ flake_dir }} --max-jobs auto --cores 0
        ;;
      Linux)
        sudo -H nixos-rebuild switch --flake {{ flake_dir }} --max-jobs auto --cores 0
        ;;
      *)
        echo "Unsupported operating system: $(uname -s)" >&2
        exit 1
        ;;
    esac
    new_system=$(readlink -f /run/current-system 2>/dev/null || true)
    if command -v nvd >/dev/null 2>&1 && [[ -n "$old_system" && -n "$new_system" && "$old_system" != "$new_system" ]]; then
      nvd diff "$old_system" "$new_system" || true
    fi
    if [[ "$(uname -s)" == "Darwin" ]]; then
      sudo yabai --load-sa
      launchctl kickstart -k "gui/$(id -u)/com.koekeishiya.yabai"
      just brew-clean
    fi
    just clean
    fastfetch || true

# Alias for rebuild
switch: rebuild

# Update flake inputs (including the pinned T3 Code release)
update:
    #!/usr/bin/env bash
    set -euo pipefail
    token="${GITHUB_TOKEN:-${GH_TOKEN:-}}"
    if [[ -z "$token" ]] && command -v gh >/dev/null; then
      token=$(gh auth token --hostname github.com 2>/dev/null || true)
    fi
    if [[ -n "$token" ]]; then
      export NIX_CONFIG="${NIX_CONFIG:+$NIX_CONFIG$'\n'}extra-access-tokens = github.com=$token"
    fi
    bash {{ flake_dir }}/update-t3code.sh
    nix flake update --flake {{ flake_dir }}

# Update flake inputs, then rebuild and switch
upgrade: update rebuild

# Clean up old generations (user + system) and optimise the store
clean days="7":
    nix-collect-garbage --delete-older-than "{{ days }}d"
    sudo nix-collect-garbage --delete-older-than "{{ days }}d"
    sudo nix store optimise -v

# ─────────────────────────────────────────────────────────────
# Building
# ─────────────────────────────────────────────────────────────

# Build a specific NixOS host configuration
build host:
    nix build {{ flake_dir }}#nixosConfigurations.{{ host }}.config.system.build.toplevel

# Build a specific Darwin host configuration
build-darwin host="gale":
    nix build {{ flake_dir }}#darwinConfigurations.{{ host }}.config.system.build.toplevel

# Build any host by name, dispatching to the correct flake output
build-host host:
    case "{{ host }}" in \
      gale) nix build {{ flake_dir }}#darwinConfigurations.{{ host }}.config.system.build.toplevel ;; \
      popper|squirrel|zevlor) nix build {{ flake_dir }}#nixosConfigurations.{{ host }}.config.system.build.toplevel ;; \
      *) echo "Unknown host: {{ host }}" >&2; exit 1 ;; \
    esac

# Build all configurations (runs flake check)
build-all: check

# Run flake check to validate all configurations on all supported systems
check:
    nix flake check {{ flake_dir }} --all-systems

# Run flake check for the current system only
check-current:
    nix flake check {{ flake_dir }}

# Run local validation checks
validate: fmt-check lint-nix check-current

# Build the wrapped Neovim package for the current system
build-neovim:
    nix build {{ flake_dir }}#judah-neovim

# Build a specific flake check output
build-check system check_name:
    nix build {{ flake_dir }}#checks.{{ system }}.{{ check_name }}

# ─────────────────────────────────────────────────────────────
# Server Deployment (Colmena)
# ─────────────────────────────────────────────────────────────

# Deploy to a specific server
deploy host:
    colmena apply --config {{ flake_dir }} --on {{ host }}

# Deploy to all servers
deploy-all:
    colmena apply --config {{ flake_dir }}

# Preview deployment changes for a specific server
deploy-dry-run host:
    colmena apply --config {{ flake_dir }} --on {{ host }} --dry-activate

# ─────────────────────────────────────────────────────────────
# macOS (Yabai)
# ─────────────────────────────────────────────────────────────

# Restart yabai window manager
[macos]
yabai-restart:
    launchctl kickstart -k "gui/$(id -u)/com.koekeishiya.yabai"

# Load yabai scripting addition (requires sudo)
[macos]
yabai-load:
    sudo yabai --load-sa

# Stop or start the yabai window manager (login auto-start unaffected)
[macos]
yabai-toggle action="toggle":
    #!/usr/bin/env bash
    set -euo pipefail
    # yabai --start/--stop/--restart-service target com.asmvik.yabai (from
    # `yabai --install-service`). Drive launchctl against the nix-darwin agent.
    LABEL=com.koekeishiya.yabai
    PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
    DOMAIN="gui/$(id -u)"
    start() { launchctl bootstrap "$DOMAIN" "$PLIST"; echo "yabai started"; }
    stop() { launchctl bootout "$DOMAIN/$LABEL"; echo "yabai stopped"; }
    case "{{ action }}" in
      start) start ;;
      stop) stop ;;
      restart) launchctl kickstart -k "$DOMAIN/$LABEL"; echo "yabai restarted" ;;
      toggle) if pgrep -xq yabai; then stop; else start; fi ;;
      *) echo "usage: just yabai-toggle [start|stop|restart|toggle]" >&2; exit 1 ;;
    esac

# ─────────────────────────────────────────────────────────────
# Utilities
# ─────────────────────────────────────────────────────────────

# Garbage collect (user + system) and optimise; alias for clean
gc days="7": (clean days)

# Clean Homebrew cache (including downloads) and remove old versions
[macos]
brew-clean:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew (brew) not found on PATH." >&2
      exit 1
    fi
    cache_dir="$(brew --cache)"
    echo "Cache before: $(du -sh "$cache_dir" 2>/dev/null | awk '{print $1}') (${cache_dir})"
    brew autoremove --quiet || true
    brew cleanup -s -v
    # Wipe the full Homebrew cache (including downloads for installed
    # formulae/casks). Safe: only removes cached archives; next brew
    # install/upgrade will re-download.
    rm -rf -- "${cache_dir}"

# Optimize nix store
optimize:
    nix store optimise

# Show flake metadata
flake-info:
    nix flake metadata {{ flake_dir }}

# Show flake outputs
flake-outputs:
    nix flake show {{ flake_dir }} --no-write-lock-file

# Format the Nix flake tree
fmt:
    nix develop {{ flake_dir }} -c nixfmt nix

# Enter the Nix dotfiles development shell
dev:
    nix develop {{ flake_dir }}

# Run Nix static analysis
lint-nix:
    nix develop {{ flake_dir }} -c statix check nix
    nix develop {{ flake_dir }} -c deadnix --fail nix

# Run Nix formatter in check mode
fmt-check:
    nix develop {{ flake_dir }} -c nixfmt --check nix

# Run a full repository secrets scan
secrets-scan:
    nix develop {{ flake_dir }} -c gitleaks git --redact --no-banner --baseline-path .gitleaks-baseline.json .

# Create or edit a sops-encrypted secret in $EDITOR (encrypts on save)
secret-edit file:
    sops "{{ file }}"

# Encrypt a file with sops; point dest into secrets/ with a .enc suffix so it is stored via git-lfs
secret-encrypt src dest:
    sops encrypt --filename-override "{{ dest }}" "{{ src }}" > "{{ dest }}"

# Decrypt a sops-encrypted file
secret-decrypt src dest:
    sops decrypt "{{ src }}" > "{{ dest }}"

# Configure this repo to use its local Git hooks immediately
install-git-hooks:
    git config core.hooksPath .githooks

# Inspect the dependency tree for a flake output
nix-tree output="judah-neovim":
    nix-tree {{ flake_dir }}#{{ output }}

# Build with nicer progress output via nix-output-monitor
nom-build output:
    nom build {{ flake_dir }}#{{ output }}

# Evaluate a host without building it
eval-host host:
    case "{{ host }}" in \
      gale) nix eval {{ flake_dir }}#darwinConfigurations.{{ host }}.config.system.name ;; \
      popper|squirrel|zevlor) nix eval {{ flake_dir }}#nixosConfigurations.{{ host }}.config.system.name ;; \
      *) echo "Unknown host: {{ host }}" >&2; exit 1 ;; \
    esac

# List available host configurations
list-hosts:
    @echo "Darwin (macOS):"
    @echo "  - gale"
    @echo ""
    @echo "NixOS:"
    @echo "  - popper"
    @echo "  - squirrel"
    @echo "  - zevlor"

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

# Update flake inputs, then rebuild and switch
upgrade: update rebuild

# Clean up old generations (user + system) and optimise the store
clean days="7":
    ./clean.sh {{ days }}

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

# ─────────────────────────────────────────────────────────────
# Utilities
# ─────────────────────────────────────────────────────────────

# Garbage collect (user + system) and optimise; alias for clean
gc days="7": (clean days)

# Clean Homebrew cache (including downloads) and remove old versions
[macos]
brew-clean:
    ./brew-clean.sh

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

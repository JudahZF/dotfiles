# AGENTS.md - Coding Agent Guidelines

NixOS/nix-darwin dotfiles repository for system configuration across macOS (Darwin)
and Linux (NixOS). Uses Nix flakes for declarative, reproducible system configuration.

## Repository Overview

- **Primary Language**: Nix (`.nix` files)
- **Secondary**: Lua (Neovim), Shell scripts, JSON
- **Package Management**: Nix flakes with home-manager
- **Deployment**: Local (darwin-rebuild, nixos-rebuild), Remote (Colmena)

## Build/Rebuild Commands

```bash
# Rebuild entire system (primary command)
./rebuild.sh

# Direct rebuild commands
# macOS:
sudo -H darwin-rebuild switch --flake ~/dotfiles/nix --max-jobs auto --cores 0
# Linux:
sudo -H nixos-rebuild switch --flake ~/dotfiles/nix --max-jobs auto --cores 0

# Update flake inputs
./update.sh
# Or: nix flake update --flake ~/dotfiles/nix

# Garbage collection (removes >7 day old derivations)
./clean.sh

# Syntax/evaluation check
nix flake check ~/dotfiles/nix

# Build without switching (dry run)
darwin-rebuild build --flake ~/dotfiles/nix   # macOS
nixos-rebuild build --flake ~/dotfiles/nix    # Linux

# Remote deployment
colmena apply --on gitlab
```

## Testing Changes

No test suite. Validation workflow:
1. `nix flake check ~/dotfiles/nix` - Syntax check
2. `darwin-rebuild build --flake ~/dotfiles/nix` - Build without applying
3. `./rebuild.sh` - Full apply with service restarts

## Directory Structure

```
dotfiles/
├── nix/
│   ├── flake.nix              # Main flake definition
│   ├── lib/                   # Helpers (mkDarwin, mkNixos)
│   ├── hosts/
│   │   ├── common/all/        # Cross-platform modules
│   │   ├── common/darwin/     # macOS-specific
│   │   ├── common/nixOS/      # Linux-specific
│   │   ├── darwin/<hostname>/ # Per-machine darwin configs
│   │   └── nixos/<hostname>/  # Per-machine nixos configs
│   └── home/                  # home-manager user configs
├── nvim/                      # Neovim config (Lua)
├── zsh/                       # Shell config
├── secrets/                   # SOPS-encrypted secrets
└── *.sh                       # Rebuild/update/clean scripts
```

## Code Style Guidelines

### Nix Files

**Module Structure**:
```nix
{ inputs, pkgs, pkgs-unstable, ... }: {
  imports = [ ./module1.nix ./module2.nix ];
  # configuration...
}
```

**Formatting**: Use `nixfmt-classic` or `nixfmt-rfc-style`, 2-space indentation

**Package Lists**:
```nix
environment.systemPackages = with pkgs; [
  package1
  unstable.package2  # Use unstable for bleeding-edge
];
```

**Naming**: Module files use `snake_case.nix`, host directories are lowercase

**Platform Conditionals**:
```nix
if pkgs.stdenv.isDarwin then darwinValue else linuxValue
```

### Shell Scripts

```bash
#!/bin/sh
set -euo pipefail

log_info() { echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $1"; }
log_error() { echo "$(date +'%Y-%m-%d %H:%M:%S') [ERROR] $1" >&2; }
```

### Lua (Neovim)

- Use `require()` for module loading
- 4-space indentation
- Organize: `config/`, `plugins/`

## Common Tasks

### Adding a Package

Add to appropriate module in `nix/hosts/common/`:
```nix
environment.systemPackages = with pkgs; [ new-package ];
```

### Adding a New Host

1. Create `nix/hosts/darwin/<hostname>/default.nix` or `nix/hosts/nixos/<hostname>/`
2. Register in `flake.nix`:
```nix
darwinConfigurations.newhost = libx.mkDarwin { hostname = "newhost"; };
```

### Secrets Management

- SOPS with age encryption, config in `.sops.yaml`
- Secrets in `secrets/` directory
- **Never commit** unencrypted secrets or API keys

## Important Notes

- `rebuild.sh` restarts yabai on macOS after applying
- Use `unstable.` prefix for nixpkgs-unstable packages
- Home-manager configs: `nix/home/`
- Platform-specific: `darwin/` for macOS, `nixOS/` for Linux
- `.gitignore` excludes `.DS_Store` files

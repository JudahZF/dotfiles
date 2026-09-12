{ inputs, ... }:
let
  # Modules shared by every host, regardless of platform. Platform-specific
  # additions live in the nixosModules/darwinModules attrsets below.
  sharedDev = [
    ../dev/ai/default.nix
    ../dev/languages.nix
    ../dev/tools.nix
    ../dev/editors/neovim/module.nix
  ];
in
{
  flake = {
    nixosModules = {
      browsers.imports = [ ../browsers/default.nix ];
      communication.imports = [
        ../communication/default.nix
        ../communication/discord.nix
        ../communication/teams.nix
      ];
      desktop.imports = [
        ../desktop/plasma.nix
        ../desktop/grim.nix
        ../desktop/krdp/system.nix
        ../desktop/niri/system.nix
        ../desktop/noctalia/system.nix
      ];
      dev.imports = sharedDev ++ [
        ../dev/ai/linux.nix
        ../dev/embedded/default.nix
      ];
      fonts = import ../fonts;
      home-manager-system = import ../home/system-manager.nix;
      libraries = import ../libraries;
      neovim = import ../dev/editors/neovim/module.nix;
      networking.imports = [ ../networking/default.nix ];
      nix-config = import ../nix-config;
      nixos.imports = [
        ../nixos/audio.nix
        ../nixos/bluetooth.nix
        ../nixos/bootloader.nix
        ../nixos/docker.nix
        ../nixos/dotfiles-auto-update.nix
        ../nixos/electron-wayland.nix
        ../nixos/filesystems/btrfs.nix
        ../nixos/firmware.nix
        ../nixos/fwupd.nix
        ../nixos/hardware-health.nix
        ../nixos/initrd-ssh.nix
        ../nixos/kernel.nix
        ../nixos/localisation.nix
        ../nixos/network.nix
        ../nixos/power.nix
        ../nixos/ssh.nix
        ../networking/tailscale/system.nix
      ];
      productivity = import ../productivity;
      security.imports = [
        inputs.sops-nix.nixosModules.sops
        ../security/linux.nix
        ../security/onepassword/nixos.nix
        ../security/sops/default.nix
      ];
      shell = import ../shell;
      utilities = import ../utilities;
    };

    darwinModules = {
      browsers.imports = [ ../browsers/darwin.nix ];
      communication.imports = [
        ../communication/claude.nix
        ../communication/darwin.nix
        ../communication/discord.nix
      ];
      darwin.imports = [
        ../darwin/activation.nix
        ../darwin/defaults.nix
        ../darwin/dock.nix
        ../darwin/dotfiles-auto-update.nix
        ../darwin/finder.nix
        ../darwin/homebrew.nix
        ../darwin/keyboard.nix
        ../darwin/locale.nix
        ../darwin/login.nix
        ../darwin/mouse.nix
        ../darwin/screen_capture.nix
        ../darwin/security.nix
        ../darwin/updates.nix
        ../darwin/user.nix
        ../darwin/window_manager.nix
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-index-database.darwinModules.nix-index
      ];
      design = import ../design;
      desktop.imports = [
        ../desktop/aldente.nix
        ../desktop/darwin.nix
        ../desktop/skhd-zig/system.nix
        ../desktop/yabai/system.nix
      ];
      dev.imports = sharedDev ++ [
        ../dev/ai/darwin.nix
        ../dev/darwin.nix
        ../dev/embedded/embedded.nix
        ../dev/xcode.nix
      ];
      fonts = import ../fonts;
      gaming.imports = [
        ../gaming/default.nix
        ../gaming/steam.nix
      ];
      home-manager-system = import ../home/system-manager.nix;
      libraries = import ../libraries;
      media = import ../media;
      neovim = import ../dev/editors/neovim/module.nix;
      networking.imports = [
        ../networking/default.nix
        ../networking/darwin.nix
        ../networking/tailscale/darwin.nix
      ];
      nix-config = import ../nix-config;
      productivity.imports = [
        ../productivity/darwin.nix
        ../productivity/default.nix
      ];
      security.imports = [
        inputs.sops-nix.darwinModules.sops
        ../security/darwin.nix
        ../security/onepassword/darwin.nix
        ../security/sops/default.nix
      ];
      shell = import ../shell;
      utilities = import ../utilities;
    };

    homeModules = {
      browsers = import ../browsers/home.nix;
      desktop.imports = [ ../desktop/noctalia/home.nix ];
      home = import ../home;
      media.imports = [ ];
      neovim = import ../dev/editors/neovim/module.nix;
      security.imports = [
        ../security/onepassword/home.nix
        ../security/sops/home.nix
      ];
      utilities.imports = [
        ../utilities/atuin.nix
        ../utilities/bat.nix
        ../utilities/btop.nix
        ../utilities/direnv.nix
        ../utilities/eza.nix
        ../utilities/fastfetch.nix
        ../utilities/fd.nix
        ../utilities/fzf.nix
        ../utilities/git.nix
        ../utilities/ripgrep.nix
        ../utilities/ssh.nix
        ../utilities/starship.nix
        ../utilities/yazi.nix
        ../utilities/zoxide.nix
      ];

      user-judahf = import ../users/judahf;
      user-richf = import ../users/richf;
      user-beckf = import ../users/beckf;
      user-bigchurch = import ../users/bigchurch;
    };
  };
}

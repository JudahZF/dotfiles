{ inputs, ... }: {
  flake = {
    nixosModules = {
      browsers = {
        imports = [
          ../browsers/helium/system.nix
        ];
      };
      cli = {
        imports = [
          ../cli/git/system.nix
        ];
      };
      communication = {
        imports = [
          ../communication/discord.nix
          ../communication/signal.nix
        ];
      };
      desktop = {
        imports = [
          ../desktop/gnome.nix
          ../desktop/grim.nix
          ../desktop/hyprland/system.nix
          ../desktop/login.nix
        ];
      };
      dev = {
        imports = [
          ../dev/go/default.nix
          ../dev/python/default.nix
          ../dev/node/default.nix
          ../dev/embedded/default.nix
          ../dev/databases/default.nix
          ../dev/editors/default.nix
          ../dev/editors/neovim/module.nix
          ../dev/reverse-engineering/default.nix
          ../dev/utilities/default.nix
          ../dev/lua/default.nix
          ../dev/cmake.nix
          ../dev/claude-code.nix
          ../dev/postman.nix
          ../dev/protobuf.nix
          ../dev/ruff.nix
          ../dev/t3code.nix
          ../dev/uv.nix
        ];
      };
      fonts = import ../fonts/packages.nix;
      home-manager-system = import ../home/system-manager.nix;
      libraries = import ../libraries/packages.nix;
      neovim = import ../dev/editors/neovim/module.nix;
      nix-config = {
        imports = [
          ../nix-config/nix.nix
          ../nix-config/nixpkgs.nix
        ];
      };
      nixos = {
        imports = [
          ../nixos/audio.nix
          ../nixos/bluetooth.nix
          ../nixos/bootloader.nix
          ../nixos/docker.nix
          ../nixos/kernel.nix
          ../nixos/localisation.nix
          ../nixos/network.nix
          ../nixos/packages.nix
          ../nixos/ssh.nix
          ../nixos/tailscale.nix
        ];
      };
      security = {
        imports = [
          ../security/onepassword/system.nix
        ];
      };
      secrets = import ../secrets/sops.nix;
      shell = import ../shell/system.nix;
    };

    darwinModules = {
      browsers = {
        imports = [
          ../browsers/safari/system.nix
        ];
      };
      cli = {
        imports = [
          ../cli/git/system.nix
        ];
      };
      communication = {
        imports = [
          ../communication/signal.nix
        ];
      };
      darwin = {
        imports = [
          ../darwin/activation.nix
          ../darwin/aldente.nix
          ../darwin/defaults.nix
          ../darwin/dock.nix
          ../darwin/finder.nix
          ../darwin/homebrew.nix
          ../darwin/keyboard.nix
          ../darwin/login.nix
          ../darwin/mouse.nix
          ../darwin/packages.nix
          ../darwin/screen_capture.nix
          ../darwin/security.nix
          ../darwin/updates.nix
          ../darwin/user.nix
          ../darwin/window_manager.nix
          inputs.home-manager.darwinModules.home-manager
          inputs.nix-index-database.darwinModules.nix-index
        ];
      };
      dev = {
        imports = [
          ../dev/go/default.nix
          ../dev/python/default.nix
          ../dev/node/default.nix
          ../dev/embedded/default.nix
          ../dev/databases/default.nix
          ../dev/editors/default.nix
          ../dev/editors/neovim/module.nix
          ../dev/reverse-engineering/default.nix
          ../dev/utilities/default.nix
          ../dev/lua/default.nix
          ../dev/cmake.nix
          ../dev/claude-code.nix
          ../dev/postman.nix
          ../dev/protobuf.nix
          ../dev/ruff.nix
          ../dev/t3code.nix
          ../dev/uv.nix
        ];
      };
      fonts = import ../fonts/packages.nix;
      home-manager-system = import ../home/system-manager.nix;
      libraries = import ../libraries/packages.nix;
      media = {
        imports = [
          ../media/music/system.nix
        ];
      };
      neovim = import ../dev/editors/neovim/module.nix;
      nix-config = {
        imports = [
          ../nix-config/nix.nix
          ../nix-config/nixpkgs.nix
        ];
      };
      security = {
        imports = [
          ../security/onepassword/system.nix
        ];
      };
      secrets = import ../secrets/sops.nix;
      shell = import ../shell/system.nix;
    };

    homeModules = {
      browsers = {
        imports = [
          ../browsers/zen/home.nix
        ];
      };
      cli = {
        imports = [
          ../cli/atuin.nix
          ../cli/bat.nix
          ../cli/btop.nix
          ../cli/direnv.nix
          ../cli/eza.nix
          ../cli/fastfetch.nix
          ../cli/fd.nix
          ../cli/fzf.nix
          ../cli/git/home.nix
          ../cli/ripgrep.nix
          ../cli/ssh.nix
          ../cli/starship.nix
          ../cli/yazi.nix
          ../cli/zig.nix
          ../cli/zoxide.nix
        ];
      };
      desktop = {
        imports = [
          ../desktop/hyprland/home.nix
          ../desktop/swww.nix
          ../desktop/walker.nix
          ../desktop/waybar.nix
        ];
      };
      home = {
        imports = [
          ../home/base.nix
          ../home/session-path.nix
          ../home/state-version.nix
        ];
      };
      media = {
        imports = [
          ../media/cider/home.nix
        ];
      };
      neovim = import ../dev/editors/neovim/module.nix;
      security = {
        imports = [
          ../security/onepassword/home.nix
        ];
      };
      user-judahf = import ../users/judahf;
      user-richf = import ../users/richf;
      user-beckf = import ../users/beckf;
    };
  };
}

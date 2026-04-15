{ inputs, ... }:
{
  flake = {
    nixosModules = {
      browsers = {
        imports = [
          ../browsers/helium/system.nix
        ];
      };
      utilities = {
        imports = [
          ../utilities/git/default.nix
          ../utilities/btop/default.nix
          ../utilities/comma.nix
          ../utilities/coreutils.nix
          ../utilities/curl.nix
          ../utilities/difftastic.nix
          ../utilities/dua.nix
          ../utilities/entr.nix
          ../utilities/fastfetch/default.nix
          ../utilities/fd/default.nix
          ../utilities/fzf/default.nix
          ../utilities/just.nix
          ../utilities/ripgrep/default.nix
          ../utilities/starship/default.nix
          ../utilities/unzip.nix
          ../utilities/wget.nix
          ../utilities/zellij.nix
          ../utilities/zoxide/default.nix
        ];
      };
      communication = {
        imports = [
          ../communication/discord.nix
          ../communication/meshtastic.nix
        ];
      };
      desktop = {
        imports = [
          ../desktop/gnome.nix
          ../desktop/grim.nix
          ../desktop/hyprland/system.nix
          ../desktop/niri/system.nix
          ../desktop/login.nix
          ../desktop/noctalia/system.nix
        ];
      };
      dev = {
        imports = [
          ../dev/ai/default.nix
          ../dev/bootdev-cli.nix
          ../dev/go/default.nix
          ../dev/python/default.nix
          ../dev/node/default.nix
          ../dev/embedded/default.nix
          ../dev/databases/default.nix
          ../dev/editors/default.nix
          ../dev/editors/neovim/module.nix
          ../dev/zig.nix
          ../dev/reverse-engineering/default.nix
          ../dev/utilities/default.nix
          ../dev/lua/default.nix
          ../dev/cmake.nix
          ../dev/postman.nix
          ../dev/protobuf.nix
        ];
      };
      fonts = import ../fonts/nerd-fonts;
      home-manager-system = import ../home/system-manager.nix;
      libraries = {
        imports = [
          ../libraries/ffmpeg.nix
          ../libraries/openssl.nix
          ../libraries/tree-sitter.nix
        ];
      };
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
          ../nixos/filesystems/btrfs.nix
          ../nixos/firmware.nix
          ../nixos/fwupd.nix
          ../nixos/kernel.nix
          ../nixos/localisation.nix
          ../nixos/network.nix
          ../nixos/ssh.nix
          ../networking/tailscale/system.nix
        ];
      };
      security = {
        imports = [
          ../security/onepassword/nixos.nix
        ];
      };
      secrets = import ../secrets/sops.nix;
      shell = {
        imports = [
          ../shell/bash.nix
          ../shell/zsh.nix
        ];
      };
    };

    darwinModules = {
      browsers = {
        imports = [
          ../browsers/helium/system.nix
          ../browsers/safari
          ../browsers/zen/system.nix
        ];
      };
      utilities = {
        imports = [
          ../utilities/git/default.nix
          ../utilities/btop/default.nix
          ../utilities/comma.nix
          ../utilities/coreutils.nix
          ../utilities/curl.nix
          ../utilities/difftastic.nix
          ../utilities/dua.nix
          ../utilities/entr.nix
          ../utilities/fastfetch/default.nix
          ../utilities/fd/default.nix
          ../utilities/fzf/default.nix
          ../utilities/just.nix
          ../utilities/ripgrep/default.nix
          ../utilities/starship/default.nix
          ../utilities/unzip.nix
          ../utilities/wget.nix
          ../utilities/zellij.nix
          ../utilities/zoxide/default.nix
        ];
      };
      communication = {
        imports = [
          ../communication/whatsapp.nix
        ];
      };
      darwin = {
        imports = [
          ../darwin/activation.nix
          ../darwin/defaults.nix
          ../darwin/dock.nix
          ../darwin/finder.nix
          ../darwin/homebrew.nix
          ../darwin/keyboard.nix
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
      };
      design = {
        imports = [
          ../design/affinity.nix
          ../design/autodesk-fusion.nix
          ../design/gimp.nix
          ../design/kicad.nix
          ../design/orcaslicer.nix
          ../design/pika.nix
          ../design/sketch.nix
        ];
      };
      desktop = {
        imports = [
          ../desktop/aldente.nix
          ../desktop/alt-tab.nix
          ../desktop/amphetamine.nix
          ../desktop/bartender.nix
          ../desktop/betterdisplay.nix
          ../desktop/displaperture.nix
          ../desktop/ghostty.nix
          ../desktop/hiddenbar.nix
          ../desktop/hyperkey.nix
          ../desktop/macmon.nix
          ../desktop/raycast.nix
          ../desktop/skhd-zig/system.nix
          ../desktop/stats.nix
          ../desktop/yabai/system.nix
        ];
      };
      dev = {
        imports = [
          ../dev/ai/default.nix
          ../dev/ai/darwin.nix
          ../dev/bootdev-cli.nix
          ../dev/go/default.nix
          ../dev/python/default.nix
          ../dev/node/default.nix
          ../dev/embedded/embedded.nix
          ../dev/embedded/darwin.nix
          ../dev/databases/default.nix
          ../dev/databases/datagrip/darwin.nix
          ../dev/editors/default.nix
          ../dev/editors/neovim/module.nix
          ../dev/zig.nix
          ../dev/reverse-engineering/default.nix
          ../dev/utilities/default.nix
          ../dev/lua/default.nix
          ../dev/cmake.nix
          ../dev/postman.nix
          ../dev/protobuf.nix
          ../dev/azure-cli.nix
          ../dev/balenaetcher.nix
          ../dev/docker-desktop.nix
          ../dev/graphite.nix
          ../dev/mas.nix
          ../dev/mqttx.nix
          ../dev/musl-cross.nix
          ../dev/raspberry-pi-imager.nix
          ../dev/xcode.nix
        ];
      };
      fonts = import ../fonts/nerd-fonts;
      gaming = {
        imports = [
          ../gaming/game-porting-toolkit.nix
          ../gaming/minecraft.nix
          ../gaming/steam.nix
          ../gaming/tetris.nix
        ];
      };
      home-manager-system = import ../home/system-manager.nix;
      libraries = {
        imports = [
          ../libraries/ffmpeg.nix
          ../libraries/openssl.nix
          ../libraries/tree-sitter.nix
        ];
      };
      media = {
        imports = [
          ../media
        ];
      };
      neovim = import ../dev/editors/neovim/module.nix;
      networking = {
        imports = [
          ../networking/angry-ip-scanner.nix
          ../networking/barrier.nix
          ../networking/nomachine.nix
          ../networking/tailscale/darwin.nix
          ../networking/unifi-identity-endpoint.nix
          ../networking/wifiman.nix
          ../networking/wireshark-app.nix
        ];
      };
      nix-config = {
        imports = [
          ../nix-config/nix.nix
          ../nix-config/nixpkgs.nix
        ];
      };
      productivity = {
        imports = [
          ../productivity/daisydisk.nix
          ../productivity/dropbox.nix
          ../productivity/home-assistant-companion.nix
          ../productivity/keka.nix
          ../productivity/microsoft-office.nix
          ../productivity/quicklook.nix
          ../productivity/wispr-flow.nix
        ];
      };
      security = {
        imports = [
          ../security/malwarebytes.nix
          ../security/onepassword/darwin.nix
          ../security/private-internet-access.nix
        ];
      };
      secrets = import ../secrets/sops.nix;
      shell = {
        imports = [
          ../shell/bash.nix
          ../shell/zsh.nix
        ];
      };
    };

    homeModules = {
      browsers = {
        imports = [
          ../browsers/zen/home.nix
        ];
      };
      utilities = {
        imports = [
          ../utilities/atuin.nix
          ../utilities/bat.nix
          ../utilities/btop/home.nix
          ../utilities/direnv.nix
          ../utilities/eza.nix
          ../utilities/fastfetch/home.nix
          ../utilities/fd/home.nix
          ../utilities/fzf/home.nix
          ../utilities/git/home.nix
          ../utilities/ripgrep/home.nix
          ../utilities/ssh.nix
          ../utilities/starship/home.nix
          ../utilities/yazi.nix
          ../utilities/zoxide/home.nix
        ];
      };
      desktop = {
        imports = [
          ../desktop/noctalia/home.nix
        ];
      };
      hyprland = {
        imports = [
          ../desktop/hyprland/home.nix
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

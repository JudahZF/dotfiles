{
  config,
  dotfiles,
  username,
  pkgs,
  ...
}:
{
  home = {
    homeDirectory = "/Users/${username}";

    file = {
      sketchybar = {
        recursive = true;
        source = "${dotfiles}/sketchybar";
        target = ".config/sketchybar";
      };
      skhd = {
        source = "${dotfiles}/skhdrc";
        target = ".config/skhd/skhdrc";
      };
      yabai = {
        source = "${dotfiles}/yabairc";
        target = ".config/yabai/yabairc";
      };
    };
  };

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
    channel.enable = false;
  };

  # programs.zsh = {
  #   promptInit = builtins.readFile "${dotfiles}/zsh/macos/zshrc";
  # };

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    activationScripts = {
      activationScripts.applications.text =
        let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
          };
        in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';
      postUserActivation.text = ''
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    stateVersion = 5;
  };

  users.users.${username}.home = "/Users/${username}";
}

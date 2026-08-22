{ lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nh
    nil
    nix
    nixd
    nix-index
    nix-output-monitor
    nvd
  ];

  nix = {
    channel.enable = false;
    enable = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      dates = "weekly";
      randomizedDelaySec = "1h";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      # Daily, since a weekly 3 AM slot is usually missed while the machine
      # sleeps. launchd runs missed jobs on wake.
      interval = {
        Hour = 3;
        Minute = 15;
      };
    };
    optimise = {
      automatic = true;
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      # Daily, an hour after gc (see above).
      interval = {
        Hour = 4;
        Minute = 15;
      };
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org/"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
      trusted-users = [
        "root"
        "@wheel"
        "@admin"
      ];
      warn-dirty = false;
    };
  };
}

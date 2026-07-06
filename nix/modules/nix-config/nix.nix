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
      options = "--delete-older-than 14d";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      dates = "weekly";
      randomizedDelaySec = "1h";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 15;
      };
    };
    optimise.automatic = true;
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
        "cache.nixos.org-1:6NCHdD59X431o0gWzR0w7WEKfFHwBgmAwFQ7RGVy9zM="
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

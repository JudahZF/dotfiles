{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nil
    nix
    nixd
    nix-index
  ];

  nix = {
    channel.enable = false;
    enable = true;
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
      ];
      warn-dirty = false;
    };
  };
}

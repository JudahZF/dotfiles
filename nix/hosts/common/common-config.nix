{
  lib,
  pkgs,
  system,
  username,
  inputs,
  ...
}:
{
  environment.systemPackages = [ pkgs.mkalias ];

  nix = {
    channel.enable = false;
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${system}";
  };

  system.primaryUser = username;
}

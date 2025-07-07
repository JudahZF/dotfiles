{ inputs, outputs, config, lib, hostname, system, username, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  environment.systemPackages = [
    pkgs.mkalias
  ];

  home-manager.backupFileExtension = "bck";

  nix = {
    channel.enable = false;
    enable = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${system}";
  };

  services.nix-daemon.enable = true;

  system = {
    stateVersion = "25.05";
  };
}

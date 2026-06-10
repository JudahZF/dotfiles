{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
  ];

  nix-zerobrew.casks = [ "1password" ];
}

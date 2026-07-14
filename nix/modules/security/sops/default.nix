{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}

{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.opentofu ];
}

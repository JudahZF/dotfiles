{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.unzip ];
}

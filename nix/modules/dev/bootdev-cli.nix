{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.bootdev-cli ];
}

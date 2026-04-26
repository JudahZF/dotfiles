{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.libpq ];
}

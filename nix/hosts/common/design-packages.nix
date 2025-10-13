{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # gimp
    # kicad
    # prusa-slicer
  ];
}

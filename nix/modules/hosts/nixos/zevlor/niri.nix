{ pkgs, self, ... }:
{
  programs.niri.package = self.packages.${pkgs.system}.niri-zevlor;
}

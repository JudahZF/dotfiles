{ pkgs, self, ... }: {
  programs.niri.package =
    self.packages.${pkgs.stdenv.hostPlatform.system}.niri-zevlor;
}

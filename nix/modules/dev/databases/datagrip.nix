{ pkgs, lib, ... }: {
  environment.systemPackages = [ pkgs.jetbrains.datagrip ];
} // lib.optionalAttrs pkgs.stdenv.isDarwin {
  homebrew.casks = [ "datagrip" ];
}

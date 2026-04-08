{ pkgs, lib, options, ... }:
(lib.optionalAttrs (pkgs.stdenv.isLinux && options ? services.tailscale.enable) {
  services.tailscale.enable = true;
})
// (lib.optionalAttrs (pkgs.stdenv.isDarwin && options ? homebrew.casks) {
  homebrew.casks = [ "tailscale-app" ];
})

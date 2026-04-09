{ pkgs, lib, ... }:
lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [
      signal-cli
    ] ++ lib.optionals pkgs.stdenv.isLinux [ signal-desktop ];
  }
  (lib.mkIf pkgs.stdenv.isDarwin {
    homebrew.casks = [ "signal" ];
  })
]

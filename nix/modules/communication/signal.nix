{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    signal-cli
  ] ++ (
    if pkgs.stdenv.isLinux then [ signal-desktop ] else [ ]
  );
} // lib.optionalAttrs pkgs.stdenv.isDarwin {
  homebrew.casks = [ "signal" ];
}

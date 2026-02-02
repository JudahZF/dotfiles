{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    signal-cli
  ] ++ (
    if pkgs.stdenv.isLinux then [ signal-desktop ] else [ ]
  );
}

{ pkgs, lib, inputs, ... }:
let
  # Check if zen-browser is available for this system
  zenBrowserAvailable = inputs.zen-browser.packages ? ${pkgs.system};
in {
  environment.systemPackages = with pkgs; [
    beszel # server monitoring
    cmatrix
    codex # openai coding agent cli
    colmena # nix server deployment
    iperf3
    nmap
    obsidian
    remmina
    temurin-bin
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    mkalias
  ] ++ lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.hostPlatform.isx86_64) [
    google-chrome # x86_64-linux only
  ] ++ lib.optionals zenBrowserAvailable [
    (inputs.zen-browser.packages.${pkgs.system}.default)
  ];
}

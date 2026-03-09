{ pkgs, lib, inputs, ... }:
let
  # Check if zen-browser is available for this system
  zenBrowserAvailable = inputs.zen-browser.packages ? ${pkgs.system};
in {
  environment.systemPackages = with pkgs; [
    beszel # server monitoring
    cmatrix
    codex
    colmena # nix server deployment
    iperf3
    nmap
    obsidian
    remmina
    temurin-bin
    turbo # turborepo cli
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    mkalias
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    libreoffice # NixOS only
  ] ++ lib.optionals (inputs.helium-browser.packages ? ${pkgs.system}) [
    (inputs.helium-browser.packages.${pkgs.system}.default)
  ] ++ lib.optionals zenBrowserAvailable [
    (inputs.zen-browser.packages.${pkgs.system}.default)
  ];
}

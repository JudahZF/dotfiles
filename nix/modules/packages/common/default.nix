{ pkgs, lib, inputs, ... }:
let
  zenBrowserAvailable = inputs.zen-browser.packages ? ${pkgs.system};
  heliumAvailable = inputs.helium-browser.packages ? ${pkgs.system};
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
    waifu2x-converter-cpp
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    mkalias
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    libreoffice # NixOS only
  ] ++ lib.optionals heliumAvailable [
    (inputs.helium-browser.packages.${pkgs.system}.default)
  ] ++ lib.optionals zenBrowserAvailable [
    (inputs.zen-browser.packages.${pkgs.system}.default)
  ];
}

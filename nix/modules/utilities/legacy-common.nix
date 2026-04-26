{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    beszel
    cmatrix
    colmena
    iperf3
    nmap
    temurin-bin
    turbo
    waifu2x-converter-cpp
  ];
}

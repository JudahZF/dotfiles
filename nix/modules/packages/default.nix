{ pkgs, lib, ... }: {
  imports = [
    ./common
    ./dev
    ./design
    ./music
    ./production
    ./uni
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ./gaming
  ];
}

{ lib, ... }:
{
  imports = [
    ./flake
    ./browsers
    ./communication
    ./darwin
    ./design
    ./desktop
    ./dev
    ./fonts
    ./gaming
    ./home
    ./libraries
    ./nix-config
    ./networking
    ./nixos
    ./productivity
    ./secrets
    ./security
    ./shell
    ./utilities
    ./users
    ./hosts/darwin/gale
    ./hosts/nixos/popper
    ./hosts/nixos/zevlor
  ]
  ++ lib.optionals (builtins.pathExists ./production) [ ./production ]
  ++ lib.optionals (builtins.pathExists ./hosts/nixos/jfpi) [ ./hosts/nixos/jfpi ];
}

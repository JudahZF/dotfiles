{ ... }: {
  imports = [
    ./flake
    ./browsers
    ./cli
    ./communication
    ./darwin
    ./desktop
    ./dev
    ./fonts
    ./home
    ./libraries
    ./media
    ./nix-config
    ./nixos
    ./secrets
    ./security
    ./shell
    ./users
    ./hosts/darwin/gale
    ./hosts/nixos/clawdbot
    ./hosts/nixos/gitlab
    ./hosts/nixos/jfpi
    ./hosts/nixos/popper
    ./hosts/nixos/zevlor
  ];
}

{ inputs, ... }: {
  imports = [
    ./fonts.nix
    ./home_manager.nix
    ./libraries.nix
    ./nix.nix
    ./nixpkgs.nix
    ./shell.nix
    ./sops.nix
    # Darwin-specific
    ./darwin
    # NixOS-specific
    ./nixos
  ];
}

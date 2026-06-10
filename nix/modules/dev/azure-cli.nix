{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.brews = [ "azure-cli" ];
  environment.systemPackages = [ pkgs.kubelogin ];
}

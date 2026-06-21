{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.brews = [ "azure-cli" ];
  environment.systemPackages = [ pkgs.kubelogin ];
}

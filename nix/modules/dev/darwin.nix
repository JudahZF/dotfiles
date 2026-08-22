{
  pkgs,
  pkgs-unstable ? null,
  lib,
  ...
}:
let
  dotnetPkgs = if pkgs-unstable != null then pkgs-unstable else pkgs;
in
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [
      "balenaetcher"
      "datagrip"
      "docker-desktop"
      "mqttx"
      "raspberry-pi-imager"
      "silicon-labs-vcp-driver"
      "utm"
    ];

    brews = [
      "azure-cli"
      "FiloSottile/musl-cross/musl-cross"
      "mas"
      "withgraphite/tap/graphite"
    ];
  };

  environment.systemPackages = [
    dotnetPkgs.dotnet-sdk_9
    pkgs.kubelogin
    (import ../../packages/cmux.nix { inherit pkgs lib; })
  ];
}

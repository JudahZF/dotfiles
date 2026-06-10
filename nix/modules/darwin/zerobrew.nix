{
  inputs,
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew = {
    enable = true;
    mutableTaps = true;

    taps = {
      "bevanjkay/homebrew-tap" = inputs.homebrew-bevanjkay-tap;
      "Gcenx/homebrew-wine" = inputs.homebrew-gcenx-wine;
      "FiloSottile/homebrew-musl-cross" = inputs.homebrew-filosottile-musl-cross;
      "withgraphite/homebrew-tap" = inputs.homebrew-withgraphite-tap;
      "steipete/homebrew-tap" = inputs.homebrew-steipete-tap;
      "koekeishiya/homebrew-formulae" = inputs.homebrew-koekeishiya-formulae;
      "jackielii/homebrew-tap" = inputs.homebrew-jackielii-tap;
      "FelixKratz/homebrew-formulae" = inputs.homebrew-felixkratz-formulae;
    };

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}

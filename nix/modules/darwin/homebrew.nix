{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  taps = {
    "bevanjkay/homebrew-tap" = inputs.homebrew-bevanjkay-tap;
    "FelixKratz/homebrew-formulae" = inputs.homebrew-felixkratz-formulae;
    "FiloSottile/homebrew-musl-cross" = inputs.homebrew-filosottile-musl-cross;
    "Gcenx/homebrew-wine" = inputs.homebrew-gcenx-wine;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "jackielii/homebrew-tap" = inputs.homebrew-jackielii-tap;
    "koekeishiya/homebrew-formulae" = inputs.homebrew-koekeishiya-formulae;
    "samtay/homebrew-tui" = inputs.homebrew-samtay-tui;
    "steipete/homebrew-tap" = inputs.homebrew-steipete-tap;
    "TheBoredTeam/homebrew-boring-notch" = inputs.homebrew-boring-notch;
    "withgraphite/homebrew-tap" = inputs.homebrew-withgraphite-tap;
  };
in
lib.mkIf pkgs.stdenv.isDarwin {
  nix-homebrew = {
    mutableTaps = false;
    inherit taps;

    trust = {
      formulae = [
        "FiloSottile/musl-cross/musl-cross"
        "samtay/tui/tetris"
        "withgraphite/tap/graphite"
      ];
      casks = [
        "jackielii/tap/skhd-zig"
        "steipete/tap/codexbar"
        "TheBoredTeam/boring-notch/boring-notch"
      ];
    };
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
}

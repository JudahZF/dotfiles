{
  config,
  lib,
  pkgs,
  self,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux (
  let
    wallpapersSource = pkgs.writeText "noctalia-wallpapers.json" "{}\n";
  in
  {
    home.packages = [ self.packages.${pkgs.system}.noctalia-shell-wrapped ];

    home.activation.noctaliaManagedFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/noctalia" "$HOME/.cache/noctalia"
      cp ${./settings.json} "$HOME/.config/noctalia/settings.json"
      chmod u+w "$HOME/.config/noctalia/settings.json"

      if [ ! -e "$HOME/.cache/noctalia/wallpapers.json" ]; then
        cp ${wallpapersSource} "$HOME/.cache/noctalia/wallpapers.json"
        chmod u+w "$HOME/.cache/noctalia/wallpapers.json"
      fi
    '';
  }
)

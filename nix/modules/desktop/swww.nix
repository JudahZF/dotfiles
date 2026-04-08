{ pkgs, config, ... }:
let
  wallpaperDir = "${config.home.homeDirectory}/dotfiles/wallpapers";

  wallpaper-cycle = pkgs.writeShellScriptBin "wallpaper-cycle" ''
    WALLPAPER_DIR="${wallpaperDir}"

    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo "Wallpaper directory not found: $WALLPAPER_DIR"
      exit 1
    fi

    # Find all image files
    mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \))

    if [ ''${#WALLPAPERS[@]} -eq 0 ]; then
      echo "No wallpapers found in $WALLPAPER_DIR"
      exit 1
    fi

    # Select random wallpaper
    RANDOM_INDEX=$((RANDOM % ''${#WALLPAPERS[@]}))
    SELECTED="''${WALLPAPERS[$RANDOM_INDEX]}"

    echo "Setting wallpaper: $SELECTED"
    ${pkgs.swww}/bin/swww img "$SELECTED" \
      --transition-type grow \
      --transition-pos center \
      --transition-duration 2
  '';
in
{
  home.packages = [
    pkgs.swww
    wallpaper-cycle
  ];

  systemd.user.services.wallpaper-cycle = {
    Unit = {
      Description = "Cycle desktop wallpaper";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${wallpaper-cycle}/bin/wallpaper-cycle";
    };
  };

  systemd.user.timers.wallpaper-cycle = {
    Unit = {
      Description = "Cycle desktop wallpaper periodically";
    };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

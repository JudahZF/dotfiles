{ pkgs, config, ... }:
let
  wallpaperDir = "${config.home.homeDirectory}/dotfiles/wallpapers";

  wallpaper-cycle = pkgs.writeShellScriptBin "wallpaper-cycle" ''
    WALLPAPER_DIR="${wallpaperDir}"
    NOCTALIA_CACHE_DIR="$HOME/.cache/noctalia"
    NOCTALIA_WALLPAPERS="$NOCTALIA_CACHE_DIR/wallpapers.json"

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

    mkdir -p "$NOCTALIA_CACHE_DIR"
    OUTPUT_JSON=$(
      {
        ${pkgs.swww}/bin/swww query 2>/dev/null || true
      } | while IFS=: read -r output _; do
        if [ -n "$output" ]; then
          printf '%s\n' "$output"
        fi
      done | ${pkgs.jq}/bin/jq -Rn --arg wallpaper "$SELECTED" '
        [inputs | select(length > 0)] as $outputs
        | if ($outputs | length) == 0 then
            ["HDMI-A-3", "HDMI-A-2"]
          else
            $outputs
          end
        | reduce .[] as $output ({}; .[$output] = { light: $wallpaper, dark: $wallpaper })
      '
    )
    printf '%s\n' "$OUTPUT_JSON" > "$NOCTALIA_WALLPAPERS"
  '';
in
{
  home.packages = [
    pkgs.jq
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

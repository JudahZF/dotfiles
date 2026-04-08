{ config, pkgs, lib, ... }: lib.mkIf pkgs.stdenv.isLinux {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions \
            --remember \
            --remember-user-session \
            --time \
            --issue \
            --width 80 \
            --theme 'border=magenta;text=white;time=cyan;prompt=green;input=white;action=magenta;button=cyan;container=black;title=blue;greet=cyan'
        '';
        user = "judahf";
      };
    };
  };
}

{ config, pkgs, ... }: {
  # Nix logo + hostname for tuigreet
  environment.etc."issue".text = ''

                     [38;5;117m▜███████████████████████████████████████████████████████▛[0m

                                        [38;5;117m⣠⣤⣤⣤⣤⣤⣤⡀[0m
                                      [38;5;117m⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆[0m
                                    [38;5;117m⣠⣾⣿⣿⣿⣿⠟⠁[0m [38;5;183m⠈⠻⣿⣿⣷⣄[0m
                                  [38;5;117m⢀⣾⣿⣿⣿⡿⠃[0m     [38;5;183m⠘⣿⣿⣿⣷⡀[0m
                                  [38;5;117m⣾⣿⣿⣿⣿⠁[0m   [38;5;117m⣷⣄[0m [38;5;183m⠈⣿⣿⣿⣿⣷[0m
                                  [38;5;117m⣿⣿⣿⣿⣿[0m   [38;5;117m⣿⣿⣦[0m [38;5;183m⣿⣿⣿⣿⣿[0m
                                  [38;5;183m⢻⣿⣿⣿⣿⣆[0m [38;5;117m⠸⣿⣿⣿[38;5;183m⣸⣿⣿⣿⣿⡟[0m
                                   [38;5;183m⠻⣿⣿⣿⣿⣷⣄[0m [38;5;117m⠙[0m [38;5;183m⣴⣿⣿⣿⣿⠟[0m
                                    [38;5;183m⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋[0m
                                      [38;5;183m⠙⠿⣿⣿⣿⣿⣿⠿⠋[0m
                                         [38;5;183m⠉⠉⠉⠉[0m

                     [38;5;117m▜███████████████████████████████████████████████████████▛[0m

                                        [1;38;5;183mWelcome to \n[0m

  '';

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

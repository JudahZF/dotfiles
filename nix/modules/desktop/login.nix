{ config, pkgs, lib, ... }:
let
  esc = "\\e";
  blue = "${esc}[38;5;117m";
  purple = "${esc}[38;5;183m";
  bold_purple = "${esc}[1;38;5;183m";
  reset = "${esc}[0m";
in lib.mkIf pkgs.stdenv.isLinux {
  environment.etc."issue".text = ''

              ${blue}▗▄▄▄       ${purple}▗▄▄▄▄    ▄▄▄▖${reset}
              ${blue}▜███▙       ${purple}▜███▙  ▟███▛${reset}
               ${blue}▜███▙       ${purple}▜███▙▟███▛${reset}
                ${blue}▜███▙       ${purple}▜██████▛${reset}
         ${blue}▟█████████████████▙ ${purple}▜████▛     ${blue}▟▙${reset}
        ${blue}▟███████████████████▙ ${purple}▜███▙    ${blue}▟██▙${reset}
               ${purple}▄▄▄▄▖           ▜███▙  ${blue}▟███▛${reset}
              ${purple}▟███▛             ▜██▛ ${blue}▟███▛${reset}
             ${purple}▟███▛               ▜▛ ${blue}▟███▛${reset}
    ${purple}▟███████████▛                  ${blue}▟██████████▙${reset}
    ${purple}▜██████████▛                  ${blue}▟███████████▛${reset}
          ${purple}▟███▛ ${blue}▟▙               ▟███▛${reset}
         ${purple}▟███▛ ${blue}▟██▙             ▟███▛${reset}
        ${purple}▟███▛  ${blue}▜███▙           ▝▀▀▀▀${reset}
        ${purple}▜██▛    ${blue}▜███▙ ${purple}▜██████████████████▛${reset}
         ${purple}▜▛     ${blue}▟████▙ ${purple}▜████████████████▛${reset}
               ${blue}▟██████▙       ${purple}▜███▙${reset}
              ${blue}▟███▛▜███▙       ${purple}▜███▙${reset}
             ${blue}▟███▛  ▜███▙       ${purple}▜███▙${reset}
             ${blue}▝▀▀▀    ▀▀▀▀▘       ${purple}▀▀▀▘${reset}

                        ${bold_purple}Welcome to \n${reset}

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

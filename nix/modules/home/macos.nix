{ config, pkgs, ... }:

{
    home = {
        username = "judahfuller";
        homeDirectory = "/Users/judahfuller";
        stateVersion = "23.05"; # Please read the comment before changing.

        # Makes sense for user specific applications that shouldn't be available system-wide
        packages = [
        ];

        # Home Manager is pretty good at managing dotfiles. The primary way to manage
        # plain files is through 'home.file'.
        file = {
            ".config/sketchybar".source = ~/dotfiles/sketchybar;
            "~/Library/Fonts".source = ~/dotfiles/fonts;
            ".config/nix".source = ~/dotfiles/nix;
        };

        sessionVariables = {
        };

        sessionPath = [
        "/run/current-system/sw/bin"
            "$HOME/.nix-profile/bin"
        ];
    };
    programs.home-manager.enable = true;
    programs.zsh = {
        enable = true;
        initExtra = ''
            # Add any additional configurations here
            export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
            if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
            fi
        '';
    };
}

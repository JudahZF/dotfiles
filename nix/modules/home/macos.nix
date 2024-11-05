{ config, pkgs, ... }:

{
    home = {
        username = "judahfuller";
        homeDirectory = "/Users/judahfuller";
        stateVersion = "23.05"; # Please read the comment before changing.

        # Makes sense for user specific applications that shouldn't be available system-wide
        packages = [];

        # Home Manager is pretty good at managing dotfiles. The primary way to manage
        # plain files is through 'home.file'.
        file = {
            ".config/fastfetch".source = ~/dotfiles/fastfetch;
            ".config/nix".source = ~/dotfiles/nix;
            ".config/nvim".source = ~/dotfiles/nvim;
            ".config/sketchybar".source = ~/dotfiles/sketchybar;
            ".config/yabai".source = ~/dotfiles/yabai;
            ".zprofile".source = ~/dotfiles/zsh/macos/zprofile;
            ".zshenv".source = ~/dotfiles/zsh/macos/zshenv;
            ".zshrc".source = ~/dotfiles/zsh/macos/zshrc;
        };

        sessionVariables = {};

        sessionPath = [
        "/run/current-system/sw/bin"
            "$HOME/.nix-profile/bin"
        ];
    };
    programs.home-manager.enable = true;
}

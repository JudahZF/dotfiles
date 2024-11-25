{
    ...
}: {
    home = {
        username = "judahfuller";
        homeDirectory = "/Users/judahfuller";
        stateVersion = "24.05";

        # Home Manager is pretty good at managing dotfiles. The primary way to manage
        # plain files is through 'home.file'.
        file = {
            fastfetch = {
                source = ~/dotfiles/fastfetch/config.jsonc;
                target = ".config/fastfetch/config.jsonc";
            };
            gitconfig = {
                source = ~/dotfiles/git/macos;
                target = ".gitconfig";
            };
            nix = {
                recursive = true;
                source = ~/dotfiles/nix;
                target = ".config/nix";
            };
            nvim = {
                recursive = true;
                source = ~/dotfiles/nvim;
                target = ".config/nvim";
            };
            OnePassword = {
                source = ~/dotfiles/OnePassword/ssh/agent.toml;
                target = ".config/1Password/ssh/agent.toml";
            };
            sketchybar = {
                recursive = true;
                source = ~/dotfiles/sketchybar;
                target = ".config/sketchybar";
            };
            skhd = {
                source = ~/dotfiles/skhdrc;
                target = ".config/skhd/skhdrc";
            };
            yabai = {
                source = ~/dotfiles/yabairc;
                target = ".config/yabai/yabairc";
            };
            zed = {
                source = ~/dotfiles/zedsettings.json;
                target = ".config/zed/settings.json";
            };
            zprofile = {
                source = ~/dotfiles/zsh/macos/zprofile;
                target = ".zprofile";
            };
            zshenv = {
                source = ~/dotfiles/zsh/macos/zshenv;
                target = ".zshenv";
            };
            zshrc = {
                source = ~/dotfiles/zsh/macos/zshrc;
                target = ".zshrc";
            };
        };

        sessionPath = [
            "/run/current-system/sw/bin"
            "$HOME/.nix-profile/bin"
        ];
    };
    programs.home-manager.enable = true;
}

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
                source = ${homeDirectory}/dotfiles/fastfetch/config.jsonc;
                target = ".config/fastfetch/config.jsonc";
            };
            gitconfig = {
                source = ${homeDirectory}/dotfiles/git/macos;
                target = ".gitconfig";
            };
            nix = {
                recursive = true;
                source = ${homeDirectory}/dotfiles/nix;
                target = ".config/nix";
            };
            nvim = {
                recursive = true;
                source = ${homeDirectory}/dotfiles/nvim;
                target = ".config/nvim";
            };
            OnePassword = {
                source = ${homeDirectory}/dotfiles/OnePassword/ssh/agent.toml;
                target = ".config/1Password/ssh/agent.toml";
            };
            sketchybar = {
                recursive = true;
                source = ${homeDirectory}/dotfiles/sketchybar;
                target = ".config/sketchybar";
            };
            skhd = {
                source = ${homeDirectory}/dotfiles/skhdrc;
                target = ".config/skhd/skhdrc";
            };
            yabai = {
                source = ${homeDirectory}/dotfiles/yabairc;
                target = ".config/yabai/yabairc";
            };
            zed = {
                source = ${homeDirectory}/dotfiles/zed/settings.json;
                target = ".config/zed/settings.json";
            };
            zed_theme = {
                source = ${homeDirectory}/dotfiles/zed/themes/efz.json;
                target = ".config/zed/themes/efz.json";
            };
            zprofile = {
                source = ${homeDirectory}/dotfiles/zsh/macos/zprofile;
                target = ".zprofile";
            };
            zshenv = {
                source = ${homeDirectory}/dotfiles/zsh/macos/zshenv;
                target = ".zshenv";
            };
            zshrc = {
                source = ${homeDirectory}/dotfiles/zsh/macos/zshrc;
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

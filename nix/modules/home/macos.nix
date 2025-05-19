{
    configDir,
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
                source = "${configDir}/fastfetch/config.jsonc";
                target = ".config/fastfetch/config.jsonc";
            };
            ghostty = {
                source = "${configDir}/ghostty/config";
                target = "/Users/judahfuller/Library/Application Support/com.mitchellh.ghostty/config";
            };
            gitconfig = {
                source = "${configDir}/git/macos";
                target = ".gitconfig";
            };
            nix = {
                recursive = true;
                source = "${configDir}/nix";
                target = ".config/nix";
            };
            nvim = {
                recursive = true;
                source = "${configDir}/nvim";
                target = ".config/nvim";
            };
            OnePassword = {
                source = "${configDir}/OnePassword/ssh/agent.toml";
                target = ".config/1Password/ssh/agent.toml";
            };
            sketchybar = {
                recursive = true;
                source = "${configDir}/sketchybar";
                target = ".config/sketchybar";
            };
            skhd = {
                source = "${configDir}/skhdrc";
                target = ".config/skhd/skhdrc";
            };
            yabai = {
                source = "${configDir}/yabairc";
                target = ".config/yabai/yabairc";
            };
		#zed = {
			#source = "${configDir}/zed/settings.json";
			#target = ".config/zed/settings.json";
		#};
		#zed_theme = {
			#source = "${configDir}/zed/themes/efz.json";
			#target = ".config/zed/themes/efz.json";
		#};
            zprofile = {
                source = "${configDir}/zsh/macos/zprofile";
                target = ".zprofile";
            };
            zshenv = {
                source = "${configDir}/zsh/macos/zshenv";
                target = ".zshenv";
            };
            zshrc = {
                source = "${configDir}/zsh/macos/zshrc";
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

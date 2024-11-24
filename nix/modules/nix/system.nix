{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        btop
        blender
        cmatrix
        fastfetch
        mkalias
        nchat
        neovim
        nix
        nixd
        starship
        tmux
	tree-sitter
	zoxide
    ];

    fonts.packages = [
        (pkgs.nerdfonts.override {
            fonts = [
                "FiraCode"
            ];
        })
    ];
    services.nix-daemon.enable = true;
    nix.settings.experimental-features = "nix-command flakes";

    programs.zsh.enable = true;

    home-manager.backupFileExtension = "bck";
    nix.configureBuildUsers = true;
    nix.useDaemon = true;
}

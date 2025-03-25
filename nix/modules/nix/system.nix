{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        btop
        cmatrix
        fastfetch
        ffmpeg
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
        pkgs.nerd-fonts.fira-code
    ];

    nix = {
        enable = true;
        settings.experimental-features = "nix-command flakes";
    };

    programs.zsh.enable = true;

    home-manager.backupFileExtension = "bck";
}

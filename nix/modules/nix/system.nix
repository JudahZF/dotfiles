{
    config,
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        mkalias
        nchat
        nix
        neovim
        oh-my-posh
        stow
        tmux
        zoxide
        btop
        cmatrix
        nixd
    ];

    fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    services.nix-daemon.enable = true;
    nix.settings.experimental-features = "nix-command flakes";

    programs.zsh.enable = true;

    home-manager.backupFileExtension = "bck";
    nix.configureBuildUsers = true;
    nix.useDaemon = true;
}

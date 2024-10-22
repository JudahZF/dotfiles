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
}

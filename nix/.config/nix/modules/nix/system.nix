{
    config,
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        mkalias
        nchat
        neovim
        oh-my-posh
        stow
        tmux
        zoxide
        btop
        cmatrix
    ];
}

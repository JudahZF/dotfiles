{
    config,
    lib,
    pkgs,
    ...
}: {

    nixconfig.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        _1password-gui
        alacritty
        angryipscanner
        discord
        firefox
        gimp
        obsidian
        remmina
        steam
        vlc
    ];
}

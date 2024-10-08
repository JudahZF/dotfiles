{
    config,
    lib,
    pkgs,
    ...
}: {

    nixconfig.allowUnfree = true;

    environment.systemPackages =
    [
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

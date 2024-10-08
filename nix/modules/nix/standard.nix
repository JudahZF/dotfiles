{
    config,
    lib,
    pkgs,
    ...
}: {

    services.nix-daemon.enable = true;
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        alacritty
        discord
        gimp
        obsidian
        remmina
        # vlc
    ];
}

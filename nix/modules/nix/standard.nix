{
    pkgs,
    ...
}: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        alacritty
        discord
        gimp
        obsidian
        remmina
        tailscale
    ];
}

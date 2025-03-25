{
    pkgs,
    ...
}: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        gimp
        obsidian
        remmina
        tailscale
    ];
}

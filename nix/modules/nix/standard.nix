{
    pkgs,
    ...
}: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      bootdev-cli
        gimp
        obsidian
        remmina
        tailscale
        temurin-bin
    ];
}

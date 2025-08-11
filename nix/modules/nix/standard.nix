{
    pkgs,
    ...
}: {
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      bootdev-cli
        gimp
        nil
        obsidian
        temurin-bin
    ];
}

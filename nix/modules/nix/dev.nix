{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        ansible
        cmake
        cargo
        gitkraken
        go
        nodejs
        pnpm
        postman
        python3
        zed
    ];

    fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
}

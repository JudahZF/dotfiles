{
    config,
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        ansible
        cmake
        gitkraken
        nodejs
        pnpm
        postman
        python3
        # rpi-imager
        zed
    ];

    fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
}

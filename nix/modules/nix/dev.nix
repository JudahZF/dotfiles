{
    config,
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        ansible
        bun
        cmake
        gitkraken
        nodejs
        postman
        python3
        # rpi-imager
        zed
    ];

    fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
}

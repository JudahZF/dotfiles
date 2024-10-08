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
        node
        postman
        python3
        rpi-imager
        zed
    ];

    fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
}

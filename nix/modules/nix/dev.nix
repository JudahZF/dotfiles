{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        ansible
        cmake
        gitkraken
        go
        nodejs
        pnpm
        postman
        python3
        zed
    ];

    fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
    ];
}
